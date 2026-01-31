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
    // 1. KONTEN MENU (UI LAYER)
    Widget myContent = Container(
      width: double.infinity,
      // Color dibuat transparent agar gambar background di bawahnya terlihat
      color: Colors.transparent,
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

          // Kotak Gambar (Tengah)
          Container(
            width: 281,
            height: 281,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), // Sedikit putih transparan
              border: Border.all(color: Colors.purple, width: 2),
            ),
            child: const Icon(Icons.image_outlined, size: 100),
          ),
          const SizedBox(height: 40),

          _buildMenuButton("Start", () {
            Navigator.pushNamed(context, "/story");
          }),

          const SizedBox(height: 16),

          _buildMenuButton("Quit", () {
            print("Quit diklik");
          }),
        ],
      ),
    );

    // 2. PROSES PENGGABUNGAN (STACK LAYER)
    Widget mainStack = Stack(
      children: [
        // LAYER 1: Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/Light Fantasy Background.jpg.png', // <--- Pastikan file ini ada di assets
            fit: BoxFit.cover,
          ),
        ),

        // LAYER 2: Overlay redup (Opsional, agar teks lebih terbaca)
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.1)),
        ),

        // LAYER 3: Konten Menu Utama
        myContent,
      ],
    );

    return Scaffold(
      body: kIsWeb
          ? Center(
              child: SizedBox(
                width: 500,
                child: mainStack,
              ),
            )
          : SafeArea(child: mainStack),
    );
  }

  Widget _buildMenuButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: 281,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700],
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
