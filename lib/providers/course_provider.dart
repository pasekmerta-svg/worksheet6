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

  // HTTP GET: Memuat daftar course
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

  // HTTP PUT: Memperbarui Course yang Ada (Tahap 7)
  Future<bool> updateCourse(int id, Course course) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _apiService.updateCourse(id, course);
      await loadCourses(); // Refresh daftar course setelah berhasil diubah
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  // HTTP DELETE: Menghapus Course (Tahap 8)
  Future<bool> deleteCourse(int id, String code) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteCourse(id);
      
      // Hapus dari favorites jika ada agar tidak tersisa data yatim
      _favorites.remove(code);
      
      // Refresh daftar course setelah berhasil dihapus
      await loadCourses();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}