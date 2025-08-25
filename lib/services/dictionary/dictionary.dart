import 'package:app/services/dictionary/dictionary_interface.dart';

class Dictionary {
  static DictionaryBase? instance;
  static Future<bool> init(DictionaryBase dict)async{
    instance = dict;
    await instance!.init();
    return true;
  }
}