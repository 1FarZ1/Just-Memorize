class AppGridTile<T> {
  final int id;
  final T child;
  final bool isFlipped;
  final bool isMatched;
  const AppGridTile(this.id, this.child,
      {this.isFlipped = false, this.isMatched = false});

  bool get isHidden => !isFlipped && !isMatched;
}
