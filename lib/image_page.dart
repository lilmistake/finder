import 'dart:io';
import 'package:finder/models.dart';
import 'package:finder/prediction.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key, required this.path});
  final String path;

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  static late List<Prediction> predictions = [];

  void openSheet(context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    File file = File(widget.path);
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const Drawer(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
              child: Image.file(
            file,
            fit: BoxFit.fitWidth,
          )),
          InkWell(
          onTap: () => openSheet(context),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: Colors.white),
            width: double.infinity,
            height: 25,
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: const Center(child: Icon(Icons.expand_less_rounded)),
          ),
        )
        ],
      ),
    );
  }
}
