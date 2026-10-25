import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

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
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCourse(Course course) async {
    _isSaving = true;
    notifyListeners();

    try {
      await repository.createCourse(course);
      await loadCourses();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCourse(int id, Course course) async {
    _isSaving = true;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);
      await loadCourses();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCourse(int id, String code) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.deleteCourse(id);
      _favorites.remove(code);
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