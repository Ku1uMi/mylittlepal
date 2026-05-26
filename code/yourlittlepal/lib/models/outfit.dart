class Outfit {
  final String top;
  final String bottom;

  const Outfit({
      this.top = '',
      this.bottom = '',
    });

  Outfit update({
    String? top,
    String? bottom,
  }){
      return Outfit(
        top: top ?? this.top,
        bottom: bottom ?? this.bottom
      );
  }

  Map<String, dynamic> toJson() => {
    'top': top,
    'bottom': bottom
  };

  factory Outfit.fromJson(Map<String, dynamic> json) => Outfit(
    top: json['top'] as String,
    bottom: json['bottom'] as String
  );
}
