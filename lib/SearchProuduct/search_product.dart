import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/HomeScreen/HomeScreen.dart';

import '../Widgets/listview_widget.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {

  final TextEditingController _searchQueryController = TextEditingController();
    String searchQuery = '';
    bool _isSearching = false;

    Widget _buildSearchField()
    {
      return TextField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
            hintText: 'Search here...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white, fontSize: 16.0)
        ),
        onChanged: (query) => updateSearchQuery(query),
      );
    }

  updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching)
    {
      return <Widget>
      [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: ()
          {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>
    [
      IconButton(
          icon: Icon(Icons.search),
          onPressed: _startSearch,
      ),
    ];
  }
  _clearSearchQuery()
  {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  _startSearch()
  {
   ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
   setState(() {
     _isSearching = true;
   });
  }

  _stopSearching()
  {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _buildTitle(BuildContext context){
      return const Text('Seach Product');
  }

  _buildBackButton(){
      return IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          icon: Icon(Icons.arrow_back, color: Colors.white,)
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        color: Colors.black
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: _isSearching ? BackButton() : _buildBackButton(),
          actions: _buildActions(),
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          automaticallyImplyLeading: false,
          centerTitle: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.black
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where('itemModel', isGreaterThanOrEqualTo: _searchQueryController.text.trim())
              .where('status', isEqualTo: 'approved')
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







// import 'package:flutter/material.dart';
//
// class SearchProduct extends StatelessWidget {
//   const SearchProduct({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _searchQueryController = TextEditingController();
//     String searchQuery = '';
//
//     Widget _buildSearchField()
//     {
//
//       updateSearchQuery(String newQuery) {
//         setState(() {
//           searchQuery = newQuery;
//           print(searchQuery);
//         });
//       }
//
//       return TextField(
//         controller: _searchQueryController,
//         autofocus: true,
//         decoration: InputDecoration(
//             hintText: 'Search here...',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.white, fontSize: 16.0)
//         ),
//         onChanged: (query) => updateSearchQuery(query),
//       );
//     }
//
//
//
//
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//             colors: [Color(0xFF170615), Color(0xFF54082A)],
//             begin: Alignment.bottomLeft,
//             end: Alignment.topRight,
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(title: const Text('Search Product Screen',
//           style: TextStyle(
//             color: Colors.black54,
//             fontFamily: 'DM Sans',
//             fontSize: 30,
//           ),
//         ),
//         ),
//       ),
//     );
//   }
// }
