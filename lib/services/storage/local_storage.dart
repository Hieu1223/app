import 'package:app/models/deck_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LocalStorage {
  static LocalStorage? _instance;
  
  Database? _db;

  static Future<LocalStorage> getInstance() async{
    if(_instance != null) return _instance!;
    _instance = LocalStorage();
    await _instance!.init();
    return _instance!;
  }

  Future<bool> init() async {
    sqfliteFfiInit();
    _db = await databaseFactoryFfi.openDatabase(
      'my_database.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            ''' CREATE TABLE IF NOT EXISTS deck ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, create_date DATE, card_count INTEGER, learnt_card_count INTEGER, fluent_card_count INTEGER ); ''',
          );
          await db.execute(
            ''' CREATE TABLE IF NOT EXISTS user_sr_card ( id INTEGER PRIMARY KEY AUTOINCREMENT, deck_id INTEGER, timestamp INTEGER, learning_state INTEGER, FOREIGN KEY (deck_id) REFERENCES deck(id) ON DELETE CASCADE ON UPDATE CASCADE ); ''',
          );
          await db.execute(
            ''' CREATE TABLE IF NOT EXISTS review_blacklist ( card_id INTEGER PRIMARY KEY, FOREIGN KEY (card_id) REFERENCES user_sr_card(id) ON DELETE CASCADE ON UPDATE CASCADE ); ''',
          );
          await db.execute(
            ''' CREATE TABLE IF NOT EXISTS look_up_blacklist ( dict_entry TEXT PRIMARY KEY ); ''',
          );
        },
      ),
    );
    await _db!.execute("PRAGMA foreign_keys = ON;");
    return true;
  }

  Future<DeckModel> addDeck(String deckName) async {
    final id = await _db!.insert('deck', {
      'name': deckName,
      'create_date': DateTime.now().toIso8601String(),
      'card_count': 0,
      'learnt_card_count': 0,
      'fluent_card_count': 0,
    });
    return DeckModel(id: id, name: deckName);
  }

  Future<List<DeckModel>> getDecks() async {
    final rows = await _db!.query('deck');
    return rows
        .map((r) => DeckModel(id: r['id'] as int, name: r['name'] as String))
        .toList();
  }

}