import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fullscreen_window_platform_interface.dart';

/// An implementation of [FullscreenWindowPlatform] that uses method channels.
class MethodChannelFullscreenWindow extends FullscreenWindowPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fullscreen_window');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
