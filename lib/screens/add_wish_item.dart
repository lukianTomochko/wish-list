import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/wish_item_model.dart';
import '../providers/wish_list_provider.dart';

class AddWishListItem extends StatefulWidget {

  final WishItem? itemToEdit;

  const AddWishListItem({super.key, this.itemToEdit});

  @override
  State<AddWishListItem> createState() => _AddWishListItemState();
}

class _AddWishListItemState extends State<AddWishListItem> {

  TextEditingController wishName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController link = TextEditingController();

  bool get isEditMode => widget.itemToEdit != null;
  String get buttonLabel => isEditMode ? 'Edit' : 'Add';
  String get pageTitle => isEditMode ? 'Edit A Wish' : 'Add A Wish';

  @override
  void initState() {
    super.initState();


    if (isEditMode) {
      print('isEditMode');
      wishName = TextEditingController(text: widget.itemToEdit!.title);
      price = TextEditingController(
        text: widget.itemToEdit!.price != 0
            ? widget.itemToEdit!.price.toString()
            : '',
      );
      link = TextEditingController(text: widget.itemToEdit!.link ?? '');
    } else {
      wishName = TextEditingController();
      price = TextEditingController();
      link = TextEditingController();
    }
  }

  Future<void> _handleAddWishListItem() async {
    if (wishName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a wish name')),
      );
      return;
    }

    try {
      double? parsedPrice;
      if (price.text.isNotEmpty) {
        parsedPrice = double.tryParse(price.text);
        if (parsedPrice == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid price')),
          );
          return;
        }
      }

      final provider = context.read<WishListProvider>();

      if (isEditMode) {
        final updatedItem = widget.itemToEdit!.copyWith(
          title: wishName.text,
          price: parsedPrice ?? 0.0,
          link: link.text.isNotEmpty ? link.text : null,
        );

        await provider.updateWishItem(provider.selectedWishList!.id, updatedItem);

        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wish item updated successfully')),
        );
      } else {
        final newItem = WishItem(
          id: '',
          title: wishName.text,
          price: parsedPrice ?? 0.0,
          link: link.text.isNotEmpty ? link.text : null,
          isDone: false,
          createdAt: DateTime.now(),
        );

        await provider.addItemToWishList(provider.selectedWishList!.id, newItem);

        if (!mounted) return;

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wish item added successfully')),
        );
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: wishName,
                          style: TextStyle(
                            color: Color(0xFFBBB4C3),
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Wish name",
                            hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                            filled: true,
                            fillColor: Color(0xFF302938),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: price,
                          style: TextStyle(
                            color: Color(0xFFBBB4C3),
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Price",
                            hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                            filled: true,
                            fillColor: Color(0xFF302938),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ' Link to a product',
                      style: TextStyle(color: Color(0xffc6bbd3), fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 5),
                    TextField(
                      controller: link,
                      style: TextStyle(
                        color: Color(0xFFBBB4C3),
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "https://somelinktoaproduct.com",
                        hintStyle: TextStyle(color: Color(0xffBBB4C3)),
                        filled: true,
                        fillColor: Color(0xFF302938),
                      ),
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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
                _handleAddWishListItem();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4D439B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonLabel, style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}