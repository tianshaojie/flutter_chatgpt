import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/settings_provider.dart';
import '../widgets/drop_down_widget.dart';

class SettingsPage {
  static Future<void> showModalSheet({required BuildContext context}) async {
    String _inputApiKey = '';
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => IntrinsicHeight(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 25, 18, 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 160,
                      child: Text(
                        "Chosen Model:",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Flexible(child: ModelsDropDownWidget()),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 160,
                      child: Text(
                        "Set up your API key:",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Flexible(child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: UnderlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        _inputApiKey = value;
                      }
                    )),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Padding(
                //         padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                //         child: SelectableText(
                //           "Your current api key is : ${settingsProvider.apiKey}",
                //           textAlign: TextAlign.right,
                //         ),
                //       )
                //     ),
                //   ]
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                        child: ElevatedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            if(_inputApiKey.isEmpty) {
                              EasyLoading.showError("Please enter your api key!");
                              return;
                            }
                            settingsProvider.saveSettings(_inputApiKey);
                            Navigator.pop(context);
                            EasyLoading.showSuccess("Your api key has been saved successfully!");
                          },
                        ),
                      )
                    ),
                  ]
                )
              ],
            ),
          )
        ),
      )
    );
  }
}
