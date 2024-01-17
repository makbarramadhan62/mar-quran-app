import 'dart:convert';

import 'ayat.dart';

List<Surah> surahFromJson(String str) {
  final parsed = json.decode(str);
  return List<Surah>.from(parsed.map((x) => Surah.fromJson(x)));
}

String surahToJson(List<Surah> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Surah {
  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
    this.ayat,
  });

  int nomor;
  String nama;
  String namaLatin;
  int jumlahAyat;
  String tempatTurun;
  String arti;
  String deskripsi;
  Map<String, String> audioFull;
  List<Ayat>? ayat;

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json['jumlahAyat'] as int,
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audioFull: Map<String, String>.from(json["audioFull"] ?? {}),
        ayat: json.containsKey('ayat')
            ? List<Ayat>.from(json["ayat"].map((x) => Ayat.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
        "tempatTurun": tempatTurun,
        "arti": arti,
        "deskripsi": deskripsi,
        "audioFull": audioFull,
        "ayat": ayat != null
            ? List<dynamic>.from(ayat!.map((e) => e.toJson()))
            : [],
      };
}
