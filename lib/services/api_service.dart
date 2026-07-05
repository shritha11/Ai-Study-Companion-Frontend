import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';
import '../models/document_model.dart';
import 'package:file_picker/file_picker.dart';

class ApiService {
  static const _base = 'http://127.0.0.1:8000';

  // Chat — plain question or with PDF context
  static Future<String> chat(String message, {String? documentName}) async {
    final res = await http.post(
      Uri.parse('$_base/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message, 'document_name': documentName}),
    );
    if (res.statusCode != 200) throw Exception('Chat failed');
    return jsonDecode(res.body)['response'] as String;
  }

  static Future<Map<String,dynamic>?> uploadPdf() async {
    final result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: [
    'pdf',
    'docx',
    'pptx',
    'txt',
    'md',
  ],
);
    if (result == null) {
      return null;
    }
    final request = http.MultipartRequest(
      'POST', 
      Uri.parse('$_base/upload'),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', 
        result.files.single.path!,
      ),
    );
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if(response.statusCode != 200) {
      throw Exception("Upload failed");
    }
    return jsonDecode(response.body);
  }

  static Future<List<DocumentModel>> getDocuments() async {
    final response = await http.get(
      Uri.parse("$_base/documents"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load documents");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => DocumentModel.fromJson(e)).toList();
  }

  // Quiz generation
  static Future<List<QuizQuestion>> generateQuiz(String topic, {String? documentName}) async {
    final res = await http.post(
      Uri.parse('$_base/quiz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic, 'document_name': documentName}),
    );
    if (res.statusCode != 200) throw Exception('Quiz generation failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['questions'] as List)
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  // Flashcard generation
  static Future<List<Flashcard>> generateFlashcards(String topic, {String? documentName}) async {
    final res = await http.post(
      Uri.parse('$_base/flashcards'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic, 'document_name': documentName}),
    );
    if (res.statusCode != 200) throw Exception('Flashcard generation failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['flashcards'] as List)
        .map((f) => Flashcard.fromJson(f as Map<String, dynamic>))
        .toList();
  }
}