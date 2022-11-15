import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fullscreen_window_method_channel.dart';

abstract class FullscreenWindowPlatform extends PlatformInterface {
  /// Constructs a FullscreenWindowPlatform.
  FullscreenWindowPlatform() : super(token: _token);

  static final Object _token = Object();

  static FullscreenWindowPlatform _instance = MethodChannelFullscreenWindow();

  /// The default instance of [FullscreenWindowPlatform] to use.
  ///
  /// Defaults to [MethodChannelFullscreenWindow].
  static FullscreenWindowPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FullscreenWindowPlatform] when
  /// they register themselves.
  static set instance(FullscreenWindowPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setFullScreen_(bool isFullScreen) {
    throw UnimplementedError();
  }

  Future<Size> getScreenSize_(BuildContext? context) {
    throw UnimplementedError();
  }

}
