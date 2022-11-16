import 'package:flutter_test/flutter_test.dart';
//import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:fullscreen_window/fullscreen_window_platform_interface.dart';
import 'package:fullscreen_window/fullscreen_window_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFullscreenWindowPlatform
    with MockPlatformInterfaceMixin
    //implements FullscreenWindowPlatform 
{
}

void main() {
  final FullScreenWindowPlatform initialPlatform = FullScreenWindowPlatform.instance;

  test('$MethodChannelFullscreenWindow is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFullscreenWindow>());
  });
}
