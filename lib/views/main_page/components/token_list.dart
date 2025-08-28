import 'package:app/models/dictionary_entry.dart';
import 'package:app/viewmodels/tokenization_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';





class TokenList extends StatelessWidget {
  const TokenList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TokenizationPageViewModel>();
    Future<List<DictionaryEntry>> lookUpResult = vm.lastLookUpResultFuture;

    

    return FutureBuilder(future: lookUpResult, builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
        return Center(
          child: TokenizationProgressBar()
        );
      }
      return Column(
        children: snapshot.data!.indexed.map((i) {
          var (index, e) = i;
          return ListTile(
            title: TokenCard(token: e,index: index),
          );
        },).toList()
      );
    },);
    
  }
}


class TokenizationProgressBar extends StatelessWidget {
  const TokenizationProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TokenizationPageViewModel>();
    return Column(
      children: [
        LinearProgressIndicator(
          value: vm.progress,
        ),
        Text(vm.progressComment)
      ],
    );
  }
}


class TokenDisplay extends StatelessWidget {
  final DictionaryEntry token;
  const TokenDisplay({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(token.word, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text(token.hiraganaReading, style: TextStyle(fontSize: 16),),
            if(token.kanji.isNotEmpty)
              Text("Kanji: ${token.kanji.map((e) => e.surface).join(", ")}", style: TextStyle(fontSize: 16),),
            if(token.kanjiReading.isNotEmpty)
              Text("Kanji Reading: ${token.kanjiReading}", style: TextStyle(fontSize: 16),),
            
          ],
        );
  }
}

class TokenCardCheckBox extends StatelessWidget {
  final int index;
  const TokenCardCheckBox({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TokenizationPageViewModel>();
    return Checkbox(value: vm.getState(index), onChanged: (value){vm.toggle(index);});
  }
}

class TokenCard extends StatelessWidget {
  
  const TokenCard({super.key, required this.token, required this.index});
  final DictionaryEntry token;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      
      child: Padding(
        padding: EdgeInsets.all(13),
        child: Row(
          children: [
            TokenDisplay(token: token),
            Spacer(),
            TokenCardCheckBox(index: index,)
          ],
        )
      )
    );
  }
}

