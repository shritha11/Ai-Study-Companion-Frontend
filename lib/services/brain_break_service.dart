import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/brain_break_challenge.dart';

class BrainBreakService {
  static Future<BrainBreakChallenge>
      loadRandomChallenge() async {

    final manifestString =
        await rootBundle.loadString(
      'assets/brain_break/manifest.json',
    );

    final manifest =
        jsonDecode(manifestString);

    final categories =
        manifest["categories"] as List;

    final random = Random();

    final category =
        categories[random.nextInt(categories.length)];

    final files =
        category["files"] as List;

    final file =
        files[random.nextInt(files.length)];

    final jsonString =
        await rootBundle.loadString(
      "assets/brain_break/$file",
    );

    final data =
        jsonDecode(jsonString);

    data["questions"].shuffle();

    data["questions"] =
        data["questions"].take(5).toList();

    return BrainBreakChallenge.fromJson(data);
  }
}