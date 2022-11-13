
import 'fullscreen_window_platform_interface.dart';

class FullscreenWindow {
  Future<String?> getPlatformVersion() {
    return FullscreenWindowPlatform.instance.getPlatformVersion();
  }
}
