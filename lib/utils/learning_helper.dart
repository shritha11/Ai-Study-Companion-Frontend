class LearningHelper {
  static String getTitle(String message) {
    final t = message.toLowerCase();
    if (t.contains('tree') || t.contains('graph') || t.contains('array') ||
        t.contains('algorithm') || t.contains('dsa') || t.contains('linked list')) {
      return 'Ready to practice?';
    }
    if (t.contains('flutter') || t.contains('dart') || t.contains('javascript') ||
        t.contains('python') || t.contains('java')) {
      return 'Deepen your understanding';
    }
    if (t.contains('dbms') || t.contains('sql') || t.contains('database')) {
      return 'Test your knowledge';
    }
    return 'Choose your next step';
  }

  static String extractTopic(String message) {
    final text = message.trim();
    for (final prefix in [
      'Explain', 'What is', 'Tell me about',
      'Generate quiz on', 'Quiz me on', 'Help me with',
    ]) {
      if (text.toLowerCase().startsWith(prefix.toLowerCase())) {
        return text.substring(prefix.length).trim();
      }
    }
    // Return first 4 words as topic fallback
    final words = text.split(' ');
    return words.take(4).join(' ');
  }
}