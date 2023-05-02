import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> testBadWordFilter({text}) async {
  final url = Uri.parse(
      "https://profanity-cleaner-bad-word-filter.p.rapidapi.com/profanity");

  final headers = {
    "content-type": "application/json",
    "X-RapidAPI-Key": "6b5732e515msha2084a7eea2f387p182eaejsnad10f95b7950",
    "X-RapidAPI-Host": "profanity-cleaner-bad-word-filter.p.rapidapi.com",
  };

  final body = jsonEncode({
    "text": text,
    "maskCharacter": "*",
    "language": "en",
  });

  final response = await http.post(url, headers: headers, body: body);
  print(response.body);
  return response;
}
