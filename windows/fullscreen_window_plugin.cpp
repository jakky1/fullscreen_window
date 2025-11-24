#include "fullscreen_window_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

struct
{
    bool fullscreen;
    bool maximized;
    LONG style;
    LONG ex_style;
    RECT window_rect;
    WINDOWPLACEMENT placement;
} g_saved_window_info;
void setFullScreen(HWND hwnd, bool fullscreen)
{
    if (!g_saved_window_info.fullscreen) {
        g_saved_window_info.maximized = !!IsZoomed(hwnd);
        g_saved_window_info.style = GetWindowLong(hwnd, GWL_STYLE);
        g_saved_window_info.ex_style = GetWindowLong(hwnd, GWL_EXSTYLE);
        GetWindowPlacement(hwnd, &g_saved_window_info.placement);
    }

    g_saved_window_info.fullscreen = fullscreen;

    if (fullscreen) {
        SetWindowLong(hwnd, GWL_STYLE,
            g_saved_window_info.style & ~(WS_CAPTION | WS_THICKFRAME | WS_MAXIMIZE));
        SetWindowLong(hwnd, GWL_EXSTYLE,
            g_saved_window_info.ex_style | WS_EX_TOPMOST & ~(WS_EX_DLGMODALFRAME |
                WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE));

        SendMessage(hwnd, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    }
    else {
        if (!g_saved_window_info.maximized) SendMessage(hwnd, WM_SYSCOMMAND, SC_RESTORE, 0);
        SetWindowLong(hwnd, GWL_STYLE, g_saved_window_info.style);
        SetWindowLong(hwnd, GWL_EXSTYLE, g_saved_window_info.ex_style);
        SetWindowPlacement(hwnd, &g_saved_window_info.placement);

        // NOTE: flutter layout is not correct after exit fullscreen, so we change window size to force re-layout
        // but sometimes it still has layout issues...
        RECT bounds;
        GetWindowRect(hwnd, &bounds);
        SetWindowPos(hwnd, 0, bounds.left, bounds.top, bounds.right - bounds.left, bounds.bottom - bounds.top, SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
    }
}


namespace fullscreen_window {

// static
void FullscreenWindowPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "fullscreen_window",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FullscreenWindowPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  // Jacky {
  plugin->m_registrar = registrar;
  plugin->m_NativeHWND = registrar->GetView()->GetNativeWindow();
  // Jacky }

  registrar->AddPlugin(std::move(plugin));
}

FullscreenWindowPlugin::FullscreenWindowPlugin() {}

FullscreenWindowPlugin::~FullscreenWindowPlugin() {}

void FullscreenWindowPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

  flutter::EncodableMap arguments = std::get<flutter::EncodableMap>(*method_call.arguments());

  if (method_call.method_name().compare("setFullScreen") == 0) {
    auto isFullScreen = std::get<bool>(arguments[flutter::EncodableValue("isFullScreen")]);
    auto hwnd = GetAncestor(m_NativeHWND, GA_ROOT);
    setFullScreen(hwnd, isFullScreen);
    result->Success();
  } else if (method_call.method_name().compare("getScreenSize") == 0) {
    RECT bounds = {0};      
    GetWindowRect(GetDesktopWindow(), &bounds);

    flutter::EncodableMap map;
    map[flutter::EncodableValue("width")] = flutter::EncodableValue((int32_t)bounds.right);
    map[flutter::EncodableValue("height")] = flutter::EncodableValue((int32_t)bounds.bottom);
    result->Success(flutter::EncodableValue(map));
  } else {
    result->NotImplemented();
  }
}

}  // namespace fullscreen_window
