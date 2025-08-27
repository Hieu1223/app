import 'package:app/views/common/app_bar.dart';
import 'package:app/views/main_page/components/input_text_field.dart';
import 'package:app/views/main_page/components/token_list.dart';
import 'package:app/views/main_page/components/token_list_menu.dart';
import 'package:flutter/material.dart';





class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
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


