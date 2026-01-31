import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Jangan lupa install package ini

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // --- KONFIGURASI DURASI (Atur di sini sesukamu) ---
  final Duration durasiZoomIn = const Duration(milliseconds: 1600);
  final Duration durasiZoomOut = const Duration(milliseconds: 800);
  final Duration durasiGeserAtas = const Duration(milliseconds: 1500);
  final Duration durasiTombolMuncul = const Duration(milliseconds: 800);

  // --- STATE ANIMASI ---
  double _logoScale = 0.0;
  double _logoOpacity = 0.0;
  double _buttonOpacity = 0.0;
  Offset _logoOffset = const Offset(0, 0);
  Duration _currentScaleDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _startSequentialAnimation();
  }

  void _startSequentialAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // 1. ZOOM IN (Kecepatan Terpisah)
    if (mounted) {
      setState(() {
        _currentScaleDuration = durasiZoomIn;
        _logoOpacity = 1.0;
        _logoScale = 1.2; // Sedikit lebih besar untuk efek impact
      });
    }

    // Tunggu sampai Zoom In Selesai
    await Future.delayed(durasiZoomIn);

    // 2. ZOOM OUT ke Normal (Kecepatan Terpisah)
    if (mounted) {
      setState(() {
        _currentScaleDuration = durasiZoomOut;
        _logoScale = 1.0;
      });
    }

    // 3. GESER KE ATAS
    await Future.delayed(durasiZoomOut);
    if (mounted) {
      setState(() {
        _logoOffset = const Offset(0, -0.2); // Naik ke atas
      });
    }

    // 4. TOMBOL MUNCUL
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _buttonOpacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Positioned.fill(
            child: Image.asset('assets/images/BG.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- LOGO DENGAN KONTROL KECEPATAN TERPISAH ---
                AnimatedOpacity(
                  opacity: _logoOpacity,
                  duration: const Duration(milliseconds: 800),
                  child: AnimatedSlide(
                    offset: _logoOffset,
                    duration: durasiGeserAtas,
                    curve: Curves.easeOutQuart, // Gerakan geser yang elegan
                    child: AnimatedScale(
                      scale: _logoScale,
                      duration:
                          _currentScaleDuration, // Menggunakan durasi dinamis
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        width: 350,
                        height: 350,
                        child: Image.asset('assets/images/LOGO.png',
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // --- TOMBOL KERAJAAN ---
                AnimatedOpacity(
                  opacity: _buttonOpacity,
                  duration: durasiTombolMuncul,
                  child: Column(
                    children: [
                      _buildRoyalButton("Start", () {
                        Navigator.pushNamed(context, "/story");
                      }),
                      const SizedBox(height: 25),
                      _buildRoyalButton("Quit", () => print("Quit")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Model Kerajaan
  Widget _buildRoyalButton(String label, VoidCallback onPressed) {
    return Container(
      width: 280,
      height: 60,
      decoration: BoxDecoration(
        // Efek Gradasi seperti emas tua atau perkamen
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B4513),
            const Color(0xFFD2691E),
            const Color(0xFF8B4513)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(5),
        border:
            Border.all(color: const Color(0xFFFFD700), width: 2), // Frame Emas
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.cinzel(
            // Font gaya Romawi/Kerajaan
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFD700), // Teks warna Emas
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}
