import 'models.dart';
import 'package:tflite/tflite.dart';

bool modelLoaded = false;

Future loadModel() async {
  await Tflite.loadModel(
      model: "assets/ssdmobilenet.tflite",
      labels: "assets/labelmap.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false);
  modelLoaded = true;
}

Future<List<Prediction>> predictObjects(String path) async {
  if (!modelLoaded) await loadModel();
  var recognitions = await Tflite.detectObjectOnImage(
      path: path, // required
      model: "SSDMobileNet",
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.4,
      numResultsPerClass: 1,
      asynch: true);
  return recognitions!.map((e) => Prediction.fromJson(e)).toList();
}
