import 'message_model.dart';

enum StudyItemType {
  message,
  quiz,
 flashcards,
  summary,
  examples,
  coding,
}

class StudyItem {
  final StudyItemType type;
  final MessageModel? message;
  final String? topic;
  final String? pdfContext;
  const StudyItem({required this.type, this.message, this.topic, this.pdfContext,
 });

  factory StudyItem.message(MessageModel message){
   return StudyItem(
     type: StudyItemType.message,
      message: message,
    );
  }

  factory StudyItem.quiz({ required String topic, String? pdfContext,
  }){

    return StudyItem(
     type: StudyItemType.quiz,
     topic: topic,
     pdfContext: pdfContext,
   );
}

  factory StudyItem.flashcards({
    required String topic,
    String? pdfContext,
  }){

    return StudyItem(
      type: StudyItemType.flashcards,
      topic: topic,
      pdfContext: pdfContext,
    );
  }

  factory StudyItem.summary({
    required String topic,
  }){

    return StudyItem(
     type: StudyItemType.summary,
    topic: topic,
    );
  }

  factory StudyItem.examples({
    required String topic,
 }){

    return StudyItem(
     type: StudyItemType.examples,
     topic: topic,
    );
  }

  factory StudyItem.coding({
   required String topic,

  }){

    return StudyItem(
      type: StudyItemType.coding,
      topic: topic,
    );
  }
}