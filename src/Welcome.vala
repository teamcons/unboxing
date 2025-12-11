/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2019-2025 elementary Inc. (https://elementary.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 */

public class Unboxing.Welcome : Gtk.ApplicationWindow {

    public signal void open_this (File file);

    public Welcome (Gtk.Application application) {
        Object (
            application: application,
            icon_name: "io.github.teamcons.unboxing",
            title: _("Install Untrusted Package")
        );
    }

    construct {
        var title_widget = new Gtk.Label (_("Unboxing"));
        title_widget.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);

        var headerbar = new Gtk.HeaderBar () {
            title_widget = title_widget
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        titlebar = headerbar;

        var view = new Gtk.Box (VERTICAL, 0) {
            hexpand = true,
            vexpand = true
        };

        var placeholder = new Granite.Placeholder (_("Install Debian Package")) {
            description = _("Debian packages are a legacy format to distribute applications and system components"),
            icon = new ThemedIcon ("application-vnd.debian.binary-package"),
            vexpand = true,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER
        };

        var scrolled = new Gtk.ScrolledWindow () {
            child = placeholder,
            hscrollbar_policy = Gtk.PolicyType.NEVER
        };

        var select = placeholder.append_button (
            new ThemedIcon ("document-open"),
            _("Select a file to open"),
            _("Browse to open a single file"));

            // TODO: Load from Downloads

        var downloads = Environment.get_user_special_dir (GLib.UserDirectory.DOWNLOAD);
        File[] filelist = {};
        GLib.Dir downloads_content;

        try {
            downloads_content = Dir.open (downloads);
        } catch (Error e) {
            warning ("Cannot read %s: %s\n", downloads, e.message);
        }

        string? item = null;
        while ((item = downloads_content.read_name ()) != null) {
            string path = Path.build_filename (downloads, item);
            File file = File.new_for_path (path);

            if (Utils.is_package (file)) {

                var open_package = placeholder.append_button (
            new ThemedIcon (
                "application-vnd.debian.binary-package"),
            _("Open %s").printf (file.get_basename ()),
                "%s".printf (file.get_path ()));

                open_package.clicked.connect (() => {open_this (file);});
            }
        }

        /* -------- -------- */
        var support_button = new Gtk.LinkButton.with_label ("https://ko-fi.com/teamcons", _("Support us!")) {
            valign = Gtk.Align.END,
            margin_top = 9,
            margin_bottom = 9
        };

        view.append (scrolled);
        view.append (support_button);

        var window_handle = new Gtk.WindowHandle () {
            child = view
        };

        child = window_handle;


        var drop_target = new Gtk.DropTarget (typeof (Gdk.FileList), Gdk.DragAction.COPY);
        ((Gtk.Widget)this).add_controller (drop_target);
        drop_target.drop.connect (on_dropped);


        select.clicked.connect (on_open_document);
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
                open_this (file);

            } catch (Error err) {
                warning ("Failed to select file to open: %s", err.message);
            }
        });
    }

    public bool on_dropped (Gtk.DropTarget target, GLib.Value value, double x, double y) {
        if (value.type () == typeof (Gdk.FileList)) {
            var list = (Gdk.FileList)value;
            File[] file_array = {};

            foreach (unowned var file in list.get_files ()) {
                file_array += file;
            }

            open_this (file_array[0]);
            return true;
        }
        return false;
    }
}
