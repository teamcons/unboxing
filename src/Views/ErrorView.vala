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
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

public class Unboxing.ErrorView : AbstractView {
    public string error_title { get; construct; }
    public string error_message { get; construct; }

    public ErrorView (string error_title, string error_message) {
        Object (
            error_title: error_title,
            error_message: error_message
        );
    }

    construct {
        badge.gicon = new ThemedIcon ("dialog-error");

        primary_label.label = _("Installation failed");
        secondary_label.label = error_title;

        var details_view = new Gtk.Label (error_message) {
            selectable = true,
            wrap = true,
            xalign = 0,
            yalign = 0
        };

        var scroll_box = new Gtk.ScrolledWindow () {
            child = details_view,
            margin_top = 12,
            min_content_height = 70
        };
        scroll_box.add_css_class (Granite.STYLE_CLASS_TERMINAL);

        var expander = new Gtk.Expander (_("Details")) {
            child = scroll_box,
            hexpand = true
        };

        var close_button = new Gtk.Button.with_label (_("Close")) {
            action_name = "app.quit"
        };

        content_area.attach (expander, 0, 0);
        button_box.append (close_button);
    }
}
