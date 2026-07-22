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
import 'library_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class StudyScreen extends StatefulWidget {
  final String sessionId;
  final String? documentName;
  final List<String>? documentNames;
  final List<String>? pdfNames;
  final StudyMode mode;

  const StudyScreen({
    super.key, 
    required this.sessionId,
    this.documentName, 
    this.documentNames,
    this.pdfNames,
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
  List<String> _documentNames = [];
  List<String> _pdfNames = [];
  late String _sessionId;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _sessionId = widget.sessionId;
    _documentName = widget.documentName;
    _documentNames = [...?widget.documentNames];
    _pdfNames = [...?widget.pdfNames];

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

  Future<void> _openLibraryPicker() async {
  final selected = await Navigator.push<List<Map<String, String>>>(
    context,
    MaterialPageRoute(
      builder: (_) => const LibraryScreen(
        selectionMode: true,
      ),
    ),
  );

  if (selected == null || selected.isEmpty) return;

  setState(() {
    for (final doc in selected) {
      final documentName = doc["document_name"]!;
      final pdfName = doc["original_filename"]!;

      if (!_documentNames.contains(documentName)) {
        _documentNames.add(documentName);
        _pdfNames.add(pdfName);
      }
    }

    if (_documentNames.isNotEmpty) {
      _documentName = _documentNames.first;
    }
  });
}

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

  Future<void> _toggleListening() async {
  print("MIC PRESSED");

  if (!_isListening) {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print("STATUS: $status");
      },
      onError: (error) {
        print("ERROR: ${error.errorMsg}");
      },
      debugLogging: true,
    );

    print("AVAILABLE: $available");

    if (!available) return;

    setState(() {
      _isListening = true;
    });

    _speech.listen(
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: "en_US",
      onResult: (result) {
        print("WORDS: ${result.recognizedWords}");

        setState(() {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });

        if (result.finalResult) {
          _speech.stop();

          setState(() {
            _isListening = false;
          });
        }
      },
    );
  } else {
    await _speech.stop();

    setState(() {
      _isListening = false;
    });
  }
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

 

  Future<void> _showAttachmentOptions() async {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text("Upload Documents"),
              onTap: () {
                Navigator.pop(context);
                _uploadPdf();
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Choose from Library"),
              onTap: () {
                Navigator.pop(context);
                _openLibraryPicker();
              },
            ),
          ],
        ),
      );
    },
  );
}

  Future<void> _uploadPdf() async {
    final result = await ApiService.uploadPdf();
    if (result == null) return;
    setState(() {
      _documentNames.add(result["document_name"]);
      _pdfNames.add(result["original_filename"]);
      _documentName = _documentNames.first;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text('${result["original_filename"]} uploaded successfully')
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
          if (_pdfNames.isNotEmpty)
    _documentChips(),
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
            onAttach: _showAttachmentOptions,
            onMic: _toggleListening,
            isListening: _isListening,
            hasPdf: _pdfNames.isNotEmpty,
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

  Widget _documentChips() {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        _pdfNames.length,
        (index) => Chip(
          label: Text(_pdfNames[index]),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() {
              _pdfNames.removeAt(index);
              _documentNames.removeAt(index);
            });
          },
        ),
      ),
    ),
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