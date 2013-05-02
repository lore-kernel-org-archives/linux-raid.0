From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH - v2] DM RAID: Add ability to restore transiently failed
 devices on resume
Date: Thu, 02 May 2013 14:19:24 -0500
Message-ID: <1367522364.23442.1.camel@f16>
References: <1365712023.9799.1.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1365712023.9799.1.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

DM RAID: Add ability to restore transiently failed devices on resume

This patch adds code to the resume function to check over the devices
in the RAID array.  If any are found to be marked as failed and their
superblocks can be read, an attempt is made to reintegrate them into
the array.  This allows the user to refresh the array with a simple
suspend and resume of the array - rather than having to load a
completely new table, allocate and initialize all the structures and
throw away the old instantiation.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1574,12 +1574,54 @@ static void raid_postsuspend(struct dm_t
 
 static void raid_resume(struct dm_target *ti)
 {
+	int i;
+	uint64_t failed_devices, cleared_failed_devices = 0;
+	unsigned long flags;
+	struct dm_raid_superblock *sb;
 	struct raid_set *rs = ti->private;
+	struct md_rdev *r;
 
 	set_bit(MD_CHANGE_DEVS, &rs->md.flags);
 	if (!rs->bitmap_loaded) {
 		bitmap_load(&rs->md);
 		rs->bitmap_loaded = 1;
+	} else {
+		/*
+		 * A secondary resume while the device is active.
+		 * Take this opportunity to check whether any failed
+		 * devices are reachable again.
+		 */
+		for (i = 0; i < rs->md.raid_disks; i++) {
+			r = &rs->dev[i].rdev;
+			if (test_bit(Faulty, &r->flags) && r->sb_page &&
+			    sync_page_io(r, 0, r->sb_size,
+					 r->sb_page, READ, 1)) {
+				DMINFO("Faulty device #%d has readable super"
+				       "block.  Attempting to revive it.", i);
+				r->raid_disk = i;
+				r->saved_raid_disk = i;
+				flags = r->flags;
+				clear_bit(Faulty, &r->flags);
+				clear_bit(WriteErrorSeen, &r->flags);
+				clear_bit(In_sync, &r->flags);
+				if (r->mddev->pers->hot_add_disk(r->mddev, r)) {
+					r->raid_disk = -1;
+					r->saved_raid_disk = -1;
+					r->flags = flags;
+				} else {
+					r->recovery_offset = 0;
+					cleared_failed_devices |= 1 << i;
+				}
+			}
+		}
+		if (cleared_failed_devices) {
+			rdev_for_each(r, &rs->md) {
+				sb = page_address(r->sb_page);
+				failed_devices = le64_to_cpu(sb->failed_devices);
+				failed_devices &= ~cleared_failed_devices;
+				sb->failed_devices = cpu_to_le64(failed_devices);
+			}
+		}
 	}
 
 	clear_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
@@ -1588,7 +1630,7 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 5, 0},
+	.version = {1, 5, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
Index: linux-upstream/drivers/md/raid1.c
===================================================================
--- linux-upstream.orig/drivers/md/raid1.c
+++ linux-upstream/drivers/md/raid1.c
@@ -1518,8 +1518,9 @@ static int raid1_add_disk(struct mddev *
 		p = conf->mirrors+mirror;
 		if (!p->rdev) {
 
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
+			if (mddev->gendisk)
+				disk_stack_limits(mddev->gendisk, rdev->bdev,
+						  rdev->data_offset << 9);
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -1558,7 +1559,7 @@ static int raid1_add_disk(struct mddev *
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
-	if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 	print_conf(conf);
 	return err;
Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -1806,15 +1806,17 @@ static int raid10_add_disk(struct mddev
 			set_bit(Replacement, &rdev->flags);
 			rdev->raid_disk = mirror;
 			err = 0;
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
+			if (mddev->gendisk)
+				disk_stack_limits(mddev->gendisk, rdev->bdev,
+						  rdev->data_offset << 9);
 			conf->fullsync = 1;
 			rcu_assign_pointer(p->replacement, rdev);
 			break;
 		}
 
-		disk_stack_limits(mddev->gendisk, rdev->bdev,
-				  rdev->data_offset << 9);
+		if (mddev->gendisk)
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
 
 		p->head_position = 0;
 		p->recovery_disabled = mddev->recovery_disabled - 1;
Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-upstream/Documentation/device-mapper/dm-raid.txt
@@ -222,3 +222,4 @@ Version History
 1.4.2   Add RAID10 "far" and "offset" algorithm support.
 1.5.0   Add message interface to allow manipulation of the sync_action.
 	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.
+1.5.1   Add ability to restore transiently failed devices on resume.


