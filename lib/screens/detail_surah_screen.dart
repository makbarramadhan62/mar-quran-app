import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:audioplayers/audioplayers.dart";

import '../models/ayat.dart';
import '../models/surah.dart';
import '../utilities/colors.dart';

class DetailSurahScreen extends StatefulWidget {
  final int noSurat;
  const DetailSurahScreen({super.key, required this.noSurat});

  @override
  State<DetailSurahScreen> createState() => _DetailSurahScreenState();
}

class _DetailSurahScreenState extends State<DetailSurahScreen> {
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
          await dio.get("https://equran.id/api/v2/surat/$noSurat");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;

        if (responseData.containsKey('data')) {
          Map<String, dynamic> surahData =
              responseData['data'] as Map<String, dynamic>;

          Surah surah = Surah.fromJson(surahData);
          surah.ayat = (surahData['ayat'] as List?)
                  ?.map((ayatData) => Ayat.fromJson(ayatData))
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
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: background,
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
                itemBuilder: (context, index) => _ayatItem(
                  size: size,
                  ayat: surah.ayat!.elementAt(
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

  Future<void> playAudio(String key, {Ayat? ayat, Surah? surah}) async {
    String? url;

    if (ayat != null) {
      url = ayat.audio[key];
    } else if (surah != null) {
      url = surah.audioFull[key];
    }

    if (url != null) {
      if (audioPlayer.state == PlayerState.playing) {
        await audioPlayer.pause();
      } else {
        audioPlayer.setVolume(1.0);
        await audioPlayer.play(UrlSource(url));
      }
    }
  }

  Future<void> _toggleAudio(Ayat ayat) async {
    if (ayat.isPlaying) {
      await stopAudio();
    } else {
      await playAudio("01", ayat: ayat);
    }
    setState(() {
      ayat.isPlaying = audioPlayer.state == PlayerState.playing;
    });
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
  }

  Widget _ayatItem({required Ayat ayat, required Size size}) => Padding(
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
                      '${ayat.nomorAyat}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.share_outlined,
                    color: primary,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _toggleAudio(ayat);
                    },
                    child: Icon(
                      ayat.isPlaying ? Icons.pause : Icons.play_arrow_outlined,
                      color: primary,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Icon(
                    Icons.bookmark_outline,
                    color: primary,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              ayat.teksArab,
              style: GoogleFonts.amiri(
                  color: text, fontWeight: FontWeight.bold, fontSize: 28),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Text(
              ayat.teksIndonesia,
              style: GoogleFonts.poppins(color: text, fontSize: 16),
            ),
          ],
        ),
      );

  Widget _details({required Surah surah}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(children: [
          Container(
            height: 257,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
                colors: [
                  Color(0xFF60A5FA),
                  Color(0xFF1E40AF),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: .2,
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
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 26),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await playAudio("01", surah: surah);
                        setState(() {
                          isPlaying = audioPlayer.state == PlayerState.playing;
                        });
                      },
                      child: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_fill_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  surah.arti,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Divider(
                  color: Colors.white.withOpacity(.35),
                  thickness: 2,
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      surah.tempatTurun,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
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
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${surah.jumlahAyat} Ayat",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                SvgPicture.asset('assets/svgs/bismillah.svg')
              ],
            ),
          )
        ]),
      );

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
                stopAudio();
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