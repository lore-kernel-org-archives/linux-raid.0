From: Andrei Warkentin <andreiw@vmware.com>
Subject: [RFC] MD: Restart an interrupted incremental recovery.
Date: Wed, 12 Oct 2011 15:41:35 -0400
Message-ID: <1318448495-8981-1-git-send-email-andreiw@vmware.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andrei Warkentin <andreiw@vmware.com>, Neil Brown <neilb@suse.de>, Andrei Warkentin <andrey.warkentin@gmail.com>
List-Id: linux-raid.ids

If an incremental recovery was interrupted, a subsequent
re-add will result in a full recovery, even though an
incremental should be possible.

This patch handles 99% of possible interruptions of an
incremental recovery (it doesn't handle I/O failure
that occurs immediately after the hot_add_disk(), which
causes the added rdev to become a spare).

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
---
 drivers/md/md.c           |   28 +++++++++++++++++++++++++---
 include/linux/raid/md_p.h |    6 +++++-
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5404b22..8002e02 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1701,10 +1701,27 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 			break;
 		default:
 			if ((le32_to_cpu(sb->feature_map) &
-			     MD_FEATURE_RECOVERY_OFFSET))
-				rdev->recovery_offset = le64_to_cpu(sb->recovery_offset);
-			else
+			     MD_FEATURE_IN_INCREMENTAL)) {
+				/* This rdev had been in an incremental
+				 * recovery, which was interrupted, and
+				 * can be restarted. Note that we specifically
+				 * ignore recovery_offset, as I/O to the degraded
+				 * array could have modified data in sectors
+				 * below the recovery offset.
+				 */
+				char b[BDEVNAME_SIZE];
 				set_bit(In_sync, &rdev->flags);
+				printk(KERN_NOTICE
+				       "md: restarting interrupted incremental resync on %s\n",
+				       bdevname(rdev->bdev, b));
+			} else {
+				if ((le32_to_cpu(sb->feature_map) &
+				     MD_FEATURE_RECOVERY_OFFSET))
+					rdev->recovery_offset =
+						le64_to_cpu(sb->recovery_offset);
+				else
+					set_bit(In_sync, &rdev->flags);
+			}
 			rdev->raid_disk = role;
 			break;
 		}
@@ -1738,6 +1755,11 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 	else
 		sb->resync_offset = cpu_to_le64(0);
 
+	if (mddev->bitmap && rdev->saved_raid_disk != -1)
+		sb->feature_map |= cpu_to_le32(MD_FEATURE_IN_INCREMENTAL);
+	else
+		sb->feature_map &= ~cpu_to_le32(MD_FEATURE_IN_INCREMENTAL);
+
 	sb->cnt_corrected_read = cpu_to_le32(atomic_read(&rdev->corrected_errors));
 
 	sb->raid_disks = cpu_to_le32(mddev->raid_disks);
diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 9e65d9e..8a17446 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -277,7 +277,11 @@ struct mdp_superblock_1 {
 					   */
 #define	MD_FEATURE_RESHAPE_ACTIVE	4
 #define	MD_FEATURE_BAD_BLOCKS		8 /* badblock list is not empty */
+#define	MD_FEATURE_IN_INCREMENTAL	16 /* set on disks undergoing incremental
+					    * recovery, so that an interrupted
+					    * incremental recovery may be restarted
+					    */
 
-#define	MD_FEATURE_ALL			(1|2|4|8)
+#define	MD_FEATURE_ALL			(1|2|4|8|16)
 
 #endif 
-- 
1.7.4.1

