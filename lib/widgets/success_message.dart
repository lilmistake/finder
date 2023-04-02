import 'package:flutter/material.dart';
/// Generic success message
class ImageSaveSuccess extends StatelessWidget {
  const ImageSaveSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: 120,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Image saved successfully"),
          ],
        ),
      ),
    );
  }
}
