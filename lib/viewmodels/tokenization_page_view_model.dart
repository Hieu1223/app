import 'package:app/models/dictionary_entry.dart';
import 'package:app/services/dictionary/dictionary.dart';
import 'package:app/services/tokenization/tokenizer.dart';
import 'package:app/viewmodels/check_box_list_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';





class TokenizationPageViewModel extends CheckBoxListViewModel {

  
  TextEditingController textController = TextEditingController();
  
  //progress bar
  String progressComment = "";
  double progress = 0;

  //UI state
  bool allowSubmit = true;
  bool enabledSelectBoxes = false;

  //look up logic
  Future<List<DictionaryEntry>> lastLookUpResultFuture = Future(()=>List.empty(growable: true));
  List<DictionaryEntry> lastLookUpResult = List.empty(growable: true);

  TokenizationPageViewModel();



  void lookUp(String text) async{
    allowSubmit = false;
    enabledSelectBoxes = false;
    lastLookUpResult = List.empty();
    notifyListeners();
    lastLookUpResultFuture = _doLookUp(text);
    lastLookUpResult =  await lastLookUpResultFuture;
    setLength(lastLookUpResult.length);
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
    for(int i = 0; i < length; i++){
      if(getState(i)){
        Logger().d("Adding ${lastLookUpResult[i].word} to deck");
      }
    }
  }
  List<DictionaryEntry> getSelectedTokens(){
    List<DictionaryEntry> selected = [];
    for(int i = 0; i < length; i++){
      if(states[i]){
        selected.add(lastLookUpResult[i]);
      }
    }
    return selected;
  }
  void notify(){
    notifyListeners();
  }
}