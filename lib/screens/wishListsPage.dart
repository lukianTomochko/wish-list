import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list/screens/addWishList.dart';
import 'package:wish_list/screens/wish_list_detail_page.dart';
import 'package:wish_list/widgets/wishListItem.dart';
import 'package:wish_list/widgets/switchModeButton.dart';
import 'package:wish_list/providers/wish_list_provider.dart';
import 'package:wish_list/providers/buy_mode_provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishListProvider>().loadWishLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff141217),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SwitchModeButton(),
          ),
          Expanded(
            child: Consumer2<WishListProvider, BuyModeProvider>(
              builder: (context, wishListProvider, buyModeProvider, child) {
                final allWishLists = wishListProvider.wishLists;
                final isBuyMode = buyModeProvider.isBuyMode;

                final filteredWishLists = allWishLists
                    .where((list) => list.isBuyMode == isBuyMode)
                    .toList();

                if (filteredWishLists.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${isBuyMode ? "Buy" : "Do"} wish lists yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredWishLists.length,
                  itemBuilder: (context, index) {
                    final wishList = filteredWishLists[index];
                    return WishListItem(
                      wishList: wishList,
                      onTap: () {
                        context
                            .read<WishListProvider>()
                            .selectWishList(wishList.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WishListDetailPage(wishListId: wishList.id),
                          ),
                        );
                      },
                      onDelete: () {
                        print('Deleted wish list: ${wishList.name}');
                        context
                            .read<WishListProvider>()
                            .deleteWishList(wishList.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${wishList.name} deleted'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
              const AddWishListPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
        backgroundColor: Color(0xff4D439B),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
