import 'package:flutter/material.dart';
import '../theme.dart';


class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.topBarBackground,
        border: Border(
          bottom: BorderSide(
            color: AppColors.topBarBorder,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset('assets/top_bar_logo.png'
          ),
        ),
      ),
    );
  }
}