import 'package:flutter/material.dart';
import '../theme.dart';


class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.topBarBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Align(
          alignment: Alignment.center,
          child: Image.asset('assets/top_bar_logo.png'
          ),
        ),
      ),
    );
  }
}