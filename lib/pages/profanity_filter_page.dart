import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_profanity_filter_app/api/bad_word_detection_service.dart';

class ProfanityFilterScreen extends StatefulWidget {
  const ProfanityFilterScreen({super.key});

  @override
  State<ProfanityFilterScreen> createState() => _ImageDetectionScreenState();
}

class _ImageDetectionScreenState extends State<ProfanityFilterScreen> {
  String? _enteredText;
  final bool _isLoading = false;
  var badwordList = [];
  var cleanedContent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profanity Filter"),
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
                        child: CircularProgressIndicator(color: Colors.red),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Entered Text: ${_enteredText ?? ""}",
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Bad Words: $badwordList ",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Cleaned Text:${cleanedContent ?? ""} ",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
              ),
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
                          _enteredText = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Enter Text ',
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
                      if (_enteredText != null && _enteredText!.isNotEmpty) {
                        setState(() {
                          _isLoading == true;
                        });
                        http.Response response =
                            await testBadWordFilter(text: _enteredText);
                        setState(() {
                          _isLoading == false;
                        });
                        var decodedResponse = jsonDecode(response.body);
                        if (response.statusCode == 200) {
                          setState(() {
                            badwordList = decodedResponse['profanities'];
                            cleanedContent = decodedResponse['clean'];
                          });
                        } else {
                          Fluttertoast.showToast(
                            msg: "Something went wrong",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      } else {
                        if (_enteredText == null || _enteredText!.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please enter text to check profanity",
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
