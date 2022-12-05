import 'package:flutter/material.dart';
import 'package:fullscreen_window/fullscreen_window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String screenSizeText = "";

  void setFullScreen(bool isFullScreen) {
    FullScreenWindow.setFullScreen(isFullScreen);
  }

  void showScreenSize(BuildContext context) async {
    Size logicalSize = await FullScreenWindow.getScreenSize(context);
    Size physicalSize = await FullScreenWindow.getScreenSize(null);
    setState(() {
      screenSizeText =
          "Screen size (logical pixel): ${logicalSize.width} x ${logicalSize.height}\n";
      screenSizeText +=
          "Screen size (physical pixel): ${physicalSize.width} x ${physicalSize.height}\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FullScreen example app'),
        ),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ElevatedButton(
              onPressed: () => setFullScreen(true),
              child: const Text("Enter FullScreen"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => setFullScreen(false),
              child: const Text("Exit FullScreen"),
            ),
            const SizedBox(height: 10),
            Builder(
                builder: (context) => ElevatedButton(
                      onPressed: () => showScreenSize(context),
                      child: const Text("Show screen size"),
                    )),
            const SizedBox(height: 10),
            if (screenSizeText.isNotEmpty) Text(screenSizeText),
          ]),
        ),
      ),
    );
  }
}
