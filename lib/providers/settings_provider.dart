import 'package:flutter/cupertino.dart';
import 'package:flutter_chatgpt/constants/constants.dart';
import 'package:flutter_chatgpt/models/models_model.dart';
import 'package:flutter_chatgpt/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _apiKey = "";
  String _model = "";
  List<ModelsModel> _modelsList = [];

  SettingsProvider() {
    initSettings();
  }

  String get apiKey => _apiKey;

  String get model => _model;

  Future<void> setModel(String newModel) async {
    if(newModel.isEmpty) {
      return;
    }
    API_MODEL = _model = newModel;
    notifyListeners();
  }

  List<ModelsModel> get modelsList => _modelsList;

  Future<List<ModelsModel>> getAllModels() async {
    _modelsList = await ApiService.getModels();
    _modelsList.removeWhere((element) => !element.id.contains("gpt"));
    return _modelsList;
  }

  Future<void> initSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    API_KEY = _apiKey = prefs.getString('user_api_key') ?? "";
    API_MODEL = _model = prefs.getString('user_api_model') ?? API_MODEL;
    notifyListeners();
  }

  Future<void> saveSettings(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_api_key', _apiKey);
    prefs.setString('user_api_model', _model);
    notifyListeners();
  }
}
