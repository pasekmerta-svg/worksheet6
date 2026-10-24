import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseProvider extends ChangeNotifier {
  final CourseApiService _apiService;

  CourseProvider(this._apiService);

  List<Course> _courses = [];
  final Set<String> _favorites = {};
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  int get favoriteCount => _favorites.length;

  List<Course> get favoriteCourses {
    return _courses.where((c) => _favorites.contains(c.code)).toList();
  }

  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _apiService.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // HTTP POST: Menambahkan Course Baru
  Future<bool> addCourse(Course course) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _apiService.createCourse(course);
      await loadCourses(); // Refresh daftar course setelah berhasil
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}