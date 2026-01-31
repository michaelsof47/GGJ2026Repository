import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ggj2026repository/arena/arena_game.dart';

class BaseArena extends StatefulWidget {
  @override
  State<BaseArena> createState() => _BaseArenaState();
}

class _BaseArenaState extends State<BaseArena> {
  // Instance Game disimpan di sini agar tidak hilang saat rebuild
  final ArenaGame _game = ArenaGame();

  @override
  Widget build(BuildContext context) {
    // Helper widget for GameWidget
    Widget gameWidget = GameWidget(game: _game);

    return kIsWeb
        ? Scaffold(body: gameWidget)
        : SafeArea(
            child: Scaffold(
            body: GestureDetector(
              // Delta Logic: Cukup panUpdate saja.
              // Kalau jari diam, tidak ada event update -> player diam.
              onPanUpdate: (details) {
                // Kirim perubahan posisi (Delta) langsung ke player
                _game.player?.moveByTouchDelta(details.delta.dx, details.delta.dy);
              },
              child: gameWidget,
            ),
          ));
  }
}
