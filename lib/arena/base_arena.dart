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
  // Kita gunakan _game sebagai referensi utama
  final ArenaGame _game = ArenaGame();
  final AudioPlayer _arenaBgmPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _prepareArenaAudio();
  }

  void _prepareArenaAudio() async {
    try {
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
        // Menggunakan FlameGame sebagai tipe dasar di parameter
        'WinMenu': (BuildContext context, FlameGame game) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.yellow, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/win.png', width: 150),
                  const SizedBox(height: 16),
                  const Text(
                    'VICTORY!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      // MENGHILANGKAN GARIS MERAH:
                      // Langsung panggil instance _game yang sudah pasti tipenya ArenaGame
                      _game.restartGame();
                    },
                    child:
                        const Text('RESTART', style: TextStyle(fontSize: 20)),
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
                _game.player?.moveByTouchDelta(event.delta.dx, event.delta.dy);
              },
              child: gameWidget,
            ),
          ));
  }
}