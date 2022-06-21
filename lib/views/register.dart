import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab3_mytutor/views/loginscreen.dart';

import '../constant.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/camera.png';
  var _image;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phonenoEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _homeaddressEditingController =
      TextEditingController();

  @override
  void dispose() {
    print("dispose was called");
    _nameEditingController.dispose();
    _emailEditingController.dispose();
    _phonenoEditingController.dispose();
    _passwordEditingController.dispose();
    _homeaddressEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth / 1.1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up '),
      ),
      body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
        width: ctrwidth,
        child: Form(
          key: _formKey,
          child: Column(children: [
            const SizedBox(height: 10),
            Card(
              child: GestureDetector(
                  onTap: () => {_takePictureDialog()},
                  child: SizedBox(
                      height: screenHeight / 2.5,
                      width: screenWidth,
                      child: _image == null
                          ? Image.asset(pathAsset)
                          : Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameEditingController,
              decoration: InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _emailEditingController,
              decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid email';
                }
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);

                if (!emailValid) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _phonenoEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _passwordEditingController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
              maxLines: 1,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                hintText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _homeaddressEditingController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your home address';
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Enter your home address',
                prefixIcon: const Icon(Icons.home),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already registered?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Sign in'),
                ),
              ],
            ),
            SizedBox(
              width: screenWidth,
              height: 50,
              child: ElevatedButton(
                child: const Text("Sign Up"),
                onPressed: () {
                  _insertDialog();
                },
              ),
            ),
            const SizedBox(height: 10),
          ]),
        ),
      ))),
    );
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _insertDialog() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _insertUser();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _insertUser() {
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _phoneno = _phonenoEditingController.text;
    String _password = _passwordEditingController.text;
    String _homeaddress = _homeaddressEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/new_user.php"),
        body: {
          "name": _name,
          "email": _email,
          "phoneno": _phoneno,
          "pass": _password,
          "homeaddress": _homeaddress,
          "image": base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen()));
      } else {
        Fluttertoast.showToast(
            msg: data['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
