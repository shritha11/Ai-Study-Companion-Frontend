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
  final String? documentName;
  const StudyItem({required this.type, this.message, this.topic, this.documentName,
 });

  factory StudyItem.message(MessageModel message){
   return StudyItem(
     type: StudyItemType.message,
      message: message,
    );
  }

  factory StudyItem.quiz({ required String topic, String? documentName,
  }){

    return StudyItem(
     type: StudyItemType.quiz,
     topic: topic,
     documentName: documentName,
   );
}

  factory StudyItem.flashcards({
    required String topic,
    String? documentName,
  }){

    return StudyItem(
      type: StudyItemType.flashcards,
      topic: topic,
      documentName: documentName,
    );
  }

  factory StudyItem.summary({
    required String topic,
    String? documentName,
  }){

    return StudyItem(
     type: StudyItemType.summary,
     topic: topic,
     documentName: documentName,
    );
  }

  factory StudyItem.examples({
    required String topic,
    String? documentName,
 }){

    return StudyItem(
     type: StudyItemType.examples,
     topic: topic,
     documentName: documentName,
    );
  }

  factory StudyItem.coding({
   required String topic,
   String? documentName,
  }){

    return StudyItem(
      type: StudyItemType.coding,
      topic: topic,
      documentName: documentName,
    );
  }
}