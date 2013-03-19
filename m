From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2 - v2] DM RAID: Add message/status support for
 changing sync action
Date: Tue, 19 Mar 2013 12:20:45 -0500
Message-ID: <1363713645.11184.20.camel@f16>
References: <1363713352.11184.15.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363713352.11184.15.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

DM RAID:  Add message/status support for changing sync action

This patch adds a message interface to dm-raid to allow the user to more
finely control the sync actions being performed by the MD driver.  This
gives the user the ability to initiate "check" and "repair" (i.e. scrubbing).
Two additional fields have been appended to the status output to provide more
information about the type of sync action occurring and the results of those
actions, specifically: <sync_action> and <mismatch_cnt>.  These new fields
will always be populated.  This is essentially the device-mapper way of doing
what MD controls through the 'sync_action' sysfs file and shows through the
'mismatch_cnt' sysfs file.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1279,6 +1279,31 @@ static int raid_map(struct dm_target *ti
 	return DM_MAPIO_SUBMITTED;
 }
 
+static const char *decipher_sync_action(struct mddev *mddev)
+{
+	if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+		return "frozen";
+
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))) {
+		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+			return "reshape";
+
+		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
+			if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+				return "resync";
+			else if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+				return "check";
+			return "repair";
+		}
+
+		if (test_bit(MD_RECOVERY_RECOVER, &mddev->recovery))
+			return "recover";
+	}
+
+	return "idle";
+}
+
 static void raid_status(struct dm_target *ti, status_type_t type,
 			unsigned status_flags, char *result, unsigned maxlen)
 {
@@ -1298,8 +1323,18 @@ static void raid_status(struct dm_target
 			sync = rs->md.recovery_cp;
 
 		if (sync >= rs->md.resync_max_sectors) {
+			/*
+			 * Sync complete.
+			 */
 			array_in_sync = 1;
 			sync = rs->md.resync_max_sectors;
+		} else if (test_bit(MD_RECOVERY_REQUESTED, &rs->md.recovery)) {
+			/*
+			 * If "check" or "repair" is occurring, the array has
+			 * undergone and initial sync and the health characters
+			 * should not be 'a' anymore.
+			 */
+			array_in_sync = 1;
 		} else {
 			/*
 			 * The array may be doing an initial sync, or it may
@@ -1311,6 +1346,7 @@ static void raid_status(struct dm_target
 				if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
 					array_in_sync = 1;
 		}
+
 		/*
 		 * Status characters:
 		 *  'D' = Dead/Failed device
@@ -1339,6 +1375,21 @@ static void raid_status(struct dm_target
 		       (unsigned long long) sync,
 		       (unsigned long long) rs->md.resync_max_sectors);
 
+		/*
+		 * Sync action:
+		 *   See Documentation/device-mapper/dm-raid.c for
+		 *   information on each of these states.
+		 */
+		DMEMIT(" %s", decipher_sync_action(&rs->md));
+
+		/*
+		 * resync_mismatches/mismatch_cnt
+		 *   This field shows the number of discrepancies found when
+		 *   performing a "check" of the array.
+		 */
+		DMEMIT(" %llu",
+		       (unsigned long long)
+		       atomic64_read(&rs->md.resync_mismatches));
 		break;
 	case STATUSTYPE_TABLE:
 		/* The string you would use to construct this array */
@@ -1425,7 +1476,62 @@ static void raid_status(struct dm_target
 	}
 }
 
-static int raid_iterate_devices(struct dm_target *ti, iterate_devices_callout_fn fn, void *data)
+static int raid_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
+
+	if (!strcasecmp(argv[0], "reshape")) {
+		DMERR("Reshape not supported.");
+		return -EINVAL;
+	}
+
+	if (!mddev->pers || !mddev->pers->sync_request)
+		return -EINVAL;
+
+	if (!strcasecmp(argv[0], "frozen"))
+		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	else
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+
+	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
+		if (mddev->sync_thread) {
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_reap_sync_thread(mddev);
+		}
+	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+		return -EBUSY;
+	else if (!strcasecmp(argv[0], "resync"))
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	else if (!strcasecmp(argv[0], "recover")) {
+		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	} else {
+		if (!strcasecmp(argv[0], "check"))
+			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+		else if (!!strcasecmp(argv[0], "repair"))
+			return -EINVAL;
+		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	}
+	if (mddev->ro == 2) {
+		/* A write to sync_action is enough to justify
+		 * canceling read-auto mode
+		 */
+		mddev->ro = 0;
+		if (!mddev->suspended)
+			md_wakeup_thread(mddev->sync_thread);
+	}
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	if (!mddev->suspended)
+		md_wakeup_thread(mddev->thread);
+
+	return 0;
+}
+
+static int raid_iterate_devices(struct dm_target *ti,
+				iterate_devices_callout_fn fn, void *data)
 {
 	struct raid_set *rs = ti->private;
 	unsigned i;
@@ -1482,12 +1588,13 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 4, 2},
+	.version = {1, 5, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
 	.map = raid_map,
 	.status = raid_status,
+	.message = raid_message,
 	.iterate_devices = raid_iterate_devices,
 	.io_hints = raid_io_hints,
 	.presuspend = raid_presuspend,
Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-upstream/Documentation/device-mapper/dm-raid.txt
@@ -1,10 +1,13 @@
 dm-raid
--------
+=======
 
 The device-mapper RAID (dm-raid) target provides a bridge from DM to MD.
 It allows the MD RAID drivers to be accessed using a device-mapper
 interface.
 
+
+Mapping Table Interface
+-----------------------
 The target is named "raid" and it accepts the following parameters:
 
   <raid_type> <#raid_params> <raid_params> \
@@ -47,7 +50,7 @@ The target is named "raid" and it accept
     followed by optional parameters (in any order):
 	[sync|nosync]   Force or prevent RAID initialization.
 
-	[rebuild <idx>]	Rebuild drive number idx (first drive is 0).
+	[rebuild <idx>]	Rebuild drive number 'idx' (first drive is 0).
 
 	[daemon_sleep <ms>]
 		Interval between runs of the bitmap daemon that
@@ -56,9 +59,9 @@ The target is named "raid" and it accept
 
 	[min_recovery_rate <kB/sec/disk>]  Throttle RAID initialization
 	[max_recovery_rate <kB/sec/disk>]  Throttle RAID initialization
-	[write_mostly <idx>]		   Drive index is write-mostly
-	[max_write_behind <sectors>]       See '-write-behind=' (man mdadm)
-	[stripe_cache <sectors>]           Stripe cache size (higher RAIDs only)
+	[write_mostly <idx>]		   Mark drive index 'idx' write-mostly.
+	[max_write_behind <sectors>]       See '--write-behind=' (man mdadm)
+	[stripe_cache <sectors>]           Stripe cache size (RAID 4/5/6 only)
 	[region_size <sectors>]
 		The region_size multiplied by the number of regions is the
 		logical size of the array.  The bitmap records the device
@@ -122,7 +125,7 @@ The target is named "raid" and it accept
 	given for both the metadata and data drives for a given position.
 
 
-Example tables
+Example Tables
 --------------
 # RAID4 - 4 data drives, 1 parity (no metadata devices)
 # No metadata devices specified to hold superblock/bitmap info
@@ -141,26 +144,70 @@ Example tables
         raid4 4 2048 sync min_recovery_rate 20 \
         5 8:17 8:18 8:33 8:34 8:49 8:50 8:65 8:66 8:81 8:82
 
+
+Status Output
+-------------
 'dmsetup table' displays the table used to construct the mapping.
 The optional parameters are always printed in the order listed
 above with "sync" or "nosync" always output ahead of the other
 arguments, regardless of the order used when originally loading the table.
 Arguments that can be repeated are ordered by value.
 
-'dmsetup status' yields information on the state and health of the
-array.
-The output is as follows:
+
+'dmsetup status' yields information on the state and health of the array.
+The output is as follows (normally a single line, but expanded here for
+clarity):
 1: <s> <l> raid \
-2:      <raid_type> <#devices> <1 health char for each dev> <resync_ratio>
+2:      <raid_type> <#devices> <health_chars> \
+3:      <sync_ratio> <sync_action> <mismatch_cnt>
 
 Line 1 is the standard output produced by device-mapper.
-Line 2 is produced by the raid target, and best explained by example:
-        0 1960893648 raid raid4 5 AAAAA 2/490221568
+Line 2 & 3 are produced by the raid target and are best explained by example:
+        0 1960893648 raid raid4 5 AAAAA 2/490221568 init 0
 Here we can see the RAID type is raid4, there are 5 devices - all of
-which are 'A'live, and the array is 2/490221568 complete with recovery.
-Faulty or missing devices are marked 'D'.  Devices that are out-of-sync
-are marked 'a'.
-
+which are 'A'live, and the array is 2/490221568 complete with its initial
+recovery.  Here is a fuller description of the individual fields:
+	<raid_type>     Same as the <raid_type> used to create the array.
+	<health_chars>  One char for each device, indicating: 'A' = alive and
+			in-sync, 'a' = alive but not in-sync, 'D' = dead/failed.
+	<sync_ratio>    The ratio indicating how much of the array has undergone
+			the process described by 'sync_action'.  If the
+			'sync_action' is "check" or "repair", then the process
+			of "resync" or "recover" can be considered complete.
+	<sync_action>   One of the following possible states:
+			idle    - No synchronization action is being performed.
+			frozen  - The current action has been halted.
+			resync  - Array is undergoing its initial synchronization
+				  or is resynchronizing after an unclean shutdown
+				  (possibly aided by a bitmap).
+			recover - A device in the array is being rebuilt or
+				  replaced.
+			check   - A user-initiated full check of the array is
+				  being performed.  All blocks are read and
+				  checked for consistency.  The number of
+				  discrepancies found are recorded in
+				  <mismatch_cnt>.  No changes are made to the
+				  array by this action.
+			repair  - The same as "check", but discrepancies are
+				  corrected.
+			reshape - The array is undergoing a reshape.
+	<mismatch_cnt>  The number of discrepancies found between mirror copies
+			in RAID1/10 or wrong parity values found in RAID4/5/6.
+			This value is valid only after a "check" of the array
+			is performed.  A healthy array has a 'mismatch_cnt' of 0.
+
+Message Interface
+-----------------
+The dm-raid target will accept certain actions through the 'message' interface.
+('man dmsetup' for more information on the message interface.)  These actions
+include:
+	"idle"   - Halt the current sync action.
+	"frozen" - Freeze the current sync action.
+	"resync" - Initiate/continue a resync.
+	"recover"- Initiate/continue a recover process.
+	"check"  - Initiate a check (i.e. a "scrub") of the array.
+	"repair" - Initiate a repair of the array.
+	"reshape"- Currently unsupported (-EINVAL).
 
 Version History
 ---------------
@@ -171,4 +218,7 @@ Version History
 1.3.1	Allow device replacement/rebuild for RAID 10
 1.3.2   Fix/improve redundancy checking for RAID10
 1.4.0	Non-functional change.  Removes arg from mapping function.
-1.4.1   Add RAID10 "far" and "offset" algorithm support.
+1.4.1   RAID10 fix redundancy validation checks (commit 55ebbb5).
+1.4.2   Add RAID10 "far" and "offset" algorithm support.
+1.5.0   Add message interface to allow manipulation of the sync_action.
+	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.


