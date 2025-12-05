import '../models/wish_item_model.dart';
import '../models/wish_list_model.dart';
import '../repositories/wish_list_repository.dart';
import 'package:flutter/material.dart';


class WishListProvider extends ChangeNotifier {
  List<WishList> _wishLists = [];
  WishList? _selectedWishList;
  bool _isLoading = false;

  List<WishList> get wishLists => _wishLists;
  WishList? get selectedWishList => _selectedWishList;
  bool get isLoading => _isLoading;

  WishListRepository? _repository;
  String? _userId;

  WishListRepository? get repository => _repository;
  String? get userId => _userId;

  get isBuyMode => null;

  set repository(WishListRepository? repo) {
    _repository = repo;
    notifyListeners();
  }

  set userId(String? uid) {
    _userId = uid;
    notifyListeners();
  }


  Future<void> loadWishLists() async {
    if (_repository == null || _userId == null) {
      print('Error: Repository or userId not set');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _wishLists = await _repository!.getMyWishLists();
    } catch (e) {
      print('Error loading wish lists: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Створити новий wish list
  Future<void> createWishList(String name, bool isBuyMode) async {
    try {
      final newList = WishList(
        id: '',
        userId: _userId!,
        name: name,
        items: [],
        isBuyMode: isBuyMode,
        createdAt: DateTime.now(),
      );

      final id = await _repository!.createWishList(newList);

      final newListWithId = newList.copyWith(id: id);

      _wishLists.add(newListWithId);
      notifyListeners();
    } catch (e) {
      print('Error creating wish list: $e');
      rethrow;
    }
  }

  // Видалити wish list
  Future<void> deleteWishList(String id) async {
    try {
      await _repository!.deleteWishList(id);
      _wishLists.removeWhere((list) => list.id == id);

      if (_selectedWishList?.id == id) {
        _selectedWishList = null;
      }

      notifyListeners();
    } catch (e) {
      print('Error deleting wish list: $e');
      rethrow;
    }
  }

  // Додати item до wish list
  Future<void> addItemToWishList(String listId, WishItem item) async {
    try {
      final itemId = await _repository!.addItemToWishList(listId, item);

      final itemWithId = item.copyWith(id: itemId);

      final listIndex = _wishLists.indexWhere((list) => list.id == listId);
      if (listIndex != -1) {
        final updatedList = _wishLists[listIndex];
        _wishLists[listIndex] = updatedList.copyWith(
          items: [...updatedList.items, itemWithId],
        );

        if (_selectedWishList?.id == listId) {
          _selectedWishList = _wishLists[listIndex];
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  // Видалити item з wish list
  Future<void> removeItemFromWishList(String listId, String itemId) async {
    try {
      await _repository!.removeWishItem(listId, itemId);

      final listIndex = _wishLists.indexWhere((list) => list.id == listId);
      if (listIndex != -1) {
        final updatedList = _wishLists[listIndex];
        final updatedItems = updatedList.items
            .where((item) => item.id != itemId)
            .toList();

        _wishLists[listIndex] = updatedList.copyWith(items: updatedItems);

        if (_selectedWishList?.id == listId) {
          _selectedWishList = _wishLists[listIndex];
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error removing item: $e');
      rethrow;
    }
  }

  // Toggle item done
  Future<void> toggleItemDone(String listId, String itemId) async {
    try {
      await _repository!.toggleWishItemDone(listId, itemId);

      final listIndex = _wishLists.indexWhere((list) => list.id == listId);
      if (listIndex != -1) {
        final updatedList = _wishLists[listIndex];
        final updatedItems = updatedList.items.map((item) {
          return item.id == itemId
              ? item.copyWith(isDone: !item.isDone)
              : item;
        }).toList();

        _wishLists[listIndex] = updatedList.copyWith(items: updatedItems);

        if (_selectedWishList?.id == listId) {
          _selectedWishList = _wishLists[listIndex];
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error toggling item: $e');
      rethrow;
    }
  }

  void selectWishList(String id) {
    _selectedWishList = _wishLists.firstWhere((list) => list.id == id);
    notifyListeners();
  }

  Future<void> updateWishItem(String listId, WishItem updatedItem) async {
    if (_repository == null) {
      throw Exception('Repository not set');
    }

    try {
      await _repository!.updateWishItem(listId, updatedItem);

      final listIndex = _wishLists.indexWhere((list) => list.id == listId);
      if (listIndex != -1) {
        final updatedList = _wishLists[listIndex];
        final updatedItems = updatedList.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();

        _wishLists[listIndex] = updatedList.copyWith(items: updatedItems);

        if (_selectedWishList?.id == listId) {
          _selectedWishList = _wishLists[listIndex];
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error updating item: $e');
      rethrow;
    }
  }

  // lib/providers/wish_list_provider.dart

// Додаємо новий метод
  Future<void> updateWishList(String listId, WishList updatedList) async {
    if (_repository == null) {
      throw Exception('Repository not set');
    }

    try {
      await _repository!.updateWishList(updatedList);

      final listIndex = _wishLists.indexWhere((list) => list.id == listId);
      if (listIndex != -1) {
        _wishLists[listIndex] = updatedList;

        if (_selectedWishList?.id == listId) {
          _selectedWishList = updatedList;
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error updating wish list: $e');
      rethrow;
    }
  }


}
