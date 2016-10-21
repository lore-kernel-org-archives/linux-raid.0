From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 1/2 v3] md: add bad block support for external metadata
Date: Fri, 21 Oct 2016 16:26:57 +0200
Message-ID: <1477060017-8217-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Add new rdev flag which external metadata handler can use to switch
on/off bad block support. If new bad block is encountered, notify it via
rdev 'unacknowledged_bad_blocks' sysfs file. If bad block has been
cleared, notify update to rdev 'bad_blocks' sysfs file.

When bad blocks support is being removed, just clear rdev flag. It is
not necessary to reset badblocks->shift field. If there are bad blocks
cleared or added at the same time, it is ok for those changes to be
applied to the structure. The array is in blocked state and the drive
which cannot handle bad blocks any more will be removed from the array
before it is unlocked.

Simplify state_show function by adding a separator at the end of each
string and overwrite last separator with new line.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c | 78 ++++++++++++++++++++++++++++-----------------------------
 drivers/md/md.h |  3 +++
 2 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0695013..b661a45 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2523,51 +2523,38 @@ struct rdev_sysfs_entry {
 static ssize_t
 state_show(struct md_rdev *rdev, char *page)
 {
-	char *sep = "";
+	char *sep = ",";
 	size_t len = 0;
 	unsigned long flags = ACCESS_ONCE(rdev->flags);
 
 	if (test_bit(Faulty, &flags) ||
-	    rdev->badblocks.unacked_exist) {
-		len+= sprintf(page+len, "%sfaulty",sep);
-		sep = ",";
-	}
-	if (test_bit(In_sync, &flags)) {
-		len += sprintf(page+len, "%sin_sync",sep);
-		sep = ",";
-	}
-	if (test_bit(Journal, &flags)) {
-		len += sprintf(page+len, "%sjournal",sep);
-		sep = ",";
-	}
-	if (test_bit(WriteMostly, &flags)) {
-		len += sprintf(page+len, "%swrite_mostly",sep);
-		sep = ",";
-	}
+	    rdev->badblocks.unacked_exist)
+		len += sprintf(page+len, "faulty%s", sep);
+	if (test_bit(In_sync, &flags))
+		len += sprintf(page+len, "in_sync%s", sep);
+	if (test_bit(Journal, &flags))
+		len += sprintf(page+len, "journal%s", sep);
+	if (test_bit(WriteMostly, &flags))
+		len += sprintf(page+len, "write_mostly%s", sep);
 	if (test_bit(Blocked, &flags) ||
 	    (rdev->badblocks.unacked_exist
-	     && !test_bit(Faulty, &flags))) {
-		len += sprintf(page+len, "%sblocked", sep);
-		sep = ",";
-	}
+	     && !test_bit(Faulty, &flags)))
+		len += sprintf(page+len, "blocked%s", sep);
 	if (!test_bit(Faulty, &flags) &&
 	    !test_bit(Journal, &flags) &&
-	    !test_bit(In_sync, &flags)) {
-		len += sprintf(page+len, "%sspare", sep);
-		sep = ",";
-	}
-	if (test_bit(WriteErrorSeen, &flags)) {
-		len += sprintf(page+len, "%swrite_error", sep);
-		sep = ",";
-	}
-	if (test_bit(WantReplacement, &flags)) {
-		len += sprintf(page+len, "%swant_replacement", sep);
-		sep = ",";
-	}
-	if (test_bit(Replacement, &flags)) {
-		len += sprintf(page+len, "%sreplacement", sep);
-		sep = ",";
-	}
+	    !test_bit(In_sync, &flags))
+		len += sprintf(page+len, "spare%s", sep);
+	if (test_bit(WriteErrorSeen, &flags))
+		len += sprintf(page+len, "write_error%s", sep);
+	if (test_bit(WantReplacement, &flags))
+		len += sprintf(page+len, "want_replacement%s", sep);
+	if (test_bit(Replacement, &flags))
+		len += sprintf(page+len, "replacement%s", sep);
+	if (test_bit(ExternalBbl, &flags))
+		len += sprintf(page+len, "external_bbl%s", sep);
+
+	if (len)
+		len -= strlen(sep);
 
 	return len+sprintf(page+len, "\n");
 }
@@ -2708,6 +2695,13 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			}
 		} else
 			err = -EBUSY;
+	} else if (cmd_match(buf, "external_bbl") && (rdev->mddev->external)) {
+		set_bit(ExternalBbl, &rdev->flags);
+		rdev->badblocks.shift = 0;
+		err = 0;
+	} else if (cmd_match(buf, "-external_bbl") && (rdev->mddev->external)) {
+		clear_bit(ExternalBbl, &rdev->flags);
+		err = 0;
 	}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
@@ -8615,6 +8609,9 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 	rv = badblocks_set(&rdev->badblocks, s, sectors, 0);
 	if (rv == 0) {
 		/* Make sure they get written out promptly */
+		if (test_bit(ExternalBbl, &rdev->flags))
+			sysfs_notify(&rdev->kobj, NULL,
+				     "unacknowledged_bad_blocks");
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
 		set_mask_bits(&mddev->flags, 0,
 			      BIT(MD_CHANGE_CLEAN) | BIT(MD_CHANGE_PENDING));
@@ -8628,12 +8625,15 @@ EXPORT_SYMBOL_GPL(rdev_set_badblocks);
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

