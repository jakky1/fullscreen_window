// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'fullscreen_window_platform_interface.dart';

/// A web implementation of the FullscreenWindowPlatform of the FullscreenWindow plugin.
class FullscreenWindowWeb extends FullscreenWindowPlatform {
  /// Constructs a FullscreenWindowWeb
  FullscreenWindowWeb();

  static void registerWith(Registrar registrar) {
    FullscreenWindowPlatform.instance = FullscreenWindowWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<void> setFullScreen_(bool isFullscreen) async {
    if (isFullscreen) {
      html.window.document.documentElement?.requestFullscreen();
    } else {
      html.window.document.exitFullscreen();
    }
  }

  @override
  Future<Size> getScreenSize_(BuildContext? context) async {
    var width = html.window.screen?.width ?? 0;
    var height = html.window.screen?.height ?? 0;
    return Size(width.toDouble(), height.toDouble());
  }

}
