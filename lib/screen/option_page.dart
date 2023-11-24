import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:tvcode/screen/home.dart';

import 'login_screen.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  bool status = false;
  bool valueSame = true;
  bool memoryUser = true;
  String? selectedValue;
  String? bannerColor;
  String? textColor;
  String? textSize;
  String? selectedValuePro;
  String? selectedValuePro1;
  String? selectedValuePro2;

  final List<String> _bannerColor = ['red', 'green', 'blue', 'black', 'white'];

  TextEditingController textEditingController = TextEditingController();

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  _colorValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('bannerColor', bannerColor ?? '');
    await prefs.setString('textColor', textColor ?? '');
    await prefs.setString('textSize', textSize ?? '');
  }

  _storeInfo(String value, bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('banner', value);
    await prefs.setBool('status', status);
  }

  _storeModeInfo(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeInfo', status);
  }

  _storeDropInfo(String view, String view1, String view2, String view3) async {
    int flex1 = 0, flex2 = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('view', view);
    await prefs.setString('view1', view1);
    await prefs.setString('view2', view2);
    await prefs.setString('view3', view3);

    await prefs.setString('select1', selectedValuePro ?? '');

    await prefs.setString('select2', selectedValuePro1 ?? '');

    await prefs.setString('select3', selectedValuePro2 ?? "");

    if (selectedValue == '2') {
      setState(() {
        flex1 = 1;
        flex2 = 1;
      });
    } else if (selectedValue == '3') {
      setState(() {
        flex1 = 3;
        flex2 = 7;
      });
    } else if (selectedValue == '4') {
      setState(() {
        flex1 = 7;
        flex2 = 3;
      });
    } else if (selectedValue == '5') {
      setState(() {
        flex1 = 2;
        flex2 = 8;
      });
    } else if (selectedValue == '6') {
      setState(() {
        flex1 = 8;
        flex2 = 2;
      });
    }

    await prefs.setInt('flex1', flex1);
    await prefs.setInt('flex2', flex2);
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    getWallpaper();
    downloadImage();
    _sharedValue();
    super.initState();
  }

  // List<CategoriesModel> categoriesModel = [];
  List imageModel = [];
  List videoModel = [];

  bool loader = false;
  Uri uri = Uri.parse('http://therent.in/tv/api/tv');

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

        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  _sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      textEditingController.text = prefs.getString('banner') ?? '';
      status = prefs.getBool('status') ?? false;
      selectedValue = prefs.getString('view');
      selectedValuePro = prefs.getString('select1');
      selectedValuePro1 = prefs.getString('select2') ?? '1';
      selectedValuePro2 = prefs.getString('select3') ?? '1';
      bannerColor = prefs.getString('bannerColor') ?? 'red';
      textColor = prefs.getString('textColor') ?? 'green';
      textSize = prefs.getString('textSize') ?? '9';
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text(
          'Filter Screen',
          style: GoogleFonts.croissantOne(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            Row(
              children: [
                SizedBox(
                  width: size.width / 18,
                ),
                FlutterSwitch(
                  width: size.width / 20,
                  height: size.height / 20,
                  activeColor: Colors.indigo,
                  valueFontSize: 10.0,
                  toggleSize: 30,
                  value: status,
                  borderRadius: 20.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (val) {
                    setState(() {
                      status = val;
                    });
                  },
                ),
                SizedBox(
                  width: size.width / 36,
                ),
                Text(
                  'Enable / Disable banner',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ],
            ),
            const Divider(),

            status
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width / 18,
                      vertical: 15,
                    ),
                    child: customTextField(
                        controller: textEditingController,
                        keyboardType: TextInputType.text,
                        hintText: 'Banner content'),
                  )
                : Container(),
            // const SizedBox(
            //   height: 20,
            // ),
            //
            // Text(
            //   'On for Landscape / OFF for Portrait',
            //   style: GoogleFonts.poppins(
            //       fontWeight: FontWeight.w800, fontSize: 15),
            // ),
            // Divider(),

            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: size.width / 18,
                ),
                Text(
                  'Screen mode',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800, fontSize: 15),
                ),
                SizedBox(
                  width: size.width / 10,
                ),
                FlutterSwitch(
                  width: size.width / 20,
                  height: size.height / 20,
                  activeColor: Colors.indigo,
                  valueFontSize: 10.0,
                  toggleSize: 30,
                  value: valueSame,
                  borderRadius: 20.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (val) {
                    setState(() {
                      valueSame = val;
                    });
                  },
                ),
                SizedBox(
                  width: size.width / 36,
                ),
                valueSame
                    ? Text(
                        'Landscape mode',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800, fontSize: 15),
                      )
                    : Text(
                        'Portrait mode',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800, fontSize: 15),
                      ),
              ],
            ),

            const Divider(),

            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: size.width / 18,
                ),
                Text(
                  'Secondary memory',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800, fontSize: 15),
                ),
                SizedBox(
                  width: size.width / 30,
                ),
                FlutterSwitch(
                  width: size.width / 20,
                  height: size.height / 20,
                  activeColor: Colors.indigo,
                  valueFontSize: 10.0,
                  toggleSize: 30,
                  value: memoryUser,
                  borderRadius: 20.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (val) {
                    setState(() {
                      memoryUser = val;
                    });
                  },
                ),
                SizedBox(
                  width: size.width / 50,
                ),
                memoryUser
                    ? Text(
                  'Enable memory',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800, fontSize: 15),
                )
                    : Text(
                  'Disable memory',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800, fontSize: 15),
                ),

              ],
            ),

            const Divider(),
            const SizedBox(
              height: 10,
            ),

            status
                ? Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: size.width / 18,
                          ),
                          child: Text(
                            'Banner bg color',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: size.width / 18,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Center(
                                child: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                              items: [
                                ...List.generate(_bannerColor.length, (index) {
                                  return DropdownMenuItem<String>(
                                    value: _bannerColor[index],
                                    child: Center(
                                      child: Text(
                                        _bannerColor[index],
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              value: bannerColor,
                              onChanged: (value) {
                                setState(() {
                                  bannerColor = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 140,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            status
                ? Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: size.width / 18,
                          ),
                          child: Text(
                            'Text color',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: size.width / 18,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Center(
                                child: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                              items: [
                                ...List.generate(_bannerColor.length, (index) {
                                  return DropdownMenuItem<String>(
                                    value: _bannerColor[index],
                                    child: Center(
                                      child: Text(
                                        _bannerColor[index],
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              value: textColor,
                              onChanged: (value) {
                                setState(() {
                                  textColor = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 140,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            status
                ? Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: size.width / 18,
                          ),
                          child: Text(
                            'Text Size',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: size.width / 18,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Center(
                                child: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                              items: [
                                ...List.generate(500, (index) {
                                  return DropdownMenuItem<String>(
                                    value: index.toString(),
                                    child: Center(
                                      child: Text(
                                        index.toString(),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              value: textSize,
                              onChanged: (value) {
                                setState(() {
                                  textSize = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 140,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: size.width / 18,
                    ),
                    child: Text(
                      'Screen view mode',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: size.width / 18,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        hint: Center(
                          child: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: '1',
                            child: Center(
                              child: Text(
                                'One View',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '2',
                            child: Center(
                              child: Text(
                                'Two View',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '3',
                            child: Center(
                              child: Text(
                                '30x70 View',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '4',
                            child: Center(
                              child: Text(
                                '70x30 View',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '5',
                            child: Center(
                              child: Text(
                                '20x80 views',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '6',
                            child: Center(
                              child: Text(
                                '80x20 views',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '7',
                            child: Center(
                              child: Text(
                                'Three View',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            selectedValue == '1'
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width / 18, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You have selected single screen view',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: Colors.indigo),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select mode',
                                style: GoogleFonts.poppins(fontSize: 15),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: size.width / 18,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Center(
                                      child: Text(
                                        'Select Mode',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: '1',
                                        child: Center(
                                          child: Text(
                                            'Image content',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: '2',
                                        child: Center(
                                          child: Text(
                                            'Video content',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                    value: selectedValuePro,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValuePro = value as String;
                                      });
                                    },
                                    buttonHeight: 40,
                                    buttonWidth: 140,
                                    itemHeight: 40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : selectedValue == '2' ||
                        selectedValue == '3' ||
                        selectedValue == '4' ||
                        selectedValue == '5' ||
                        selectedValue == '6'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You have selected double screen view',
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: Colors.indigo),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Select 1st mode',
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        hint: Center(
                                          child: Text(
                                            'Select Mode',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ),
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: '1',
                                            child: Center(
                                              child: Text(
                                                'Image content',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '2',
                                            child: Center(
                                              child: Text(
                                                'Video content',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ],
                                        value: selectedValuePro,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValuePro = value as String;
                                          });
                                        },
                                        buttonHeight: 40,
                                        buttonWidth: 140,
                                        itemHeight: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Select 2nd mode',
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        hint: Center(
                                          child: Text(
                                            'Select Mode',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ),
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: '1',
                                            child: Center(
                                              child: Text(
                                                'Image content',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '2',
                                            child: Center(
                                              child: Text(
                                                'Video content',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ],
                                        value: selectedValuePro1,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValuePro1 = value as String;
                                          });
                                        },
                                        buttonHeight: 40,
                                        buttonWidth: 140,
                                        itemHeight: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : selectedValue == '7'
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You have selected third screen view',
                                  style: GoogleFonts.inter(
                                      fontSize: 10, color: Colors.indigo),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select 1st mode',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            hint: Center(
                                              child: Text(
                                                'Select mode',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                            items: [
                                              DropdownMenuItem<String>(
                                                value: '1',
                                                child: Center(
                                                  child: Text(
                                                    'Image content',
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: '2',
                                                child: Center(
                                                  child: Text(
                                                    'Video content',
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            value: selectedValuePro,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValuePro =
                                                    value as String;
                                              });
                                            },
                                            buttonHeight: 40,
                                            buttonWidth: 140,
                                            itemHeight: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select 2nd mode',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            hint: Center(
                                              child: Text(
                                                'Select Mode',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                            items: [
                                              DropdownMenuItem<String>(
                                                value: '1',
                                                child: Center(
                                                  child: Text(
                                                    'Image content',
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: '2',
                                                child: Center(
                                                  child: Text(
                                                    'Video content',
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            value: selectedValuePro1,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValuePro1 =
                                                    value as String;
                                              });
                                            },
                                            buttonHeight: 40,
                                            buttonWidth: 140,
                                            itemHeight: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select 3rd mode',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            hint: Center(
                                              child: Text(
                                                'Select Mode',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                            items: [
                                              DropdownMenuItem<String>(
                                                value: '1',
                                                child: Center(
                                                  child: Text(
                                                    'Image content',
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: '2',
                                                child: Center(
                                                  child: Text(
                                                    'video content',
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            value: selectedValuePro2,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValuePro2 =
                                                    value as String;
                                              });
                                            },
                                            buttonHeight: 40,
                                            buttonWidth: 140,
                                            itemHeight: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
            InkWell(
              onTap: () async {
                if (selectedValue == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Please select value'),
                          actions: [
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.indigo.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    "okay",
                                    style:
                                        GoogleFonts.inter(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  await _storeOnboardInfo();
                  await _storeModeInfo(valueSame);
                  await _storeInfo(textEditingController.text.trim(), status);
                  await _colorValue();
                  await _storeDropInfo(selectedValue!, selectedValuePro ?? '',
                      selectedValuePro1 ?? '', selectedValuePro2 ?? '');

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(1, 0),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(-1, 0),
                      )
                    ]),
                child: Center(
                  child: Text(
                    'Submit',
                    style: GoogleFonts.croissantOne(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
