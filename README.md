# fullscreen_window

![pub version][visits-count-image] 

[visits-count-image]: https://img.shields.io/badge/dynamic/json?label=Visits%20Count&query=value&url=https://api.countapi.xyz/hit/jakky1_fullscren_window/visits

This plugin makes your window fullscreen.



## Platform Support

| Windows | Web | Android | iOS |
| :-----: | :-----: | :-----: | :-----: |
|    ✔️    |    ✔️    |    ✔️    |    ✔️    |

* Web is tested on Chrome / Edge (in Windows)
* Not tested on iOS, but I think it should work because just use the pure Flutter API and works on Android.

## Quick Start

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  fullscreen_window: ^1.0.3
```

Or

```yaml
dependencies:
  fullscreen_window:
    git:
      url: https://github.com/jakky1/fullscreen_window.git
      ref: master
```

### Functions

```
import 'package:fullscreen_window/fullscreen_window.dart';

FullScreenWindow.setFullScreen(true);    // enter fullscreen
FullScreenWindow.setFullScreen(false);   // exit fullscreen
Size screen_logical_size = await FullScreenWindow.getScreenSize(context);
Size screen_physical_size = await FullScreenWindow.getScreenSize(null);
```

### Example

```
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
      screenSizeText = "Screen size (logical pixel): ${logicalSize.width} x ${logicalSize.height}\n";
      screenSizeText += "Screen size (physical pixel): ${physicalSize.width} x ${physicalSize.height}\n";
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Builder(builder: (context) => ElevatedButton(
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
```