import 'package:flutter/material.dart';
import 'models/course.dart';
import 'repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  // 46. Tambahkan repository sebagai dependency CourseProvider
  final CourseRepository repository;

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  final Set<String> _favorites = {};

  CourseProvider(this.repository) {
    loadCourses();
  }

  // 47. Implementasikan loadCourses() dengan penanganan state (loading, success, error)
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Set<String> get favorites => _favorites;
  int get favoriteCount => _favorites.length;

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