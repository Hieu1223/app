import 'package:app/models/deck_model.dart';
import 'package:app/models/dictionary_entry.dart';
import 'package:app/services/storage/local_storage.dart';
import 'package:app/viewmodels/check_box_list_view_model.dart';
import 'package:logger/web.dart';

class AddTokenToDeckViewModel extends CheckBoxListViewModel{

  List<DeckModel> testDecks = [
      DeckModel(id: 0, name: "Deck 1"),
      DeckModel(id: 0, name: "Deck 2"),
      DeckModel(id: 0, name: "Deck 3"),
  ];

  Future<List<DeckModel>> decksFuture = Future.value([]);
  List<DeckModel> decks = [];
  late LocalStorage dbInstance;


  AddTokenToDeckViewModel(){
    init();
  }

  void init() async{
    decksFuture = Future<List<DeckModel>>(()async{
      dbInstance = await LocalStorage.getInstance();
      return _getDecks();
    });
    decks = await decksFuture;
    setLength(decks.length);
  }

  void startLoadingDecks() async{
    decksFuture = _getDecks();
    decks = await decksFuture;
    setLength(decks.length);
  }

  Future<List<DeckModel>> _getDecks() async {
    await Future.delayed(Duration(seconds: 2));
    return testDecks;
  }

  Future<bool> addCardsToDecks(List<DictionaryEntry> cards) async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<bool> addDeck(String deckName) async{
    testDecks.add(DeckModel(name: deckName, id: 0));
    startLoadingDecks();
    notifyListeners();
    Logger().d(testDecks);
    return true;
  }
}