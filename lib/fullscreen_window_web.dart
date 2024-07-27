// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web show window;

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'fullscreen_window_platform_interface.dart';

/// A web implementation of the FullscreenWindowPlatform of the FullscreenWindow plugin.
class FullScreenWindowWeb extends FullScreenWindowPlatform {
  /// Constructs a FullscreenWindowWeb
  FullScreenWindowWeb();

  static void registerWith(Registrar registrar) {
    FullScreenWindowPlatform.instance = FullScreenWindowWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<void> setFullScreen(bool isFullScreen) async {
    if (isFullScreen) {
      web.window.document.documentElement?.requestFullscreen();
    } else {
      web.window.document.exitFullscreen();
    }
  }

  @override
  Future<Size> getScreenSize(BuildContext? context) async {
    var width = web.window.screen.width;
    var height = web.window.screen.height;
    return Size(width.toDouble(), height.toDouble());
  }

}
