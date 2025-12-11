/*
* Copyright 2021-2022 elementary, Inc. (https://elementary.io)
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

public class Unboxing.Backend : Object {

    private static Backend? instance;

    public static Backend get_instance () {
        if (instance == null) {
            instance = new Backend ();
        }
        return instance;
    }
    
    
    public File[] files { get; private set; }
    public bool busy { get; private set; default = false};

    Pk.Task task = new Pk.Task ();
    Cancellable current_cancellable = null;

    public signal void progress_changed (string status, int percentage);
    public signal void installation_failed (string error_title, string? error_message);
    public signal void installation_succeeded ();

    construct {
        GLib.Application.get_default ().shutdown.connect (() => {
            if (current_cancellable != null) {
                current_cancellable.cancel ();
            }
        });
    }

    public void install (string[] files) {
        busy = true;

        task = new Pk.Task () {
            allow_downgrade = true,
            allow_reinstall = true
        };

        current_cancellable = new Cancellable ();
        task.install_files_async.begin (
                files,
                current_cancellable,
                progress_cb,
                async_cb);
    }

    public void progress_cb (Pk.Progress progress, Pk.ProgressType type) {
        print ("\n" + Utils.status_to_title (progress.status) + "|");
        print ("ROLE: " + progress.get_role ().to_localised_present () + " | ");
        print ("PERCENT: " + progress.percentage.to_string () + " | ");

        var status = Utils.status_to_title (progress.status);

        progress_changed (status, progress.percentage);
    }

    // Delegate
    public void async_cb (Object? object, AsyncResult res)
    {
        print ("\ncb called\n");
        var task = object as Pk.Task;

        try {
            var result = task.install_files_async.end (res);
            print (result.role.to_localised_present () + "|");
            print (result.get_exit_code ().to_string () + "|");
            print (" Finished lol \n");
            installation_succeeded ();
        }
        catch (Error e)
        {
            print (e.domain.to_string ());
            print (e.message);

            string? title = "yoy";

            print (((Pk.Error)e).get_details ());

            installation_failed (title ?? _("Unknown error"), e.message ?? _("An unknown error occurred."));
        }

        busy = false;
    }
}
