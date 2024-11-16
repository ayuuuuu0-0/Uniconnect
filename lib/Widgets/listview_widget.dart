import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uniconnect/ImageSliderScreen/image_slider_screen.dart';

import 'global_var.dart';

class ListViewWidget extends StatefulWidget {
  String docId,
      itemColor,
      img1,
      img2,
      img3,
      img4,
      //img5,
      userImg,
      name,
      userId,
      itemModel,
      postId;
  String itemPrice,
      description,
      //address,
      userNumber,
      userEmail;
  DateTime date;
  //double lat, lng;

  ListViewWidget({
    required this.docId,
    required this.itemColor,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.img4,
    //required this.img5,
    required this.userImg,
    required this.name,
    required this.userEmail,
    required this.userId,
    required this.itemModel,
    required this.postId,
    required this.itemPrice,
    required this.description,
    //required this.address,
    required this.userNumber,
    required this.date,
    //required this.lat,
    //required this.lng,
  });
  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  Future<Future> showDialogForUpdateData(
      selectedDoc,
      oldUserName,
      oldPhoneNumber,
      oldItemprice,
      oldItemName,
      oldItemColor,
      oldItemDescription) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Text(
                'Update Data',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Bebas',
                  letterSpacing: 2.0,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      initialValue: oldUserName,
                      decoration: InputDecoration(
                        hintText: 'Enter your Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          oldUserName = value;
                        });
                      }),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                      initialValue: oldPhoneNumber,
                      decoration: InputDecoration(
                        hintText: 'Enter your Phone Number',
                      ),
                      onChanged: (value) {
                        setState(() {
                          oldPhoneNumber = value;
                        });
                      }),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                      initialValue: oldItemprice,
                      decoration: InputDecoration(
                        hintText: 'Enter Item Price',
                      ),
                      onChanged: (value) {
                        setState(() {
                          oldItemprice = value;
                        });
                      }),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                      initialValue: oldItemName,
                      decoration: InputDecoration(
                        hintText: 'Enter Item Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          oldItemName = value;
                        });
                      }),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                      initialValue: oldItemColor,
                      decoration: InputDecoration(
                        hintText: 'Enter Item Color',
                      ),
                      onChanged: (value) {
                        setState(() {
                          oldItemColor = value;
                        });
                      }),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                      initialValue: oldItemDescription,
                      decoration: InputDecoration(
                        hintText: 'Enter Item Description',
                      ),
                      onChanged: (value) {
                        setState(() {
                          oldItemDescription = value;
                        });
                      }),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                      updateProfileNameOnExistingPosts(oldUserName);
                      _updateUserName(oldUserName, oldPhoneNumber);
                      FirebaseFirestore.instance
                          .collection('items')
                          .doc(selectedDoc)
                          .update({
                        'userName': oldUserName,
                        'userNumber': oldPhoneNumber,
                        'itemPrice': oldItemprice,
                        'itemModel': oldItemName,
                        'itemColor': oldItemColor,
                        'description': oldItemDescription,
                      }).catchError((onError) {
                        print(onError);
                      });

                      Fluttertoast.showToast(
                        msg: 'Credentials has been uploaded',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey,
                        fontSize: 18.0,
                      );
                    },
                    child: const Text('Update Now',
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          );
        });
  }

  updateProfileNameOnExistingPosts(oldUserName) async {
    await FirebaseFirestore.instance
        .collection('items')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (int index = 0; index < snapshot.docs.length; index++) {
        String userProfileNameInPost = snapshot.docs[index]['userName'];

        if (userProfileNameInPost != oldUserName) {
          FirebaseFirestore.instance
              .collection('items')
              .doc(snapshot.docs[index].id)
              .update({
            'userName': oldUserName,
          });
        }
      }
    });
  }

  Future _updateUserName(oldUserName, oldPhoneNumber) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'userName': oldUserName,
      'userNumber': oldPhoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 16.0,
        shadowColor: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          side: BorderSide(
            color: Colors.white, // Border color
            width: 0.50, // Border width
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(
                12.0)), // Ensures rounded corners inside the container
          ),
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageSliderScreen(
                                title: widget.itemModel,
                                urlImage1: widget.img1,
                                urlImage2: widget.img2,
                                urlImage3: widget.img3,
                                urlImage4: widget.img4,
                                //urlImage5: widget.img5,
                                itemColor: widget.itemColor,
                                userNumber: widget.userNumber,
                                userEmail: widget.userEmail,
                                description: widget.description,
                                //address: widget.address,
                                itemPrice: widget.itemPrice,
                                //lat: widget.lat,
                                //lng: widget.lng,
                              )));
                },
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12.0), // Rounding the image
                  child: Image.network(
                    widget.img1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.userImg),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'DMSerifText',
                            color: Colors.white60,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.itemModel,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'DMSerifText',
                            color: Colors.white60,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          DateFormat('dd MMM, yyyy - hh:mm a')
                              .format(widget.date)
                              .toString(),
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                              fontFamily: 'DMSerifText'),
                        ),
                      ],
                    ),
                    widget.userId != uid
                        ? Padding(
                            padding: EdgeInsets.only(right: 50.0),
                            child: Column(),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialogForUpdateData(
                                    widget.docId,
                                    widget.name,
                                    widget.userNumber,
                                    widget.itemPrice,
                                    widget.itemModel,
                                    widget.itemColor,
                                    widget.description,
                                  );
                                },
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Icon(
                                    Icons.edit_note,
                                    color: Colors.white,
                                    size: 27,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('items')
                                      .doc(widget.postId)
                                      .delete();
                                },
                                icon: const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Icon(
                                    Icons.delete_forever,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
