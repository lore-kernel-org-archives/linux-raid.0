From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md: clear WantReplacement once disk is removed
Date: Mon, 24 Apr 2017 15:58:04 +0800
Message-ID: <20170424075804.19103-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

We can clear 'WantReplacement' flag directly no
matter it's replacement existed or not since the
semantic is same as before.

Also since the disk is removed from array, then
it is straightforward to remove 'WantReplacement'
flag and the comments in raid10/5 can be removed
as well.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid1.c  | 6 +++---
 drivers/md/raid10.c | 8 ++------
 drivers/md/raid5.c  | 9 +++------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 57611f4..e93dd50 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1831,9 +1831,9 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			p->rdev = repl;
 			conf->mirrors[conf->raid_disks + number].rdev = NULL;
 			unfreeze_array(conf);
-			clear_bit(WantReplacement, &rdev->flags);
-		} else
-			clear_bit(WantReplacement, &rdev->flags);
+		}
+
+		clear_bit(WantReplacement, &rdev->flags);
 		err = md_integrity_register(mddev);
 	}
 abort:
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index acb3f46..72b2a9c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1874,13 +1874,9 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			   * but will never see neither -- if they are careful.
 			   */
 		p->replacement = NULL;
-		clear_bit(WantReplacement, &rdev->flags);
-	} else
-		/* We might have just remove the Replacement as faulty
-		 * Clear the flag just in case
-		 */
-		clear_bit(WantReplacement, &rdev->flags);
+	}
 
+	clear_bit(WantReplacement, &rdev->flags);
 	err = md_integrity_register(mddev);
 
 abort:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 356cd9c..3d971e5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7603,15 +7603,12 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			   * but will never see neither - if they are careful
 			   */
 		p->replacement = NULL;
-		clear_bit(WantReplacement, &rdev->flags);
 
 		if (!err)
 			err = log_modify(conf, p->rdev, true);
-	} else
-		/* We might have just removed the Replacement as faulty-
-		 * clear the bit just in case
-		 */
-		clear_bit(WantReplacement, &rdev->flags);
+	}
+
+	clear_bit(WantReplacement, &rdev->flags);
 abort:
 
 	print_raid5_conf(conf);
-- 
2.10.0

