import 'package:app/models/dictionary_entry.dart';
import 'package:app/viewmodels/mainpageviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';





class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(padding: EdgeInsets.all(13),
            child: Column(
            children: [
                InputTextField(),
                Divider(),
                Expanded(
                  child: ListView(
                    children: [
                      TokenList()
                    ],
                  ),
                )
              ],
            ),
          )
        )
    );
  }
}

class TokenizationProgressBar extends StatelessWidget {
  const TokenizationProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainpageViewModel>();
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



class TokenList extends StatelessWidget {
  const TokenList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainpageViewModel>();
    Future<List<DictionaryEntry>> lookUpResult = vm.lastLookUpResult;


    return FutureBuilder(future: lookUpResult, builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
        return Center(
          child: TokenizationProgressBar()
        );
      }
      return Column(
        children: snapshot.data!.map((e) {
          return ListTile(
            title: TokenCard(token: e),
          );
        },).toList()
      );
    },);
    
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


class TokenCard extends StatelessWidget {
  
  const TokenCard({super.key, required this.token});
  final DictionaryEntry token;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      
      child: Padding(
        padding: EdgeInsets.all(13),
        child: Row(
          children: [
            TokenDisplay(token: token),
            Spacer(),
            OutlinedButton(
              onPressed: (){}, 
              child: const Text("Add")
            )
          ],
        )
      )
    );
  }
}

class InputTextField extends StatelessWidget {
  const InputTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MainpageViewModel>(context);
    void onSubmit(String text){
      vm.lookUp(text);
    }
    return TextField(
      controller: vm.textController,
      onSubmitted: !vm.allowSubmit ? null : onSubmit,
      enabled: vm.allowSubmit,
      decoration: InputDecoration(
        suffixIcon: IconButton(onPressed: (){onSubmit(vm.textController.text);}, icon: Icon(Icons.send)),
        border: OutlineInputBorder(),
      ),
    );
  }
}