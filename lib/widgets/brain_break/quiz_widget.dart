class QuizWidget extends StatefulWidget {
  final String topic;
  final String? documentName;
  final String sessionId;

  const QuizWidget({
    super.key,
    required this.topic,
    this.documentName,
    required this.sessionId,
  });
}