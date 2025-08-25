import 'package:app/models/dictionary_entry.dart';
import 'package:app/services/dictionary/dictionary.dart';
import 'package:app/services/tokenization/tokenizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MainpageViewModel extends ChangeNotifier {

  Future<List<DictionaryEntry>> lastLookUpResult = Future(()=>[]);
  TextEditingController textController = TextEditingController();
  String progressComment = "";
  double progress = 0;
  bool allowSubmit = true;
  void lookUp(String text) async{
    allowSubmit = false;
    notifyListeners();
    lastLookUpResult = _doLookUp(text);
    await lastLookUpResult;
    allowSubmit = true;
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
}