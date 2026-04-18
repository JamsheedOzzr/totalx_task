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
    // notifyListeners();
    // Simulate fetching
    _users = [
      UserModel(id: '1', name: 'John Doe', phoneNumber: '1234567890', imageUrl: '', age: 45),
      UserModel(id: '2', name: 'Jane Smith', phoneNumber: '0987654321', imageUrl: '', age: 65),
      UserModel(id: '3', name: 'Alice', phoneNumber: '1112223334', imageUrl: '', age: 30),
      UserModel(id: '4', name: 'Bob', phoneNumber: '5556667778', imageUrl: '', age: 70),
    ];
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
