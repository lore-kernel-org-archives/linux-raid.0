From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 13/13] md/multipath: Replace printk() calls by the usage of
 higher level interfaces
Date: Sun, 2 Oct 2016 14:10:13 +0200
Message-ID: <7f99844c-c478-920c-56b2-8f2997392ff1@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 2 Oct 2016 12:42:46 +0200

1. Add a definition for the macros "MY_LOG_PREFIX" and "pr_fmt"
   so that their information can be used for consistent message output.

2. Prefer usage of some higher level macros over calling "printk" directly
   in this software module.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 69 ++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 85f6c85..045b866 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -19,6 +19,8 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define MY_LOG_PREFIX KBUILD_MODNAME ": "
+#define pr_fmt(fmt) MY_LOG_PREFIX fmt
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/raid/md_u.h>
@@ -51,8 +53,7 @@ static int multipath_map(struct mpconf *conf)
 		}
 	}
 	rcu_read_unlock();
-
-	printk(KERN_ERR "multipath_map(): no more operational IO paths?\n");
+	pr_err("map: no more operational IO paths?\n");
 	return (-1);
 }
 
@@ -97,7 +98,8 @@ static void multipath_end_request(struct bio *bio)
 		 */
 		char b[BDEVNAME_SIZE];
 		md_error(mp_bh->mddev, rdev);
-		printk(KERN_ERR "multipath: %s: rescheduling sector %llu\n",
+
+		pr_err("%s: rescheduling sector %llu\n",
 		       bdevname(rdev->bdev, b),
 		       (unsigned long long)bio->bi_iter.bi_sector);
 		multipath_reschedule_retry(mp_bh);
@@ -195,8 +197,7 @@ static void multipath_error(struct mddev *mddev, struct md_rdev *rdev)
 		 * first check if this is a queued request for a device
 		 * which has just failed.
 		 */
-		printk(KERN_ALERT
-		       "multipath: only one IO path left and IO error.\n");
+		pr_alert("only one IO path left and IO error.\n");
 		/* leave it active... it's all we have */
 		return;
 	}
@@ -211,12 +212,10 @@ static void multipath_error(struct mddev *mddev, struct md_rdev *rdev)
 	}
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	printk(KERN_ALERT "multipath: IO failure on %s,"
-	       " disabling IO path.\n"
-	       "multipath: Operation continuing"
-	       " on %d IO paths.\n",
-	       bdevname(rdev->bdev, b),
-	       conf->raid_disks - mddev->degraded);
+	pr_alert("IO failure on %s, disabling IO path.\n"
+		 MY_LOG_PREFIX "Operation continuing on %d IO paths.\n",
+		 bdevname(rdev->bdev, b),
+		 conf->raid_disks - mddev->degraded);
 }
 
 static void print_multipath_conf(struct mpconf *conf)
@@ -224,21 +223,22 @@ static void print_multipath_conf(struct mpconf *conf)
 	int i;
 	struct multipath_info *tmp;
 
-	printk("MULTIPATH conf printout:\n");
+	pr_info("conf printout:\n");
 	if (!conf) {
-		printk("(conf==NULL)\n");
+		pr_info("(conf==NULL)\n");
 		return;
 	}
-	printk(" --- wd:%d rd:%d\n", conf->raid_disks - conf->mddev->degraded,
-			 conf->raid_disks);
+	pr_info("--- wd:%d rd:%d\n",
+		conf->raid_disks - conf->mddev->degraded,
+		conf->raid_disks);
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		char b[BDEVNAME_SIZE];
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
-			printk(" disk%d, o:%d, dev:%s\n",
-			       i, !test_bit(Faulty, &tmp->rdev->flags),
-			       bdevname(tmp->rdev->bdev, b));
+			pr_info("disk%d, o:%d, dev:%s\n",
+				i, !test_bit(Faulty, &tmp->rdev->flags),
+				bdevname(tmp->rdev->bdev, b));
 	}
 }
 
@@ -295,8 +295,8 @@ static int multipath_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (rdev == p->rdev) {
 		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
-			printk(KERN_ERR "hot-remove-disk, slot %d is identified"
-			       " but is still operational!\n", number);
+			pr_err("hot-remove-disk, slot %d is identified but is still operational!\n",
+			       number);
 			err = -EBUSY;
 			goto abort;
 		}
@@ -350,16 +350,14 @@ static void multipathd(struct md_thread *thread)
 
 		mp_bh->path = multipath_map(conf);
 		if (mp_bh->path < 0) {
-			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
-				" error for block %llu\n",
-				bdevname(bio->bi_bdev, b),
-				(unsigned long long)bio->bi_iter.bi_sector);
+			pr_alert("%s: unrecoverable IO read error for block %llu\n",
+				 bdevname(bio->bi_bdev, b),
+				 (unsigned long long)bio->bi_iter.bi_sector);
 			multipath_end_bh_io(mp_bh, -EIO);
 		} else {
-			printk(KERN_ERR "multipath: %s: redirecting sector %llu"
-				" to another IO path\n",
-				bdevname(bio->bi_bdev, b),
-				(unsigned long long)bio->bi_iter.bi_sector);
+			pr_err("%s: redirecting sector %llu to another IO path\n",
+			       bdevname(bio->bi_bdev, b),
+			       (unsigned long long)bio->bi_iter.bi_sector);
 			*bio = *(mp_bh->master_bio);
 			bio->bi_iter.bi_sector +=
 				conf->multipaths[mp_bh->path].rdev->data_offset;
@@ -393,8 +391,8 @@ static int multipath_run(struct mddev *mddev)
 		return -EINVAL;
 
 	if (mddev->level != LEVEL_MULTIPATH) {
-		printk("multipath: %s: raid level not set to multipath IO (%d)\n",
-		       mdname(mddev), mddev->level);
+		pr_notice("%s: raid level not set to multipath IO (%d)\n",
+			  mdname(mddev), mddev->level);
 		goto out;
 	}
 	/*
@@ -436,8 +434,7 @@ static int multipath_run(struct mddev *mddev)
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	if (!working_disks) {
-		printk(KERN_ERR "multipath: no operational IO paths for %s\n",
-			mdname(mddev));
+		pr_err("no operational IO paths for %s\n", mdname(mddev));
 		goto free_multipaths;
 	}
 	mddev->degraded = conf->raid_disks - working_disks;
@@ -451,10 +448,10 @@ static int multipath_run(struct mddev *mddev)
 	if (!mddev->thread)
 		goto destroy_pool;
 
-	printk(KERN_INFO
-		"multipath: array %s active with %d out of %d IO paths\n",
-		mdname(mddev), conf->raid_disks - mddev->degraded,
-	       mddev->raid_disks);
+	pr_info("array %s active with %d out of %d IO paths\n",
+		mdname(mddev),
+		conf->raid_disks - mddev->degraded,
+		mddev->raid_disks);
 	/*
 	 * Ok, everything is just fine now
 	 */
-- 
2.10.0

