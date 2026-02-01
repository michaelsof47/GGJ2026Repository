import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ggj2026repository/arena/arena_game.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ggj2026repository/main_menu.dart';

class BaseArena extends StatefulWidget {
  @override
  State<BaseArena> createState() => _BaseArenaState();
}

class _BaseArenaState extends State<BaseArena> {
  // Instance game utama
  final ArenaGame _game = ArenaGame();
  final AudioPlayer _arenaBgmPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _prepareArenaAudio();
  }

  void _prepareArenaAudio() async {
    try {
      // Menghentikan musik global jika ada, lalu memutar musik in-game
      await globalBgmPlayer.stop();
      await Future.delayed(const Duration(milliseconds: 100));
      await _arenaBgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _arenaBgmPlayer.play(AssetSource('sounds/ingame.mp3'), volume: 0.7);
    } catch (e) {
      print("Error arena music: $e");
    }
  }

  @override
  void dispose() {
    _arenaBgmPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget gameWidget = GameWidget(
      game: _game,
      overlayBuilderMap: {
        // Overlay yang muncul ketika menang (Karpet tersentuh)
        'WinMenu': (BuildContext context, FlameGame game) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.yellow, width: 3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gambar Victory
                  Image.asset('assets/images/win.png', width: 300),
                  const SizedBox(height: 20),
                  const Text(
                    'VICTORY!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- TOMBOL RESTART ---
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(220, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Menggunakan referensi _game langsung untuk menghindari error casting
                      _game.restartGame();
                    },
                    child: const Text('RESTART',
                        style: TextStyle(fontSize: 22, color: Colors.white)),
                  ),

                  const SizedBox(height: 16),

                  // --- TOMBOL QUIT ---
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size(220, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      _arenaBgmPlayer.stop(); // Berhenti musik saat keluar

                      // Kembali ke Main Menu (Rute '/' di main.dart)
                      // pushNamedAndRemoveUntil digunakan agar tumpukan story page dihapus
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    child: const Text('QUIT',
                        style: TextStyle(fontSize: 22, color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      },
    );

    return kIsWeb
        ? Scaffold(body: gameWidget)
        : SafeArea(
            child: Scaffold(
              body: Listener(
                onPointerMove: (event) {
                  // Input smartphone untuk menggerakkan player
                  _game.player
                      ?.moveByTouchDelta(event.delta.dx, event.delta.dy);
                },
                child: gameWidget,
              ),
            ),
          );
  }
}
