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

class ContinueLearning {
  final String id;
  final String? documentName;
  final String? title;
  final DateTime createdAt;

  ContinueLearning({
    required this.id,
    this.documentName,
    this.title,
    required this.createdAt,
  });

  factory ContinueLearning.fromJson(Map<String, dynamic> json) {
    return ContinueLearning(
      id: json["id"],
      documentName: json["document_name"],
      title: json["title"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}

class RecentSession {
  final String id;
  final String? documentName;
  final DateTime createdAt;
  final String? title;

  RecentSession({
    required this.id,
    this.documentName,
    required this.createdAt,
    this.title,
  });

  factory RecentSession.fromJson(Map<String, dynamic> json) {
    return RecentSession(
      id: json["id"],
      documentName: json["document_name"],
      title: json["title"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}

class DashboardModel {
  final UserModel user;
  final DashboardStats stats;
  final ContinueLearning? continueLearning;
  final List<RecentSession> recentSessions;

  DashboardModel({
    required this.user,
    required this.stats,
    this.continueLearning,
    required this.recentSessions,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      user: UserModel.fromJson(json["user"]),
      stats: DashboardStats.fromJson(json["stats"]),
      continueLearning: json["continue_learning"] == null
          ? null
          : ContinueLearning.fromJson(json["continue_learning"]),
      recentSessions: (json["recent_sessions"] as List)
          .map((e) => RecentSession.fromJson(e))
          .toList(),
    );
  }
}