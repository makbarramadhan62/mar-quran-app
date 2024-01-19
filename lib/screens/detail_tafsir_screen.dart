import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:audioplayers/audioplayers.dart";
import 'package:quran_app/models/tafsir.dart';
import 'package:quran_app/utilities/coming_soon.dart';

import '../models/surah.dart';
import '../utilities/colors.dart';

class DetailTafsirScreen extends StatefulWidget {
  final int noSurat;
  const DetailTafsirScreen({super.key, required this.noSurat});

  @override
  State<DetailTafsirScreen> createState() => _DetailTafsirnState();
}

class _DetailTafsirnState extends State<DetailTafsirScreen> {
  late AudioPlayer audioPlayer;
  late bool isPlaying;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setVolume(1.0);
    isPlaying = false;
  }

  Future<Surah> _getDetailSurah(int noSurat) async {
    try {
      Dio dio = Dio();
      Response response =
          await dio.get("https://equran.id/api/v2/tafsir/$noSurat");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;

        if (responseData.containsKey('data')) {
          Map<String, dynamic> surahData =
              responseData['data'] as Map<String, dynamic>;

          Surah surah = Surah.fromJson(surahData);
          surah.tafsir = (surahData['tafsir'] as List?)
                  ?.map((tafsirData) => Tafsir.fromJson(tafsirData))
                  .toList() ??
              [];
          return surah;
        } else {
          throw Exception("Failed to load detail surah");
        }
      } else {
        throw Exception("Failed to load detail surah");
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<Surah>(
      future: _getDetailSurah(widget.noSurat),
      initialData: null,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: background,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Row(children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset('assets/svgs/back-icon.svg')),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Text(
                  "Memuat...",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: text,
                  ),
                ),
              ]),
            ),
            backgroundColor: background,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Gagal mengambil data Pastikan Anda terhubung ke internet.',
              style: TextStyle(color: text, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          );
        }
        Surah surah = snapshot.data!;
        return Scaffold(
          backgroundColor: background,
          appBar: _appBar(context: context, surah: surah, size: size),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _details(surah: surah),
              )
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView.separated(
                itemBuilder: (context, index) => _tafsirItem(
                  size: size,
                  tafsir: surah.tafsir!.elementAt(
                    index + (widget.noSurat == 1 ? 1 : 0),
                  ),
                ),
                itemCount: surah.jumlahAyat + (widget.noSurat == 1 ? -1 : 0),
                separatorBuilder: (context, index) => Container(),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _tafsirItem({required Tafsir tafsir, required Size size}) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                  color: secondary, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(27 / 2)),
                    child: Center(
                        child: Text(
                      '${tafsir.ayat}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      showComingSoonDialog(context);
                    },
                    child: Icon(
                      Icons.share_outlined,
                      color: primary,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      showComingSoonDialog(context);
                    },
                    child: Icon(
                      Icons.bookmark_outline,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              tafsir.teks,
              style: GoogleFonts.poppins(
                  color: text, fontWeight: FontWeight.w500, fontSize: 18),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
          ],
        ),
      );

  Widget _details({required Surah surah}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
            colors: [
              Color(0xFFE5ECFD),
              Color(0xFFF3F5FC),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -10,
              right: -10,
              child: Opacity(
                opacity: .5,
                child: SvgPicture.asset(
                  'assets/svgs/quran.svg',
                  width: 324 - 55,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        surah.namaLatin,
                        style: GoogleFonts.poppins(
                            color: text,
                            fontWeight: FontWeight.w500,
                            fontSize: 26),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    surah.arti,
                    style: GoogleFonts.poppins(
                        color: text, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Divider(
                    color: text.withOpacity(.35),
                    thickness: 2,
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        surah.tempatTurun,
                        style: GoogleFonts.poppins(
                          color: text,
                          fontWeight: FontWeight.w500,
                        ),
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SvgPicture.asset(
                    'assets/svgs/bismillah.svg',
                    // ignore: deprecated_member_use
                    color: text,
                  )
                ],
              ),
            )
          ],
        ),
      ));

  AppBar _appBar(
          {required BuildContext context,
          required Surah surah,
          required Size size}) =>
      AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: SvgPicture.asset('assets/svgs/back-icon.svg')),
          SizedBox(
            width: size.width * 0.01,
          ),
          Text(
            surah.namaLatin,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: text,
            ),
          ),
          const Spacer(),
          IconButton(
              onPressed: (() => {}),
              icon: SvgPicture.asset('assets/svgs/search-icon.svg')),
        ]),
      );
}
