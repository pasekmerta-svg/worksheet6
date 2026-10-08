import 'package:flutter/material.dart';

const String studentName = 'Made Pasek Merta Sujati';
const String studentId = '2415051096';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Parent menyimpan state favorites (State Ownership)
  final List<String> _favoriteCourses = [];

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
          backgroundColor: Colors.indigo,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Prop Drilling: Mengoper data & callback ke Child 1
              CourseList(
                favorites: _favoriteCourses,
                onToggleFavorite: _toggleFavorite,
              ),
              const Divider(height: 32, thickness: 2),
              // Prop Drilling: Mengoper data ke Child 2
              CourseSummary(favoritesCount: _favoriteCourses.length),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseList extends StatelessWidget {
  final List<String> favorites;
  final Function(String) onToggleFavorite;

  const CourseList({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final courses = ['Flutter Basics', 'State Management', 'Dart Advanced'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Kursus:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...courses.map((course) {
          final isFav = favorites.contains(course);
          return ListTile(
            title: Text(course),
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () => onToggleFavorite(course),
            ),
          );
        }),
      ],
    );
  }
}

class CourseSummary extends StatelessWidget {
  final int favoritesCount;

  const CourseSummary({super.key, required this.favoritesCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Favorit Ditandai:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Chip(
              label: Text(
                '$favoritesCount Kursus',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}