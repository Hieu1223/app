class CheckBoxStates {
  late List<bool> states;

  CheckBoxStates(int length) {
    states = List.filled(length, false);
  }

  void toggle(int index) {
    states[index] = !states[index];
  }

  void clear() {
    for (int i = 0; i < states.length; i++) {
      states[i] = false;
    }
  }

  void selectAll() {
    for (int i = 0; i < states.length; i++) {
      states[i] = true;
    }
  }

  bool isAllFalse() {
    for (int i = 0; i < states.length; i++) {
      if (states[i]) {
        return false;
      }
    }
    return true;
  }
}

