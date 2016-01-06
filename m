From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/3] md: set MD_HAS_JOURNAL in correct places
Date: Wed, 6 Jan 2016 14:37:13 -0800
Message-ID: <55aef157bf27c1de417577f02b69944a277a0141.1452119479.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.de
List-Id: linux-raid.ids

Set MD_HAS_JOURNAL when a array is loaded or journal is initialized.
This is to avoid the flags set too early in journal disk hotadd.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c          | 8 ++++----
 drivers/md/raid5-cache.c | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0c3e6d..e896320 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1607,6 +1607,10 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			mddev->new_chunk_sectors = mddev->chunk_sectors;
 		}
 
+		if (mddev->recovery_cp == MaxSector)
+			set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
+		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
+			set_bit(MD_HAS_JOURNAL, &mddev->flags);
 	} else if (mddev->pers == NULL) {
 		/* Insist of good event counter while assembling, except for
 		 * spares (which don't need an event count) */
@@ -1653,8 +1657,6 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			}
 			set_bit(Journal, &rdev->flags);
 			rdev->journal_tail = le64_to_cpu(sb->journal_tail);
-			if (mddev->recovery_cp == MaxSector)
-				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
 			rdev->raid_disk = 0;
 			break;
 		default:
@@ -1674,8 +1676,6 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			set_bit(WriteMostly, &rdev->flags);
 		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_REPLACEMENT)
 			set_bit(Replacement, &rdev->flags);
-		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
-			set_bit(MD_HAS_JOURNAL, &mddev->flags);
 	} else /* MULTIPATH are always insync */
 		set_bit(In_sync, &rdev->flags);
 
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 31e0fad..16cf876 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1242,6 +1242,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		goto error;
 
 	rcu_assign_pointer(conf->log, log);
+	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	return 0;
 
 error:
-- 
2.4.6

