import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'fullscreen_window_platform_interface.dart';

class FullscreenWindow {

  static Future<void> setFullScreen(bool isFullScreen) async {
    if (kIsWeb || Platform.isWindows) {
      FullscreenWindowPlatform.instance.setFullScreen(isFullScreen);
    } else if (Platform.isAndroid || Platform.isIOS) {
      if (isFullScreen) { //OK for Android, fail for windows/web
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      }
    } else {
      log("[fullscren_window] setFullScreen() not support for this platform");
    }
  }

  static Future<Size> getScreenSize(BuildContext? context) async {
    if (kIsWeb || Platform.isWindows) {
      return await FullscreenWindowPlatform.instance.getScreenSize(context);
    } else if (Platform.isAndroid || Platform.isIOS) {
      if (context != null) {
        throw UnsupportedError("context must not be null here in Android/iOS");
      }
      var data = context!.findAncestorWidgetOfExactType<MediaQuery>()!.data;
      return data.size;
    } else {
      throw UnsupportedError("[fullscren_window] getScreenSize() not support for this platform");
    } 
  }

}
