import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/emoji_item.dart';

class EmojiGuessService {
  static const List<String> _files = [
    "assets/brain_break/emoji_guess/movies.json",
  ];

  static Future<List<EmojiItem>> loadRandomGame() async {
    final random = Random();

    final file = _files[random.nextInt(_files.length)];

    final jsonString = await rootBundle.loadString(file);

    final data = json.decode(jsonString);

    final items = (data["items"] as List)
        .map((e) => EmojiItem.fromJson(e))
        .toList();

    items.shuffle();

    return items.take(5).toList();
  }
}