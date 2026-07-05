class ChatResponse {
    final String type;
    final String? response;
    final String? topic;
    final String? learningTitle;
    final List<String> actions;

    ChatResponse({
        required this.type,
        this.response, 
        this.topic, 
        this.learningTitle, 
        required this.actions,
    });

    factory ChatResponse.fromJson(Map<String, dynamic> json) {
        return ChatResponse(
            type: json["type"], 
            response: json["response"], 
            topic: json["topic"], 
            learningTitle: json["learning_title"], 
            actions: json["actions"] == null ? [] : List<String>.from(json["actions"]),
        );
    }
}