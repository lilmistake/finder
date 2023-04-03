import 'dart:io';
import 'package:finder/core/models.dart';
import 'package:flutter/material.dart';

class BoundedBox extends StatelessWidget {
  const BoundedBox({super.key, required this.file, required this.predictions});
  final File file;
  final List<Prediction> predictions;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: decodeImageFromList(
            file.readAsBytesSync()), //loading file height width
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          //image size received
          var width = MediaQuery.of(context).size.width;
          var height = (snapshot.data!.height / snapshot.data!.width) * width;

          return Align(
            child: SizedBox(
              // setting height width to add bounding boxes for each precition at right spot
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
                                    border:
                                        Border.all(color: e.color, width: 5)),
                                child: Text(
                                  e.object,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    backgroundColor: Colors.black,
                                  ),
                                )),
                          ))
                      .toList()),
            ),
          );
        });
  }
}
