import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_profanity_filter_app/pages/view_image_screen.dart';
import '../api/image_detection_service.dart';

class ImageDetectionScreen extends StatefulWidget {
  const ImageDetectionScreen({super.key});

  @override
  State<ImageDetectionScreen> createState() => _ImageDetectionScreenState();
}

class _ImageDetectionScreenState extends State<ImageDetectionScreen> {
  String? _imageUrlText;
  bool? _isLoading = false;
  var _unsafe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Detection"),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              color: Colors.transparent,
              child: SizedBox(
                  height: 600,
                  width: double.infinity,
                  child: _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.red))
                      : Center(
                          child: _unsafe == null
                              ? const Text(
                                  "Please Enter your image url below....")
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _unsafe == true
                                          ? "This images is not safe for \nwork or other public places"
                                          : "This images is safe for \nwork or other public places",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: _unsafe == true
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewImageScreen(
                                                    image: _imageUrlText),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.lightBlue,
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'View Image',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        )),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _imageUrlText = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Enter Image Url',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      // [call api here]
                      if (_imageUrlText != null &&
                          _imageUrlText!.isNotEmpty &&
                          _isLoading == false) {
                        setState(() {
                          _isLoading = true;
                        });
                        var response = await detectImage(
                          imageUrl: _imageUrlText,
                        );
                        var resp = jsonDecode(response.body);
                        var status = response.statusCode;

                        setState(() {
                          _unsafe = resp['unsafe'];
                          _isLoading = false;
                        });
                        if (status != 200) {
                          Fluttertoast.showToast(
                            msg: "invalid image url",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      } else {
                        if (_imageUrlText == null ||
                            _imageUrlText!.isNotEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please enter image url",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else if (_isLoading == true) {
                          Fluttertoast.showToast(
                            msg: "Please wait while fetching data ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
