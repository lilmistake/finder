import 'dart:io';
import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:finder/core/prediction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'image_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  /// listens for image capture and navigates
  bool arButton = false;
  void listenCapture(state) {
    if (arButton) {
      // making sure the event wasn't caused by changing aspect ratio
      arButton = false;
      return;
    }
    state.captureState$.listen((event) {
      if (event != null &&
          event.isPicture &&
          event.status == MediaCaptureStatus.success) {
        predictObjects(event.filePath);
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ImagePage(path: event.filePath);
          },
        ));
      }
    });
  }

  double zoomLevel = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black,
          child: CameraAwesomeBuilder.awesome(
            aspectRatio: CameraAspectRatios.ratio_1_1,
            // opens picture previously clicked (visible on right of shutter button)
            onMediaTap: (p0) => {if (p0.isPicture) OpenFile.open(p0.filePath)},
            previewFit: CameraPreviewFit.fitWidth,
            zoom: zoomLevel,
            topActionsBuilder: (state) {
              // build top bar of camera
              listenCapture(state);
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AwesomeFlashButton(state: state),
                    AwesomeAspectRatioButton(
                      state: PhotoCameraState.from(state.cameraContext),
                      onAspectRatioTap: (sensorConfig, aspectRatio) {
                        arButton = true;
                        sensorConfig.switchCameraRatio();
                      },
                    ),
                  ],
                ),
              );
            },
            middleContentBuilder: (state) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: AwesomeFilterWidget(
                        state: state,
                      ),
                    )),
                    _ZoomSlideController(
                        zoomLevel: zoomLevel,
                        onChange: (newZoom) => setState(() {
                              state.sensorConfig.setZoom(newZoom);
                              zoomLevel = newZoom;
                            })),
                  ],
                ),
              );
            },
            theme:
                AwesomeTheme(bottomActionsBackgroundColor: Colors.transparent),
            saveConfig: SaveConfig.photo(
              pathBuilder: () async {
                //saves to cache directory (android) or NSCaches directory
                final Directory tempDir = await getTemporaryDirectory();
                final testDir = await Directory('${tempDir.path}/test')
                    .create(recursive: true);
                return '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
              },
            ),
          )),
    );
  }
}

/// Retuns a slider widget which sets zoom of camera
class _ZoomSlideController extends StatelessWidget {
  const _ZoomSlideController({required this.zoomLevel, required this.onChange});

  final double zoomLevel;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.zoom_out,
            color: Colors.white,
          ),
          Expanded(
            child: Slider(
                value: zoomLevel,
                inactiveColor: Colors.white,
                activeColor: Colors.white,
                onChanged: (s) => onChange(s)),
          ),
          const Icon(
            Icons.zoom_in,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
