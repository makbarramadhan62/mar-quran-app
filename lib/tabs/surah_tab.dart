import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

import '../models/surah.dart';
import '../screens/detail_screen.dart';
import '../utilities/colors.dart';

class SurahTab extends StatelessWidget {
  const SurahTab({super.key});

  Future<List<Surah>> _getSurahList() async {
    try {
      Dio dio = Dio();
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
        if (!snapshot.hasData) {
          return Container();
        }
        return ListView.separated(
            itemBuilder: (context, index) => _surahItem(
                context: context, surah: snapshot.data!.elementAt(index)),
            separatorBuilder: (context, index) =>
                Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
            itemCount: snapshot.data!.length);
      }),
    );
  }

  Widget _surahItem({required Surah surah, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailScreen(
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
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.namaLatin,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          surah.tempatTurun,
                          style: GoogleFonts.poppins(
                              color: text,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: text),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${surah.jumlahAyat} Ayat",
                          style: GoogleFonts.poppins(
                              color: text,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(
                surah.nama,
                style: GoogleFonts.amiri(
                    color: primary, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}