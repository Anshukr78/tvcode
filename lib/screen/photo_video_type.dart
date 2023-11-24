import 'package:flutter/material.dart';

class PhotoVideoViewWidget extends StatelessWidget {
  final String type;
  final String url;

  const PhotoVideoViewWidget({required this.type, required this.url}) ;

  @override
  Widget build(BuildContext context) {
    return type == "video"
        ? VideoViewWidget(
      videoUrl: url,
    )
        : PhotoViewWidget(
      imageUrl: url,
    );
  }
}

class PhotoViewWidget extends StatelessWidget {
  final String imageUrl;

  const PhotoViewWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return const Text('Image');
    //return PhotoViewer(imageUrl);
  }
}

class VideoViewWidget extends StatelessWidget {
  final String videoUrl;

  const VideoViewWidget({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return const Text('Video');
    //return VideoViewer(videoUrl);
  }
}