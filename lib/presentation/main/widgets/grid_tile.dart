class GridTile {
  final int id;
  final String text;
  final bool isFlipped;
  final bool isMatched;
  const GridTile(this.id, this.text,
      {this.isFlipped = false, this.isMatched = false});

  bool get isHidden => !isFlipped && !isMatched;
}
