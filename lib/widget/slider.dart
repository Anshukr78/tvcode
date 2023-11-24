import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_tile/url_tile.dart';
import 'package:http/http.dart' as http;

class SliderPageWidget extends StatefulWidget {
  final CarouselSliderController controller;

  const SliderPageWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<SliderPageWidget> createState() => _SliderPageWidgetState();
}

class _SliderPageWidgetState extends State<SliderPageWidget> {
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

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  Uri uri = Uri.parse('http://therent.in/tv/api/tv');
  List imageModel = [];
  List videoModel = [];

  getWallpaper() async {
    setState(() {
      loader = true;
    });
    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        var valueUrl = decode['data'];

        for (int i = 0; i < valueUrl.length; i++) {
          if (valueUrl[i]['type'] == 'image' || valueUrl[i]['type'] == '1') {
            imageModel.add(valueUrl[i]['pathurl']);
          } else {
            videoModel.add(valueUrl[i]['pathurl']);
            //imageModel.add(valueUrl[i]['pathurl']);
          }
        }
        downloadImage();
        setState(() {
          loader = false;
        });
      } else {
        setState(() {
          loader = false;
        });
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
    }
  }

  downloadImage() async {
    for (int i = 0; i < imageModel.length; i++) {
      await saveFile(imageModel[i], '${i}image.jpg', 'imageFolder');
    }
    for (int j = 0; j < videoModel.length; j++) {
      await saveFile(videoModel[j], '${j}video.mp4', 'videoFolder');
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> saveFile(String url, String fileName, String pathValue) async {
    try {
      if (await _requestPermission(Permission.storage)) {
        Directory? directory;
        directory = await getExternalStorageDirectory();

        String? newPath = "";

        newPath = await getDownloadPath();
        directory = Directory(newPath!);

        File saveFile = File("${directory.path}/$pathValue/$fileName");
        if (kDebugMode) {
          print(saveFile.path);
        }

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        if (await directory.exists()) {
          await Dio().download(
            url,
            saveFile.path,
          );
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
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

  @override
  Widget build(BuildContext context) {
    return loader
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: CarouselSlider.builder(
              unlimitedMode: true,
              controller: widget.controller,
              // onSlideStart: () {
              //   getWallpaper();
              //   downloadImage();
              // },
              slideBuilder: (index) {
                //return URLTile(url: 'https://media.istockphoto.com/id/1411042848/video/beautiful-young-woman-wearing-white-dress-and-hat-standing-in-a-lavender-field.mp4?s=mp4-640x640-is&k=20&c=451m5eY4kVvZeBLfCws3Zkyqb9wyqDJWuZkZNxR-srU=',);
                return Image.file(
                  imageFiles[index],
                  fit: BoxFit.fill,
                );
              },
              // slideTransform: const CubeTransform(),
              // slideIndicator: CircularSlideIndicator(
              //   padding: const EdgeInsets.only(bottom: 32),
              //   indicatorBorderColor: Colors.black,
              // ),
              itemCount: imageFiles.length,
              initialPage: 0,
              enableAutoSlider: true,
            ),
          );
  }
}
