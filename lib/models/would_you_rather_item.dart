class WouldYouRatherItem {
  final String optionA;
  final String optionB;

  WouldYouRatherItem({
    required this.optionA,
    required this.optionB,
  });

  factory WouldYouRatherItem.fromJson(Map<String, dynamic> json) {
    return WouldYouRatherItem(
      optionA: json["optionA"] ?? "",
      optionB: json["optionB"] ?? "",
    );
  }
}