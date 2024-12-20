import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:uniconnect/DialogBox/loading_dialog.dart';
import 'package:uniconnect/HomeScreen/HomeScreen.dart';
import 'package:uuid/uuid.dart';
import '../Widgets/global_var.dart';

class UploadAdScreen extends StatefulWidget {
  const UploadAdScreen({Key? key}) : super(key: key);

  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {
  String postId = Uuid().v4();
  bool uploading = false,
      next = false;

  final List<File> _image = [];

  List<String> urlsList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  double val = 0;
  String name = '';
  String phoneNo = '';
  String email = '';
  String itemPrice = '';
  String itemModel = '';
  String itemColor = '';
  String description = '';

  chooseImage() async {
    XFile? pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });

      var ref = FirebaseStorage.instance
          .ref()
          .child('image/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlsList.add(value);
          i++;
        });
      });
    }
  }

  getNameofUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!['userName'];
          phoneNo = snapshot.data()!['userNumber'];
          email = snapshot.data()!['userEmail'];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNameofUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                color: Colors.black
            ),
          ),
          title: Text(
            next ? 'Please write Items Info' : 'Choose Item Images',
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: 'DMSerifText',
              fontSize: 25,

            ),
          ),
          actions: [
            next
                ? Container()
                : ElevatedButton(
              onPressed: () {
                if (_image.length == 4) {
                  setState(() {
                    uploading = true;
                    next = true;
                  });
                } else {
                  Fluttertoast.showToast(
                    msg: 'Please select 4 images only...',
                    fontSize: 22,
                    backgroundColor: Colors.white54,
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontFamily: 'DMSerifText'),
              ),
            ),
          ],
        ),
        body: next
            ? SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5.0),
                TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'DMSerifText'),
                  decoration: const InputDecoration(
                    hintText: 'Enter Item Price',
                    hintStyle: TextStyle(
                        color: Colors.white54, fontFamily: 'DMSerifText'),
                  ),
                  onChanged: (value) {
                    itemPrice = value;
                  },
                ),
                const SizedBox(height: 5.0),
                TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'DMSerifText'),
                  decoration: const InputDecoration(
                      hintText: 'Enter Item Name',
                      hintStyle: TextStyle(
                          color: Colors.white54, fontFamily: 'DMSerifText')),
                  onChanged: (value) {
                    itemModel = value;
                  },
                ),
                const SizedBox(height: 5.0),
                TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'DMSerifText'),
                  decoration: const InputDecoration(
                      hintText: 'Enter Item Color',
                      hintStyle: TextStyle(
                          color: Colors.white54, fontFamily: 'DMSerifText')),
                  onChanged: (value) {
                    itemColor = value;
                  },
                ),
                const SizedBox(height: 5.0),
                TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'DMSerifText'),
                  decoration: const InputDecoration(
                    hintText: 'Write some Items Description',
                    hintStyle: TextStyle(
                        color: Colors.white54, fontFamily: 'DMSerifText'),
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return LoadingAlertDialog(
                              message: 'Uploading....',
                            );
                          });
                      uploadFile().whenComplete(() {
                        FirebaseFirestore.instance
                            .collection('items')
                            .doc(postId)
                            .set({
                          'userName': name,
                          'id': _auth.currentUser!.uid,
                          'postId': postId,
                          'userNumber': phoneNo,
                          'userEmail': email,
                          "itemPrice": itemPrice,
                          "itemModel": itemModel,
                          "itemColor": itemColor,
                          "description": description,
                          "urlImage1": urlsList[0].toString(),
                          "urlImage2": urlsList[1].toString(),
                          "urlImage3": urlsList[2].toString(),
                          "urlImage4": urlsList[3].toString(),
                          //"urlImage5": urlsList[4].toString(),
                          'imgPro': userImageurl,

                          // 'lat': position!.latitude,
                          // 'lng': position!.longitude,
                          // 'address': completeAddress,
                          'time': DateTime.now(),
                          'status': 'approved',
                        });
                        Fluttertoast.showToast(
                          msg: 'Data added successfully...',
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white54
                    ),
                    child: Text(
                      'Upload',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'DMSerifText',
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            : Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  // Only show the text if 'next' is false
                  if (!next)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      // Padding above the + icon
                      child: Text(
                        'Please add only 4 images', // Your text above the icon
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white54,
                          fontFamily: "DMSerifText"
                        ),
                      ),
                    ),
                  Expanded(child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: _image.length + 1,
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white38
                          ),

                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              !uploading ? chooseImage() : null;
                            },
                          ),
                        ),
                      )
                          : Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.white,
                            ),
                            image: DecorationImage(
                                image: FileImage(_image[index - 1]),
                                fit: BoxFit.cover)),
                      );
                    },
                  ),
                  ),
                ],
              ),
            ),
            uploading
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'uploading.....',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator(
                    value: val,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white),
                  ),
                ],
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
