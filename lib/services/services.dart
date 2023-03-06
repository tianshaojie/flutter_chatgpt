import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/constants/api_consts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../widgets/drop_down.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    String _inputValue = '';
    Future<void> _saveInputValue() async {
      if(_inputValue.isEmpty) {
        EasyLoading.showError("Please enter your api key!");
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_api_key', _inputValue);
      API_KEY = _inputValue;
      EasyLoading.showSuccess("Your api key has been saved successfully!");
    }
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
            padding: const EdgeInsets.fromLTRB(18, 30, 18, 18),
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
                    Flexible(child: ModelsDrowDownWidget()),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 160,
                      child: Text(
                        "Set Your Api Key:",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Flexible(child: TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'Enter your api key and click the Save button',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        _inputValue = value;
                      }
                    )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "Your current api key is : $API_KEY",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ),
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: ElevatedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            await _saveInputValue();
                            Navigator.pop(context);
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
