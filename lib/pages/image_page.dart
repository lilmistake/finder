import 'dart:io';
import 'package:finder/core/models.dart';
import 'package:finder/core/prediction.dart';
import 'package:finder/widgets/predictions_list.dart';
import 'package:flutter/material.dart';
import '../widgets/bounded_box.dart';
import '../widgets/bottom_sheet_expander.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key, required this.path});
  final String path;
  static List<Prediction> predictions = [];


  void openSheet(context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // make sure view is rendered before opening bottom sheet
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: true,
        builder: (context) {
          return PredictionList(
            predictions: predictions,
            path: path,
          );
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
        children: [
          Center(child: img),
          FutureBuilder(
            future: predictObjects(path),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              predictions = snapshot.data!;
              openSheet(context);
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  BoundedBox(file: file, predictions: predictions),
                  SheetExpander(onTap: () => openSheet(context))
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
