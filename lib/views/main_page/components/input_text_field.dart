import 'package:app/viewmodels/tokenization_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class InputTextField extends StatefulWidget {
  const InputTextField({super.key});

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool expanded = true; // starts expanded

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TokenizationPageViewModel>(context);

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
        suffixIcon:  IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => onSubmit(vm.textController.text),
              ),
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
