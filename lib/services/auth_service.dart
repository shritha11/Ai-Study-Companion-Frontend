import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../models/auth_response.dart';

class AuthService {
    static const _base = "http://127.0.0.1:8000";
    static const storage = FlutterSecureStorage();

    static Future<AuthResponse> login({
        required String email,
        required String password,
    }) async {
        final response = await http.post(
            Uri.parse("_base/login"),
            headers: {
                "Content-Type": "application/json",
            },
            body: jsonEncode({
                "email": email, 
                "password": password,
            }),
        );

        if (response.statusCode != 200) {
            throw Exception("Invalid email or password");
        }


        final data = jsonDecode(response.body);

        await storage.write(
            key: "token", 
            value: data["access_token"],
        );

        return AuthResponse.fromJson(data);
    }

    static Future<AuthResponse> signup({
        required String name, 
        required String email,
        required String password,
    }) async {
        final response = await http.post(
            Uri.parse("$_base/signup"), 
            headers: {
                "Content-Type": "application/json",
            },
            body: jsonEncode({
                "name": name, 
                "email": email,
                "password": password,
            }),
        );

        if (response.statusCode != 200) {
            throw Exception("Signup failed");
        }

        final data = jsonEncode(response.body);

        await storage.write(
            key: "token",
            value: data["access_token"],
        );

        return AuthResponse.fromJson(data);
    }

    static Future<String> getToken() async {
        return await storage.read(key: "token");
    }

    static Future<void> logout() async {
        await storage.delete(key: "token");
    }

    static Future<bool> isLoggedIn() async {
        final token = await getToken();
        return token != null;
    }
}