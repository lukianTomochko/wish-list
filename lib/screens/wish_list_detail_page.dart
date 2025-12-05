import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list/models/wish_item_model.dart';
import 'package:wish_list/providers/wish_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wish_list/screens/add_wish_item.dart';

import 'addWishList.dart';


class WishListDetailPage extends StatefulWidget {
  final String wishListId;

  const WishListDetailPage({
    required this.wishListId,
    super.key,
  });

  @override
  State<WishListDetailPage> createState() => _WishListDetailPageState();
}

class _WishListDetailPageState extends State<WishListDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff141217),
      appBar: AppBar(
        backgroundColor: const Color(0xff141217),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<WishListProvider>(
          builder: (context, provider, child) {
            final wishList = provider.wishLists
                .firstWhere((list) => list.id == widget.wishListId);
            return Text(
              wishList.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.drive_file_rename_outline_rounded, color: Colors.white),
            onPressed: () {
              final provider = context.read<WishListProvider>();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddWishListPage(
                      listToEdit: provider.selectedWishList,
                    ),
                  ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: Consumer<WishListProvider>(
        builder: (context, wishListProvider, child) {
          final wishList = wishListProvider.wishLists
              .firstWhere((list) => list.id == widget.wishListId);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2635),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Items: ${wishList.completedCount}/${wishList.totalCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(wishList.createdAt),
                            style: const TextStyle(
                              color: Color(0xFF8B8B9B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total: \$${wishList.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Progress: ${(wishList.progressPercentage * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Color(0xFF8B8B9B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Items List
              Expanded(
                child: wishList.items.isEmpty
                    ? Center(
                  child: Text(
                    'No items in this wish list',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: wishList.items.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final item = wishList.items[index];
                    return _buildWishItemCard(
                      context,
                      item,
                      wishList.id,
                      wishListProvider,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddWishListItem(),
            ),
          );
        },
        backgroundColor: const Color(0xff4D439B),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildWishItemCard(
      BuildContext context,
      WishItem item,
      String wishListId,
      WishListProvider provider,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2635),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: item.isDone,
                  onChanged: (value) {
                    provider.toggleItemDone(wishListId, item.id);
                  },
                  fillColor: WidgetStateProperty.all(
                    item.isDone ? const Color(0xFF4CAF50) : Colors.transparent,
                  ),
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(
                      color: Color(0xFF8B8B9B),
                      width: 2,
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    decoration: item.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Price
                                Text(
                                  'Price: \$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Color(0xFF8B8B9B),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddWishListItem(
                                            itemToEdit: item,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      child: const Icon(
                                        Icons.mode_edit_outline_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),

                                  // Vertical line
                                  Container(
                                    width: 1.3,
                                    height: 20,
                                    color: Colors.white,
                                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                  ),

                                  // Delete button
                                  GestureDetector(
                                    onTap: () {
                                      provider.removeItemFromWishList(wishListId, item.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${item.title} deleted'),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                DateFormat('dd/MM/yyyy').format(item.createdAt),
                                style: const TextStyle(
                                  color: Color(0xFF8B8B9B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Link button
                      if (item.link != null && item.link!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: GestureDetector(
                            onTap: ()  {
                              launch(item.link!);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4D439B),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.link,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Link',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2635),
        title: const Text(
          'Delete Wish List?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this wish list?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<WishListProvider>().deleteWishList(widget.wishListId);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

}
