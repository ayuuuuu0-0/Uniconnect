import 'package:flutter/material.dart';

class SearchProduct extends StatelessWidget {
  const SearchProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Product Screen',
      style: TextStyle(
        color: Colors.black54,
        fontFamily: 'DM Sans',
        fontSize: 30,
      ),
      ),
      ),
    );
  }
}
