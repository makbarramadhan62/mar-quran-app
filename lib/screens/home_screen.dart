import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/utilities/colors.dart';

import '../tabs/surah_tab.dart';
import '../tabs/tafsir_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: _sideBar(context),
      backgroundColor: background,
      appBar: _appBar(size),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _greeting(size),
            ),
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: background,
              automaticallyImplyLeading: false,
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
              children: [SurahTab(), TafsirTab()],
            ),
          ),
        ),
      ),
    );
  }

  _sideBar(context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.025),
                Image.asset(
                  "assets/images/logo_landscape.png",
                  scale: 1.5,
                ),
                SizedBox(height: size.height * 0.025),
                buildMenuItem(
                  textValue: 'Informasi Dataset',
                  icon: Icons.dataset_outlined,
                  onClicked: () {
                    // Navigator.pop(context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const DatasetScreen(),
                    //   ),
                    // );
                  },
                ),
                SizedBox(height: size.height * 0.025),
                buildMenuItem(
                  textValue: 'Cara Penggunaan',
                  icon: Icons.question_mark_outlined,
                  onClicked: () {
                    // Navigator.pop(context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const HowToUseScreen(),
                    //   ),
                    // );
                  },
                ),
                SizedBox(height: size.height * 0.025),
                buildMenuItem(
                  textValue: 'Versi Aplikasi',
                  icon: Icons.info_outline,
                  onClicked: () {
                    // Navigator.pop(context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const AppVersion(),
                    //   ),
                    // );
                  },
                ),
                const Spacer(),
                const Divider(
                  thickness: 2,
                ),
                buildMenuItem(
                  textValue: 'Keluar',
                  icon: Icons.logout,
                  onClicked: () async {
                    // final action = await AlertDialogs.yesCancelDialog(
                    //     context, 'Keluar', 'Apa kamu yakin untuk keluar?');
                    // if (action == DialogsAction.yes) {
                    //   exit(0);
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String textValue,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: primary),
      title: Text(textValue, style: TextStyle(fontSize: 16, color: text)),
      hoverColor: hoverColor,
      onTap: onClicked,
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
                    '"Maka nikmat Tuhanmu yang manakah yang kamu dustakan"',
                    style: GoogleFonts.poppins(
                        color: text, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    'QS. Ar- Rahman 55:13',
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

  AppBar _appBar(Size size) => AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(children: [
          IconButton(
              onPressed: (() => {}),
              icon: SvgPicture.asset('assets/svgs/menu-icon.svg')),
          SizedBox(
            width: size.width * 0.01,
          ),
          Text(
            'MAR Quran App',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: text),
          ),
          const Spacer(),
          IconButton(
              onPressed: (() => {}),
              icon: SvgPicture.asset('assets/svgs/search-icon.svg')),
        ]),
      );
}
