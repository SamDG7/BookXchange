import 'package:bookxchange_flutter/constants.dart';
import 'package:flutter/material.dart';



class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.textField});
  final TextField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          width: 2.5,
          color: butterfly,
        ),
      ),
      child: textField,
    );
  }
}


class CustomTextField2 extends StatelessWidget {
  const CustomTextField2({super.key, required this.textField});
  final TextField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2.5,
          color: butterfly,
        ),
      ),
      child: textField,
    );
  }
}