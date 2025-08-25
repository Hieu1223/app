import 'package:app/services/dictionary/dictionary.dart';
import 'package:app/services/dictionary/local_dictionary.dart';
import 'package:app/services/tokenization/kuromoji_tokenizer.dart';
import 'package:app/services/tokenization/tokenizer.dart';
import 'package:app/viewmodels/mainpageviewmodel.dart';
import 'package:app/views/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Tokenizer.init(KuromojiTokenizer());
  if(await Dictionary.init(LocalDictionary())){
    Logger().d("Dictionary initialized");
  } else {
    Logger().e("Failed to initialize dictionary");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>MainpageViewModel())
      ],
      child: MaterialApp(
        home: Mainpage(),
      ),
    );
  }
}
