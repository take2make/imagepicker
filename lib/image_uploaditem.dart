import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagepicker/photo_placeholder.dart';
import 'package:mime/mime.dart';

class ImageUploadItem extends StatefulWidget {
  dynamic document;
  Map? controllers;
  Function? callback;
  Function? loadImages;
  List<File>? files;
  ImageUploadItem({
    Key? key,
    this.document,
    this.controllers,
    this.callback,
    this.loadImages,
    this.files,
  }) : super(key: key);

  @override
  _ImageUploadItemState createState() => _ImageUploadItemState();
}

class _ImageUploadItemState extends State<ImageUploadItem> {
  final picker = ImagePicker();

  List<File> imageList = [];
  bool isUploaded = false;

  Future<XFile?> imageCamera() async {
    XFile? pickedFile =
        await picker.pickImage(imageQuality: 100, source: ImageSource.camera);

    return pickedFile;
  }

  Future<XFile?> imageGallery() async {
    XFile? pickedFile =
        await picker.pickImage(imageQuality: 100, source: ImageSource.gallery);

    return pickedFile;
  }

  getImageSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: SizedBox(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        imageGallery().then((value) {
                          setState(() {
                            if (value != null) {
                              imageList.add(File(value.path));
                            }
                          });
                          if (widget.callback != null) {
                            widget.callback!(
                              widget.document.typeParameters.specificationsId,
                              widget.document.typeParameters.id,
                              imageList,
                            );
                          }
                          if (widget.loadImages != null) {
                            widget.loadImages!(imageList);
                          }
                        });

                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      imageCamera().then((value) {
                        setState(() {
                          if (value != null) {
                            imageList.add(File(value.path));
                          }
                        });
                        if (widget.callback != null) {
                          widget.callback!(
                            widget.document.typeParameters.specificationsId,
                            widget.document.typeParameters.id,
                            imageList,
                          );
                        }
                        if (widget.loadImages != null) {
                          widget.loadImages!(imageList);
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    if (widget.files != null) {
      print("FILES INIT = ${widget.files}");
      imageList = widget.files!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              getImageSheet();
            },
            child: Row(children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                      color: const Color(0xffF1F3F9),
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Прикрепить файл',
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontSize: 12,
                                  ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(child: Icon(Icons.video_call)),
                        const SizedBox(width: 18),
                        Icon(Icons.photo_camera)
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 30),
          imageList.isNotEmpty
              ? GridView.builder(
                  shrinkWrap: true,
                  itemCount: imageList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      childAspectRatio: 103 / 103),
                  itemBuilder: (context, index) {
                    return PhotoPlaceholder(
                      deleteImage: () {
                        setState(() {
                          imageList.remove(imageList[index]);
                        });
                        if (widget.callback != null) {
                          widget.callback!(
                            widget.document.typeParameters.specificationsId,
                            widget.document.typeParameters.id,
                            imageList,
                          );
                        }
                        if (widget.loadImages != null) {
                          widget.loadImages!(imageList);
                        }
                      },
                      child: lookupMimeType(imageList[index].path.toString())!
                              .startsWith('image/')
                          ? Image.file(imageList[index])
                          : Text(
                              imageList[index].path.toString().split("/").last),
                      isUploaded: true,
                    );
                  })
              : SizedBox(),
          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }
}
