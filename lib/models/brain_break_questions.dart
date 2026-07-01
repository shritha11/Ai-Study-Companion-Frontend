class BrainBreakQuestion {
  final String question;
  final List<String> options;
  final int answer;

  const BrainBreakQuestion({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory BrainBreakQuestion.fromJson(
      Map<String, dynamic> json) {
    return BrainBreakQuestion(
      question: json["question"],
      options: List<String>.from(json["options"]),
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "options": options,
      "answer": answer,
    };
  }
}