import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_chatgpt/constants/constants.dart';
import 'package:flutter_chatgpt/models/chat_model.dart';
import 'package:flutter_chatgpt/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      ).timeout(const Duration(seconds: 45));;

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Send Message fct
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          'model': modelId,
          'messages': [
            {"role": "user", "content": message}
          ]
        }),
      ).timeout(const Duration(seconds: 45));
      List<ChatModel> chatList = [];
      if (response.statusCode == 200) {
        Utf8Decoder utf8decoder = const Utf8Decoder();
        String responseString = utf8decoder.convert(response.bodyBytes);
        final jsonResponse = json.decode(responseString);
        if (jsonResponse["choices"].length > 0) {
          chatList = List.generate(
            jsonResponse["choices"].length, (index) => ChatModel(msg: jsonResponse["choices"][index]['message']['content'], chatIndex: 1,),
          );
        }
        // final message = data['choices'][0]['message']['content'].toString();
        // return message;
      } else {
        throw Exception('Failed to get response message from API');
      }
      return chatList;

      // if (jsonResponse['error'] != null) {
      //   // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
      //   throw HttpException(jsonResponse['error']["message"]);
      // }
      // List<ChatModel> chatList = [];
      // if (jsonResponse["choices"].length > 0) {
      //   // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
      //   chatList = List.generate(
      //     jsonResponse["choices"].length,
      //     (index) => ChatModel(
      //       msg: jsonResponse["choices"][index]["text"],
      //       chatIndex: 1,
      //     ),
      //   );
      // }
      // return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
