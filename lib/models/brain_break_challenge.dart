import 'brain_break_questions.dart';

class BrainBreakChallenge {
  final String title;
  final String category;
  final String challengeType;
  final String estimatedTime;
  final List<BrainBreakQuestion> questions;

  const BrainBreakChallenge({
    required this.title,
    required this.category,
    required this.challengeType,
    required this.estimatedTime,
    required this.questions,
  });

  factory BrainBreakChallenge.fromJson(
      Map<String, dynamic> json) {
    return BrainBreakChallenge(
      title: json["title"],
      category: json["category"],
      challengeType: json["challengeType"],
      estimatedTime: json["estimatedTime"],
      questions: (json["questions"] as List)
          .map(
            (e) => BrainBreakQuestion.fromJson(e),
          )
          .toList(),
    );
  }
}