import 'package:app/models/dictionary_entry.dart';
import 'package:app/models/token_model.dart';

abstract class DictionaryBase{
  Future<bool> init();
  Future<DictionaryEntry?> lookUp(TokenModel token);
}