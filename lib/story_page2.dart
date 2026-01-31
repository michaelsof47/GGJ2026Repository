import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class StoryPage2 extends StatelessWidget {
  const StoryPage2({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna emas mewah sesuai tema kerajaan
    Color warnaTulisan = const Color(0xFFFFD700);

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND UTAMA
          Positioned.fill(
            child: Image.asset(
              'assets/images/BG.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. OVERLAY GELAP
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // 3. KONTEN UTAMA
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
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                      minHeight: 250,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/kotakcerita.png'),
                        fit: BoxFit.fill, // Menghilangkan celah di tepi
                      ),
                    ),
                    // Padding internal agar teks tidak menyentuh pinggir
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Center(
                      child: Text(
                        "Anak kecil itu ingin keluar dari\nkastel yang mengurungnya dan\nharus mengumpulkan topeng",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.medievalSharp(
                          // Font Kerajaan
                          fontSize: kIsWeb ? 32 : 24,
                          fontWeight: FontWeight.bold,
                          color: warnaTulisan,
                          height: 1.5,
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
                        // Kembali ke Story 1
                        _buildNavButton("Back", () => Navigator.pop(context)),

                        // Mulai Game (Begin)
                        _buildNavButton("Begin", () {
                          Navigator.pushNamed(context, "/play");
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

  // Helper Widget Tombol (Desain Kerajaan/Emas)
  Widget _buildNavButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
              color: Color(0xFFFFD700), width: 1), // Border Emas
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
