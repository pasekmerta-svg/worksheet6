import 'package:flutter/material.dart';
import 'models/course.dart';

class CourseProvider extends ChangeNotifier {
  final Set<String> _favorites = {};

  // 37. Data JSON mentah yang di-parse menjadi list object Course
  final List<Map<String, dynamic>> _rawJsonCourses = [
    {'code': 'CS101', 'title': 'Git & GitHub', 'credits': 2, 'status': 'done'},
    {'code': 'CS102', 'title': 'Dart Fundamentals', 'credits': 3, 'status': 'done'},
    {'code': 'CS103', 'title': 'State Management', 'credits': 4, 'status': 'active'},
  ];

  late List<Course> _courses;

  CourseProvider() {
    // Parsing JSON ke object Course
    _courses = _rawJsonCourses.map((json) => Course.fromJson(json)).toList();
  }

  List<Course> get courses => _courses;
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