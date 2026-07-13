import 'user_model.dart';

class DashboardStats {
    final int sessions;
    final int documents;
    final int quizzes;
    final int flashcards;

    DashboardStats({
        required this.sessions,
        required this.documents,
        required this.quizzes,
        required this.flashcards,
    });

    factory DashboardStats.fromJson(Map<String, dynamic> json) {
        return DashboardStats(
            sessions: json["sessions"],
            documents: json["documents"],
            quizzes: json["quizzes"],
            flashcards: json["flashcards"],
        );
    }
}

class DashboardModel {
    final UserModel user;
    final DashboardStats stats;

    DashboardModel({
        required this.user,
        required this.stats,
    });

    factory DashboardModel.fromJson(Map<String, dynamic> json) {
        return DashboardModel(
            user: UserModel.fromJson(json["user"]),
            stats: DashboardStats.fromJson(json["stats"]),
        );
    }
}