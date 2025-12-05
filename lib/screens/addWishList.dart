import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list/screens/homePage.dart';
import 'package:wish_list/screens/signUp.dart';
import 'package:wish_list/screens/wishListsPage.dart';

import '../models/wish_list_model.dart';
import '../providers/buy_mode_provider.dart';
import '../providers/wish_list_provider.dart';
import '../widgets/switchModeButton.dart';

class AddWishListPage extends StatefulWidget {
  final WishList? listToEdit;

  const AddWishListPage({
    super.key,
    this.listToEdit,
  });

  @override
  State<AddWishListPage> createState() => _AddWishListPageState();
}

class _AddWishListPageState extends State<AddWishListPage> {

  TextEditingController listName = TextEditingController();

  bool get isEditMode => widget.listToEdit != null;
  String get buttonLabel => isEditMode ? 'Edit' : 'Add';
  String get pageTitle => isEditMode ? 'Edit Wish List' : 'Add Wish List';
  String get subtitle => isEditMode
      ? 'Update your wish list details.'
      : 'Create a new list to track your wishes.';

  @override
  void initState() {
    super.initState();

    if (isEditMode) {
      listName = TextEditingController(text: widget.listToEdit!.name);
    } else {
      listName = TextEditingController();
    }
  }

  Future<void> _handleAddWishList() async {
    if (listName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a list name')),
      );
      return;
    }

    try {
      final provider = context.read<WishListProvider>();
      final isBuyMode = context.read<BuyModeProvider>().isBuyMode;

      if (isEditMode) {
        final updatedList = widget.listToEdit!.copyWith(
          name: listName.text,
          isBuyMode: isBuyMode,
        );

        await provider.updateWishList(widget.listToEdit!.id, updatedList);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wish list updated successfully')),
        );

        Navigator.pop(context);

      } else {
        await provider.createWishList(listName.text, isBuyMode);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wish list created successfully')),
        );

        Navigator.pop(context);

      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141217),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          pageTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff141217),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TextField(
                      controller: listName,
                      style: TextStyle(
                        color: Color(0xFFBBB4C3),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "List name",
                        hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                        filled: true,
                        fillColor: Color(0xFF302938),
                      ),
                    ),
                  ),
                  SwitchModeButton(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8B828E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Cancel", style: TextStyle(color: Colors.white),),
            ),
          ),

          // Right bottom button
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                _handleAddWishList();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4D439B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Add", style: TextStyle(color: Colors.white),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
