//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <fullscreen_window/fullscreen_window_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) fullscreen_window_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FullscreenWindowPlugin");
  fullscreen_window_plugin_register_with_registrar(fullscreen_window_registrar);
}
