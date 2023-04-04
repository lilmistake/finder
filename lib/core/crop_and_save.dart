import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'models.dart';
import 'package:crop_image/crop_image.dart';

/// Shows the interface to crop the image with default selection as the object
class CustomCropper extends StatefulWidget {
  const CustomCropper(
      {super.key, required this.path, required this.prediction});
  final String path;
  final Prediction prediction;

  @override
  State<CustomCropper> createState() => _CustomCropperState();
}

class _CustomCropperState extends State<CustomCropper> {
  late CropController controller;

  @override
  void initState() {
    Rect rect = Rect.fromLTWH(
        widget.prediction.rect.x,
        widget.prediction.rect.y,
        widget.prediction.rect.width,
        widget.prediction.rect.height);
    controller = CropController(
      defaultCrop: rect,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Mark selection"),
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: CropImage(
              controller: controller, image: Image.file(File(widget.path))),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_SaveButton(controller: controller)],
        ));
  }
}

/// Returns the button to process selection, and saves it
class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.controller,
  });

  final CropController controller;

  getBytes() async {
    ui.Image cropped =
        await controller.croppedBitmap(quality: FilterQuality.medium);
    ByteData? bytes = await cropped.toByteData(format: ui.ImageByteFormat.png);
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () async {
          ByteData? bytes = await getBytes();
          if (bytes == null) return;
          Uint8List img = bytes.buffer.asUint8List();

          final Directory tempDir = await getTemporaryDirectory();
          final testDir =
              await Directory('${tempDir.path}/test').create(recursive: true);

          File("${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.png")
              .create(recursive: true)
              .then((value) {
            value.writeAsBytes(img).then((value) async {
              PhotoManager.editor
                  .saveImageWithPath(value.path,
                      title: "${DateTime.now().millisecondsSinceEpoch}.png")
                  .then((value) {
                if (context.mounted) {
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text("Image Saved!")));
                }
              });
            });
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(999)),
          width: 150,
          height: 60,
          margin: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
