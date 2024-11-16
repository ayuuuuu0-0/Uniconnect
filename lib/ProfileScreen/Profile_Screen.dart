import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/HomeScreen/HomeScreen.dart';
import 'package:uniconnect/Widgets/global_var.dart';

import '../Widgets/listview_widget.dart';

class ProfileScreen extends StatefulWidget {

  String sellerId;

  ProfileScreen({required this.sellerId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  _buildBackButton()
  {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: ()
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
              HomeScreen()));
        }
    );
  }

  _buildUserImage()
  {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(
            adUserImageUrl,
          ),
          fit: BoxFit.fill,
        )
      ),
    );
  }

  getResult()
  {
    FirebaseFirestore.instance
        .collection('items')
        .where('id', isEqualTo: widget.sellerId)
        .where('status', isEqualTo: 'approved')
        .get().then((results){
          setState(() {
            items = results;
            adUserName = items!.docs[0].get('userName');
            adUserImageUrl = items!.docs[0].get('imgPro');
          });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResult();
  }

  QuerySnapshot? items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: _buildBackButton(),
          title: Row(
            children: [
              _buildUserImage(),
              const SizedBox(width: 10,),
              Text(adUserName, style: TextStyle(fontFamily: 'DMSerifText', color: Colors.white),),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
            color: Colors.black
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListViewWidget(
                      docId: snapshot.data!.docs[index].id,
                      itemColor: snapshot.data!.docs[index]['itemColor'],
                      img1: snapshot.data!.docs[index]['urlImage1'],
                      img2: snapshot.data!.docs[index]['urlImage2'],
                      img3: snapshot.data!.docs[index]['urlImage3'],
                      img4: snapshot.data!.docs[index]['urlImage4'],
                      //img5: snapshot.data!.docs[index]['urlImage5'],
                      userImg: snapshot.data!.docs[index]['imgPro'],
                      name: snapshot.data!.docs[index]['userName'],
                      date: snapshot.data!.docs[index]['time'].toDate(),
                      userId: snapshot.data!.docs[index]['id'],
                      itemModel: snapshot.data!.docs[index]['itemModel'],
                      postId: snapshot.data!.docs[index]['postId'],
                      itemPrice: snapshot.data!.docs[index]['itemPrice'],
                      description: snapshot.data!.docs[index]['description'],
                      //lat: snapshot.data!.docs[index]['lat'],
                      //lng: snapshot.data!.docs[index]['lng'],
                      //address: snapshot.data!.docs[index]['address'],
                      userNumber: snapshot.data!.docs[index]['userNumber'],
                      userEmail: snapshot.data!.docs[index]['userEmail'],
                    );
                  },
                );
              }
              else {
                return const Center(
                  child: Text('There is no Tasks',),
                );
              }
            }
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            );
          },
        ),
      ),
    );
  }
}
