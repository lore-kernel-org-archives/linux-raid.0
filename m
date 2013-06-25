From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD: Remember the last sync operation that was performed
Date: Tue, 25 Jun 2013 01:23:59 -0500
Message-ID: <1372141439.2016.4.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

MD:  Remember the last sync operation that was performed

This patch adds a field to the mddev structure to track the last
sync operation that was performed.  This is especially useful when
it comes to what is recorded in mismatch_cnt in sysfs.  If the
last operation was "data-check", then it reports the number of
descrepancies found by the user-initiated check.  If it was a
"repair" operation, then it is reporting the number of
descrepancies repaired.  etc.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1388,6 +1388,7 @@ static void raid_status(struct dm_target
 		 *   performing a "check" of the array.
 		 */
 		DMEMIT(" %llu",
+		       (strcmp(rs->md.last_sync_action, "data-check")) ? 0 :
 		       (unsigned long long)
 		       atomic64_read(&rs->md.resync_mismatches));
 		break;
@@ -1651,7 +1652,7 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 5, 1},
+	.version = {1, 5, 2},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
Index: linux-upstream/drivers/md/md.c
===================================================================
--- linux-upstream.orig/drivers/md/md.c
+++ linux-upstream/drivers/md/md.c
@@ -521,6 +521,7 @@ void mddev_init(struct mddev *mddev)
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
 	mddev->reshape_backwards = 0;
+	mddev->last_sync_action = "none";
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
@@ -4272,6 +4273,17 @@ action_store(struct mddev *mddev, const
 	return len;
 }
 
+static struct md_sysfs_entry md_scan_mode =
+__ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
+
+static ssize_t
+last_sync_action_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%s\n", mddev->last_sync_action);
+}
+
+static struct md_sysfs_entry md_last_scan_mode = __ATTR_RO(last_sync_action);
+
 static ssize_t
 mismatch_cnt_show(struct mddev *mddev, char *page)
 {
@@ -4280,10 +4292,6 @@ mismatch_cnt_show(struct mddev *mddev, c
 		       atomic64_read(&mddev->resync_mismatches));
 }
 
-static struct md_sysfs_entry md_scan_mode =
-__ATTR(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
-
-
 static struct md_sysfs_entry md_mismatches = __ATTR_RO(mismatch_cnt);
 
 static ssize_t
@@ -4686,6 +4694,7 @@ static struct attribute *md_default_attr
 
 static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
+	&md_last_scan_mode.attr,
 	&md_mismatches.attr,
 	&md_sync_min.attr,
 	&md_sync_max.attr,
@@ -7336,7 +7345,7 @@ void md_do_sync(struct md_thread *thread
 		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
 			desc = "data-check";
 		else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
-			desc = "requested-resync";
+			desc = "requested-resync"; /* AKA "repair" */
 		else
 			desc = "resync";
 	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
@@ -7344,6 +7353,8 @@ void md_do_sync(struct md_thread *thread
 	else
 		desc = "recovery";
 
+	mddev->last_sync_action = desc;
+
 	/* we overload curr_resync somewhat here.
 	 * 0 == not engaged in resync at all
 	 * 2 == checking that there is no conflict with another sync
Index: linux-upstream/drivers/md/md.h
===================================================================
--- linux-upstream.orig/drivers/md/md.h
+++ linux-upstream/drivers/md/md.h
@@ -268,6 +268,14 @@ struct mddev {
 
 	struct md_thread		*thread;	/* management thread */
 	struct md_thread		*sync_thread;	/* doing resync or reconstruct */
+
+	/* 'last_sync_action' is initialized to "none".  It is set when a
+	 * sync operation (i.e "data-check", "requested-resync", "resync",
+	 * "recovery", or "reshape") is started.  It holds this value even
+	 * when the sync thread is "frozen" (interrupted) or "idle" (stopped
+	 * or finished).  It is overwritten when a new sync operation is begun.
+	 */
+	char				*last_sync_action;
 	sector_t			curr_resync;	/* last block scheduled */
 	/* As resync requests can complete out of order, we cannot easily track
 	 * how much resync has been completed.  So we occasionally pause until
Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-upstream/Documentation/device-mapper/dm-raid.txt
@@ -223,3 +223,4 @@ Version History
 1.5.0   Add message interface to allow manipulation of the sync_action.
 	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.
 1.5.1   Add ability to restore transiently failed devices on resume.
+1.5.2   'mismatch_cnt' is zero unless [last_]sync_action is "check".


