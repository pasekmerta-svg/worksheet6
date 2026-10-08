import 'package:flutter/material.dart';

const String studentName = 'Made Pasek Merta Sujati';
const String studentId = '2415051096';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MobileFrameWrapper(),
    );
  }
}

// Wrapper agar tampilan web Chrome terpusat seperti layar HP
class MobileFrameWrapper extends StatelessWidget {
  const MobileFrameWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFD8DC),
      body: Center(
        child: Container(
          width: 380, // Lebar standar layar HP
          height: 750, // Tinggi standar layar HP
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFF1E293B), width: 8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: const CourseExplorerPage(),
          ),
        ),
      ),
    );
  }
}

class CourseExplorerPage extends StatefulWidget {
  const CourseExplorerPage({super.key});

  @override
  State<CourseExplorerPage> createState() => _CourseExplorerPageState();
}

class _CourseExplorerPageState extends State<CourseExplorerPage> {
  int _selectedIndex = 0;

  // ValueNotifier untuk memantau jumlah favorite
  final ValueNotifier<int> favoriteCountNotifier = ValueNotifier<int>(0);

  final List<Map<String, dynamic>> _courses = [
    {'title': 'Git & GitHub', 'status': 'done', 'isFav': false},
    {'title': 'Dart Fundamentals', 'status': 'done', 'isFav': false},
    {'title': 'State Management', 'status': 'active', 'isFav': false},
  ];

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index]['isFav'] = !_courses[index]['isFav'];
      int totalFav = _courses.where((c) => c['isFav'] == true).length;
      favoriteCountNotifier.value = totalFav;
    });
  }

  @override
  void dispose() {
    favoriteCountNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Course Explorer v2',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Identitas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$studentId • $studentName',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
              ),
            ),
            const SizedBox(height: 12),

            // Ringkasan Courses & Favorites
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
                        const Text('Courses', style: TextStyle(color: Colors.black54, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text('${_courses.length}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
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
                        ValueListenableBuilder<int>(
                          valueListenable: favoriteCountNotifier,
                          builder: (context, value, child) {
                            return Text(
                              '$value',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                            );
                          },
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
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final item = _courses[index];
                  final bool isFav = item['isFav'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title']!,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                            const SizedBox(height: 4),
                            Text(
                              item['status']!,
                              style: TextStyle(
                                color: item['status'] == 'done' ? Colors.green.shade700 : Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => _toggleFavorite(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
}