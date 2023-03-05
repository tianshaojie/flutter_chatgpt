import 'package:flutter_chatgpt/constants/constants.dart';
import 'package:flutter_chatgpt/services/assets_manager.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? cardColor : scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chatIndex == 0
                    ? Icon(
                        Icons.person_pin,
                        color: Colors.blue,
                        size: 28,
                      )
                    : Transform.rotate(
                        angle: 0,
                        child: Image.asset(
                          AssetsManager.botImage,
                          height: 28,
                          width: 28,
                        )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: chatIndex == 0
                        ? SelectableText(
                            msg,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 17),
                          )
                        : SelectableText(
                            msg.trim(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          )
                    )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
