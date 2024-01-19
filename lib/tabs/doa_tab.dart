import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/models/doa.dart';

import '../models/surah.dart';
import '../utilities/colors.dart';

class DoaTab extends StatelessWidget {
  const DoaTab({super.key});

  Future<List<Doa>> _getDoaList() async {
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      Response response =
          await dio.get('https://doa-doa-api-ahmadramadhan.fly.dev/api');

      if (response.statusCode == 200) {
        List<Doa> doaList = [];

        try {
          var responseData = response.data as List<dynamic>;
          doaList = responseData.map((doa) => Doa.fromJson(doa)).toList();
        } catch (e) {
          throw Exception("Error parsing doa data");
        }

        return doaList;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doa>>(
      future: _getDoaList(),
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
          itemBuilder: (context, index) => _doaItem(
            context: context,
            doa: snapshot.data!.elementAt(index),
          ),
          separatorBuilder: (context, index) =>
              Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
          itemCount: snapshot.data!.length,
        );
      }),
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
                )),
          ],
        ),
      );
}
