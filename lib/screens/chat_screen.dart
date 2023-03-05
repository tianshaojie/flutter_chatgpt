import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/constants/constants.dart';
import 'package:flutter_chatgpt/providers/chats_provider.dart';
import 'package:flutter_chatgpt/screens/rotating_image_widget.dart';
import 'package:flutter_chatgpt/services/services.dart';
import 'package:flutter_chatgpt/widgets/chat_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../services/assets_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  bool _isTyping = false;

  late TextEditingController _textEditingController;
  late ScrollController _listScrollController;
  late AnimationController _animationController;
  late FocusNode focusNode;
  @override
  void initState() {
    _listScrollController = ScrollController();
    _textEditingController = TextEditingController();
    _animationController = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
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
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 2,
        // leading: Padding(
        //   padding: EdgeInsets.only(left: 30.0),
        //   child: RotatingImage(
        //     imagePath: AssetsManager.openaiLogo,
        //     size: 10.0,
        //     animationController: _animationController,
        //   ),
        // ),
        // title: const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Text(
        //     "Your OpenAI's ChatGPT",
        //     maxLines: 1,
        //     textAlign: TextAlign.center,
        //     style: TextStyle(fontSize: 18),
        //   ),
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotatingImage(
              imagePath: AssetsManager.openaiLogo,
              size: 25.0,
              animationController: _animationController,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "ChatGPT Flutter App",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
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
                  }),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: _textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.grey,
                        ))
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

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider,required ChatProvider chatProvider}) async {
    if (_isTyping) {
      EasyLoading.showToast('You cant send multiple messages at a time');
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
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        _textEditingController.clear();
        focusNode.unfocus();
        _animationController.repeat();
      });
      await chatProvider.sendMessageAndGetAnswers(msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
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
