import 'package:app/models/token_model.dart';
import 'package:app/services/tokenization/tokenizer_interface.dart';
import 'package:kuromoji/kuromoji.dart';
import 'package:logger/web.dart';

class KuromojiTokenizer implements TokenizerBase{
  final regex = RegExp(r'[）。、／「」、！？\?! \r（]+');
  late final tokenizer;
  @override
  Future<bool> init() async {
    tokenizer = await TokenizerBuilder().build();
    return true;
  }

  @override
  Future<List<TokenModel>> process(String text) async{

    List<String> sentences  = text.split(regex);
    Logger().d(sentences);
    List<TokenModel> results = [];
    List<String> processedTokens = [];
    for(var sentence in sentences){
      //Empty sentence causes memory explosion for some reason
      if(sentence.isEmpty){
        continue;
      }
      results.addAll(await _processSentence(sentence,processedTokens));
    }
    return results;
  }

  Future<List<TokenModel>> _processSentence(String text, List<String> processedTokens) async {
    var tokens =tokenizer.tokenize(text);
    List<TokenModel> results = [];
    for(var token in tokens){
      bool isKnown = token['word_type'] == "KNOWN";
      bool isWord = token['reading'] == '*';
      bool isName = token['pos_detail_2'] == "固有名詞";
      if(!isKnown | isName | isWord) {
        continue;
      }
      if(processedTokens.contains(token['basic_form'])){
        continue;
      }
      processedTokens.add(token['basic_form']);
      results.add(TokenModel(baseWord: token['basic_form'].toString(), wordType: token['pos'].toString()));
    }
    
    return results;
  }

}