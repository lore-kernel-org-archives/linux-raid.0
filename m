From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/4] mdadm.8: fix possible typos
Date: Wed, 22 Jun 2011 01:19:04 +0900
Message-ID: <1308673145-8151-3-git-send-email-namhyung@gmail.com>
References: <1308673145-8151-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308673145-8151-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Fix random typos and add a few of missing words/macros.
Also update RAID website URL as it is not accessible anymore.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mdadm.8.in |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index d56cd98..5eee54a 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1496,7 +1496,7 @@ the first device given is the md device.
 In the second usage example, all devices listed are treated as md
 devices and assembly is attempted.
 In the third (where no devices are listed) all md devices that are
-listed in the configuration file are assembled.  If not arrays are
+listed in the configuration file are assembled.  If no arrays are
 described by the configuration file, then any arrays that
 can be found on unused devices will be assembled.
 
@@ -1605,7 +1605,7 @@ and no devices are listed,
 will first attempt to assemble all the arrays listed in the config
 file.
 
-In no array at listed in the config (other than those marked
+If no arrays are listed in the config (other than those marked
 .BR <ignore> )
 it will look through the available devices for possible arrays and
 will try to assemble anything that it finds.  Arrays which are tagged
@@ -2205,11 +2205,11 @@ change the "size" attribute for RAID1, RAID4, RAID5 and RAID6.
 .IP \(bu 4
 increase or decrease the "raid\-devices" attribute of RAID0, RAID1, RAID4,
 RAID5, and RAID6.
-.IP \bu 4
+.IP \(bu 4
 change the chunk-size and layout of RAID0, RAID4, RAID5 and RAID6.
-.IP \bu 4
+.IP \(bu 4
 convert between RAID1 and RAID5, between RAID5 and RAID6, between
-RAID0, RAID5, and RAID5, and between RAID0 and RAID10 (in the near-2 mode).
+RAID0, RAID4, and RAID5, and between RAID0 and RAID10 (in the near-2 mode).
 .IP \(bu 4
 add a write-intent bitmap to any array which supports these bitmaps, or
 remove a write-intent bitmap from such an array.
@@ -2255,7 +2255,7 @@ space to start being used.  If the size is increased in this way, a
 are synchronised.
 
 Note that when an array changes size, any filesystem that may be
-stored in the array will not automatically grow for shrink to use or
+stored in the array will not automatically grow or shrink to use or
 vacate the space.  The
 filesystem will need to be explicitly told to use the extra space
 after growing, or to reduce its size
@@ -2264,7 +2264,7 @@ to shrinking the array.
 
 Also the size of an array cannot be changed while it has an active
 bitmap.  If an array has a bitmap, it must be removed before the size
-can be changed. Once the change it complete a new bitmap can be created.
+can be changed. Once the change is complete a new bitmap can be created.
 
 .SS RAID\-DEVICES CHANGES
 
@@ -2440,7 +2440,7 @@ must match one of the names or patterns in a
 line.
 
 .IP +
-Does the device have a valid md superblock.  If a specific metadata
+Does the device have a valid md superblock?  If a specific metadata
 version is request with
 .B \-\-metadata
 or
@@ -2472,6 +2472,7 @@ is not able to positively identify the array as belonging to the
 current host, the device will be rejected.
 ..
 
+.PP
 .I mdadm
 keeps a list of arrays that it has partially assembled in
 .B /var/run/mdadm/map
@@ -2644,7 +2645,7 @@ can be started.
 Any devices which are components of /dev/md4 will be marked as faulty
 and then remove from the array.
 
-.B "  mdadm --grow /dev/md4 --level=6 --backup-file=/root/backup-md4
+.B "  mdadm --grow /dev/md4 --level=6 --backup-file=/root/backup-md4"
 .br
 The array
 .B /dev/md4
@@ -2792,7 +2793,7 @@ configuration file at all.
 For further information on mdadm usage, MD and the various levels of
 RAID, see:
 .IP
-.B http://linux\-raid.osdl.org/
+.B http://raid.wiki.kernel.org/
 .PP
 (based upon Jakob \(/Ostergaard's Software\-RAID.HOWTO)
 .\".PP
-- 
1.7.5.2

