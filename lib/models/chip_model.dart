class ChipNo {
  final String value;
  final bool isValid;

  ChipNo({required this.value, required this.isValid});

  factory ChipNo.fromJson(Map<String, dynamic> json) {
    return ChipNo(
      value: json['String'],
      isValid: json['Valid'],
    );
  }
}