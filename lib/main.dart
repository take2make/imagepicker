import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imagepicker/image_uploaditem.dart';

void main() {
  return runApp(ImagePicker());
}

class ImagePicker extends StatelessWidget {
  const ImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(child: ImageUploadItem()),
        ),
      ),
    );
  }
}
