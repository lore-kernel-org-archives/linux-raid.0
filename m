From: Andre Majorel <aym-xunil@teaser.fr>
Subject: Man page patch (manage mode options clarification)
Date: Sun, 14 Jan 2007 21:21:29 +0100
Message-ID: <20070114202129.GA27074@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

This one is more debatable than the previous one. It attempts to
clarify the synopses of the manage mode options.

Those options take arguments so make that evident in the synopses.

I'm not entirely sure about the wording. Comments welcome. Is it
clearer than what we have now ?

Before :

  For Manage mode:
     -a, --add
            hot-add listed devices.

     --re-add
            re-add a device that was recently removed from an array.

     -r, --remove
            remove  listed  devices.  They must not be active.  i.e.
            they should be failed or spare devices.

     -f, --fail
            mark listed devices as faulty.

     --set-faulty
            same as --fail.

After :

  For Manage mode:
     -a, --add [component-device ...]
            Hot-add  its  arguments to raid-device.  If no arguments
            are given, this option is a no-op.

     --re-add [component-device ...]
            Re-add its arguments to raid-device.  The arguments must
            be  devices  that  were recently removed from the array.
            If no arguments are given, this option is a no-op.

     -r, --remove [component-device ...]
            Remove its arguments from  raid-device.   The  arguments
            must  not be active, i.e. they should be failed or spare
            devices.  If no arguments are given, this  option  is  a
            no-op.

     -f, --fail [component-device ...]
            Mark  its  arguments  as  faulty.   If  no arguments are
            given, this option is a no-op.

     --set-faulty [component-device ...]
            Same as --fail.

-- 
André Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-2.6-man2.diff"

diff -ur mdadm-2.6-man1/mdadm.8 mdadm-2.6-man2/mdadm.8
--- mdadm-2.6-man1/mdadm.8	2007-01-14 14:50:25.000000000 +0100
+++ mdadm-2.6-man2/mdadm.8	2007-01-14 15:19:07.000000000 +0100
@@ -13,7 +13,7 @@
 
 .SH SYNOPSIS
 
-.BI mdadm " [mode] <raiddevice> [options] <component-devices>"
+.BI mdadm " [mode] <raid-device> [options] <component-devices>"
 
 .SH DESCRIPTION
 RAID devices are virtual devices created from two or more
@@ -836,25 +836,30 @@
 .SH For Manage mode:
 
 .TP
-.BR -a ", " --add
-hot-add listed devices.
+\fB\-a\fP, \fB\-\-add\fP [\fIcomponent-device\fP ...]
+Hot-add its arguments to \fIraid-device\fP.
+If no arguments are given, this option is a no-op.
 
 .TP
-.BR --re-add
-re-add a device that was recently removed from an array.
+\fB\-\-re\-add\fP [\fIcomponent-device\fP ...]
+Re-add its arguments to \fIraid-device\fP.
+The arguments must be devices that were recently removed from the array.
+If no arguments are given, this option is a no-op.
 
 .TP
-.BR -r ", " --remove
-remove listed devices.  They must not be active.  i.e. they should
-be failed or spare devices.
+\fB\-r\fP, \fB\-\-remove\fP [\fIcomponent-device\fP ...]
+Remove its arguments from \fIraid-device\fP.
+The arguments must not be active, i.e. they should be failed or spare devices.
+If no arguments are given, this option is a no-op.
 
 .TP
-.BR -f ", " --fail
-mark listed devices as faulty.
+\fB\-f\fP, \fB\-\-fail\fP [\fIcomponent-device\fP ...]
+Mark its arguments as faulty.
+If no arguments are given, this option is a no-op.
 
 .TP
-.BR --set-faulty
-same as --fail.
+\fB\-\-set\-faulty\fP [\fIcomponent-device\fP ...]
+Same as \fB\-\-fail\fP.
 
 .P
 Each of these options require that the first device list is the array

--h31gzZEtNLTqOjlF--
