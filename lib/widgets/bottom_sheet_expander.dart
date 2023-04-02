import 'package:flutter/material.dart';
/// Icon to expand bottom sheet which contains the predictions
class SheetExpander extends StatelessWidget {
  const SheetExpander({super.key, required this.onTap});
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {onTap()},
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            color: Colors.white),
        width: double.infinity,
        height: 30,
        child: const Center(child: Icon(Icons.expand_less_rounded)),
      ),
    );
  }
}
