import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fullscreen_window_method_channel.dart';

abstract class FullScreenWindowPlatform extends PlatformInterface {
  /// Constructs a FullscreenWindowPlatform.
  FullScreenWindowPlatform() : super(token: _token);

  static final Object _token = Object();

  static FullScreenWindowPlatform _instance = MethodChannelFullscreenWindow();

  /// The default instance of [FullScreenWindowPlatform] to use.
  ///
  /// Defaults to [MethodChannelFullscreenWindow].
  static FullScreenWindowPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FullScreenWindowPlatform] when
  /// they register themselves.
  static set instance(FullScreenWindowPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setFullScreen(bool isFullScreen) {
    throw UnimplementedError();
  }

  Future<Size> getScreenSize(BuildContext? context) {
    throw UnimplementedError();
  }

}
