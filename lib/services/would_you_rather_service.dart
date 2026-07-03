import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/would_you_rather_item.dart';

class WYRService {
  static const String _file = "assets/brain_break/wyr.json";

  static Future<List<WouldYouRatherItem>> loadRandomGame() async {
    try {
      final jsonString = await rootBundle.loadString(_file);
      final data = json.decode(jsonString);

      if (data == null || data["items"] == null) return [];

      final items = (data["items"] as List)
          .map((e) => WouldYouRatherItem.fromJson(e))
          .toList();

      items.shuffle();
      return items.take(5).toList();
    } catch (e) {
      return [];
    }
  }
}