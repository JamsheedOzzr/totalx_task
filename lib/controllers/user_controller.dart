import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserController extends ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _ageFilter = 'All'; // 'All', 'Older', 'Younger'

  List<UserModel> get users {
    List<UserModel> filteredUsers = _users;

    if (_searchQuery.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               user.phoneNumber.contains(_searchQuery);
      }).toList();
    }

    if (_ageFilter == 'Older') {
      filteredUsers = filteredUsers.where((user) => user.age >= 60).toList();
    } else if (_ageFilter == 'Younger') {
      filteredUsers = filteredUsers.where((user) => user.age < 60).toList();
    }

    return filteredUsers;
  }

  bool get isLoading => _isLoading;
  String get ageFilter => _ageFilter;

  void fetchUsers() {
    _isLoading = true;
    _users = []; // Start with an empty list
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setAgeFilter(String filter) {
    _ageFilter = filter;
    notifyListeners();
  }

  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
  }
}
