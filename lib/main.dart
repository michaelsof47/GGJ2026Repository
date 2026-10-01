import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ggj2026repository/arena/base_arena.dart';
import 'package:ggj2026repository/main_menu.dart';
import 'package:ggj2026repository/story_page.dart';
import 'package:ggj2026repository/story_page2.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'The Masked Paladin',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MainMenu(),
          routes: {
            '/story': (context) => StoryPage(),
            '/story2': (context) => StoryPage2(),
            '/game': (context) => BaseArena(),
          },
        );
      },
    );
  } // Penutup Widget build
} // Penutup class MyApp
