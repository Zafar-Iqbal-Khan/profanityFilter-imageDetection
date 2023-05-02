import 'package:flutter/material.dart';

class ViewImageScreen extends StatelessWidget {
  var image;
  ViewImageScreen({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Image.network(image),
        ));
  }
}
