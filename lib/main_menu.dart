import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

// DEKLARASI GLOBAL: Agar musik tidak mati saat pindah ke Story
final AudioPlayer globalBgmPlayer = AudioPlayer();

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // --- STATE AUDIO & ANIMASI ---
  bool _isMuted = false; // Status suara
  double _logoScale = 0.0;
  double _logoOpacity = 0.0;
  double _buttonOpacity = 0.0;
  Offset _logoOffset = const Offset(0, 0);
  Duration _currentScaleDuration = const Duration(milliseconds: 500);

  // --- KONFIGURASI DURASI ---
  final Duration durasiZoomIn = const Duration(milliseconds: 1600);
  final Duration durasiZoomOut = const Duration(milliseconds: 800);
  final Duration durasiGeserAtas = const Duration(milliseconds: 1500);
  final Duration durasiTombolMuncul = const Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _startSequentialAnimation();
  }

  // FUNGSI MUSIK (Mendukung Mute)
  void _setupAndPlayMusic() async {
    try {
      if (globalBgmPlayer.state == PlayerState.playing) return;
      await globalBgmPlayer.setReleaseMode(ReleaseMode.loop);
      await globalBgmPlayer.play(AssetSource('sounds/main_menu.mp3'),
          volume: _isMuted ? 0.0 : 0.9);
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fungsi Toggle Suara
  void _toggleSound() {
    setState(() {
      _isMuted = !_isMuted;
    });
    globalBgmPlayer.setVolume(_isMuted ? 0.0 : 0.9);
  }

  void _startSequentialAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _currentScaleDuration = durasiZoomIn;
        _logoOpacity = 1.0;
        _logoScale = 1.2;
      });
    }
    await Future.delayed(durasiZoomIn);
    if (mounted) {
      setState(() {
        _currentScaleDuration = durasiZoomOut;
        _logoScale = 1.0;
      });
    }
    await Future.delayed(durasiZoomOut);
    if (mounted) {
      setState(() {
        _logoOffset = const Offset(0, -0.2);
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _buttonOpacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _setupAndPlayMusic(), // Klik layar untuk start musik
      child: Scaffold(
        body: Stack(
          children: [
            // BACKGROUND
            Positioned.fill(
              child: Image.asset(
                'assets/images/Light Fantasy Background.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),

            // --- TOMBOL MUTE (Pojok Kanan Atas) ---
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  _setupAndPlayMusic(); // Pastikan musik inisialisasi jika belum
                  _toggleSound();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFFFD700), width: 1.5),
                  ),
                  child: Icon(
                    _isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    color: const Color(0xFFFFD700),
                    size: 30,
                  ),
                ),
              ),
            ),

            // LOGO & TOMBOL UTAMA
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _logoOpacity,
                    duration: const Duration(milliseconds: 800),
                    child: AnimatedSlide(
                      offset: _logoOffset,
                      duration: durasiGeserAtas,
                      curve: Curves.easeOutQuart,
                      child: AnimatedScale(
                        scale: _logoScale,
                        duration: _currentScaleDuration,
                        curve: Curves.easeInOut,
                        child: SizedBox(
                          width: 350,
                          height: 350,
                          child: Image.asset(
                            'assets/images/LOGO.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: _buttonOpacity,
                    duration: durasiTombolMuncul,
                    child: Column(
                      children: [
                        _buildRoyalButton("Start", () {
                          _setupAndPlayMusic();
                          // Navigasi ke story, musik TETAP JALAN karena globalBgmPlayer tidak di-stop
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
      ),
    );
  }

  Widget _buildRoyalButton(String label, VoidCallback onPressed) {
    return Container(
      width: 280,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B4513), Color(0xFFD2691E), Color(0xFF8B4513)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFFFFD700), width: 2),
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFD700),
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}
