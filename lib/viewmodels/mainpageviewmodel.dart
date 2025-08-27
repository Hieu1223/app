import 'package:app/models/deck_model.dart';
import 'package:app/models/dictionary_entry.dart';
import 'package:app/services/dictionary/dictionary.dart';
import 'package:app/services/tokenization/tokenizer.dart';
import 'package:app/views/common/check_box_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';





class MainpageViewModel extends ChangeNotifier {

  
  TextEditingController textController = TextEditingController();
  
  //progress bar
  String progressComment = "";
  double progress = 0;
  //check box states;
  CheckBoxStates selectBoxState = CheckBoxStates(0);
  CheckBoxStates deckSelectBoxState = CheckBoxStates(0);

  //UI state
  bool allowSubmit = true;
  bool enabledSelectBoxes = false;

  //look up logic
  Future<List<DictionaryEntry>> lastLookUpResultFuture = Future(()=>[]);
  List<DictionaryEntry> lastLookUpResult = List.empty();



  void lookUp(String text) async{
    allowSubmit = false;
    enabledSelectBoxes = false;
    lastLookUpResult = List.empty();
    notifyListeners();
    lastLookUpResultFuture = _doLookUp(text);
    lastLookUpResult =  await lastLookUpResultFuture;
    selectBoxState = CheckBoxStates(lastLookUpResult.length);
    allowSubmit = true;
    enabledSelectBoxes = true;
    notifyListeners();
  }


  Future<List<DictionaryEntry>> _doLookUp(String text) async{
    progress = 0;
    progressComment = "Tokenizing";
    notifyListeners();
    final tokens = await compute(Tokenizer.instance!.process, text);
    progress = 0.2;
    notifyListeners();
    List<DictionaryEntry> results = [];
    for(final token in tokens){
      progressComment = "Looking Up ${results.length}/${tokens.length} words";
      progress = 0.2 + 0.8 * (results.length / tokens.length);
      notifyListeners();
      final entry = await Dictionary.instance!.lookUp(token);
      if(entry != null){
        results.add(entry);
      }
      //await Future.delayed(Duration(milliseconds: 1));
    }
    //await Future.delayed(Duration(seconds: 2));
    return results;
  }

  void addSelectionToDeck(){
    for(int i = 0; i < selectBoxState.states.length; i++){
      if(selectBoxState.states[i]){
        Logger().d("Adding ${lastLookUpResult[i].word} to deck");
      }
    }
  }
  List<DeckModel> getDecks(){
    List<DeckModel> decks =[
      DeckModel(name: "Default Deck", id: 1),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
      DeckModel(name: "My Deck", id: 2),
    ];
    deckSelectBoxState = CheckBoxStates(decks.length);
    return decks;
  }
  void notify(){
    notifyListeners();
  }
}