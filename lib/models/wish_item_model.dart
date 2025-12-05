import 'package:cloud_firestore/cloud_firestore.dart';

class WishItem {
  final String id;
  final String title;
  final double price;
  final String? link;
  final bool isDone;
  final DateTime createdAt;

  WishItem({
    required this.id,
    required this.title,
    required this.price,
    this.link,
    this.isDone = false,
    required this.createdAt,
  });

  // Для серіалізації з Firestore
  factory WishItem.fromJson(Map<String, dynamic> json) {
    return WishItem(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      link: json['link'] as String?,
      isDone: json['isDone'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'link': link,
      'isDone': isDone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  WishItem copyWith({
    String? id,
    String? title,
    double? price,
    String? link,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return WishItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      link: link ?? this.link,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
