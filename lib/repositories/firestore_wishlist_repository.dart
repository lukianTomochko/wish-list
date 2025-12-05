import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wish_list/repositories/wish_list_repository.dart';

import '../models/wish_item_model.dart';
import '../models/wish_list_model.dart';

class FirestoreWishListRepository implements WishListRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId;

  FirestoreWishListRepository(this._currentUserId);

  @override
  Future<List<WishList>> getMyWishLists() async {
    try {
      final snapshot = await _firestore
          .collection('wishLists')
          .where('userId', isEqualTo: _currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      List<WishList> lists = [];
      for (var doc in snapshot.docs) {
        final wishList = WishList.fromJson({
          ...doc.data(),
          'id': doc.id,
        });

        final itemsSnapshot = await doc.reference.collection('items').get();
        final items = itemsSnapshot.docs
            .map((itemDoc) => WishItem.fromJson({
          ...itemDoc.data(),
          'id': itemDoc.id,
        })).toList();

        lists.add(wishList.copyWith(items: items));
      }

      return lists;
    } catch (e) {
      throw Exception('Failed to load wish lists: $e');
    }
  }

  @override
  Future<WishList> getWishListById(String id) async {
    try {
      final doc = await _firestore.collection('wishLists').doc(id).get();

      if (!doc.exists) {
        throw Exception('Wish list not found');
      }

      final wishList = WishList.fromJson({
        ...doc.data()!,
        'id': doc.id,
      });

      // Load items
      final itemsSnapshot = await doc.reference.collection('items').get();
      final items = itemsSnapshot.docs
          .map((itemDoc) => WishItem.fromJson({
        ...itemDoc.data(),
        'id': itemDoc.id,
      }))
          .toList();

      return wishList.copyWith(items: items);
    } catch (e) {
      throw Exception('Failed to load wish list: $e');
    }
  }

  @override
  Future<String> createWishList(WishList wishList) async {
    try {
      final docRef = await _firestore.collection('wishLists').add({
        'userId': _currentUserId,
        'name': wishList.name,
        'isBuyMode': wishList.isBuyMode,
        'createdAt': Timestamp.fromDate(wishList.createdAt),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create wish list: $e');
    }
  }

  @override
  Future<void> updateWishList(WishList wishList) async {
    try {
      await _firestore.collection('wishLists').doc(wishList.id).update({
        'name': wishList.name,
        'isBuyMode': wishList.isBuyMode,
      });
    } catch (e) {
      throw Exception('Failed to update wish list: $e');
    }
  }

  @override
  Future<void> deleteWishList(String id) async {
    try {
      final itemsSnapshot = await _firestore
          .collection('wishLists')
          .doc(id)
          .collection('items')
          .get();

      for (var doc in itemsSnapshot.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection('wishLists').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete wish list: $e');
    }
  }

  @override
  Future<String> addItemToWishList(String listId, WishItem item) async {
    try {
      final docRef = await _firestore
          .collection('wishLists')
          .doc(listId)
          .collection('items')
          .add(item.toJson());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  @override
  Future<void> updateWishItem(String listId, WishItem item) async {
    try {
      await _firestore
          .collection('wishLists')
          .doc(listId)
          .collection('items')
          .doc(item.id)
          .update(item.toJson());
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  @override
  Future<void> removeWishItem(String listId, String itemId) async {
    try {
      await _firestore
          .collection('wishLists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove item: $e');
    }
  }

  @override
  Future<void> toggleWishItemDone(String listId, String itemId) async {
    try {
      final docRef = _firestore
          .collection('wishLists')
          .doc(listId)
          .collection('items')
          .doc(itemId);

      final doc = await docRef.get();
      if (doc.exists) {
        final isDone = doc['isDone'] as bool;
        await docRef.update({'isDone': !isDone});
      }
    } catch (e) {
      throw Exception('Failed to toggle item: $e');
    }
  }
}
