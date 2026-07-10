import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
    UserModel? user;
    bool isLoading = false;
    Future<void> login({
        required String email,
        required String password,
    }) async {
        isLoading = true;
        notifyListeners();

        final response = await AuthService.login(
            email: email, 
            password: password,
        );

        user = response.user;

        isLoading = false;
        notifyListeners();
    }

    Future<void> signup({
        required String name,
        required String email,
        required String password,
    }) async {
        isLoading = true;
        notifyListeners();

        final response = await AuthService.signup(
            name: name, 
            email: email, 
            password: password,
        );
        user = response.user;

        isLoading = false;
        notifyListeners();
    }

    Future<void> logout() async {
        await AuthService.logout();
        user = null;
        notifyListeners();
    }
}