From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1/2] DM RAID:  Break-up untidy function
Date: Wed, 08 May 2013 17:57:13 -0500
Message-ID: <1368053833.2890.7.camel@f16>
References: <1368053697.2890.5.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1368053697.2890.5.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

DM RAID:  Break-up untidy function

Clean-up excessive indentation by moving some code in raid_resume()
into its own function.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1572,15 +1572,51 @@ static void raid_postsuspend(struct dm_t
 	mddev_suspend(&rs->md);
 }
 
-static void raid_resume(struct dm_target *ti)
+static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 {
 	int i;
 	uint64_t failed_devices, cleared_failed_devices = 0;
 	unsigned long flags;
 	struct dm_raid_superblock *sb;
-	struct raid_set *rs = ti->private;
 	struct md_rdev *r;
 
+	for (i = 0; i < rs->md.raid_disks; i++) {
+		r = &rs->dev[i].rdev;
+		if (test_bit(Faulty, &r->flags) && r->sb_page &&
+		    sync_page_io(r, 0, r->sb_size, r->sb_page, READ, 1)) {
+			DMINFO("Faulty %s device #%d has readable super block."
+			       "  Attempting to revive it.",
+			       rs->raid_type->name, i);
+			r->raid_disk = i;
+			r->saved_raid_disk = i;
+			flags = r->flags;
+			clear_bit(Faulty, &r->flags);
+			clear_bit(WriteErrorSeen, &r->flags);
+			clear_bit(In_sync, &r->flags);
+			if (r->mddev->pers->hot_add_disk(r->mddev, r)) {
+				r->raid_disk = -1;
+				r->saved_raid_disk = -1;
+				r->flags = flags;
+			} else {
+				r->recovery_offset = 0;
+				cleared_failed_devices |= 1 << i;
+			}
+		}
+	}
+	if (cleared_failed_devices) {
+		rdev_for_each(r, &rs->md) {
+			sb = page_address(r->sb_page);
+			failed_devices = le64_to_cpu(sb->failed_devices);
+			failed_devices &= ~cleared_failed_devices;
+			sb->failed_devices = cpu_to_le64(failed_devices);
+		}
+	}
+}
+
+static void raid_resume(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+
 	set_bit(MD_CHANGE_DEVS, &rs->md.flags);
 	if (!rs->bitmap_loaded) {
 		bitmap_load(&rs->md);
@@ -1591,37 +1627,7 @@ static void raid_resume(struct dm_target
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
-		for (i = 0; i < rs->md.raid_disks; i++) {
-			r = &rs->dev[i].rdev;
-			if (test_bit(Faulty, &r->flags) && r->sb_page &&
-			    sync_page_io(r, 0, r->sb_size,
-					 r->sb_page, READ, 1)) {
-				DMINFO("Faulty device #%d has readable super"
-				       "block.  Attempting to revive it.", i);
-				r->raid_disk = i;
-				r->saved_raid_disk = i;
-				flags = r->flags;
-				clear_bit(Faulty, &r->flags);
-				clear_bit(WriteErrorSeen, &r->flags);
-				clear_bit(In_sync, &r->flags);
-				if (r->mddev->pers->hot_add_disk(r->mddev, r)) {
-					r->raid_disk = -1;
-					r->saved_raid_disk = -1;
-					r->flags = flags;
-				} else {
-					r->recovery_offset = 0;
-					cleared_failed_devices |= 1 << i;
-				}
-			}
-		}
-		if (cleared_failed_devices) {
-			rdev_for_each(r, &rs->md) {
-				sb = page_address(r->sb_page);
-				failed_devices = le64_to_cpu(sb->failed_devices);
-				failed_devices &= ~cleared_failed_devices;
-				sb->failed_devices = cpu_to_le64(failed_devices);
-			}
-		}
+		attempt_restore_of_faulty_devices(rs);
 	}
 
 	clear_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);


