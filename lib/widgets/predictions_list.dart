import 'package:finder/core/models.dart';
import 'package:flutter/material.dart';

class PredictionList extends StatelessWidget {
  const PredictionList({super.key, required this.predictions});
  final List<Prediction> predictions;

  Widget _noPredictionsFound() {
    if (predictions.isNotEmpty) return Container();
    return const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Couldn't  find any object",
          style: TextStyle(fontSize: 20),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.expand_more),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Expanded(
                    child: Text(
                  "Color",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                Expanded(
                    child: Text(
                  "Object",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                Expanded(
                    child: Text(
                  "Confidence",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ))
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            _noPredictionsFound(),
            ...predictions
                .map((e) => Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: e.color),
                            width: 25,
                            height: 25,
                          )),
                          Expanded(
                              child: Text(
                            e.object,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          )),
                          Expanded(
                              child: Text(
                            "${(double.parse(e.confidence.toString()) * 100).floorToDouble().toString()}%",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          )),
                        ],
                      ),
                    ))
                .toList()
          ]),
        ));
  }
}
