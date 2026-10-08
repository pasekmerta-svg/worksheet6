import 'package:flutter/material.dart';

// 22. Class CourseState extends ChangeNotifier
class CourseState extends ChangeNotifier {
  // 23. Tambahkan collection favorites
  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  int get favoriteCount => _favorites.length;

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }

  // 24. Method toggleFavorite()
  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    // 25. Memanggil notifyListeners() setelah state berubah
    notifyListeners();
  }
}