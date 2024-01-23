import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/screens/detail_tafsir_screen.dart';

import '../models/surah.dart';
import '../utilities/colors.dart';

class TafsirTab extends StatefulWidget {
  const TafsirTab({super.key});

  @override
  State<TafsirTab> createState() => _TafsirTabState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _TafsirTabState extends State<TafsirTab> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  List<Surah> surahList = [];
  List<Surah> filteredSurahList = [];

  bool isLoading = true;
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    _getSurahList();
  }

  Future<void> _getSurahList() async {
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      Response response = await dio.get('https://equran.id/api/v2/surat');

      if (response.statusCode == 200) {
        try {
          var responseData = response.data as Map<String, dynamic>;
          var surahData = responseData['data'] as List<dynamic>?;

          if (surahData != null) {
            setState(() {
              surahList =
                  surahData.map((surah) => Surah.fromJson(surah)).toList();
              isLoading = false;
            });
          }
        } catch (e) {
          throw Exception("Error parsing surah data");
        }
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }

  List<Surah> _searchSurah(String query) {
    query = _preprocessQuery(query.toLowerCase());

    return surahList.where((surah) {
      String processedNamaLatin =
          _preprocessQuery(surah.namaLatin.toLowerCase());
      return processedNamaLatin.contains(query);
    }).toList();
  }

  String _preprocessQuery(String query) {
    query = query.replaceAll(RegExp(r'[^\w\s]'), '');
    return query;
  }

  void _onSearchTextChanged(String query) {
    _debouncer.run(() {
      setState(() {
        filteredSurahList = _searchSurah(query);
        hasText = query.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextField(
            controller: _searchController,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: text,
            ),
            onChanged: _onSearchTextChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              filled: true,
              fillColor: secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hintText: "Cari Surah...",
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
              suffixIcon: hasText
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          filteredSurahList.clear();
                          _searchController.clear();
                          hasText = false;
                        });
                      },
                    )
                  : const Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemBuilder: (context, index) => _tafsirItem(
                    context: context,
                    surah: filteredSurahList.isNotEmpty
                        ? filteredSurahList.elementAt(index)
                        : surahList.elementAt(index),
                  ),
                  separatorBuilder: (context, index) =>
                      Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
                  itemCount: filteredSurahList.isNotEmpty
                      ? filteredSurahList.length
                      : surahList.length,
                ),
        ),
      ],
    );
  }

  Widget _tafsirItem({required Surah surah, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(_createRoute(surah));
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

  Route _createRoute(Surah surah) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DetailTafsirScreen(
        noSurat: surah.nomor,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
