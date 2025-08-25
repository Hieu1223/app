import 'package:app/models/dictionary_entry.dart';
import 'package:app/models/kanji.dart';
import 'package:app/models/token_model.dart';
import 'package:app/services/dictionary/dictionary_interface.dart';
import 'package:sqlite3/sqlite3.dart';

class LocalDictionary  implements DictionaryBase{
  late Database _database;
  
  @override
  Future<bool> init() async{
    final dbDir = "assets/dictionary.db";
    _database = sqlite3.open(dbDir);
    return true;
  }

  Future<List<Kanji>> _lookUpKanjis(List<String> kanjiIds) async{
    List<Kanji> results = [];
    for(String kanjiId in kanjiIds){
      final rawData = _database.select("SELECT * FROM 'kanjis' WHERE id = ?",
        [kanjiId]
      );
      final entry = rawData[0];
      results.add(Kanji(surface: entry["kanji"], pronunciation: entry["reading"]));
      
    }
    return results;
  }


  @override
  Future<DictionaryEntry?> lookUp(TokenModel token) async {
    final rawData = _database.select("SELECT * FROM 'dict_entries' WHERE word ==? LIMIT 0,1",
        [token.baseWord]
    );

    if(rawData.isEmpty){
      return null;
    }


    final dictEntry = rawData.first;


    final kanjiIds = _database.select("SELECT kanji_id FROM 'dict_entry_kanjis' WHERE dict_entry_id ==?",
        [dictEntry['id']]
    );

    String word =  dictEntry['word'];
    String kanjiReading = dictEntry['kanji_reading']; 
    List<Kanji> kanji = await _lookUpKanjis(kanjiIds.map((i)=>i.values[0].toString()).toList());
    String hiraganaReading = dictEntry['reading']; 
    String desc = dictEntry['desc'];



    return DictionaryEntry(
      word: word,
      kanjiReading: kanjiReading, 
      kanji: kanji, 
      hiraganaReading: hiraganaReading, 
      desc:desc
    );

  }

}