import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'models.dart';
import 'package:finder/widgets/success_message.dart';
/// This functions opens an interface to crop and edit image.
/// You can:
/// 1. Change aspect ratio
/// 2. Crop Image
/// 3. Rotate Image
/// 
/// Afte that click on check mark to save the selection to local storage.
cropAndSaveFile(Prediction e, String path, BuildContext context) async {
  CroppedFile? file = await ImageCropper().cropImage(
    sourcePath: path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop selection',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
          title: 'Crop selection',
          rectY: e.rect.y,
          rectX: e.rect.x,
          rectHeight: e.rect.height,
          rectWidth: e.rect.width),
    ],
  );
  file = null;
  if (file != null) {
    PhotoManager.editor
        .saveImageWithPath(file.path,
            title:
                "found ${e.object}-${DateTime.now().toUtc().toIso8601String()}")
        .then((value) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const ImageSaveSuccess(),
        );
      }
    });
  }
}
