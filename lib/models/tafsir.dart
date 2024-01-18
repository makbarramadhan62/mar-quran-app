class Tafsir {
  int? ayat;
  String teks;

  Tafsir({
    required this.ayat,
    required this.teks,
  });

  factory Tafsir.fromJson(Map<String, dynamic> json) {
    return Tafsir(
      ayat: json['ayat'] ?? 0,
      teks: json['teks'],
    );
  }

  Map<String, dynamic> toJson() => {
        "ayat": ayat,
        "teks": teks,
      };
}
