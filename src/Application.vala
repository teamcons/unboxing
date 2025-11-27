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

public class Unboxing.Application : Gtk.Application {

    public const string XDEB = "application/x-deb";
    public const string DEBPKG = "application/vnd.debian.binary-package";
    public const string[] SUPPORTED_CONTENT_TYPES = {
        XDEB,
        DEBPKG
    };

    private Unboxing.MainWindow? main_window;

    public Application () {
        GLib.Intl.setlocale (LocaleCategory.ALL, "");
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
        GLib.Intl.textdomain (GETTEXT_PACKAGE);

        Object (
            application_id: "io.github.teamcons.unboxing",
            flags: ApplicationFlags.HANDLES_OPEN
        );
    }

    protected override void startup () {
        base.startup ();
        Granite.init ();

        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == DARK;

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == DARK;
        });

        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>q"});
        quit_action.activate.connect (quit);
    }

    protected override void activate () {

    }

    public static int main (string[] args) {
        if (args.length < 2) {
            print ("Usage: %s /path/to/flatpakref or /path/to/flatpak\n", args[0]);
            return 1;
        }

        var app = new Application ();
        return app.run (args);
    }

    protected override void open (File[] files, string hint) {
        if (files.length == 0) {
            return;
        }

        if (main_window != null) {
            var dialog = new Granite.MessageDialog.with_image_from_icon_name (_("There Are Ongoing Operations"),
                _("Please wait until all operations are finished"),
                "dialog-warning",
                Gtk.ButtonsType.CLOSE);

            dialog.present ();
            return;
        }

        var file = files[0];

        if (!Utils.is_package (file)) {
            var dialog = new Granite.MessageDialog.with_image_from_icon_name (_("Invalid file"),
                _("%s is not a valid package").printf (file.get_basename ()),
                "dialog-warning",
                Gtk.ButtonsType.CLOSE);

            dialog.present ();
            return;
        }

        hold ();
        main_window = new Unboxing.MainWindow (this, file);
        main_window.present ();
    }
}
