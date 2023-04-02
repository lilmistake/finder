import 'dart:io';
import 'package:finder/core/models.dart';
import 'package:finder/widgets/predictions_list.dart';
import 'package:flutter/material.dart';
import '../widgets/bounded_box.dart';
import '../widgets/bottom_sheet_expander.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key, required this.path});
  final String path;

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  static List<Prediction> predictions = [];

  /// setter for predictions list -> used by bottom sheet
  void setPredictions(List<Prediction> p) {
    predictions = p;
    openSheet(context);
  }

  void openSheet(context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // make sure view is rendered before opening bottom sheet
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: true,
        builder: (context) {
          return PredictionList(predictions: predictions);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    File file = File(widget.path);
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
          SheetExpander(onTap: () => openSheet(context))
        ],
      ),
    );
  }
}
