From: prasanna.panchamukhi@riverbed.com
Subject: [PATCH] drivers/md: raid10: Fix null pointer dereference in fix_read_error()
Date: Mon, 21 Jun 2010 15:14:35 -0700
Message-ID: <1277158475-11397-1-git-send-email-prasanna.panchamukhi@riverbed.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: prasanna.panchamukhi@riverbed.com, rbecker@riverbed.com
List-Id: linux-raid.ids

From: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>

Such NULL pointer dereference can occur when the driver was fixing the
read errors/bad blocks and the disk was physically removed
causing a system crash. This patch check if the
rcu_dereference() returns valid rdev before accessing it in fix_read_error().

Signed-off-by: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>
Signed-off-by: Rob Becker <rbecker@riverbed.com>
---
 drivers/md/raid10.c |   51 +++++++++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0372499..9556faa 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1490,31 +1490,34 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 		int cur_read_error_count = 0;
 
 		rdev = rcu_dereference(conf->mirrors[d].rdev);
-		bdevname(rdev->bdev, b);
+		if (rdev) { /* Check if the mirror raid device is not NULL*/
+			bdevname(rdev->bdev, b);
 
-		if (test_bit(Faulty, &rdev->flags)) {
-			rcu_read_unlock();
-			/* drive has already been failed, just ignore any
-			   more fix_read_error() attempts */
-			return;
-		}
+			if (test_bit(Faulty, &rdev->flags)) {
+				rcu_read_unlock();
+				/* drive has already been failed, just ignore
+				   any more fix_read_error() attempts */
+				return;
+			}
 
-		check_decay_read_errors(mddev, rdev);
-		atomic_inc(&rdev->read_errors);
-		cur_read_error_count = atomic_read(&rdev->read_errors);
-		if (cur_read_error_count > max_read_errors) {
-			rcu_read_unlock();
-			printk(KERN_NOTICE
-			       "md/raid10:%s: %s: Raid device exceeded "
-			       "read_error threshold "
-			       "[cur %d:max %d]\n",
-			       mdname(mddev),
-			       b, cur_read_error_count, max_read_errors);
-			printk(KERN_NOTICE
-			       "md/raid10:%s: %s: Failing raid "
-			       "device\n", mdname(mddev), b);
-			md_error(mddev, conf->mirrors[d].rdev);
-			return;
+			check_decay_read_errors(mddev, rdev);
+			atomic_inc(&rdev->read_errors);
+			cur_read_error_count = atomic_read(&rdev->read_errors);
+			if (cur_read_error_count > max_read_errors) {
+				rcu_read_unlock();
+				printk(KERN_NOTICE
+				       "md/raid10:%s: %s: Raid device exceeded "
+				       "read_error threshold "
+				       "[cur %d:max %d]\n",
+				       mdname(mddev),
+				       b, cur_read_error_count,
+				       max_read_errors);
+				printk(KERN_NOTICE
+				       "md/raid10:%s: %s: Failing raid "
+				       "device\n", mdname(mddev), b);
+				md_error(mddev, conf->mirrors[d].rdev);
+				return;
+			}
 		}
 	}
 	rcu_read_unlock();
-- 
1.7.0.4

