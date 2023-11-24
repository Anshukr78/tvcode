import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../screen/home.dart';
import '../widget/slider.dart';

class OneView extends StatefulWidget {
  final bool status;
  const OneView({Key? key, required this.status}) : super(key: key);

  @override
  State<OneView> createState() => _OneViewState();
}

class _OneViewState extends State<OneView> {
  var imageFiles, videoFiles;
  bool loader = false;

  void getFiles() async {
    setState(() {
      loader = true;
    });
    imageFiles = await dirContents(
        Directory("/storage/emulated/0/Download/imageFolder"));
    videoFiles = await dirContents(
        Directory("/storage/emulated/0/Download/videoFolder"));

    controller1 = VideoPlayerController.file(videoFiles[0])
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(100)
      ..initialize().then((value) => controller1!.play());

    setState(() {
      loader = false;
    });
  }

  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  CarouselSliderController? _sliderController1;
  VideoPlayerController? controller1;
  String? view;

  _callingShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      view = prefs.getString('view1');
    });
  }

  @override
  void initState() {
    getFiles();
    _callingShared();
    _sliderController1 = CarouselSliderController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loader
        ? const CircularProgressIndicator()
        : view == '0' || view == ''
            ? const CircularProgressIndicator()
            : SizedBox(
                height: widget.status ? MediaQuery.of(context).size.height * 0.80: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: view == '1'
                    ? SliderPageWidget(
                        controller: _sliderController1!,
                      )
                    : view == '2'
                        ? VideoPlayerWidget(controller: controller1!)
                        : const Center(
                            child: Text('Some thing went worng'),
                          ),
              );
  }
}
