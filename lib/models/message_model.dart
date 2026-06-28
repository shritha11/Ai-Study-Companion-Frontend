class MessageModel {
  final String text;
  final bool isUser;
  MessageModel({required this.text, required this.isUser});
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  int? selectedIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> j) => QuizQuestion(
        question: j['question'] as String,
        options: List<String>.from(j['options'] as List),
        correctIndex: j['correct_index'] as int,
      );

  bool get isAnswered => selectedIndex != null;
  bool get isCorrect => selectedIndex == correctIndex;
}

class Flashcard {
  final String front;
  final String back;
  Flashcard({required this.front, required this.back});

  factory Flashcard.fromJson(Map<String, dynamic> j) => Flashcard(
        front: j['front'] as String,
        back: j['back'] as String,
      );
}

class QuizResult {
  final String topic;
  final int score;
  final int total;
  final DateTime date;
  QuizResult({required this.topic, required this.score, required this.total})
      : date = DateTime.now();
  int get percent => (score / total * 100).round();
}