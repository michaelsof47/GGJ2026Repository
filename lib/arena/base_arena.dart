import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: kIsWeb ? 350 : 320.w, // Maksimal 350px di Web
              ),
              child: Container(
                padding: EdgeInsets.all(kIsWeb ? 20 : 24.r),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(kIsWeb ? 15 : 20.r),
                  border: Border.all(
                      color: Colors.yellow, width: kIsWeb ? 2 : 3.w),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/win.png',
                        width: kIsWeb ? 220 : 200.r),
                    SizedBox(height: kIsWeb ? 10 : 16.h),
                    Text(
                      'VICTORY!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kIsWeb ? 24 : 28.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: kIsWeb ? 20 : 24.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, kIsWeb ? 45 : 50.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _game.restartGame(),
                      child: Text('RESTART',
                          style: TextStyle(
                              fontSize: kIsWeb ? 16 : 18.sp,
                              color: Colors.white)),
                    ),
                    SizedBox(height: kIsWeb ? 10 : 12.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: Size(double.infinity, kIsWeb ? 45 : 50.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        _arenaBgmPlayer.stop();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      child: Text('QUIT',
                          style: TextStyle(
                              fontSize: kIsWeb ? 16 : 18.sp,
                              color: Colors.white)),
                    ),
                  ],
                ),
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
