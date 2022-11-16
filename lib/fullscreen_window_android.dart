import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'fullscreen_window_platform_interface.dart';

class FullScreenWindowAndroid extends FullScreenWindowPlatform {
  FullScreenWindowAndroid();

  static void registerWith() {
    FullScreenWindowPlatform.instance = FullScreenWindowAndroid();
  }

  @override
  Future<void> setFullScreen(bool isFullScreen) async {
    if (isFullScreen) { //OK for Android, fail for windows/web
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    }
  }

  @override
  Future<Size> getScreenSize(BuildContext? context) async {
    if (context == null) {
      throw UnsupportedError("context must not be null here in Android/iOS");
    }
    var data = context.findAncestorWidgetOfExactType<MediaQuery>()!.data;
    return data.size;
  }

}
