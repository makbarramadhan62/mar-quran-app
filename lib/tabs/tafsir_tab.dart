import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/screens/detail_tafsir_screen.dart';

import '../models/surah.dart';
// import '../screens/detail_screen.dart';
import '../utilities/colors.dart';

class TafsirTab extends StatelessWidget {
  const TafsirTab({super.key});

  Future<List<Surah>> _getSurahList() async {
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      Response response = await dio.get('https://equran.id/api/v2/surat');

      if (response.statusCode == 200) {
        List<Surah> surahList = [];

        try {
          var responseData = response.data as Map<String, dynamic>;
          var surahData = responseData['data'] as List<dynamic>?;

          if (surahData != null) {
            surahList =
                surahData.map((surah) => Surah.fromJson(surah)).toList();
          }
        } catch (e) {
          throw Exception("Error parsing surah data");
        }

        return surahList;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Surah>>(
      future: _getSurahList(),
      initialData: const [],
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Gagal mengambil data Pastikan Anda terhubung ke internet.',
              style: TextStyle(color: text, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.separated(
          itemBuilder: (context, index) => _surahItem(
            context: context,
            surah: snapshot.data!.elementAt(index),
          ),
          separatorBuilder: (context, index) =>
              Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
          itemCount: snapshot.data!.length,
        );
      }),
    );
  }

  Widget _surahItem({required Surah surah, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailTafsirScreen(
                noSurat: surah.nomor,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Stack(
                children: [
                  SvgPicture.asset('assets/svgs/nomor-surah.svg'),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Center(
                      child: Text(
                        "${surah.nomor}",
                        style: GoogleFonts.poppins(
                            color: text, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                surah.namaLatin,
                style: GoogleFonts.poppins(
                    color: text, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
        ),
      );
}
