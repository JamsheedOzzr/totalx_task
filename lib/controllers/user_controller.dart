import 'package:flutter/material.dart';
import '../models/user_model.dart';

enum SortOption { all, elder, younger, nameAZ, nameZA }

class UserController extends ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String _searchQuery = '';
  SortOption _sortOption = SortOption.all;

  List<UserModel> get users {
    List<UserModel> filteredUsers = List.from(_users);

    // Search filter
    if (_searchQuery.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               user.phoneNumber.contains(_searchQuery);
      }).toList();
    }

    // Sort/Filter logic
    switch (_sortOption) {
      case SortOption.elder:
        // User asked for "age - elder", interpreting as oldest first
        filteredUsers.sort((a, b) => b.age.compareTo(a.age));
        break;
      case SortOption.younger:
        // User asked for "age - younger", interpreting as youngest first
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
        // No sorting
        break;
    }

    return filteredUsers;
  }

  bool get isLoading => _isLoading;
  SortOption get sortOption => _sortOption;

  void fetchUsers() {
    _isLoading = true;
    _users = []; // Start with an empty list as requested earlier
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

  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
  }
}
