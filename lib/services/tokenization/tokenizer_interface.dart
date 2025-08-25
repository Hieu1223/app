import 'package:app/models/token_model.dart';

abstract class TokenizerBase{
  Future<List<TokenModel>> process(String text);
  Future<bool> init();
}