class SessionModel {
    final String id;
    final String? documentName;
    final String createdAt;
    final String updatedAt;

    SessionModel({
        required this.id,
        this.documentName, 
        required this.createdAt, 
        required this.updatedAt,
    });

    factory SessionModel.fromJson(Map<String, dynamic> json) {
        return SessionModel(
            id: json["id"], 
            documentName: json["document_name"], 
            createdAt: json["created_at"], 
            updatedAt: json["updated_at"],
        );
    }
}