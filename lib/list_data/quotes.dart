class Quote {
  final String text;
  final String source;

  Quote(this.text, this.source);
}

class Quotes {
  static List<Quote> quotes = [
    Quote('"Maka nikmat Tuhanmu, QS. Ar-Rahman 55:13"',
        'Baca Al-Qur\'an untuk petunjuk hidup.'),
    Quote('"Berbuat baik kepada sesama"', 'QS. Al-Baqarah 2:197'),
    Quote('"Bersabarlah dalam ujian"', 'QS. Al-Baqarah 2:286'),
    Quote('"Cintai sesama seperti dirimu sendiri."', 'QS. Al-Hasyr 59:13'),
    Quote('"Teguhkan iman"', 'QS. Al-Imran 3:200'),
    Quote('"Berbuat adil"', 'QS. An-Nisa 4:135'),
    Quote('"Tolonglah sesama"', 'QS. Al-Baqarah 2:267'),
    Quote('"Syukuri nikmat"', 'QS. Ibrahim 14:7'),
    Quote('"Bacalah Al-Qur\'an"', 'QS. Al-Muzzammil 73:20'),
    Quote('"Takutlah kepada Allah"', 'QS. Al-Imran 3:102'),
  ];
}
