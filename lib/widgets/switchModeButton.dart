import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list/providers/buy_mode_provider.dart';

class SwitchModeButton extends StatelessWidget {
  const SwitchModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BuyModeProvider>(
      builder: (context, buyModeProvider, child) {
        bool isBuySelected = buyModeProvider.isBuyMode;

        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF2A2635),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              // Buy Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    buyModeProvider.setBuyMode(true);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isBuySelected
                          ? Color(0xFF141217)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Buy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isBuySelected
                            ? Colors.white
                            : Color(0xFF8B8B9B),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              // Do Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    buyModeProvider.setBuyMode(false);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: !isBuySelected
                          ? Color(0xFF141217)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Do',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !isBuySelected
                            ? Colors.white
                            : Color(0xFF8B8B9B),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
