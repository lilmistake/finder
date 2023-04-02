import 'dart:io';
import 'package:finder/core/models.dart';
import 'package:finder/core/prediction.dart';
import 'package:flutter/material.dart';

class BoundedBox extends StatelessWidget {
  const BoundedBox({
    super.key,
    required this.file,
    required this.setPredictions,
  });
  final File file;
  final Function setPredictions;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prediction>>(
      future: predictObjects(file.path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        //predictions made
        setPredictions(snapshot.data!);
        List<Prediction> predictions = snapshot.data!;
        return FutureBuilder(
            future: decodeImageFromList(file.readAsBytesSync()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              //image size received
              var width = MediaQuery.of(context).size.width;
              var height =
                  (snapshot.data!.height / snapshot.data!.width) * width;

              return Align(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                      children: predictions
                          .map((e) => Positioned(
                                top: e.rect.y * height,
                                left: e.rect.x * width,
                                width: e.rect.width * width,
                                height: e.rect.height * height,
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: e.color, width: 5)),
                                    child: Text(
                                      e.object,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        backgroundColor: Colors.black,
                                      ),
                                    )),
                              ))
                          .toList()),
                ),
              );
            });
      },
    );
  }
}
