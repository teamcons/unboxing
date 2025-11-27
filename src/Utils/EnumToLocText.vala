/*
* SPDX-License-Identifier: GPL-3.0-or-later
* SPDX-FileCopyrightText: {{YEAR}} {{DEVELOPER_NAME}} <{{DEVELOPER_EMAIL}}>
*/

namespace Unboxing.Utils {

    public static unowned string status_to_title (Pk.Status status) {
        // From https://github.com/elementary/appcenter/blob/master/src/Core/ChangeInformation.vala#L51
        switch (status) {
            case Pk.Status.SETUP:
                return _("Starting");
            case Pk.Status.WAIT:
                return _("Waiting");
            case Pk.Status.RUNNING:
                return _("Running");
            case Pk.Status.QUERY:
                return _("Querying");
            case Pk.Status.INFO:
                return _("Getting information");
            case Pk.Status.REMOVE:
                return _("Removing packages");
            case Pk.Status.DOWNLOAD:
                return _("Downloading");
            case Pk.Status.REFRESH_CACHE:
                return _("Refreshing software list");
            case Pk.Status.UPDATE:
                return _("Installing updates");
            case Pk.Status.CLEANUP:
                return _("Cleaning up packages");
            case Pk.Status.OBSOLETE:
                return _("Obsoleting packages");
            case Pk.Status.DEP_RESOLVE:
                return _("Resolving dependencies");
            case Pk.Status.SIG_CHECK:
                return _("Checking signatures");
            case Pk.Status.TEST_COMMIT:
                return _("Testing changes");
            case Pk.Status.COMMIT:
                return _("Committing changes");
            case Pk.Status.REQUEST:
                return _("Requesting data");
            case Pk.Status.FINISHED:
                return _("Finished");
            case Pk.Status.CANCEL:
                return _("Cancelling");
            case Pk.Status.DOWNLOAD_REPOSITORY:
                return _("Downloading repository information");
            case Pk.Status.DOWNLOAD_PACKAGELIST:
                return _("Downloading list of packages");
            case Pk.Status.DOWNLOAD_FILELIST:
                return _("Downloading file lists");
            case Pk.Status.DOWNLOAD_CHANGELOG:
                return _("Downloading lists of changes");
            case Pk.Status.DOWNLOAD_GROUP:
                return _("Downloading groups");
            case Pk.Status.DOWNLOAD_UPDATEINFO:
                return _("Downloading update information");
            case Pk.Status.REPACKAGING:
                return _("Repackaging files");
            case Pk.Status.LOADING_CACHE:
                return _("Loading cache");
            case Pk.Status.SCAN_APPLICATIONS:
                return _("Scanning applications");
            case Pk.Status.GENERATE_PACKAGE_LIST:
                return _("Generating package lists");
            case Pk.Status.WAITING_FOR_LOCK:
                return _("Waiting for package manager lock");
            case Pk.Status.WAITING_FOR_AUTH:
                return _("Waiting for authentication");
            case Pk.Status.SCAN_PROCESS_LIST:
                return _("Updating running applications");
            case Pk.Status.CHECK_EXECUTABLE_FILES:
                return _("Checking applications in use");
            case Pk.Status.CHECK_LIBRARIES:
                return _("Checking libraries in use");
            case Pk.Status.COPY_FILES:
                return _("Copying files");
            case Pk.Status.INSTALL:
            default:
                return _("Installing");
        }
    }

    public static string error_to_title (int code) {
        print (code.to_string ());
        print (Pk.ClientError.FAILED_AUTH.to_string ());

        switch (code) {
            case Pk.ClientError.CANNOT_START_DAEMON:
                return _("Cannot start daemon");
            case Pk.ClientError.DECLINED_INTERACTION:
                return _("Declined interaction");
            case Pk.ClientError.DECLINED_SIMULATION:
                return _("Declined sim");
            case Pk.ClientError.FAILED:
                return _("Failed");
            case Pk.ClientError.FAILED_AUTH:
                return _("Auth fail");
            case Pk.ClientError.INVALID_FILE:
                return _("File bad");
            case Pk.ClientError.INVALID_INPUT:
                return _("Input bad");
            case Pk.ClientError.NOT_SUPPORTED:
                return _("Not supported");
            default:
                return _("idk, client error");
        }
    }
}
