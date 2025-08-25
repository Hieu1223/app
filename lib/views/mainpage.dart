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

class TokenList extends StatelessWidget {
  const TokenList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainpageViewModel>();
    Future<List<DictionaryEntry>> lookUpResult = vm.lastLookUpResult;


    return FutureBuilder(future: lookUpResult, builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(
          child: LinearProgressIndicator(
            value: vm.progress,
          ),
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


class InputTextField extends StatefulWidget {
  const InputTextField({super.key});

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MainpageViewModel>(context);
    void onSubmit(String text){
      vm.lookUp(text);
    }
    return TextField(
      controller: vm.textController,
      onSubmitted: onSubmit,
      decoration: InputDecoration(
        suffixIcon: IconButton(onPressed: (){onSubmit(vm.textController.text);}, icon: Icon(Icons.send)),
        border: OutlineInputBorder(),
      ),
    );
  }
}