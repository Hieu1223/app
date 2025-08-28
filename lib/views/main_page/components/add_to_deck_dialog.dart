import 'package:app/models/deck_model.dart';
import 'package:app/viewmodels/add_token_to_deck_view_model.dart';
import 'package:app/viewmodels/tokenization_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class _CancelButton extends StatelessWidget {
  const _CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("Cancel"),
    );
  }
}


class _AddButton extends StatelessWidget {
  final TokenizationPageViewModel tokenVm;
  final AddTokenToDeckViewModel deckVm;
  const _AddButton({super.key, required this.tokenVm, required this.deckVm});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        deckVm.addCardsToDecks(tokenVm.getSelectedTokens());
        Navigator.of(context).pop();
      },
      child: Text("Add"),
    );
  }
}

class _NewDeckButton extends StatelessWidget {
  const _NewDeckButton({super.key});

  @override
  Widget build(BuildContext context) {
    final deckVm = context.watch<AddTokenToDeckViewModel>();
    return TextButton(
      onPressed: (){
        final controller = TextEditingController();
        
        final textField = TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Deck name"
          ),
        );

        showDialog(context: context, builder: (context){
          return AlertDialog(
            content: textField,
            actions: [
              TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cancel")),
              TextButton(onPressed: (){deckVm.addDeck(controller.text);Navigator.of(context).pop();}, child: Text("Add")),    
            ],
          );
        });
      }, 
      child: Text("New Deck")
    );
  }
}


class _Dialog extends StatelessWidget {
  const _Dialog({super.key});

  @override
  Widget build(BuildContext context) {

    final deckVm = context.watch<AddTokenToDeckViewModel>();
    final tokenVm = context.watch<TokenizationPageViewModel>();
    final content = SizedBox(
        width: double.maxFinite,
        child: FutureBuilder(future: deckVm.decksFuture, builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
            return Center(
              child: CircularProgressIndicator()
            );
          }
          return ListView(
            shrinkWrap: false,
            children: snapshot.data!.indexed.map((i) {
              var (index, e) = i;
              return DeckListTile(deck: e, index: index);
            },).toList()
          );
        },),
      );

    return AlertDialog(
      title: Text("Add to Deck"),
      content: content,
      actions: [_CancelButton(), _NewDeckButton(), _AddButton(deckVm: deckVm,tokenVm:tokenVm)],
    );
  }
}



class AddToDeckDialog extends StatelessWidget {
  const AddToDeckDialog({super.key});

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (_)=> AddTokenToDeckViewModel(),
      child: _Dialog(),
    );
  }
}

class DeckListTile extends StatelessWidget {
  final DeckModel deck;
  final int index;  
  const DeckListTile({super.key,required this.deck, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddTokenToDeckViewModel>();
    return ListTile(
      title: Text(deck.name),
      subtitle: Text("${deck.cardCount} cards, ${deck.learntCount} learnt, ${deck.fluentCount} fluent"),
      trailing: Checkbox(value: vm.getState(index), onChanged: (value){vm.toggle(index);}),
    );
  }
}

