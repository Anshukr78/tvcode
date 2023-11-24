

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvcode/screen/option_page.dart';

import 'package:video_player/video_player.dart';

import '../pages/page1.dart';
import '../pages/page2.dart';
import '../pages/page3.dart';


class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isPlaying = true;
  String? view;
  bool? modeValue;
  bool? status;
  String? banner;
  String? view1, view2, view3;
  String? bannerColor, textColor, textSize;

  int? flex1, flex2;

  _sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      banner = prefs.getString('banner') ?? '';
      status = prefs.getBool('status') ?? false;
      flex1 = prefs.getInt('flex1') ?? 0;
      flex2 = prefs.getInt('flex2') ?? 0;
      view = prefs.getString('view') ?? '';
      view1 = prefs.getString('select1') ?? '';
      view2 = prefs.getString('select2') ?? '';
      view3 = prefs.getString('select3') ?? '';
      bannerColor = prefs.getString('bannerColor') ?? '';
      textColor = prefs.getString('textColor') ?? '';
      textSize = prefs.getString('textSize') ?? '';
      modeValue = prefs.getBool('modeInfo') ?? false;
    });
    SystemChrome.setPreferredOrientations(modeValue!
        ? [
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]
        : [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
  }

  var imageFiles, videoFiles;

  void getFiles() async {
    imageFiles = await dirContents(
        Directory("/storage/emulated/0/Download/imageFolder"));
    videoFiles = await dirContents(
        Directory("/storage/emulated/0/Download/videoFolder"));
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory("/storage/emulated/0/Download/imageFolder");
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
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

  @override
  void initState() {
    super.initState();
    getFiles();

    _sharedValue();
    _getLocalFile('');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    // SystemChrome.setPreferredOrientations(modeValue! ?[
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    // ] : [
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return view == 0 || view == null
        ? const CircularProgressIndicator()
        : OrientationBuilder(
        builder: (context, orientation) {
            return Scaffold(
              key: _key,
              body: orientation == Orientation.landscape
                  ? GestureDetector(
                      onTap: () {
                        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                      },
                      child: Column(
                        children: [
                          view == '1'
                              ? OneView(
                                  status: status!,
                                )
                              : view == '7'
                                  ? ThreeView(
                                      modeScreen: orientation,
                                      status: status!,
                                    )
                                  : TwoView(
                                      modeScreen: orientation,
                                      flex1: flex1!,
                                      flex2: flex2!,
                                      status: status!),
                          status! ? const SizedBox(height: 1,) : const SizedBox(),
                          status!
                              ? Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                width: MediaQuery.of(context).size.width,
                                color: bannerColor == 'red'
                                    ? Colors.red
                                    : bannerColor == 'green'
                                        ? Colors.green
                                        : bannerColor == 'blue'
                                            ? Colors.blue
                                            : bannerColor == 'black'
                                                ? Colors.black
                                                : Colors.white,
                                child: Center(
                                  child: Marquee(
                                    text: banner ?? '' "    ",
                                    blankSpace: 50,
                                    style: GoogleFonts.notoSans(
                                        color: textColor == 'red'
                                            ? Colors.red
                                            : textColor == 'green'
                                                ? Colors.green
                                                : textColor == 'blue'
                                                    ? Colors.blue
                                                    : textColor == 'black'
                                                        ? Colors.black
                                                        : Colors.white,
                                        fontSize: double.parse(textSize!)),
                                  ),
                                ),
                              )
                              : SizedBox()
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                      },
                      child: Column(
                        children: [
                          view == '1'
                              ? OneView(status: status!)
                              : view == '7'
                                  ? ThreeView(
                                      modeScreen: orientation, status: status!)
                                  : TwoView(
                                      modeScreen: orientation,
                                      flex1: flex1!,
                                      flex2: flex2!,
                                      status: status!),
                          status! ? const SizedBox(height: 1,) : SizedBox(),
                          status!
                              ? Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                width: MediaQuery.of(context).size.width,
                                color: bannerColor == 'red'
                                    ? Colors.red
                                    : bannerColor == 'green'
                                        ? Colors.green
                                        : bannerColor == 'blue'
                                            ? Colors.blue
                                            : bannerColor == 'black'
                                                ? Colors.black
                                                : Colors.white,
                                child: Center(
                                  child: Marquee(
                                    text: banner ?? '' + "    ",
                                    blankSpace: 50,
                                    style: GoogleFonts.notoSans(
                                        color: textColor == 'red'
                                            ? Colors.red
                                            : textColor == 'green'
                                                ? Colors.green
                                                : textColor == 'blue'
                                                    ? Colors.blue
                                                    : textColor == 'black'
                                                        ? Colors.black
                                                        : Colors.white,
                                        fontSize: double.parse(textSize!)),
                                  ),
                                ),
                              )
                              : SizedBox()
                        ],
                      ),
                    ),


              floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OptionScreen()));
                  }),
            );
          },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {


  @override
  void initState() {
    widget.controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.value.isInitialized
        ? Container(
            alignment: Alignment.topCenter,
            child: buildVideoPlayer(),
          )
        : const SizedBox(
            height: 150,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  //Widget buildVideo() => buildVideoPlayer();

  // Widget buildVideo() => Stack(
  //       children: [
  //         buildVideoPlayer(),
  //         Positioned.fill(
  //           child: BasicOverlayWidget(
  //             controller: widget.controller,
  //           ),
  //         ),
  //       ],
  //     );

  Widget buildVideoPlayer() => VideoPlayer(widget.controller);
}

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const BasicOverlayWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            bottom: 0, left: 0, right: 0, child: VideoPlayer(controller)),
        controller.value.isPlaying
            ? Container()
            : Container(
                alignment: Alignment.center,
                color: Colors.black26,
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
      ],
    );
  }
}
