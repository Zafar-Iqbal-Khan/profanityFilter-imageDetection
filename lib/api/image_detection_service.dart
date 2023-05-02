import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<http.Response> detectImage({imageUrl}) async {
  var url = Uri.parse(
      'https://nsfw-images-detection-and-classification.p.rapidapi.com/adult-content');
  var headers = {
    'content-type': 'application/json',
    'X-RapidAPI-Key': '6b5732e515msha2084a7eea2f387p182eaejsnad10f95b7950',
    'X-RapidAPI-Host': 'nsfw-images-detection-and-classification.p.rapidapi.com'
  };
  var body = jsonEncode({
    'url': imageUrl.toString(),
  });
  var response = await http.post(url, headers: headers, body: body);
  log(response.body.toString());
  return response;
}
