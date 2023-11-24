import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../screen/home.dart';
import '../widget/slider.dart';

class TwoView extends StatefulWidget {
  final int flex1;
  final int flex2;
  final modeScreen;
  final bool status;

  const TwoView(
      {Key? key,
      required this.flex1,
      required this.flex2,
      required this.modeScreen,
      required this.status})
      : super(key: key);

  @override
  State<TwoView> createState() => _TwoViewState();
}

class _TwoViewState extends State<TwoView> {
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

    print('gdcmlfbdbfd');
    print(videoFiles.length);
    print(videoFiles[0]);
    print('gdcmlfbdbfd');

    _sliderController1 = CarouselSliderController();
    _sliderController2 = CarouselSliderController();
    controller1 = VideoPlayerController.file(videoFiles[0])
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(100)
      ..initialize().then((value) => controller1!.play());

    controller2 = VideoPlayerController.file(videoFiles[0])
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(100)
      ..initialize().then((value) => controller2!.play());

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

  CarouselSliderController? _sliderController1, _sliderController2;
  VideoPlayerController? controller1, controller2;
  String? view1, view2;

  _callingShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      view1 = prefs.getString('view1');
      view2 = prefs.getString('view2');
    });
  }

  @override
  void initState() {
    getFiles();
    _callingShared();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loader
        ? CircularProgressIndicator()
        : widget.modeScreen == Orientation.landscape
            ? Container(
                height: widget.status
                    ? MediaQuery.of(context).size.height * 0.89
                    : MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      flex: widget.flex1,
                      child: view1 == '1'
                          ? SliderPageWidget(
                              controller: _sliderController1!,
                            )
                          : view1 == '2'
                              ? VideoPlayerWidget(controller: controller1!)
                              : const Center(
                                  child: Text('Some thing went worng'),
                                ),
                    ),
                    Expanded(
                      flex: widget.flex2,
                      child: view2 == '1'
                          ? SliderPageWidget(
                              controller: _sliderController2!,
                            )
                          : view2 == '2'
                              ? VideoPlayerWidget(controller: controller2!)
                              : const Center(
                                  child: Text('Some thing went worng'),
                                ),
                    ),
                  ],
                ),
              )
            : Container(
                height: widget.status
                    ? MediaQuery.of(context).size.height * 0.89
                    : MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Expanded(
                      flex: widget.flex1,
                      child: view1 == '1'
                          ? SliderPageWidget(
                              controller: _sliderController1!,
                            )
                          : view1 == '2'
                              ? VideoPlayerWidget(controller: controller1!)
                              : const Center(
                                  child: Text('Some thing went worng'),
                                ),
                    ),
                    Expanded(
                      flex: widget.flex2,
                      child: view2 == '1'
                          ? SliderPageWidget(
                              controller: _sliderController2!,
                            )
                          : view2 == '2'
                              ? VideoPlayerWidget(controller: controller2!)
                              : const Center(
                                  child: Text('Some thing went worng'),
                                ),
                    ),
                  ],
                ),
              );
  }
}
