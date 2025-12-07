import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wish_list/models/wish_list_model.dart';

class WishListItem extends StatelessWidget {
  final WishList wishList;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const WishListItem({super.key, 
    required this.wishList,
    this.onTap,
    this.onDelete,
  });

  void _shareList(BuildContext context, String listName, String wishListId) {

    final String webLink = 'https://lukianTomochko.github.io/wish-list-share/?id=$wishListId';

    final String message = 'Hey, check my wish list "$listName".\n'
        'In order to save click the link:\n$webLink';

    Share.share(message);
  }


  @override
  Widget build(BuildContext context) {
    double progress = wishList.progressPercentage;
    int progressPercent = (progress * 100).round();

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2A2635),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    wishList.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _shareList(context, wishList.name, wishList.id);
                    },
                    child: Icon(
                      Icons.ios_share_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Done: ${wishList.completedCount}/${wishList.totalCount}',
                style: TextStyle(
                  color: Color(0xFF8B8B9B),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Total: \$${wishList.totalAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Color(0xFF8B8B9B),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Color(0xFF3D3449),
                        valueColor: AlwaysStoppedAnimation(
                          Color(0xFF4CAF50),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '$progressPercent%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
