import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';
import '../utils/learning_helper.dart';
import '../widgets/chat_input.dart';
import '../widgets/empty_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../models/chat_response.dart';
import '../models/study_item.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/flashcards_widget.dart';
import '../widgets/summary_widget.dart';
import '../models/study_mode.dart';

class StudyScreen extends StatefulWidget {
  final String sessionId;
  final String? documentName;
  final List<String>? documentNames;
  final String? pdfName;
  final StudyMode mode;

  const StudyScreen({
    super.key, 
    required this.sessionId,
    this.documentName, 
    this.documentNames,
    this.pdfName, 
    this.mode = StudyMode.learn,
  });

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<StudyItem> _timeline = [];
  bool _isTyping = false;
  String? _documentName;
  List<String>? _documentNames;
  String? _pdfName;
  late String _sessionId;

  @override
  void initState() {
    super.initState();
    _sessionId = widget.sessionId;
    _documentName = widget.documentName;
    _documentNames = widget.documentNames;
    _pdfName = widget.pdfName;

    if (_sessionId.isNotEmpty) {
      _loadMessages();
    }
    }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // Future<void> _initializeSession() async {
  //   if (_sessionId.isNotEmpty) {
  //     await _loadMessages();
  //     return;
  //   }

  //   final session = await ApiService.createSession(
  //     _documentName,
  //   );

  //   _sessionId = session.id;
  // }

  void _scrollBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    final msg = text.trim();
    if (msg.isEmpty) return;
    if (_sessionId.isEmpty) {
      final session = await ApiService.createSession(_documentName);
      _sessionId = session.id;
    }
    _controller.clear();

    // Quiz mode
if (widget.mode == StudyMode.quiz) {
  setState(() {
    _timeline.add(
      StudyItem.quiz(
        topic: msg,
        documentName: _documentName,
      ),
    );
  });

  _scrollBottom();
  return;
}

// Flashcards mode
if (widget.mode == StudyMode.flashcards) {
  setState(() {
    _timeline.add(
      StudyItem.flashcards(
        topic: msg,
        documentName: _documentName,
      ),
    );
  });

  _scrollBottom();
  return;
}

    setState(() {
      _timeline.add(StudyItem.message(MessageModel(text: msg, isUser: true)));
      _isTyping = true;
    });
    _scrollBottom();

    try {
      final response = await ApiService.chat(msg, documentName: _documentName, documentNames: _documentNames, sessionId: _sessionId);
      debugPrint("TYPE: ${response.type}");
      debugPrint("TOPIC: ${response.topic}");

      setState(() {
        if (response.type == "chat") {
          _timeline.add(StudyItem.message(
            MessageModel(
          text: response.response ?? "",
          isUser: false,
          learningTitle: response.learningTitle,
        )));
        }
        else if(response.type == "quiz") {
          _timeline.add(StudyItem.quiz(topic: response.topic!, documentName: _documentName));
        }

        else if(response.type == "summary") {
          _timeline.add(
            StudyItem.summary(
              topic: response.topic!, 
              documentName: _documentName,
            )
          );
        }

        else if (response.type == "examples") {
          _timeline.add(
            StudyItem.examples(
              topic: response.topic!, 
              documentName: _documentName,
            )
          );
        }

        else if(response.type == "coding") {
          _timeline.add(
            StudyItem.coding(
              topic: response.topic!, 
              documentName: _documentName,
            )
          );
        }

        else if(response.type == "flashcards") {
          _timeline.add(
            StudyItem.flashcards(
              topic: response.topic!, 
              documentName: _documentName,
            )
          );
        }
        _isTyping = false;
      });
    } catch (_) {
      setState(() {
        _timeline.add(StudyItem.message(MessageModel(
          text: 'Something went wrong. Please try again.',
          isUser: false,
        )));
        _isTyping = false;
      });
    }
    _scrollBottom();
  }

 

  Future<void> _uploadPdf() async {
    final result = await ApiService.uploadPdf();
    if (result == null) return;
    setState(() {
      _pdfName = result["original_filename"];
      _documentName = result["document_name"];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text('$_pdfName uploaded successfully'),
      ]),
      backgroundColor: AppColors.card,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  Future<void> _loadMessages() async {
  print("Loading $_sessionId");
  final messages =
      await ApiService.getMessages(_sessionId);

  print(messages);

  setState(() {
    _timeline.clear();

    for (final message in messages) {
      _timeline.add(
        StudyItem.message(
          MessageModel(
            text: message["content"],
            isUser: message["role"] == "user",
          ),
        ),
      );
    }
  });

  _scrollBottom();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_pdfName != null) _pdfBanner(),
          Expanded(
            child: _timeline.isEmpty
                ? EmptyState(
                  mode: widget.mode,
                  onChipTap: _send,
                  )
                : _buildTimeline(),
          ),
          if (_isTyping) const TypingIndicator(),
          ChatInput(
            controller: _controller,
            onSend: () => _send(_controller.text),
            onAttach: _uploadPdf,
            hasPdf: _pdfName != null,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      title: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        const Text('Eunoia',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ]),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }

  Widget _pdfBanner() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text('$_pdfName · AI will answer from this.',
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        GestureDetector(
          onTap: () => setState(() { _pdfName = null; _documentName = null; }),
          child: const Icon(Icons.close_rounded, color: AppColors.primary, size: 16),
        ),
      ]),
    );
  }

  Widget _buildTimeline() {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _timeline.length,
      itemBuilder: (_, i) {
        final item = _timeline[i];
        Widget child = const SizedBox();
        switch (item.type) {
          case StudyItemType.message:
          child = MessageBubble(
            message: item.message!,
            documentName: item.documentName,
            sessionId: _sessionId,
          );
          break;

          case StudyItemType.quiz:
          child = QuizWidget(
            topic: item.topic!, 
            documentName: item.documentName,
            sessionId: _sessionId,
            documentNames: _documentNames,
          );
          break;

          case StudyItemType.flashcards:
          child = FlashcardsWidget(
            topic: item.topic!, 
            documentName: item.documentName,
            sessionId: _sessionId,
            documentNames: _documentNames,
          );
          break;

          case StudyItemType.coding:
             child = CodingWidget(
             topic: item.topic!,
             documentName: item.documentName,
             documentNames: _documentNames,
             //sessionId: _sessionId,
          );
          break;

          case StudyItemType.summary:
            child = SummaryWidget(
              topic: item.topic!,
              documentName: item.documentName,
              documentNames: _documentNames,
              //sessionId: _sessionId,
            );
            break;

          case StudyItemType.examples:
          child = ExamplesWidget(
            topic: item.topic!,
            documentName: item.documentName,
            documentNames: _documentNames,
            //sessionId: _sessionId,
          );
          break;
        }
        return _TimelineItemWrapper(
          key: ValueKey(i),
          child: child, 
        );
      },
    );
  }

}

class _TimelineItemWrapper extends StatefulWidget {
  final Widget child;
  const _TimelineItemWrapper({super.key, required this.child});

  @override
  State<_TimelineItemWrapper> createState() => _TimelineItemWrapperState();
}

class _TimelineItemWrapperState extends State<_TimelineItemWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}