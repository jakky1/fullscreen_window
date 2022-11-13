import 'package:flutter/widgets.dart';

import 'fullscreen_window_platform_interface.dart';

class FullscreenWindow {
  static Future<void> setFullScreen(bool isFullScreen) {
    return FullscreenWindowPlatform.instance.setFullScreen(isFullScreen);
  }

  static Future<Size> getScreenSize(BuildContext? context) {
    return FullscreenWindowPlatform.instance.getScreenSize(context);
  }

}
