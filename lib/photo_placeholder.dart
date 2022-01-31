import 'package:flutter/material.dart';

class PhotoPlaceholder extends StatelessWidget {
  final bool isUploaded;
  final Widget child;
  final VoidCallback? deleteImage;
  const PhotoPlaceholder({
    Key? key,
    required this.isUploaded,
    this.deleteImage,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 103,
      width: 103,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 3),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: const Color(0xff798CBD).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12)),
            child: Container(
                margin: const EdgeInsets.only(top: 8),
                child: isUploaded
                    ? child
                    : Image.asset('assets/images/photo_holder.png')),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (deleteImage != null) deleteImage!();
                    },
                    child: deleteImage != null
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.cancel,
                                  size: 24,
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 21,
                                  height: 21,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
