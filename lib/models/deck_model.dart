class DeckModel {
  final String name;
  final int id;
  final int cardCount = 0;
  final int learntCount = 0;
  final int fluentCount = 0;
  DeckModel({required this.name, required this.id});

  @override
  String toString() {
    return 'DeckModel{name: $name, id: $id, cardCount: $cardCount, learntCount: $learntCount, fluentCount: $fluentCount}';
  }
}