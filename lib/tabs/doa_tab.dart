import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/models/doa.dart';

import '../utilities/colors.dart';

class DoaTab extends StatefulWidget {
  const DoaTab({super.key});

  @override
  State<DoaTab> createState() => _DoaTabState();
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

class _DoaTabState extends State<DoaTab> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  List<Doa> doaList = [];
  List<Doa> filteredDoaList = [];

  bool isLoading = true;
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    _getDoaList();
  }

  Future<void> _getDoaList() async {
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      Response response =
          await dio.get('https://doa-doa-api-ahmadramadhan.fly.dev/api');

      if (response.statusCode == 200) {
        try {
          var responseData = response.data as List<dynamic>;

          setState(() {
            doaList = responseData.map((doa) => Doa.fromJson(doa)).toList();
            isLoading = false;
          });
        } catch (e) {
          throw Exception("Error parsing doa data");
        }
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }

  List<Doa> _searchDoa(String query) {
    query = _preprocessQuery(query.toLowerCase());

    return doaList.where((doa) {
      String processedNamaLatin = _preprocessQuery(doa.doa.toLowerCase());
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
        filteredDoaList = _searchDoa(query);
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
              hintText: "Cari Doa...",
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
                          filteredDoaList.clear();
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
                  itemBuilder: (context, index) => _doaItem(
                    context: context,
                    doa: filteredDoaList.isNotEmpty
                        ? filteredDoaList.elementAt(index)
                        : doaList.elementAt(index),
                  ),
                  separatorBuilder: (context, index) =>
                      Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
                  itemCount: filteredDoaList.isNotEmpty
                      ? filteredDoaList.length
                      : doaList.length,
                ),
        ),
      ],
    );
  }

  Widget _doaItem({required Doa doa, required BuildContext context}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ExpansionTile(
          shape: Border.all(color: Colors.transparent),
          tilePadding: EdgeInsets.zero,
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Row(
            children: [
              Stack(
                children: [
                  SvgPicture.asset('assets/svgs/nomor-surah.svg'),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Center(
                      child: Text(
                        doa.id,
                        style: GoogleFonts.poppins(
                          color: text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  doa.doa,
                  style: GoogleFonts.poppins(
                    color: text,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          children: [
            ListTile(
              title: Column(
                children: [
                  Text(
                    doa.ayat,
                    style: GoogleFonts.amiri(
                      color: text,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      height: 2,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doa.latin,
                    style: GoogleFonts.poppins(
                      color: text,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Artinya: ${doa.artinya}',
                    style: GoogleFonts.poppins(
                      color: text,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
