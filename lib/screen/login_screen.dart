import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tvcode/screen/home.dart';

import 'option_page.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool obsureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffbfbfa),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const Center(
                child: CustomText(
                  text: 'Login',
                  weight: FontWeight.w600,
                  size: 24,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              customTextField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  hintText: 'Phone number/ Email id'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              customTextField(
                  controller: passwordController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsureText = !obsureText;
                      });
                    },
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                  obsureText: obsureText,
                  keyboardType: TextInputType.text,
                  hintText: 'Password'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextButton(
                onPressed: () {},
                child: const CustomText(
                  text: 'Forget Password?',
                  color: Colors.blueAccent,
                  weight: FontWeight.normal,
                  size: 12,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              primaryButton(
                  context: context,
                  text: 'login',
                  onTap: () async {

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OptionScreen()));

                    // try {
                    //   UserCredential userCredential = await FirebaseAuth.instance
                    //       .signInWithEmailAndPassword(
                    //           email: emailController.text,
                    //           password: passwordController.text);
                    //   print('loggedIn');
                    // } on FirebaseAuthException catch (e) {
                    //   if (e.code == 'user-not-found') {
                    //     print('No user found for that email.');
                    //   } else if (e.code == 'wrong-password') {
                    //     print('Wrong password provided for that user.');
                    //   }
                    // }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              // const CustomText(
              //   text: 'Or',
              //   color: Color.fromRGBO(0, 0, 0, 0.4),
              //   size: 12,
              // ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.04,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Image.asset(
              //       'images/google.png',
              //       filterQuality: FilterQuality.high,
              //     ),
              //     Image.asset(
              //       'images/fb.png',
              //       filterQuality: FilterQuality.high,
              //     ),
              //     Image.asset(
              //       'images/apple.png',
              //       filterQuality: FilterQuality.high,
              //     )
              //   ],
              // ),
              // const Spacer(),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       WidgetSpan(
              //         child: CustomText(
              //           text: 'don\'t have account?',
              //           size: 10,
              //           color: Colors.black.withOpacity(0.78),
              //         ),
              //       ),
              //       WidgetSpan(
              //         child: GestureDetector(
              //           onTap: () {},
              //           child: CustomText(
              //             text: ' register',
              //             size: 10,
              //             color: Colors.black.withOpacity(0.78),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }
}




class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const CustomText({Key? key, this.text, this.size, this.color, this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            fontSize: size ?? 14,
            color: color ?? Colors.black,
            fontWeight: weight ?? FontWeight.w600),
      ),
    );
  }
}


Widget customTextField(
    {
      Function? onEditingComplete,
      FocusNode? focusNode,
      bool errorText = false,
      String? errorTextMessage,
      String Function(String?)? validator,
      Function? onTap,
      TextEditingController? controller,
      required TextInputType keyboardType,
      required String hintText,
      Widget? prefixIcon,
      bool obsureText = false,
      Widget? suffixIcon,
      bool autofocus = false}) {
  return TextFormField(
    autofocus: autofocus,
    focusNode: focusNode,
    controller: controller,
    obscureText: obsureText,
    keyboardType: keyboardType,
    style: GoogleFonts.montserrat(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
    decoration: InputDecoration(
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      errorText: errorText ? errorTextMessage : null,
      suffixIcon: suffixIcon,
      prefixIconColor: Colors.black,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      hintStyle: GoogleFonts.montserrat(
          color: const Color.fromRGBO(0, 0, 0, 0.4),
          fontSize: 14,
          fontWeight: FontWeight.w500),
      hintText: hintText,
      fillColor: const Color(0xfff5f5f5),
      prefixIcon: prefixIcon,
    ),
    onEditingComplete: () {
      onEditingComplete;
    },
  );
}



Widget primaryButton(
    {required BuildContext context,
      required String text,
      required VoidCallback onTap}) {
  return Container(
    color: Colors.indigo,
    child: ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.transparent),

        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        // elevation: MaterialStateProperty.all(25),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CustomText(
                text: text,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
