import 'package:app/models/kanji.dart';

class DictionaryEntry{
  final int id;
  final String word;
  final String kanjiReading;
  final List<Kanji> kanji;
  final String hiraganaReading;
  final String desc;

  DictionaryEntry({required this.id, required this.word, required this.kanjiReading, required this.kanji, required this.hiraganaReading, required this.desc});
  @override
  String toString() {
    return 'DictionaryEntry(word: $word, kanjiReading: $kanjiReading, '
           'kanji: $kanji, hiraganaReading: $hiraganaReading, desc: $desc)';
  }
}
