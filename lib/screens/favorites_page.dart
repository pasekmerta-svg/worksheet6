import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favList = provider.favoriteCourses;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: favList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada mata kuliah favorit.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favList.length,
              itemBuilder: (context, index) {
                final course = favList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text('${course.code} - ${course.title}'),
                    subtitle: Text('${course.credits} SKS • ${course.status}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        provider.toggleFavorite(course.code);
                      },
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
    );
  }
}