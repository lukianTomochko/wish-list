import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wish_list/models/wish_item_model.dart';

class WishList {
  final String id;
  final String userId;
  final String name;
  final List<WishItem> items;
  final bool isBuyMode;
  final DateTime createdAt;

  WishList({
    required this.id,
    required this.userId,
    required this.name,
    required this.items,
    required this.isBuyMode,
    required this.createdAt,
  });

  int get totalCount => items.length;
  int get completedCount => items.where((item) => item.isDone).length;
  double get totalAmount => items.fold(0, (sum, item) => sum + item.price);
  double get progressPercentage => totalCount == 0 ? 0 : completedCount / totalCount;

  factory WishList.fromJson(Map<String, dynamic> json) {
    return WishList(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      items: [],
      isBuyMode: json['isBuyMode'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'isBuyMode': isBuyMode,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  WishList copyWith({
    String? id,
    String? userId,
    String? name,
    List<WishItem>? items,
    bool? isBuyMode,
    DateTime? createdAt,
  }) {
    return WishList(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      items: items ?? this.items,
      isBuyMode: isBuyMode ?? this.isBuyMode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
