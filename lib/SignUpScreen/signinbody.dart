import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniconnect/DialogBox/error_dialog.dart';
import 'package:uniconnect/ForgotPassword/forgot_password.dart';
import 'package:uniconnect/LoginScreen/Login_Screen.dart';
import 'package:uniconnect/SignUpScreen/signin_background.dart';
import 'package:uniconnect/Widgets/Already_Registered.dart';
import 'package:uniconnect/Widgets/rounded_button.dart';
import 'package:uniconnect/Widgets/rounded_input_field.dart';
import '../HomeScreen/HomeScreen.dart';
import '../LoginScreen/rounded_password_field.dart';
import '../Widgets/global_var.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {

  String userPhotoUrl = '';
  File? _image;
  bool _isLoading = false;

  final signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _getFromCamera() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  void _showImageDisplay() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text('Camera',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text('Gallery',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void submitFormOnSignup() async {
    final isValid = signUpFormKey.currentState!.validate();
    if (isValid) {
      if (_image == null) {
        showDialog(context: context, builder: (context) {
          return ErrorAlertDialog(
            Message: 'Please pick an image',
          );
        }
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim().toLowerCase(),
            password: _passwordController.text.trim(),
        );

        final User? user = _auth.currentUser;
        uid = user!.uid;

        final ref = FirebaseStorage.instance.ref().child('userImages').child(uid + '.jpg');
        await ref.putFile(_image!);
        userPhotoUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(uid).set(
            {'userName': _nameController.text.trim(),
             'id': uid,
              'userNumber': _phoneController.text.trim(),
              'userEmail': _emailController.text,
              'userImage': userPhotoUrl,
              'time': DateTime.now(),
              'status': 'approved',
          }
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()
            ));
      }
      catch(error){
        setState(() {
          _isLoading = false;
        });
        ErrorAlertDialog(Message: error.toString(),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width,
        screenHeight = MediaQuery
            .of(context)
            .size
            .height;
    return SignUpBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(key: signUpFormKey,
              child: InkWell(
                onTap: () {
                  _showImageDisplay();
                },
                child: CircleAvatar(
                  radius: screenWidth * 0.20,
                  backgroundColor: Colors.white24,
                  backgroundImage: _image == null
                      ? null
                      : FileImage(_image!),
                  child: _image == null
                      ? Icon(
                    Icons.camera_enhance,
                    size: screenWidth * 0.180,
                    color: Colors.black54,
                  )
                      : null,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02,),
            RoundedInputField(
              hintText: 'Name',
              icon: Icons.person,
              onChanged: (value) {
                _nameController.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Email',
              icon: Icons.email,
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            RoundedInputField(
              hintText: 'Phone',
              icon: Icons.call,
              onChanged: (value) {
                _phoneController.text = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            const SizedBox(height: 5,),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ForgotPassword()));
                },
                child: Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            _isLoading
                ?
            Center(
              child: Container(
                width: 70,
                height: 70,
                child: const CircularProgressIndicator(),
              ),
            )
                :
            RoundedButton(
              text: 'SIGN UP',
              press: () {
                submitFormOnSignup();
              },
            ),
            SizedBox(height: screenHeight * 0.03,),
            AlreadyHaveAnAccount(
                login: false,
                press: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
            ),
          ],
        ),
      ),
    );
  }
}
