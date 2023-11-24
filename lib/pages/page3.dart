import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../screen/home.dart';
import '../widget/slider.dart';



class ThreeView extends StatefulWidget {
  final modeScreen;
  final bool status;
  const ThreeView({Key? key, required this.modeScreen, required this.status}) : super(key: key);

  @override
  State<ThreeView> createState() => _ThreeViewState();
}

class _ThreeViewState extends State<ThreeView> {

  var imageFiles, videoFiles;
  bool loader = false;


  void getFiles() async {
    setState(() {
      loader = true;
    });
    imageFiles = await dirContents(Directory("/storage/emulated/0/Download/imageFolder"));
    videoFiles = await dirContents(Directory("/storage/emulated/0/Download/videoFolder"));

    controller1 = VideoPlayerController.file(
        videoFiles[0])
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(50)
      ..initialize().then((value) => controller1!.play());

    controller2 = VideoPlayerController.file(
        videoFiles[0])
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(50)
      ..initialize().then((value) => controller2!.play());

    controller3 = VideoPlayerController.file(
        videoFiles[0])
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(50)
      ..initialize().then((value) => controller3!.play());

    controller1!.play();
    controller2!.play();
    controller3!.play();

    setState(() {
      loader = false;
    });
  }
  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen (
            (file) => files.add(file),
        // should also register onError
        onDone:   () => completer.complete(files)
    );
    return completer.future;
  }

  CarouselSliderController? _sliderController1,
      _sliderController2,
      _sliderController3;
  VideoPlayerController? controller1, controller2, controller3;
  String? view1, view2, view3;

  _callingShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      view1 = prefs.getString('view1');
      view2 = prefs.getString('view2');
      view3 = prefs.getString('view3');
    });
  }

  @override
  void initState() {
    getFiles();
    _callingShared();
    _sliderController1 = CarouselSliderController();
    _sliderController2 = CarouselSliderController();
    _sliderController3 = CarouselSliderController();
    //controller1!.play();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  loader ? CircularProgressIndicator() : widget.modeScreen == Orientation.landscape ?
    SizedBox(
      height: widget.status ? MediaQuery.of(context).size.height *0.89 : MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: view1 == '1'
                ? SliderPageWidget(
              controller: _sliderController1!,
            )
                : view1 == '2'
                ? Container(child: VideoPlayerWidget(controller: controller1!))
                : const Center(
              child: Text('Some thing went worng'),
            ),
          ),
          Expanded(
            child: view2 == '1'
                ? SliderPageWidget(
              controller: _sliderController2!,
            )
                : view2 == '2'
                ? Container(child: VideoPlayerWidget(controller: controller2!))
                : const Center(
              child: Text('Some thing went worng'),
            ),
          ),
          Expanded(
            child: view3 == '1'
                ? SliderPageWidget(
              controller: _sliderController3!,
            )
                : view3 == '2'
                ? Container(child: VideoPlayerWidget(controller: controller3!))
                : const Center(
              child: Text('Some thing went worng'),
            ),
          ),
        ],
      ),
    ) :
    SizedBox(
      height: widget.status ? MediaQuery.of(context).size.height *0.89 : MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            child: view1 == '1'
                ? SliderPageWidget(
              controller: _sliderController1!,
            )
                : view1 == '2'
                ? Container(child: VideoPlayerWidget(controller: controller1!))
                : const Center(
              child: Text('Some thing went worng'),
            ),
          ),
          Expanded(
            child: view2 == '1'
                ? SliderPageWidget(
              controller: _sliderController2!,
            )
                : view2 == '2'
                ? Container(child: VideoPlayerWidget(controller: controller2!))
                : const Center(
              child: Text('Some thing went worng'),
            ),
          ),
          Expanded(
            child: view3 == '1'
                ? SliderPageWidget(
              controller: _sliderController3!,
            )
                : view3 == '2'
                ? Container(child: VideoPlayerWidget(controller: controller3!))
                : const Center(
              child: Text('Some thing went worng'),
            ),
          ),
        ],
      ),
    );
  }
}
