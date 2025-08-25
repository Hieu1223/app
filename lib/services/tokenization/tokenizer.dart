import 'package:app/services/tokenization/tokenizer_interface.dart';

class Tokenizer {
  static TokenizerBase?instance;
  static Future<bool> init(TokenizerBase tokenizer) async{
    instance = tokenizer;
    bool sucess = await tokenizer.init();
    return sucess;
  }
}