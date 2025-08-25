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
  void lookUp(String text) async{
    lastLookUpResult = _doLookUp(text);
    notifyListeners();
  }


  Future<List<DictionaryEntry>> _doLookUp(String text) async{
      progress = 0;
      progressComment = "Tokenizing";
      notifyListeners();
      final tokens = await compute(Tokenizer.instance!.process, text);
      progressComment = "Looking Up 1/${tokens.length}}";
      progress = 0.2;
      notifyListeners();
      List<DictionaryEntry> results = [];
      Future.wait(tokens.map((token) async{
        final entry = await Dictionary.instance!.lookUp(token);
        if(entry != null){
          results.add(entry);
        }
        progressComment = "Looking Up ${results.length}/${tokens.length}}";
        progress = 0.2 + 0.8 * (results.length / tokens.length);
        notifyListeners();
      }));
      //await Future.delayed(Duration(seconds: 2));
      return results;
  }
}