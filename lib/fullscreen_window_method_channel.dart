import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'fullscreen_window_platform_interface.dart';

/// An implementation of [FullScreenWindowPlatform] that uses method channels.
class MethodChannelFullscreenWindow extends FullScreenWindowPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fullscreen_window');

  @override
  Future<void> setFullScreen(bool isFullScreen) async {
    await methodChannel.invokeMethod<void>('setFullScreen', { "isFullScreen": isFullScreen });
  }

  @override
  Future<Size> getScreenSize(BuildContext? context) async {
    double devicePixelRatio = 1.0;
    if (context != null) {
      var data = context.findAncestorWidgetOfExactType<MediaQuery>()?.data;
      if (data != null) {
        devicePixelRatio = data.devicePixelRatio;
      }
    }

    var map = await methodChannel.invokeMethod<Map>('getScreenSize', {});
    int width = map!["width"];
    int height = map["height"];

    var size = Size(width.toDouble() / devicePixelRatio, height.toDouble() / devicePixelRatio);
    return size;
  }

}
