import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/pages/chat_page.dart';
import 'package:flutter_chatgpt/pages/setting_page.dart';
import 'package:flutter_chatgpt/providers/chats_provider.dart';
import 'package:flutter_chatgpt/providers/settings_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';

Future<void> main(List<String> args) async {
  // if (Platform.isMacOS) {
  //   runApp(const MacApp());
  // } else {
  //   runApp(const App());
  // }
  runApp(const App());
  // configLoading();
}

class MacApp extends StatelessWidget {
  const MacApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'ChatGPT',
      theme: MacosThemeData(brightness: Brightness.dark, canvasColor: scaffoldBackgroundColor),
      darkTheme: MacosThemeData(brightness: Brightness.dark, canvasColor: scaffoldBackgroundColor),
      themeMode: ThemeMode.system,
      home: const MacosMainView(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class MacosMainView extends StatefulWidget {
  const MacosMainView({super.key});

  @override
  State<MacosMainView> createState() => _MacosMainViewState();
}

class _MacosMainViewState extends State<MacosMainView> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MacosWindow(
        child: MacosScaffold(
          backgroundColor: cardColor,
          toolBar: ToolBar(
            dividerColor: scaffoldBackgroundColor,
            padding: const EdgeInsets.fromLTRB(80,5,5,5),
            title: const Text('ChatGPT'),
            actions: [
              ToolBarIconButton(
                label: 'Chosen Model',
                icon: const MacosIcon(CupertinoIcons.ellipsis_circle),
                showLabel: false,
                tooltipMessage: 'Chosen Model',
                onPressed: () async {
                  await SettingsPage.showModalSheet(context: context);
                },
              )
            ],
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return const ChatPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}


class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter ChatGPT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: cardColor,
            cardColor: cardColor,
            appBarTheme: AppBarTheme(
              color: scaffoldBackgroundColor,
            )),
        home: const ChatPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 3000)
//     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//     ..loadingStyle = EasyLoadingStyle.dark
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..textColor = Colors.white
//     ..userInteractions = true
//     ..toastPosition = EasyLoadingToastPosition.bottom
//     ..dismissOnTap = false;
// }
