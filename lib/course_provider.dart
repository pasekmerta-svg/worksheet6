import 'package:flutter/material.dart';
import 'models/course.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  final Set<String> _favorites = {};
  
  // 45. Provider memanggil repository, bukan langsung service/rootBundle
  final CourseRepository _repository = CourseRepository(CourseService());

  List<Course> _courses = [];
  bool _isLoading = true;

  CourseProvider() {
    fetchCourses();
  }

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  Set<String> get favorites => _favorites;
  int get favoriteCount => _favorites.length;

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
      debugPrint('Berhasil memuat ${_courses.length} courses via CourseRepository.');
    } catch (e) {
      debugPrint('Error loading courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }
}