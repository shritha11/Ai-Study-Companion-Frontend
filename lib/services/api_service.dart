import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';
import '../models/document_model.dart';
import '../models/chat_response.dart';
import '../models/session_model.dart';
import '../models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'auth_service.dart';
import '../models/dashboard_model.dart';

class ApiService {
  static const _base = 'http://127.0.0.1:8000';

  // Chat — plain question or with PDF context
  static Future<ChatResponse> chat(String message, {String? documentName, List<String>? documentNames, String? sessionId}) async {
    final res = await http.post(
      Uri.parse('$_base/chat'),
      headers: await AuthService.authHeaders(),
      body: jsonEncode({'message': message, 'document_name': documentName, "document_names": documentNames, "session_id": sessionId}),
    );
    if (res.statusCode != 200) throw Exception('Chat failed');
    return ChatResponse.fromJson(
      jsonDecode(res.body),
    );
  }

  static Future<void> deleteDocument(
    String documentName,
  ) async {
    final response = await http.delete(
      Uri.parse("$_base/documents/$documentName"),
      headers: await AuthService.authHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete");
    }
  }

  static Future<DashboardModel> getDashboard() async {
    final response = await http.get(
      Uri.parse("$_base/dashboard"), 
      headers: await AuthService.authHeaders(),
    );

   // print(response.body);

   if (response.statusCode == 401) {
    await AuthService.logout();
    throw Exception("Session expired");
  }


    if (response.statusCode != 200) {
      throw Exception("Failed to load dashboard");
    }

    return DashboardModel.fromJson(
      jsonDecode(response.body),
    );
  }

  static Future<List<dynamic>> getMessages(
  String sessionId,
) async {
  final response = await http.get(
    Uri.parse("$_base/sessions/$sessionId/messages"),
    headers: await AuthService.authHeaders(),
  );

  return jsonDecode(response.body);
}

  static Future<SessionModel> createSession(
    String? documentName,
  ) async {
    final response = await http.post(
      Uri.parse("$_base/sessions"),
      headers: await AuthService.authHeaders(),
      body: jsonEncode({
        "document_name": documentName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to create session");
    }

    return SessionModel.fromJson(
      jsonDecode(response.body),
    );
  }

  static Future<SessionModel?> getSession(String documentName) async {
    final response = await http.get(
      Uri.parse("$_base/sessions/$documentName"), 
      headers: await AuthService.authHeaders(),
    );
    final data = jsonDecode(response.body);
    if (!data["exists"]) {
      return null;
    }

    return SessionModel.fromJson(
      data["session"],
    );
  }

  static Future<void> renameDocument(
  String documentName,
  String newName,
) async {

  final response = await http.put(
    Uri.parse("$_base/documents/$documentName"),
    headers: await AuthService.authHeaders(),
    body: jsonEncode({
      "new_name": newName,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Rename failed");
  }
}

static Future<UserModel> getCurrentUser() async {
  final response = await http.get(
    Uri.parse("$_base/me"),
    headers: await AuthService.authHeaders(),
  );

  print(response.body);

  if (response.statusCode != 200) {
    throw Exception("Failed to load user");
  }

  return UserModel.fromJson(jsonDecode(response.body));
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

    request.headers.addAll(
        await AuthService.authHeaders(),
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
      headers: await AuthService.authHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load documents");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => DocumentModel.fromJson(e)).toList();
  }

  // Quiz generation
  static Future<List<QuizQuestion>> generateQuiz(String topic, {String? documentName, List<String>? documentNames, required String sessionId}) async {
    final res = await http.post(
      Uri.parse('$_base/quiz'),
      headers: await AuthService.authHeaders(),
      body: jsonEncode({
        'topic': topic, 
        'document_name': documentName,
        'document_names': documentNames,
        'session_id': sessionId,
        }),
    );
    if (res.statusCode != 200) throw Exception('Quiz generation failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['questions'] as List)
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  // Flashcard generation
  static Future<List<Flashcard>> generateFlashcards(String topic, {String? documentName, List<String>? documentNames, required String sessionId}) async {
    final res = await http.post(
      Uri.parse('$_base/flashcards'),
      headers: await AuthService.authHeaders(),
      body: jsonEncode({
        'topic': topic, 
        'document_name': documentName,
        'document_names': documentNames,
        'session_id': sessionId,
        }),
    );
    if (res.statusCode != 200) throw Exception('Flashcard generation failed');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['flashcards'] as List)
        .map((f) => Flashcard.fromJson(f as Map<String, dynamic>))
        .toList();
  }
}