import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/constants.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75, // Set a fixed width
        height: 75, // Set a fixed height
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: butterfly, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Image.asset(
          imagePath,
          height: 20, // Adjust the image fit to cover the container
        ),
      ),
    );
  }
}
