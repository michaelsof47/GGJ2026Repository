import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita hilangkan pembatasan Lebar di tingkat Scaffold agar background selalu FULL
      body: Stack(
        children: [
          // LAYER 1: Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Light Fantasy Background.png',
              fit: BoxFit
                  .cover, // KUNCI UTAMA: Gambar akan memenuhi layar tanpa gepeng
            ),
          ),

          // LAYER 2: Overlay redup (Sedikit lebih gelap agar tombol 'Start' menonjol)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // LAYER 3: Konten Menu (Tombol & Judul)
          Center(
            child: SingleChildScrollView(
              child: Container(
                // Di Desktop, kita batasi lebar konten tombolnya saja agar tidak terlalu lebar (500px)
                // Di Android, dia akan otomatis mengikuti lebar layar
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TITLE
                    const Text(
                      "MASK",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                              blurRadius: 15,
                              color: Colors.black,
                              offset: Offset(2, 2))
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Kotak Gambar Tengah (Opsional, bisa kamu isi logo atau biarkan kosong)
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 2),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          size: 80, color: Colors.white),
                    ),
                    const SizedBox(height: 50),

                    _buildMenuButton("Start", () {
                      Navigator.pushNamed(context, "/story");
                    }),

                    const SizedBox(height: 20),

                    _buildMenuButton("Quit", () {
                      print("Quit Game");
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, // Mengikuti lebar constraints (500px)
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.15), // Efek Glassmorphism
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
