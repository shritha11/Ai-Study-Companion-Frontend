import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class ApiService {
  static const _base = 'http://127.0.0.1:8000';

  // Chat — plain question or with PDF context
  static Future<String> chat(String message, {String? pdfContext}) async {
    final res = await http.post(
      Uri.parse('$_base/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message, 'pdf_context': pdfContext}),
    );
    if (res.statusCode != 200) throw Exception('Chat failed');
    return jsonDecode(res.body)['response'] as String;
  }

  // Quiz generation
  static Future<List<QuizQuestion>> generateQuiz(String topic, {String? pdfContext}) async {
    final res = await http.post(
      Uri.parse('$_base/quiz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic, 'pdf_context': pdfContext}),
    );
    if (res.statusCode != 200) throw Exception('Quiz generation failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['questions'] as List)
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  // Flashcard generation
  static Future<List<Flashcard>> generateFlashcards(String topic, {String? pdfContext}) async {
    final res = await http.post(
      Uri.parse('$_base/flashcards'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic, 'pdf_context': pdfContext}),
    );
    if (res.statusCode != 200) throw Exception('Flashcard generation failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['flashcards'] as List)
        .map((f) => Flashcard.fromJson(f as Map<String, dynamic>))
        .toList();
  }
}