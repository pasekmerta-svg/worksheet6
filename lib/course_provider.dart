import 'package:flutter/material.dart';
import 'models/course.dart';
import 'services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  final Set<String> _favorites = {};
  final CourseService _courseService = CourseService();

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
      _courses = await _courseService.loadCourses();
      debugPrint('Berhasil memuat ${_courses.length} courses dari CourseService.');
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