import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../services/api_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
    const ChatScreen({super.key});

    @override
    State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    final TextEditingController controller = TextEditingController();

    List<MessageModel> messages = [];

    Future<void> sendMessage() async {
        String text = controller.text.trim();

        if (text.isEmpty) return;

        setState(() {
            messages.add(
                MessageModel(
                text: text,
                isUser: true,
            ),
        );
        });

        controller.clear();

        String aiResponse = await ApiService.sendMessage(text);
        setState(() {
            messages.add(
                MessageModel(
                    text: aiResponse, 
                    isUser: false,
                )
            );
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text("AI Study Companion"),
            ), 
            body: Column(
                children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: messages.length, 
                            itemBuilder: (context, index) {
                                return MessageBubble(
                                    message: messages[index],
                                );
                            }
                        )
                    ), 
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            children: [
                                Expanded(
                                    child: TextField(
                                        controller: controller, 
                                        decoration: const InputDecoration(
                                            hintText: "Ask anything...", 
                                            border: OutlineInputBorder(),
                                        ),
                                    ),
                                ), 
                                IconButton(
                                    onPressed: sendMessage, 
                                    icon: const Icon(Icons.send),
                                )
                            ]
                        )
                    )
                ]
            ),
        );
    }
}