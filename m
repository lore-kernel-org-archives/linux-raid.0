From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/16] md: make error_handler functions more uniform and
	correct.
Date: Mon, 07 Jun 2010 10:07:55 +1000
Message-ID: <20100607000755.13302.33181.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

- there is no need to test_bit Faulty, as that was already done in
  md_error which is the only caller of these functions.
- MD_CHANGE_DEVS should be set *after* faulty is set to ensure
  metadata is updated correctly.
- spinlock should be held while updating ->degraded.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/multipath.c |   40 ++++++++++++++++++++++------------------
 drivers/md/raid5.c     |   40 +++++++++++++++++++---------------------
 2 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index da3654a..5ec4ca7 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -216,6 +216,7 @@ static int multipath_congested(void *data, int bits)
 static void multipath_error (mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	multipath_conf_t *conf = mddev->private;
+	char b[BDEVNAME_SIZE];
 
 	if (conf->raid_disks - mddev->degraded <= 1) {
 		/*
@@ -224,26 +225,27 @@ static void multipath_error (mddev_t *mddev, mdk_rdev_t *rdev)
 		 * which has just failed.
 		 */
 		printk(KERN_ALERT 
-			"multipath: only one IO path left and IO error.\n");
+		       "multipath: only one IO path left and IO error.\n");
 		/* leave it active... it's all we have */
-	} else {
-		/*
-		 * Mark disk as unusable
-		 */
-		if (!test_bit(Faulty, &rdev->flags)) {
-			char b[BDEVNAME_SIZE];
-			clear_bit(In_sync, &rdev->flags);
-			set_bit(Faulty, &rdev->flags);
-			set_bit(MD_CHANGE_DEVS, &mddev->flags);
-			mddev->degraded++;
-			printk(KERN_ALERT "multipath: IO failure on %s,"
-				" disabling IO path.\n"
-				"multipath: Operation continuing"
-				" on %d IO paths.\n",
-				bdevname (rdev->bdev,b),
-				conf->raid_disks - mddev->degraded);
-		}
+		return;
+	}
+	/*
+	 * Mark disk as unusable
+	 */
+	if (test_and_clear_bit(In_sync, &rdev->flags)) {
+		unsigned long flags;
+		spin_lock_irqsave(&conf->device_lock, flags);
+		mddev->degraded++;
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
+	set_bit(Faulty, &rdev->flags);
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	printk(KERN_ALERT "multipath: IO failure on %s,"
+	       " disabling IO path.\n"
+	       "multipath: Operation continuing"
+	       " on %d IO paths.\n",
+	       bdevname(rdev->bdev, b),
+	       conf->raid_disks - mddev->degraded);
 }
 
 static void print_multipath_conf (multipath_conf_t *conf)
@@ -303,9 +305,11 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 							   PAGE_CACHE_SIZE - 1);
 			}
 
+			spin_lock_irq(&conf->device_lock);
 			mddev->degraded--;
 			rdev->raid_disk = path;
 			set_bit(In_sync, &rdev->flags);
+			spin_unlock_irq(&conf->device_lock);
 			rcu_assign_pointer(p->rdev, rdev);
 			err = 0;
 			md_integrity_add_rdev(rdev, mddev);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5ec9792..6fb36d8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1626,28 +1626,26 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	raid5_conf_t *conf = mddev->private;
 	pr_debug("raid456: error called\n");
 
-	if (!test_bit(Faulty, &rdev->flags)) {
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
-		if (test_and_clear_bit(In_sync, &rdev->flags)) {
-			unsigned long flags;
-			spin_lock_irqsave(&conf->device_lock, flags);
-			mddev->degraded++;
-			spin_unlock_irqrestore(&conf->device_lock, flags);
-			/*
-			 * if recovery was running, make sure it aborts.
-			 */
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		}
-		set_bit(Faulty, &rdev->flags);
-		printk(KERN_ALERT
-		       "md/raid:%s: Disk failure on %s, disabling device.\n"
-		       KERN_ALERT
-		       "md/raid:%s: Operation continuing on %d devices.\n",
-		       mdname(mddev),
-		       bdevname(rdev->bdev, b),
-		       mdname(mddev),
-		       conf->raid_disks - mddev->degraded);
+	if (test_and_clear_bit(In_sync, &rdev->flags)) {
+		unsigned long flags;
+		spin_lock_irqsave(&conf->device_lock, flags);
+		mddev->degraded++;
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+		/*
+		 * if recovery was running, make sure it aborts.
+		 */
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	}
+	set_bit(Faulty, &rdev->flags);
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	printk(KERN_ALERT
+	       "md/raid:%s: Disk failure on %s, disabling device.\n"
+	       KERN_ALERT
+	       "md/raid:%s: Operation continuing on %d devices.\n",
+	       mdname(mddev),
+	       bdevname(rdev->bdev, b),
+	       mdname(mddev),
+	       conf->raid_disks - mddev->degraded);
 }
 
 /*


