import 'dart:io';
import 'package:finder/core/models.dart';
import 'package:flutter/material.dart';
import '../widgets/bounded_box.dart';
import '../widgets/bottom_sheet_expander.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key, required this.path});
  final String path;
  static List<Prediction> predictions = [];
  /// setter for predictions list -> used by bottom sheet
  void setPredictions(List<Prediction> p) => predictions = p;

  void openSheet(context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // make sure view is rendered before opening bottom sheet
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: true,
        builder: (context) {
          return Container();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    File file = File(path);
    Image img = Image.file(
      file,
      fit: BoxFit.fitWidth,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(child: img),
          BoundedBox(
            file: file,
            setPredictions: setPredictions,
          ),
          SheetExpander(
            onTap: (){
              print("sheet open");
              openSheet(context);},
          )
        ],
      ),
    );
  }
}
