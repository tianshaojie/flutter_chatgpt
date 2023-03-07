import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/constants/assets.dart';
import 'package:flutter_chatgpt/constants/constants.dart';
import 'package:flutter_chatgpt/providers/chats_provider.dart';
import 'package:flutter_chatgpt/providers/settings_provider.dart';
import 'package:flutter_chatgpt/widgets/rotating_image_widget.dart';
import 'package:flutter_chatgpt/pages/setting_page.dart';
import 'package:flutter_chatgpt/widgets/chat_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  bool _isTyping = false;

  late TextEditingController _textEditingController;
  late ScrollController _listScrollController;
  late AnimationController _animationController;
  late FocusNode focusNode;
  @override
  void initState() {
    _listScrollController = ScrollController();
    _textEditingController = TextEditingController();
    _animationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _textEditingController.dispose();
    _animationController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotatingImage(
              imagePath: Assets.openaiLogo,
              size: 25.0,
              animationController: _animationController,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              "${titleMap[settingsProvider.model] ?? settingsProvider.model}",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await SettingsPage.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length, //chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].msg, // chatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex, //chatList[index].chatIndex,
                  );
                }
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.grey,
                size: 18,
              ),
            ],
            Container(width: double.infinity, height: 1.0, color: cardColor),
            Material(
              color: scaffoldBackgroundColor,
              child: Container(
                height: 55,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: _textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageAndGetAnswers(
                              modelsProvider: settingsProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageAndGetAnswers(
                            modelsProvider: settingsProvider,
                            chatProvider: chatProvider);
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    Future.delayed(Duration(milliseconds: 100), () {
      _listScrollController.animateTo(
          _listScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate);
    });
  }

  Future<void> sendMessageAndGetAnswers({required SettingsProvider modelsProvider,required ChatProvider chatProvider}) async {
    if (_isTyping) {
      EasyLoading.showToast("You can't send multiple messages at the same time");
      return;
    }
    if (_textEditingController.text.isEmpty) {
      EasyLoading.showToast('Please type a message');
      return;
    }
    try {
      String msg = _textEditingController.text;
      scrollListToEnd();
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        _textEditingController.clear();
        focusNode.unfocus();
        _animationController.repeat();
      });
      await chatProvider.sendMessageAndGetAnswers(msg: msg, chosenModelId: modelsProvider.model);
      setState(() {
      });
    } catch (error) {
      log("error $error");
      EasyLoading.showError(error.toString());
    } finally {
      setState(() {
        scrollListToEnd();
        _animationController.stop();
        _isTyping = false;
      });
    }
  }
}
