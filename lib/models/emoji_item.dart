class EmojiItem {
  final String emoji;
  final String answer;

  EmojiItem({
    required this.emoji,
    required this.answer,
  });

  factory EmojiItem.fromJson(Map<String, dynamic> json) {
    return EmojiItem(
      emoji: json["emoji"],
      answer: json["answer"],
    );
  }
}