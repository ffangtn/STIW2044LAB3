import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab3_mytutor/views/loginscreen.dart';

import 'models/palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tutor',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
      home: const MySplashScreen(title: 'My Tutor'),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  late double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          )),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Container(
                      height: 200,
                      width: 200,
                      child: Image.asset('assets/images/1.png',
                          fit: BoxFit.cover)),
                ),
                const Text(
                  "My Tutor",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const CircularProgressIndicator(),
                const Text("Version 0.1",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
