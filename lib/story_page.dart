import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class StoryPage extends StatelessWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna tulisan kuning emas agar lebih mewah
    Color warnaTulisan = const Color(0xFFFFD700);

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND UTAMA
          Positioned.fill(
            child: Image.asset(
              'assets/images/BG.png',
              fit: BoxFit.cover,
            ),
          ),

          // OVERLAY GELAP (Agar kontras tetap terjaga)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // KONTEN UTAMA
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- KOTAK CERITA ---
                  Container(
                    width: kIsWeb ? 800 : double.infinity,
                    constraints: BoxConstraints(
                      // Mengatur agar tinggi kotak tidak terlalu memenuhi layar di web
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                      minHeight: 250,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/kotakcerita.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Padding internal agar teks tidak menempel ke pinggir gambar
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Center(
                      // Memastikan konten di dalam kotak benar-benar di tengah
                      child: Text(
                        "Pada suatu hari hiduplah seorang\nanak kecil\nyang terkunci di istana",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.medievalSharp(
                          // Menggunakan Font Kerajaan
                          fontSize: kIsWeb
                              ? 32
                              : 24, // Lebih besar di Web agar tidak kopong
                          fontWeight: FontWeight.bold,
                          color: warnaTulisan,
                          height:
                              1.5, // Mengatur jarak antar baris (line height)
                          shadows: const [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // --- TOMBOL NAVIGASI ---
                  SizedBox(
                    width: kIsWeb ? 800 : double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNavButton("Back", () {
                          Navigator.pop(context);
                        }),
                        _buildNavButton("Next", () {
                          Navigator.pushNamed(context, "/story2");
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
              color: Color(0xFFFFD700), width: 1), // Border emas tipis
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        // Font tombol juga disesuaikan agar senada
        style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
