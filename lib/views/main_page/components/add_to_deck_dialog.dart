import 'package:app/models/deck_model.dart';
import 'package:app/viewmodels/mainpageviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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

