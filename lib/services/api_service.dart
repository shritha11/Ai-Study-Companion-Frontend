import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
    static const String baseUrl = "http://localhost:8000";

    static Future<String> sendMessage(String message) async {
        final response = await http.post(
            Uri.parse("$baseUrl/chat"),
            headers: {
                "Content-Type": "application/json",
            }, 
            body: jsonEncode({
                "message": message,
            }),
        );

        final data = jsonDecode(response.body);

        return data["response"];
    }
}