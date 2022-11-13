#include "include/fullscreen_window/fullscreen_window_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fullscreen_window_plugin.h"

void FullscreenWindowPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fullscreen_window::FullscreenWindowPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
