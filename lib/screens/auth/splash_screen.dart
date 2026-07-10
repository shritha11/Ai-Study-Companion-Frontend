import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
        super.initState();
        checkLogin();
    }

    Future<void> checkLogin() async {
        final loggedIn = await AuthService.isLoggedIn();
        if (!mounted) return;

        Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
                builder: (_) => loggedIn ? const RootScreen() : const LoginScreen(),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(),
            ),
        );
    }
}