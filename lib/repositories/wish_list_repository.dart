import '../models/wish_item_model.dart';
import '../models/wish_list_model.dart';

abstract class WishListRepository {
  Future<List<WishList>> getMyWishLists();
  Future<WishList> getWishListById(String id);
  Future<String> createWishList(WishList wishList);
  Future<void> updateWishList(WishList wishList);
  Future<void> deleteWishList(String id);

  Future<String> addItemToWishList(String listId, WishItem item);
  Future<void> updateWishItem(String listId, WishItem item);
  Future<void> removeWishItem(String listId, String itemId);
  Future<void> toggleWishItemDone(String listId, String itemId);
}

abstract class UserRepository {
  Future<void> createUserDocument(String uid, String username, String email);
}
