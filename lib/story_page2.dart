import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StoryPage2 extends StatelessWidget {
  StoryPage2({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Logika Warna (Sesuaikan dengan StoryPage 1 agar serasi)
    Color warnaTulisan = Colors.white;
    Color warnaGambar = Colors.white70;
    Color warnaKotak = Colors.grey[600]!;

    Widget storyContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // KOTAK CERITA
        Container(
          width: kIsWeb ? 1000 : double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            minHeight: 200,
          ),
          decoration: BoxDecoration(
            color: warnaKotak,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: warnaGambar,
                ),
              ),
              SizedBox(height: 20),
              // TEKS CERITA KEDUA
              Text(
                "Anak kecil itu ingin keluar dari\nkastel yang mengurungnya dan\nharus mengumpulkan topeng",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: warnaTulisan,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        // TOMBOL NAVIGASI
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back: Kembali ke StoryPage 1
              _buildNavButton("Back", () => Navigator.pop(context)),

              // Begin: Pindah ke Level Selection atau Game
              _buildNavButton("Begin", () {
                print("Game Dimulai");
                // Nanti tambahkan Navigator.push ke halaman LevelSelect di sini
              }),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: storyContent,
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: 130,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(label, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
