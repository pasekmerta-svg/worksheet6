import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import 'course_detail_page.dart';
import 'favorites_page.dart';

const String studentName = 'Made Pasek Merta Sujati';
const String studentId = '2415051096';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<CourseProvider>().loadCourses(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Course Explorer v2',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Identitas Mahasiswa (Nama & NIM)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '$studentId • $studentName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Konten Sesuai Tab Navigasi
            Expanded(
              child: _selectedIndex == 2
                  ? const FavoritesPage()
                  : _buildCourseListSection(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF1565C0),
        backgroundColor: const Color(0xFFE8F1F5),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }

  Widget _buildCourseListSection() {
    final provider = context.watch<CourseProvider>();

    // 1. Loading State
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error State (Menggunakan ErrorView Widget)
    if (provider.error != null) {
      return ErrorView(
        message: provider.error!,
        onRetry: provider.loadCourses,
      );
    }

    // 3. Empty State
    if (provider.courses.isEmpty) {
      return const Center(
        child: Text(
          'Data course belum tersedia',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // 4. Success State (Daftar Data Course)
    return Column(
      children: [
        // Ringkasan Jumlah Course & Favorit
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1F5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Courses', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(
                      '${provider.courses.length}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1F5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Favorites', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(
                      '${provider.favoriteCount}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Daftar Course
        Expanded(
          child: ListView.builder(
            itemCount: provider.courses.length,
            itemBuilder: (context, index) {
              final course = provider.courses[index];
              final isFav = provider.isFavorite(course.code);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    '${course.code} • ${course.title}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                  ),
                  subtitle: Text('${course.status} • ${course.credits} SKS'),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => provider.toggleFavorite(course.code),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(course: course),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}