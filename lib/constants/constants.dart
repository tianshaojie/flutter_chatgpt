import 'package:flutter/material.dart';

Color scaffoldBackgroundColor = const Color(0xFF343541);
Color cardColor = const Color(0xFF444654);

String BASE_URL = "https://api.openai.com/v1";
String API_KEY = "";
String API_MODEL = "gpt-3.5-turbo-0301";

Map<String, String> titleMap = {
  "gpt-3.5-turbo-0301" : "ChatGPT-3.5-Turbo-0301",
  "gpt-3.5-turbo" : "ChatGPT-3.5-Turbo"
};