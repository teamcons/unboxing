/*
* Copyright 2019-2022 elementary, Inc. (https://elementary.io)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

public class Unboxing.MainWindow : Gtk.ApplicationWindow {

    public string? filepath { get; construct; }

    private Gtk.Stack stack;
    private MainView main_view;
    private ProgressView progress_view;

    Unboxing.Backend backend;

    public string app_id = "io.github.teamcons.unboxing";
    public string app_name = "io.github.teamcons.unboxing";

    public MainWindow (Gtk.Application application, string? filepath) {
        Object (
            application: application,
            icon_name: "io.github.teamcons.unboxing",
            resizable: false,
            title: _("Install Untrusted Package"),
            filepath: filepath
        );
    }

    construct {
        backend = Backend.get_instance ();

        var image = new Gtk.Image.from_icon_name ("io.github.teamcons.unboxing") {
            pixel_size = 48,
            valign = Gtk.Align.START
        };

        main_view = new MainView ();
        stack = new Gtk.Stack () {
            transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
            vhomogeneous = false,
            interpolate_size = true
        };
        stack.add_child (main_view);
        stack.visible_child = main_view;

        var window_handle = new Gtk.WindowHandle () {
            child = stack
        };

        child = window_handle;

        // We need to hide the title area
        var null_title = new Gtk.Grid () {
            visible = false
        };
        set_titlebar (null_title);

        add_css_class ("dialog");
        add_css_class (Granite.STYLE_CLASS_MESSAGE_DIALOG);

        var file = File.new_for_path (filepath);

        if (!Utils.is_package (file)) {
            var title = _("This does not appear to be a valid package file");
            var message = _("%s does not belong to supported mimetypes").printf (file.get_basename ());
            var error_view = new ErrorView (title, message);
            stack.add_child (error_view);
            stack.visible_child = error_view;
            return;
        }

        progress_view = new ProgressView ();
        stack.add_child (progress_view);

        main_view.install_request.connect (on_install_button_clicked);

        backend.progress_changed.connect (on_progress_changed);
        backend.installation_failed.connect (on_install_failed);
        backend.installation_succeeded.connect (on_install_succeeded);
    }

    private void on_install_button_clicked () {
        backend.install ({filepath});
        stack.visible_child = progress_view;

        Granite.Services.Application.set_progress_visible.begin (true);
    }

    private void on_progress_changed (string status, int percentage) {
        progress_view.status = status;
        progress_view.progress = percentage;

        Granite.Services.Application.set_progress.begin (percentage);
    }

    private void on_install_failed (string error_title, string? error_message) {

        var error_view = new ErrorView (error_title, error_message);
        stack.add_child (error_view);
        stack.visible_child = error_view;

        Granite.Services.Application.set_progress_visible.begin (false);
    }

    private void on_install_succeeded () {
        var success_view = new SuccessView (app_name);

        stack.add_child (success_view);
        stack.visible_child = success_view;

        Granite.Services.Application.set_progress_visible.begin (false);

        if (!is_active) {
            var notification = new Notification (_("Package installed"));
            notification.set_body (_("Installed “%s”").printf (app_name));
            application.send_notification ("Installed", notification);
        }
    }
}
