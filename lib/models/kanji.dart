class Kanji{
    final String surface;
    final String pronunciation;

  Kanji({required this.surface, required this.pronunciation});
   @override
  String toString() {
    return 'Kanji(surface: $surface, pronunciation: $pronunciation)';
  }
}