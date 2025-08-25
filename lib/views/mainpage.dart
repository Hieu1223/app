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
            child: ListView(
            children: [
                InputTextField(),
                Divider(),
                TokenList()
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
            title: Text(e.word),
          );
        },).toList()
      );
    },);
    
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