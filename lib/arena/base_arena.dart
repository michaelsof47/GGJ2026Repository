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
            body: Listener(
              onPointerMove: (event) {
                // Listener lebih responsif dari GestureDetector karena tidak ada "slop" (jeda deteksi)
                _game.player?.moveByTouchDelta(event.delta.dx, event.delta.dy);
              },
              child: gameWidget,
            ),
          ));
  }
}
