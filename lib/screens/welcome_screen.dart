import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/utilities/colors.dart';

import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: SvgPicture.asset('assets/svgs/mar-logo.svg'),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  "Quran App",
                  style: GoogleFonts.poppins(
                      color: text, fontWeight: FontWeight.bold, fontSize: 28),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Baca dan Pelajari Al-Quran dimanapun, kapanpun',
                  style: GoogleFonts.poppins(
                      fontSize: 15, color: text, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: SvgPicture.asset('assets/svgs/splash.svg'),
                ),
                const Spacer(),
                Center(
                  child: Text(
                    "Dengan mengklik Mulai, anda menyetujui Syarat dan Ketentuan Penggunaan grapsense",
                    style: TextStyle(
                      color: text,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: button,
                    minimumSize: Size(size.width, 50),
                    shadowColor: Colors.grey,
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Mulai",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
