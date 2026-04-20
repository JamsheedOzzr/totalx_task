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

  void fetchUsers() {
    _isLoading = true;
    _users = [];
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
