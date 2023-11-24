// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:marquee/marquee.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tvapp/screen/option_page.dart';
//
// import 'package:video_player/video_player.dart';
//
// import '../widget/slider.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   String? view;
//   bool? status;
//   String? banner;
//   String? view1, view2, view3;
//
//
//   int? flex1, flex2;
//
//
//   _sharedValue()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       banner =  prefs.getString('banner') ?? '';
//       status = prefs.getBool('status') ?? false;
//       flex1 = prefs.getInt('flex1') ?? 0;
//       flex2 = prefs.getInt('flex2') ?? 0;
//       view = prefs.getString('view') ?? '';
//       view1 = prefs.getString('select1') ?? '';
//       view2 = prefs.getString('select2') ?? '';
//       view3 = prefs.getString('select3') ?? '';
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _sharedValue();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//     ]);
//   }
//
//   final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return view == 0 || view ==null ? CircularProgressIndicator() : Scaffold(
//       key: _key,
//       body: Stack(
//         children: [
//           view == '1' ?
//           const OneView() :
//           view == '7' ?
//           ThreeView():
//           TwoView(
//             flex1: flex1!,
//             flex2: flex2!,
//           ),
//           status! ? Positioned(
//             bottom: 0,
//             child: Container(
//               height: 50,
//               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               width: MediaQuery.of(context).size.width,
//               color: Colors.red,
//               child: Center(
//                 child: Marquee(
//                   text: banner!+ "      ",
//                   style:
//                   GoogleFonts.notoSans(color: Colors.white, fontSize: 15),
//                 ),
//               ),
//             ),
//           ) : Positioned(
//             bottom: 0,
//             child: Container(
//               height: 50,
//               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               width: MediaQuery.of(context).size.width,
//               color: Colors.transparent,
//             ),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.indigo,
//           onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=> const OptionScreen()));
//           }
//       ),
//     );
//   }
// }
//
// class BasicOverlayWidget extends StatelessWidget {
//   final VideoPlayerController controller;
//
//   const BasicOverlayWidget({Key? key, required this.controller})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         controller.value.isPlaying ? controller.pause() : controller.play();
//       },
//       child: Stack(
//         children: [
//           Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: VideoPlayer(controller)
//           ),
//           controller.value.isPlaying
//               ? Container()
//               : Container(
//             alignment: Alignment.center,
//             color: Colors.black26,
//             child: const Icon(
//               Icons.play_arrow,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// class OneView extends StatefulWidget {
//   const OneView({Key? key}) : super(key: key);
//
//   @override
//   State<OneView> createState() => _OneViewState();
// }
//
// class _OneViewState extends State<OneView> {
//   CarouselSliderController? _sliderController1;
//   VideoPlayerController? controller1;
//   String? view;
//   _callingShared()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       view = prefs.getString('view1');
//     });
//   }
//
//   @override
//   void initState() {
//     _callingShared();
//     _sliderController1 = CarouselSliderController();
//     controller1 = VideoPlayerController.network('https://media.istockphoto.com/id/1411042848/video/beautiful-young-woman-wearing-white-dress-and-hat-standing-in-a-lavender-field.mp4?s=mp4-640x640-is&k=20&c=451m5eY4kVvZeBLfCws3Zkyqb9wyqDJWuZkZNxR-srU=')
//       ..addListener(() {
//         setState(() {});
//       })
//       ..setLooping(true)
//       ..initialize().then((value) => controller1!.play());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return view == '0' || view == '' ? const CircularProgressIndicator() : Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: view == '1' ?  SliderPageWidget(
//         controller: _sliderController1!,
//       ) : view == '2' ? VideoPlayerWidget(controller: controller1!) : const Center(child: Text('Some thing went worng'),),
//     );
//   }
// }
//
//
//
// class TwoView extends StatefulWidget {
//   final int flex1;
//   final int flex2;
//   const TwoView({Key? key, required this.flex1, required this.flex2}) : super(key: key);
//
//   @override
//   State<TwoView> createState() => _TwoViewState();
// }
//
// class _TwoViewState extends State<TwoView> {
//
//   CarouselSliderController? _sliderController1, _sliderController2;
//   VideoPlayerController? controller1, controller2;
//   String? view1, view2;
//   _callingShared()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       view1 = prefs.getString('view1');
//       view2 = prefs.getString('view2');
//     });
//   }
//
//   @override
//   void initState() {
//     _callingShared();
//     _sliderController1 = CarouselSliderController();
//     _sliderController2 = CarouselSliderController();
//     controller1 = VideoPlayerController.network('https://media.istockphoto.com/id/1411042848/video/beautiful-young-woman-wearing-white-dress-and-hat-standing-in-a-lavender-field.mp4?s=mp4-640x640-is&k=20&c=451m5eY4kVvZeBLfCws3Zkyqb9wyqDJWuZkZNxR-srU=')
//       ..addListener(() {
//         setState(() {});
//       })
//       ..setLooping(true)
//       ..initialize().then((value) => controller1!.play());
//
//     controller2 = VideoPlayerController.network('https://media.istockphoto.com/id/1411042848/video/beautiful-young-woman-wearing-white-dress-and-hat-standing-in-a-lavender-field.mp4?s=mp4-640x640-is&k=20&c=451m5eY4kVvZeBLfCws3Zkyqb9wyqDJWuZkZNxR-srU=')
//       ..addListener(() {
//         setState(() {});
//       })
//       ..setLooping(true)
//       ..initialize().then((value) => controller2!.play());
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         children: [
//           Expanded(
//             flex: widget.flex1,
//             child:  view1 == '1' ?  SliderPageWidget(
//               controller: _sliderController1!,
//             ) : view1 == '2' ? VideoPlayerWidget(controller: controller1!) : const Center(child: Text('Some thing went worng'),), ),
//           Expanded(
//             flex: widget.flex2,
//             child:  view2 == '1' ?  SliderPageWidget(
//               controller: _sliderController2!,
//             ) : view2 == '2' ? VideoPlayerWidget(controller: controller2!) : const Center(child: Text('Some thing went worng'),), ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// class ThreeView extends StatefulWidget {
//
//   const ThreeView({Key? key}) : super(key: key);
//
//   @override
//   State<ThreeView> createState() => _ThreeViewState();
// }
//
// class _ThreeViewState extends State<ThreeView> {
//
//
//   CarouselSliderController? _sliderController1, _sliderController2, _sliderController3;
//   VideoPlayerController? controller1, controller2, controller3;
//   String? view1, view2, view3;
//   _callingShared()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       view1 = prefs.getString('view1');
//       view2 = prefs.getString('view2');
//       view3 = prefs.getString('view3');
//     });
//   }
//
//   @override
//   void initState() {
//     _callingShared();
//     _sliderController1 = CarouselSliderController();
//     _sliderController2 = CarouselSliderController();
//     _sliderController3 = CarouselSliderController();
//     controller1 = VideoPlayerController.network('https://media.istockphoto.com/id/1411042848/video/beautiful-young-woman-wearing-white-dress-and-hat-standing-in-a-lavender-field.mp4?s=mp4-640x640-is&k=20&c=451m5eY4kVvZeBLfCws3Zkyqb9wyqDJWuZkZNxR-srU=')
//       ..addListener(() {
//         setState(() {});
//       })
//       ..setLooping(true)
//       ..initialize().then((value) => controller1!.play());
//
//     controller2 = VideoPlayerController.network('https://media.istockphoto.com/id/1411042848/video/beautiful-young-woman-wearing-white-dress-and-hat-standing-in-a-lavender-field.mp4?s=mp4-640x640-is&k=20&c=451m5eY4kVvZeBLfCws3Zkyqb9wyqDJWuZkZNxR-srU=')
//       ..addListener(() {
//         setState(() {});
//       })
//       ..setLooping(true)
//       ..initialize().then((value) => controller2!.play());
//
//     controller3 = VideoPlayerController.network('https://media.istockphoto.com/id/1411042848/video/beautiful-young-woman-wearing-white-dress-and-hat-standing-in-a-lavender-field.mp4?s=mp4-640x640-is&k=20&c=451m5eY4kVvZeBLfCws3Zkyqb9wyqDJWuZkZNxR-srU=')
//       ..addListener(() {
//         setState(() {});
//       })
//       ..setLooping(true)
//       ..initialize().then((value) => controller3!.play());
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         children: [
//           Expanded(
//             child:  view1 == '1' ?  SliderPageWidget(
//               controller: _sliderController1!,
//             ) : view1 == '2' ? VideoPlayerWidget(controller: controller1!) : const Center(child: Text('Some thing went worng'),), ),
//           Expanded(
//             child:  view2 == '1' ?  SliderPageWidget(
//               controller: _sliderController2!,
//             ) : view2 == '2' ? VideoPlayerWidget(controller: controller2!) : const Center(child: Text('Some thing went worng'),), ),
//           Expanded(
//             child:  view3 == '1' ?  SliderPageWidget(
//               controller: _sliderController3!,
//             ) : view3 == '2' ? VideoPlayerWidget(controller: controller3!) : const Center(child: Text('Some thing went worng'),), ),
//         ],
//       ),
//     );
//   }
// }
