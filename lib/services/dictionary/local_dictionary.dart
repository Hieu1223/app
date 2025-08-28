import 'package:app/models/dictionary_entry.dart';
import 'package:app/models/kanji.dart';
import 'package:app/models/token_model.dart';
import 'package:app/services/dictionary/dictionary_interface.dart';
import 'package:logger/web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';

class LocalDictionary implements DictionaryBase {
  late Database _database;

  Future<String> copyAssetDbIfNotExists(String assetPath, String targetPath) async {
    final file = File(targetPath);
    if (!file.existsSync()) {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }
    return file.path;
  }

  @override
  Future<bool> init() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    var databasesPath = await getDatabasesPath();
    var dbPath = p.join(databasesPath, "dictionary.db");
    if(!await databaseExists(dbPath)){
      Logger().d("Copying database from asset to $dbPath");
      try{
        await Directory(p.dirname(dbPath)).create(recursive: true);
      }  catch(e){
        Logger().e("Failed to create directory for database: $e");
        return false;
      }
      ByteData data = await rootBundle.load(p.url.join("assets", "dictionary.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);

    }
    _database = await openDatabase(dbPath);
    return _database.isOpen;
  }

  Future<List<Kanji>> _lookUpKanjis(List<String> kanjiIds) async {
    if (kanjiIds.isEmpty) return [];
    final rows = await _database.rawQuery( '''
      SELECT kanji, reading FROM kanjis
      WHERE id IN (${List.filled(kanjiIds.length, '?').join(',')})
    ''', kanjiIds);
    return rows.map((r) => Kanji(
      surface: r['kanji'].toString(),
      pronunciation: r['reading'].toString(),
    )).toList();
  }

  @override
  Future<DictionaryEntry?> lookUp(TokenModel token) async {
    Logger().d("Looking up ${token.baseWord}");
    final rawData = await _database.rawQuery('''
      SELECT * FROM dict_entries
      WHERE word = ?
      LIMIT 1
    ''', [token.baseWord]);
    Logger().d("Found ${rawData.length} entries for ${token.baseWord}");

    if (rawData.isEmpty) return null;

    final dictEntry = rawData.first;

    final kanjiIdsRaw = await _database.rawQuery('''
      SELECT kanji_id FROM dict_entry_kanjis
      WHERE dict_entry_id = ?
    ''', [dictEntry['id']]);

    final kanjiIds = kanjiIdsRaw.map((row) => row['kanji_id'].toString()).toList();
    final kanji = await _lookUpKanjis(kanjiIds);

    return DictionaryEntry(
      id: dictEntry['id'] as int,
      word: dictEntry['word'].toString(),
      kanjiReading: dictEntry['kanji_reading'].toString(),
      kanji: kanji,
      hiraganaReading: dictEntry['reading'].toString(),
      desc: dictEntry['desc'].toString(),
    );
  }
}
