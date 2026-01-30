import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StoryPage extends StatelessWidget {
  StoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Logika Warna - Ganti di sini untuk bereksperimen!
    Color warnaTulisan = Colors.yellowAccent; // Contoh: ganti ke kuning
    Color warnaGambar = Colors.redAccent; // Contoh: ganti ke merah
    Color warnaKotak = Colors.grey[800]!; // Contoh: kotak lebih gelap

    Widget storyContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // KOTAK CERITA
        Container(
          width: kIsWeb
              ? 1000
              : double.infinity, // Lebar dikurangi agar aman di scaling 125%
          constraints: BoxConstraints(
            // Membatasi tinggi agar tombol Next/Back tidak terdorong keluar layar
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
              // AGAR WARNA GAMBAR BISA DIGANTI:
              // Gunakan Icon dengan property 'color'
              Flexible(
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: warnaGambar, // <--- Warna Gambar
                ),
              ),
              SizedBox(height: 20),
              // AGAR WARNA TULISAN BISA DIGANTI:
              Text(
                "Pada suatu hari hiduplah seorang\nanak kecil\nyang terkunci di istana",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: warnaTulisan, // <--- Warna Tulisan
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
              _buildNavButton("Back", () => Navigator.pop(context)),
              _buildNavButton("Begin", () => print("Game Dimulai")),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // SCROLL VIEW: Kunci agar 125% scaling tidak memunculkan garis kuning
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
