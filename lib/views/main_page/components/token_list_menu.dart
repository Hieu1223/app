import 'package:app/viewmodels/mainpageviewmodel.dart';
import 'package:app/views/common/deactivatable_select_button.dart';
import 'package:app/views/main_page/components/add_to_deck_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




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
