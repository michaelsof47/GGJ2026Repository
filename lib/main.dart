import 'package:flutter/material.dart';
import 'package:ggj2026repository/arena/base_arena.dart';
import 'package:ggj2026repository/main_menu.dart';
import 'package:ggj2026repository/story_page.dart';
import 'package:ggj2026repository/story_page2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner:
          false, // Tambahkan ini agar tampilan lebih bersih
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // 1. Home diisi dengan MainMenu
      home: const MainMenu(),

      // 2. Daftar rute navigasi
      routes: {
        '/story': (context) => StoryPage(),
        '/story2': (context) => StoryPage2(),
        '/game': (context) => BaseArena(),
      },
    ); // Penutup MaterialApp
  } // Penutup Widget build
} // Penutup class MyApp
