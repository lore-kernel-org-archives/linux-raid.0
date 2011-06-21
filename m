From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/4] mdadm.8: move description of --add under Grow mode
Date: Wed, 22 Jun 2011 01:19:03 +0900
Message-ID: <1308673145-8151-2-git-send-email-namhyung@gmail.com>
References: <1308673145-8151-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308673145-8151-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It is supposed to be under Grow mode. Since Create/Build/Grow modes
use common options and '-a' is already used for '--auto' in Create/
Build modes, describe it to avoid confusion.
---
 mdadm.8.in |   49 +++++++++++++++++++++++++++----------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 44accc0..d56cd98 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -811,6 +811,11 @@ number, and there is no entry in /dev for that number and with a
 non-standard name.  Names that are not in 'standard' format are only
 allowed in "/dev/md/".
 
+This is meaningful with
+.B \-\-create
+or
+.BR \-\-build .
+
 .ig XX
 .\".TP
 .\".BR \-\-symlink = no
@@ -835,6 +840,28 @@ allowed in "/dev/md/".
 .\"
 .XX
 
+.TP
+.BR \-a ", " "\-\-add"
+This option can be used in Grow mode in two cases.
+
+If the target array is a Linear array, then
+.B \-\-add
+can be used to add one or more devices to the array.  They
+are simply catenated on to the end of the array.  Once added, the
+devices cannot be removed.
+
+If the
+.B \-\-raid\-disks
+option is being used to increase the number of devices in an array,
+then
+.B \-\-add
+can be used to add some extra devices to be included in the array.
+In most cases this is not needed as the extra devices can be added as
+spares first, and then the number of raid-disks can be changed.
+However for RAID0, it is not possible to add spares.  So to increase
+the number of devices in a RAID0, it is necessary to set the new
+number of devices, and to add the new devices, in the same command.
+
 .SH For assemble:
 
 .TP
@@ -912,28 +939,6 @@ not as reliable as you would like.
 See this option under Create and Build options.
 
 .TP
-.BR \-a ", " "\-\-add"
-This option can be used in Grow mode in two cases.
-
-If the target array is a Linear array, then
-.B \-\-add
-can be used to add one or more devices to the array.  They
-are simply catenated on to the end of the array.  Once added, the
-devices cannot be removed.
-
-If the
-.B \-\-raid\-disks
-option is being used to increase the number of devices in an array,
-then
-.B \-\-add
-can be used to add some extra devices to be included in the array.
-In most cases this is not needed as the extra devices can be added as
-spares first, and then the number of raid-disks can be changed.
-However for RAID0, it is not possible to add spares.  So to increase
-the number of devices in a RAID0, it is necessary to set the new
-number of devices, and to add the new devices, in the same command.
-
-.TP
 .BR \-b ", " \-\-bitmap=
 Specify the bitmap file that was given when the array was created.  If
 an array has an
-- 
1.7.5.2

