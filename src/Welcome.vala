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

public class Unboxing.Welcome : Gtk.ApplicationWindow {

    public Welcome (Gtk.Application application) {
        Object (
            application: application,
            icon_name: "io.github.teamcons.unboxing",
            title: _("Install Untrusted Package")
        );
    }

    construct {
        var view = new Gtk.Box (VERTICAL, 0);
        var placeholder = new Granite.Placeholder (title);

        var select = placeholder.append_button (
            new ThemedIcon ("document-open"),
            _("Open"),
            _("Browse to open a single file"));

            // TODO: Load from Downloads

        var window_handle = new Gtk.WindowHandle () {
            child = view
        };

    }


    public void on_open_document () {
        var all_files_filter = new Gtk.FileFilter () {
            name = _("All files"),
        };
        all_files_filter.add_pattern ("*");

        var deb_filter = new Gtk.FileFilter () {
            name = _("Deb packages"),
        };

        foreach (var mimetype in Application.SUPPORTED_CONTENT_TYPES) {
            deb_filter.add_mime_type (mimetype);
        }

        var filter_model = new ListStore (typeof (Gtk.FileFilter));
        filter_model.append (all_files_filter);
        filter_model.append (deb_filter);

        var open_dialog = new Gtk.FileDialog () {
            default_filter = deb_filter,
            filters = filter_model,
            title = _("Open"),
            modal = true
        };

        open_dialog.open.begin (this, null, (obj, res) => {
            try {
                var file = open_dialog.open.end (res);
                application.open ({file}, _("Package"));

            } catch (Error err) {
                warning ("Failed to select file to open: %s", err.message);
            }
        });
    }

}
