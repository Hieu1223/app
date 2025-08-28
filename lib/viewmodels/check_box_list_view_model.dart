import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CheckBoxListViewModel extends ChangeNotifier {
  List<bool> states = List.empty();
  int length = 0;
  CheckBoxListViewModel(){
    setLength(0);
  }
  CheckBoxListViewModel.withLength(int length) {
    setLength(length);
  }

  void toggle(int index) {
    states[index] = !states[index];
    notifyListeners();
  }

  void clear() {
    for (int i = 0; i < states.length; i++) {
      states[i] = false;
    }
    notifyListeners();
  }

  void selectAll() {
    for (int i = 0; i < states.length; i++) {
      states[i] = true;
    }
    notifyListeners();
  }

  bool isAllFalse() {
    for (int i = 0; i < states.length; i++) {
      if (states[i]) {
        return false;
      }
    }
    return true;
  }

  void setLength(int length) {
    this.length = length;
    states = List.filled(length, false);
  }

  bool getState(int index){
    return states[index];
  }
}
