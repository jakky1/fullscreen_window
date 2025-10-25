#include "include/fullscreen_window/fullscreen_window_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "fullscreen_window_plugin_private.h"

#define FULLSCREEN_WINDOW_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), fullscreen_window_plugin_get_type(), \
                              FullscreenWindowPlugin))

struct _FullscreenWindowPlugin {
  GObject parent_instance;

  FlPluginRegistrar *registrar; //Jacky  
};

G_DEFINE_TYPE(FullscreenWindowPlugin, fullscreen_window_plugin, g_object_get_type())

// --------------------------------------------------------------------------

GtkWindow* get_window(FullscreenWindowPlugin* self) {
  FlView* view = fl_plugin_registrar_get_view(self->registrar);
  if (view == nullptr)
    return nullptr;

  return GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

FlMethodResponse* getScreenSize() {
  GdkDisplay *display = gdk_display_get_default();
  GdkMonitor *monitor = gdk_display_get_primary_monitor(display);
  GdkRectangle geometry;
  gdk_monitor_get_geometry(monitor, &geometry);

  int width = geometry.width;
  int height = geometry.height;

  g_autoptr(FlValue) result_data = fl_value_new_map();
  fl_value_set_string_take(result_data, "width", fl_value_new_int(width));
  fl_value_set_string_take(result_data, "height", fl_value_new_int(height));

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result_data));
}

// --------------------------------------------------------------------------

// Called when a method call is received from Flutter.
static void fullscreen_window_plugin_handle_method_call(
    FullscreenWindowPlugin* self,
    FlMethodCall* method_call) {

  g_autoptr(FlMethodResponse) response = nullptr;
  const gchar* method = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);

  if (strcmp(method, "setFullScreen") == 0) {
    bool isFullScreen = fl_value_get_bool(fl_value_lookup_string(args, "isFullScreen"));
    if (isFullScreen) {
      gtk_window_fullscreen(get_window(self));
    } else {
      gtk_window_unfullscreen(get_window(self));
    }

    g_autoptr(FlValue) result = fl_value_new_bool(true);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if (strcmp(method, "getScreenSize") == 0) {
    response = getScreenSize();
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void fullscreen_window_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(fullscreen_window_plugin_parent_class)->dispose(object);
}

static void fullscreen_window_plugin_class_init(FullscreenWindowPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = fullscreen_window_plugin_dispose;
}

static void fullscreen_window_plugin_init(FullscreenWindowPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FullscreenWindowPlugin* plugin = FULLSCREEN_WINDOW_PLUGIN(user_data);
  fullscreen_window_plugin_handle_method_call(plugin, method_call);
}

void fullscreen_window_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FullscreenWindowPlugin* plugin = FULLSCREEN_WINDOW_PLUGIN(
      g_object_new(fullscreen_window_plugin_get_type(), nullptr));

  plugin->registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar)); //Jacky

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "fullscreen_window",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
