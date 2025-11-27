/*
 * Copyright 2019–2022 elementary, Inc. (https://elementary.io)
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
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

public class Unboxing.SuccessView : AbstractView {

    public string? app_name { get; construct; }

    public SuccessView (string? app_name) {
        Object (
            app_name: app_name
        );
    }

    construct {
        badge.gicon = new ThemedIcon ("process-completed");

        var app = (Unboxing.Application) GLib.Application.get_default ();
        var file = ((Unboxing.MainWindow) app.active_window).file;
        //string? secondary_label_string;

        primary_label.label = _("“%s” has been installed").printf (app_name);

        //secondary_label_string = _("Open it any time from the Applications Menu.");
        //secondary_label.label = secondary_label_string;

        var trash_check = new Gtk.CheckButton.with_label (_("Move ”%s” to Trash").printf (file.get_basename ()));
        content_area.attach (trash_check, 0, 0);

        var settings = new Settings ("io.github.teamcons.unboxing");
        settings.bind ("trash-on-success", trash_check, "active", GLib.SettingsBindFlags.DEFAULT);

        var close_button = new Gtk.Button.with_label (_("Close"));

        //var open_button = new Gtk.Button.with_label (_("Open App"));
        //open_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);

        button_box.append (close_button);
        //button_box.append (open_button);

        ((Unboxing.MainWindow) app.active_window).default_widget = close_button;

        close_button.clicked.connect (() => {
            if (trash_check.active) {
                Utils.trash_files ({file});
            }

            app.quit ();
        });

        //  open_button.clicked.connect (() => {
        //      if (trash_check.active) {
        //          trash_file (files);
        //      }

        //      app.activate_action ("launch", null);
        //  });
    }
}
