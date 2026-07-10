import 'user_model.dart';

class AuthResponse {
    final String accessToken;
    final UserModel user;

    AuthResponse({
        required this.accessToken,
        required this.user,
    });

    factory AuthResponse.fromJson(Map<String, dynamic> json) {
        return AuthResponse(
            accessToken: json["access_token"],
            user: UserModel.fromJson(json),
        );
    }
}