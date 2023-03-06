import 'package:flutter_chatgpt/models/models_model.dart';
import 'package:flutter_chatgpt/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_consts.dart';

class SettingsProvider with ChangeNotifier {
  String currentModel = "gpt-3.5-turbo-0301";
  String apiKey = "";

  String get getApiKey {
    return apiKey;
  }

  Future<void> setApiKey(String key) async {
    if(key.isEmpty) {
      return;
    }
    apiKey = key;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_api_key', key);
    API_KEY = key;
    notifyListeners();
  }

  String get getCurrentModel {
    return currentModel;
  }

  Future<void> setCurrentModel(String newModel) async {
    if(newModel.isEmpty) {
      return;
    }
    currentModel = newModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_api_model', newModel);
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    modelsList.removeWhere((element) => !element.id.contains("gpt"));
    return modelsList;
  }
}
