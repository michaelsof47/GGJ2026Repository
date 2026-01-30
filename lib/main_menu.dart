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
    // Kita bungkus konten dalam sebuah widget agar bisa dipanggil di logika kIsWeb
    Widget myContent = Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TITLE
          const Text(
            "MASK",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Kotak Gambar sesuai Figma (281x281)
          Container(
            width: 281,
            height: 281,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 2),
            ),
            child: const Icon(Icons.image_outlined, size: 100),
          ),
          const SizedBox(height: 40),

          // Tombol Start (Ukuran menyesuaikan Figma)
          _buildMenuButton("Start", () {
            print("Start diklik");
            Navigator.pushNamed(context, "/story");
          }),

          const SizedBox(height: 16),

          // Tombol Quit
          _buildMenuButton("Quit", () {
            print("Quit diklik");
          }),
        ],
      ),
    );

    return Scaffold(
      // LOGIKA UTAMA:
      // Jika Web, konten ditaruh di tengah dengan lebar terbatas agar tidak melar.
      // Jika Android, gunakan SafeArea agar tidak tertutup notch/status bar.
      body: kIsWeb
          ? Center(
              child: SizedBox(
                width: 500, // Membatasi lebar tampilan di browser
                child: myContent,
              ),
            )
          : SafeArea(child: myContent),
    );
  }

  // Helper untuk membuat Button agar codingan di atas tidak berantakan
  Widget _buildMenuButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: 281, // Lebar tombol disamakan dengan kotak gambar Figma
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700], // Warna gelap seperti di gambar
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
