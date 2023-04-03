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
      backgroundColor: Colors.black,
      body: Center(
        child: CropImage(
            controller: controller, image: Image.file(File(widget.path))),
      ),
      bottomNavigationBar: _BottomNav(controller: controller),
    );
  }
}

/// Shows the bottom nav buttons to procees or cancel selection
class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.controller,
  });

  final CropController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                size: 30,
              )),
          _SaveButton(controller: controller)
        ],
      ),
    );
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
    return IconButton(
        color: Colors.white,
        onPressed: () async {
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
        icon: const Icon(
          Icons.check,
          size: 30,
        ));
  }
}
