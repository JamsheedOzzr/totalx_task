import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

enum SortOption { all, elder, younger, nameAZ, nameZA }

class UserController extends ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String _searchQuery = '';
  SortOption _sortOption = SortOption.all;

  List<UserModel> get users {
    List<UserModel> filteredUsers = List.from(_users);

    if (_searchQuery.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               user.phoneNumber.contains(_searchQuery);
      }).toList();
    }

    switch (_sortOption) {
      case SortOption.elder:
        filteredUsers.sort((a, b) => b.age.compareTo(a.age));
        break;
      case SortOption.younger:
        filteredUsers.sort((a, b) => a.age.compareTo(b.age));
        break;
      case SortOption.nameAZ:
        filteredUsers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.nameZA:
        filteredUsers.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case SortOption.all:
      default:
        break;
    }

    return filteredUsers;
  }

  bool get isLoading => _isLoading;
  SortOption get sortOption => _sortOption;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users_list');
    
    if (usersJson != null) {
      final List<dynamic> decoded = jsonDecode(usersJson);
      _users = decoded.map((u) => UserModel.fromJson(u)).toList();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  Future<void> addUser(UserModel user) async {
    _users.add(user);
    await _saveUsers();
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = jsonEncode(_users.map((u) => u.toJson()).toList());
    await prefs.setString('users_list', usersJson);
  }
}
