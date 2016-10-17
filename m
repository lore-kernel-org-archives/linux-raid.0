From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 1/2] md: add bad block support for external metadata
Date: Mon, 17 Oct 2016 16:29:09 +0200
Message-ID: <1476714549-15057-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com, mariusz.dabrowski@intel.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Add new rdev flag which external metadata handler can use to switch
on/off bad block support. If new bad block is encountered, notify it via
rdev 'unacknowledged_bad_blocks' sysfs file. If bad block has been
cleared, notify update to rdev 'bad_blocks' sysfs file.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c | 22 ++++++++++++++++++++--
 drivers/md/md.h |  3 +++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index eac84d8..f375d1b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2568,6 +2568,10 @@ state_show(struct md_rdev *rdev, char *page)
 		len += sprintf(page+len, "%sreplacement", sep);
 		sep = ",";
 	}
+	if (test_bit(ExternalBbl, &flags)) {
+		len += sprintf(page+len, "%sexternal_bbl", sep);
+		sep = ",";
+	}
 
 	return len+sprintf(page+len, "\n");
 }
@@ -2708,6 +2712,14 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			}
 		} else
 			err = -EBUSY;
+	} else if (cmd_match(buf, "external_bbl") && (rdev->mddev->external)) {
+		set_bit(ExternalBbl, &rdev->flags);
+		rdev->badblocks.shift = 0;
+		err = 0;
+	} else if (cmd_match(buf, "-external_bbl") && (rdev->mddev->external)) {
+		clear_bit(ExternalBbl, &rdev->flags);
+		rdev->badblocks.shift = -1;
+		err = 0;
 	}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
@@ -8614,6 +8626,9 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 	rv = badblocks_set(&rdev->badblocks, s, sectors, 0);
 	if (rv == 0) {
 		/* Make sure they get written out promptly */
+		if (test_bit(ExternalBbl, &rdev->flags))
+			sysfs_notify(&rdev->kobj, NULL,
+				     "unacknowledged_bad_blocks");
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
 		set_mask_bits(&mddev->flags, 0,
 			      BIT(MD_CHANGE_CLEAN) | BIT(MD_CHANGE_PENDING));
@@ -8627,12 +8642,15 @@ EXPORT_SYMBOL_GPL(rdev_set_badblocks);
 int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 			 int is_new)
 {
+	int rv;
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
 		s += rdev->data_offset;
-	return badblocks_clear(&rdev->badblocks,
-				  s, sectors);
+	rv = badblocks_clear(&rdev->badblocks, s, sectors);
+	if ((rv == 0) && test_bit(ExternalBbl, &rdev->flags))
+		sysfs_notify(&rdev->kobj, NULL, "bad_blocks");
+	return rv;
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2b20417..21bd94f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -168,6 +168,9 @@ enum flag_bits {
 				 * so it is safe to remove without
 				 * another synchronize_rcu() call.
 				 */
+	ExternalBbl,            /* External metadata provides bad
+				 * block management for a disk
+				 */
 };
 
 static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
-- 
1.8.3.1

