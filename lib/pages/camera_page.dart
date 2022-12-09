import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'display_picture_page.dart';

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePicturePageState createState() => TakePicturePageState();
}

class TakePicturePageState extends State<TakePicturePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: [
        StepTakePicture(camera: widget.camera),
      ]),
    ));
  }
}

class StepTakePicture extends StatefulWidget {
  const StepTakePicture({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<StepTakePicture> createState() => _StepTakePictureState();
}

class _StepTakePictureState extends State<StepTakePicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(children: [
            const Text(
              'STEP 1: 拍攝圖片',
              style: TextStyle(fontSize: 20),
            ),
            Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 3, color: Colors.black26)),
                child: CameraPreview(_controller)),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await _initializeControllerFuture;
                      final image = await _controller.takePicture();

                      if (!mounted) return;
                      final RecognizedText recognizedText = await textRecognizer
                          .processImage(InputImage.fromFilePath(image.path));
                      textRecognizer.close();
                      
                      for (TextBlock block in recognizedText.blocks) {
                        for (TextLine line in block.lines) {
                          for (TextElement element in line.elements) {
                            debugPrint('aaaaa: ${element.text}');
                          }
                        }
                      }
                      /* await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPicturePage(
                            imagePath: image.path,
                          ),
                        ),
                      ); */
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  child: Text('拍照')),
            )
          ]);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
