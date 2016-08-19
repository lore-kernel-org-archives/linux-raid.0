From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] r5cache: set MD_JOURNAL_CLEAN correctly
Date: Fri, 19 Aug 2016 15:34:01 -0700
Message-ID: <1471646042-2366825-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Currently, the code sets MD_JOURNAL_CLEAN when the array has
MD_FEATURE_JOURNAL and the recovery_cp is MaxSector. The array
will be MD_JOURNAL_CLEAN even if the journal device is missing.

With this patch, the MD_JOURNAL_CLEAN is only set when the journal
device presents.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/md.c    |  5 +----
 drivers/md/raid5.c | 13 ++++++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 51bc35f..46917f7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1604,11 +1604,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			mddev->new_chunk_sectors = mddev->chunk_sectors;
 		}
 
-		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL) {
+		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
 			set_bit(MD_HAS_JOURNAL, &mddev->flags);
-			if (mddev->recovery_cp == MaxSector)
-				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
-		}
 	} else if (mddev->pers == NULL) {
 		/* Insist of good event counter while assembling, except for
 		 * spares (which don't need an event count) */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4f8f524..2119e09 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6840,11 +6840,14 @@ static int raid5_run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	if (test_bit(MD_HAS_JOURNAL, &mddev->flags) && !journal_dev) {
-		printk(KERN_ERR "md/raid:%s: journal disk is missing, force array readonly\n",
-		       mdname(mddev));
-		mddev->ro = 1;
-		set_disk_ro(mddev->gendisk, 1);
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
+		if (!journal_dev) {
+			pr_err("md/raid:%s: journal disk is missing, force array readonly\n",
+			       mdname(mddev));
+			mddev->ro = 1;
+			set_disk_ro(mddev->gendisk, 1);
+		} else if (mddev->recovery_cp == MaxSector)
+			set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
 	}
 
 	conf->min_offset_diff = min_offset_diff;
-- 
2.8.0.rc2

