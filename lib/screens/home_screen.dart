import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/tabs/doa_tab.dart';
import 'package:quran_app/utilities/colors.dart';
import 'package:quran_app/utilities/coming_soon.dart';

import '../list_data/quotes.dart';
import '../tabs/surah_tab.dart';
import '../tabs/tafsir_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      appBar: _appBar(size, context),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _greeting(size),
            ),
            SliverAppBar(
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: background,
                ),
              ),
              shape: Border(
                  bottom: BorderSide(
                      width: 5,
                      color: const Color(0xFFAAAAAA).withOpacity(.1))),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: _tab(),
              ),
            )
          ],
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: TabBarView(
              children: [SurahTab(), TafsirTab(), DoaTab()],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(Size size, BuildContext context) => AppBar(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          SizedBox(
            width: size.width * 0.01,
          ),
          Text(
            'MAR Quran App',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: secondaryText),
          ),
          const Spacer(),
          IconButton(
              onPressed: (() => {showComingSoonDialog(context)}),
              icon: SvgPicture.asset('assets/svgs/search-icon.svg')),
        ]),
      );

  Padding _greeting(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            'Assalamualaikum',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: secondaryText),
          ),
          SizedBox(
            height: size.height * 0.005,
          ),
          Text(
            'Akhi wa Ukhti',
            style: GoogleFonts.poppins(
                fontSize: 24, fontWeight: FontWeight.w600, color: text),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          _quotes(size)
        ],
      ),
    );
  }

  Padding _quotes(Size size) {
    Quote randomQuote = Quotes.quotes[Random().nextInt(Quotes.quotes.length)];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/svgs/book.svg'),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Quotes',
                        style: GoogleFonts.poppins(
                            color: text, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    randomQuote.text,
                    style: GoogleFonts.poppins(
                        color: text, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    randomQuote.source,
                    style: GoogleFonts.poppins(
                      color: text,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -10,
              right: -10,
              child: SvgPicture.asset('assets/svgs/quran.svg'),
            ),
          ],
        ),
      ),
    );
  }

  TabBar _tab() {
    return TabBar(
        unselectedLabelColor: secondaryText,
        labelColor: text,
        indicatorColor: primary,
        indicatorWeight: 3,
        tabs: [
          _tabItem(label: "Surah"),
          _tabItem(label: "Tafsir"),
          _tabItem(label: "Doa"),
        ]);
  }

  Tab _tabItem({required String label}) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
