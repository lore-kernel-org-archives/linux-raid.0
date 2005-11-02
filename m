From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 010 of 10] Document sysfs usage of md, and make a couple of small refinements.
Date: Wed, 2 Nov 2005 21:16:03 +1100
Message-ID: <1051102101603.23981@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-raid.ids


Document in Documentation/md.txt the files that now appear in sysfs,
and make a couple of small refinements to exactly when 'level' and
'raid_disks' are empty, to make it match the documentation.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |  119 +++++++++++++++++++++++++++++++++++++++++++++++++
 ./drivers/md/md.c      |    4 +
 2 files changed, 122 insertions(+), 1 deletion(-)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-11-02 17:32:28.000000000 +1100
+++ ./Documentation/md.txt	2005-11-02 17:33:38.000000000 +1100
@@ -116,3 +116,122 @@ and it's role in the array.
 
 Once started with RUN_ARRAY, uninitialized spares can be added with
 HOT_ADD_DISK.
+
+
+
+MD devices in sysfs
+-------------------
+md devices appear in sysfs (/sys) as regular block devices,
+e.g.
+   /sys/block/md0
+
+Each 'md' device will contain a subdirectory called 'md' which
+contains further md-specific information about the device.
+
+All md devices contain:
+  level
+     a text file indicating the 'raid level'.  This may be a standard
+     numerical level prefixed by "RAID-" - e.g. "RAID-5", or some
+     other name such as "linear" or "multipath".
+     If no raid level has been set yet (array is still being
+     assembled), this file will be empty.
+
+  raid_disks
+     a text file with a simple number indicating the number of devices
+     in a fully functional array.  If this is not yet known, the file
+     will be empty.  If an array is being resized (not currently
+     possible) this will contain the larger of the old and new sizes.
+
+As component devices are added to an md array, they appear in the 'md'
+directory as new directories named
+      dev-XXX
+where XXX is a name that the kernel knows for the device, e.g. hdb1.
+Each directory contains:
+
+      block
+        a symlink to the block device in /sys/block, e.g.
+	     /sys/block/md0/md/dev-hdb1/block -> ../../../../block/hdb/hdb1
+
+      super
+        A file containing an image of the superblock read from, or
+        written to, that device.
+
+      state
+        A file recording the current state of the device in the array
+	which can be a comma separated list of
+	      faulty   - device has been kicked from active use due to
+                         a detected fault
+	      in_sync  - device is a fully in-sync member of the array
+	      spare    - device is working, but not a full member.
+			 This includes spares that are in the process
+			 of being recoverred to
+	This list make grow in future.
+
+
+An active md device will also contain and entry for each active device
+in the array.  These are named
+
+    rdNN
+
+where 'NN' is the possition in the array, starting from 0.
+So for a 3 drive array there will be rd0, rd1, rd2.
+These are symbolic links to the appropriate 'dev-XXX' entry.
+Thus, for example,
+       cat /sys/block/md*/md/rd*/state
+will show 'in_sync' on every line.
+
+
+
+Active md devices for levels that support data redundancy (1,4,5,6)
+also have
+
+   sync_action
+     a text file that can be used to monitor and control the rebuild
+     process.  It contains one word which can be one of:
+       resync        - redundancy is being recalculated after unclean
+                       shutdown or creation
+       recover       - a hot spare is being built to replace a
+                       failed/missing device
+       idle          - nothing is happening
+       check         - A full check of redundancy was requested and is
+                       happening.  This reads all block and checks
+                       them. A repair may also happen for some raid
+                       levels.
+       repair        - A full check and repair is happening.  This is
+                       similar to 'resync', but was requested by the
+                       user, and the write-intent bitmap is NOT used to
+		       optimise the process.
+
+      This file is writable, and each of the strings that could be
+      read are meaningful for writing.
+
+       'idle' will stop an active resync/recovery etc.  There is no
+           guarantee that another resync/recovery may not be automatically
+	   started again, though some event will be needed to trigger
+           this.
+	'resync' or 'recovery' can be used to restart the
+           corresponding operation if it was stopped with 'idle'.
+	'check' and 'repair' will start the appropriate process
+           providing the current state is 'idle'.
+
+   mismatch_count
+      When performing 'check' and 'repair', and possibly when
+      performing 'resync', md will count the number of errors that are
+      found.  The count in 'mismatch_cnt' is the number of sectors
+      that were re-written, or (for 'check') would have been
+      re-written.  As most raid levels work in units of pages rather
+      than sectors, this my be larger than the number of actual errors
+      by a factor of the number of sectors in a page.
+
+Each active md device may also have attributes specific to the
+personality module that manages it.
+These are specific to the implementation of the module and could
+change substantially if the implementation changes.
+
+These currently include
+
+  stripe_cache_size  (currently raid5 only)
+      number of entries in the stripe cache.  This is writable, but
+      there are upper and lower limits (32768, 16).  Default is 128.
+  strip_cache_active (currently raid5 only)
+      number of active entries in the stripe cache

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-02 17:33:35.000000000 +1100
+++ ./drivers/md/md.c	2005-11-02 17:33:38.000000000 +1100
@@ -1727,7 +1727,7 @@ static ssize_t
 level_show(mddev_t *mddev, char *page)
 {
 	mdk_personality_t *p = mddev->pers;
-	if (p == NULL)
+	if (p == NULL && mddev->raid_disks == 0)
 		return 0;
 	if (mddev->level >= 0)
 		return sprintf(page, "RAID-%d\n", mddev->level);
@@ -1740,6 +1740,8 @@ static struct md_sysfs_entry md_level = 
 static ssize_t
 raid_disks_show(mddev_t *mddev, char *page)
 {
+	if (mddev->raid_disks == 0)
+		return 0;
 	return sprintf(page, "%d\n", mddev->raid_disks);
 }
 
