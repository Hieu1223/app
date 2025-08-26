import 'package:app/models/deck_model.dart';
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
                TokenListMenu(),
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

class DeactivatableSelectButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  final Widget child;
  const DeactivatableSelectButton({super.key, required this.enabled, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      child: child,
    );
  }
}

class TokenListMenu extends StatelessWidget {
  const TokenListMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainpageViewModel>();
    bool enabled = vm.enabledSelectBoxes;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 13,
      children: [
        DeactivatableSelectButton(enabled: enabled, onPressed: (){vm.selectBoxState.selectAll(); vm.notify();}, child: Text("Select All")),
        DeactivatableSelectButton(enabled: enabled, onPressed: (){vm.selectBoxState.clear();vm.notify();}, child: Text("Deselect All")),
        DeactivatableSelectButton(enabled: enabled, onPressed: (){}, child: Text("Blacklist Selected")),
        DeactivatableSelectButton(
          enabled: enabled, 
          onPressed: (){
            if(vm.selectBoxState.isAllFalse()){
              
              final snackBar = SnackBar(
                content: Text("No tokens selected"),
                action: SnackBarAction(
                  label: "Close", 
                  onPressed: ()=>{
                    ScaffoldMessenger.of(context).hideCurrentSnackBar()
                  }),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }

            showDialog(context: context, builder: (context) {
              return AddToDeckDialog();
            },);
          }, 
          child: Text("Add Selected")),
      ],
    );
  }
}


class AddToDeckDialog extends StatelessWidget {
  const AddToDeckDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add to Deck"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          children: context.read<MainpageViewModel>().getDecks().indexed.map((deck) => DeckListTile(deck: deck.$2,index: deck.$1,)).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("Cancel")),
        TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, 
          child: Text("Add")
        ),
      ],
    );
  }
}

class DeckListTile extends StatefulWidget {
  final DeckModel deck;
  final int index;  
  const DeckListTile({super.key,required this.deck, required this.index});

  @override
  State<DeckListTile> createState() => _DeckListTileState();
}

class _DeckListTileState extends State<DeckListTile> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainpageViewModel>();
    return ListTile(
      title: Text(widget.deck.name),
      subtitle: Text("${widget.deck.cardCount} cards, ${widget.deck.learntCount} learnt, ${widget.deck.fluentCount} fluent"),
      trailing: Checkbox(value: vm.deckSelectBoxState.states[widget.index], onChanged: (value){vm.deckSelectBoxState.toggle(widget.index); vm.notify();}),
    );
  }
}


class TokenList extends StatelessWidget {
  const TokenList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainpageViewModel>();
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

class TokenCardCheckBox extends StatefulWidget {
  final int index;
  const TokenCardCheckBox({super.key, required this.index});

  @override
  State<TokenCardCheckBox> createState() => _TokenCardCheckBoxState();
}

class _TokenCardCheckBoxState extends State<TokenCardCheckBox> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainpageViewModel>();
    return Checkbox(value: vm.selectBoxState.states[widget.index], onChanged: (value){vm.selectBoxState.toggle(widget.index); vm.notify();});
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

class InputTextField extends StatefulWidget {
  const InputTextField({super.key});

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool expanded = true; // starts expanded

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MainpageViewModel>(context);

    void onSubmit(String text) {
      vm.lookUp(text);
      setState(() {
        expanded = false; // shrink after submit
      });
    }

    final textField = TextField(
      controller: vm.textController,
      onSubmitted: !vm.allowSubmit ? null : onSubmit,
      enabled: vm.allowSubmit,
      minLines: 3,
      maxLines: expanded ? null : 3, // unlimited when expanded
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: expanded
            ? IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => onSubmit(vm.textController.text),
              )
            : null,
      ),
    );

    final expandCollapseButton = Center(
      child: TextButton(
        onPressed: () => setState(() => expanded = !expanded),
        child: Text(expanded ? "Collapse" : "Expand"),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        textField,
        expandCollapseButton,
      ],
    );
  }
}
