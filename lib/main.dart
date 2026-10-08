import 'package:flutter/material.dart';

// Identitas Mahasiswa
const String studentName = 'Made Pasek Merta Sujati';
const String studentId = '2415051096';

void main() {
  runApp(const MyApp());
}

// 1. Ancestor terdekat (Parent) memegang state tunggal (Single Source of Truth)
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State tunggal disimpan di sini
  final List<String> _favoriteCourses = [];

  // Callback untuk mengubah state di Parent
  void _toggleFavorite(String courseTitle) {
    setState(() {
      if (_favoriteCourses.contains(courseTitle)) {
        _favoriteCourses.remove(courseTitle);
      } else {
        _favoriteCourses.add(courseTitle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('$studentId - $studentName'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Mengirim data & callback ke Child 1
              CourseListSection(
                favorites: _favoriteCourses,
                onToggleFavorite: _toggleFavorite,
              ),
              const Divider(height: 32, thickness: 2),
              // Mengirim data ke Child 2 (menjamin tampilan konsisten)
              CourseSummarySection(favoritesCount: _favoriteCourses.length),
            ],
          ),
        ),
      ),
    );
  }
}

// Child Widget 1: Hanya menerima data dan memicu callback
class CourseListSection extends StatelessWidget {
  final List<String> favorites;
  final Function(String) onToggleFavorite;

  const CourseListSection({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final courses = [
      'Pemrograman Mobile',
      'Arsitektur Software',
      'Desain Antarmuka'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Kursus (Lifting State Up):',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...courses.map((course) {
          final isFav = favorites.contains(course);
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(course),
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                ),
                onPressed: () => onToggleFavorite(course),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// Child Widget 2: Menerima data terhitung dari Parent
class CourseSummarySection extends StatelessWidget {
  final int favoritesCount;

  const CourseSummarySection({super.key, required this.favoritesCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Kursus Difavoritkan:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Chip(
            label: Text(
              '$favoritesCount Kursus',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}