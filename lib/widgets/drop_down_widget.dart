import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/providers/settings_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/models_model.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  String? currentModel;

  bool isFirstLoading = true;
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    currentModel = settingsProvider.model;
    return FutureBuilder<List<ModelsModel>>(
        future: settingsProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&isFirstLoading == true) {
            isFirstLoading= false;
            return const FittedBox(
              child: SpinKitFadingCircle(
                color: Colors.lightBlue,
                size: 30,
              ),
            );
          }
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15
              ),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                      snapshot.data!.length,
                      (index) => DropdownMenuItem(
                        value: snapshot.data![index].id,
                        child: Text(
                          snapshot.data![index].id,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                          ),
                        )
                      )
                    ),
                    value: currentModel,
                    onChanged: (value) {
                      setState(() {
                        currentModel = value.toString();
                      });
                      settingsProvider.setModel(value.toString(),);
                    },
                  ),
                );
        });
  }
}
