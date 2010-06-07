From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/16] md/multipath: discard ->working_disks in favour of
	->degraded
Date: Mon, 07 Jun 2010 10:07:55 +1000
Message-ID: <20100607000755.13302.54033.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

conf->working_disks duplicates information already available
in mddev->degraded.
So remove working_disks.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/multipath.c |   22 +++++++++++-----------
 drivers/md/multipath.h |    1 -
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 410fb60..da3654a 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -176,7 +176,7 @@ static void multipath_status (struct seq_file *seq, mddev_t *mddev)
 	int i;
 	
 	seq_printf (seq, " [%d/%d] [", conf->raid_disks,
-						 conf->working_disks);
+		    conf->raid_disks - mddev->degraded);
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf (seq, "%s",
 			       conf->multipaths[i].rdev && 
@@ -217,7 +217,7 @@ static void multipath_error (mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	multipath_conf_t *conf = mddev->private;
 
-	if (conf->working_disks <= 1) {
+	if (conf->raid_disks - mddev->degraded <= 1) {
 		/*
 		 * Uh oh, we can do nothing if this is our last path, but
 		 * first check if this is a queued request for a device
@@ -235,14 +235,13 @@ static void multipath_error (mddev_t *mddev, mdk_rdev_t *rdev)
 			clear_bit(In_sync, &rdev->flags);
 			set_bit(Faulty, &rdev->flags);
 			set_bit(MD_CHANGE_DEVS, &mddev->flags);
-			conf->working_disks--;
 			mddev->degraded++;
 			printk(KERN_ALERT "multipath: IO failure on %s,"
 				" disabling IO path.\n"
 				"multipath: Operation continuing"
 				" on %d IO paths.\n",
 				bdevname (rdev->bdev,b),
-				conf->working_disks);
+				conf->raid_disks - mddev->degraded);
 		}
 	}
 }
@@ -257,7 +256,7 @@ static void print_multipath_conf (multipath_conf_t *conf)
 		printk("(conf==NULL)\n");
 		return;
 	}
-	printk(" --- wd:%d rd:%d\n", conf->working_disks,
+	printk(" --- wd:%d rd:%d\n", conf->raid_disks - conf->mddev->degraded,
 			 conf->raid_disks);
 
 	for (i = 0; i < conf->raid_disks; i++) {
@@ -304,7 +303,6 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 							   PAGE_CACHE_SIZE - 1);
 			}
 
-			conf->working_disks++;
 			mddev->degraded--;
 			rdev->raid_disk = path;
 			set_bit(In_sync, &rdev->flags);
@@ -421,6 +419,7 @@ static int multipath_run (mddev_t *mddev)
 	int disk_idx;
 	struct multipath_info *disk;
 	mdk_rdev_t *rdev;
+	int working_disks;
 
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
@@ -455,7 +454,7 @@ static int multipath_run (mddev_t *mddev)
 		goto out_free_conf;
 	}
 
-	conf->working_disks = 0;
+	working_disks = 0;
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx < 0 ||
@@ -477,7 +476,7 @@ static int multipath_run (mddev_t *mddev)
 		}
 
 		if (!test_bit(Faulty, &rdev->flags))
-			conf->working_disks++;
+			working_disks++;
 	}
 
 	conf->raid_disks = mddev->raid_disks;
@@ -485,12 +484,12 @@ static int multipath_run (mddev_t *mddev)
 	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
-	if (!conf->working_disks) {
+	if (!working_disks) {
 		printk(KERN_ERR "multipath: no operational IO paths for %s\n",
 			mdname(mddev));
 		goto out_free_conf;
 	}
-	mddev->degraded = conf->raid_disks - conf->working_disks;
+	mddev->degraded = conf->raid_disks - working_disks;
 
 	conf->pool = mempool_create_kmalloc_pool(NR_RESERVED_BUFS,
 						 sizeof(struct multipath_bh));
@@ -512,7 +511,8 @@ static int multipath_run (mddev_t *mddev)
 
 	printk(KERN_INFO 
 		"multipath: array %s active with %d out of %d IO paths\n",
-		mdname(mddev), conf->working_disks, mddev->raid_disks);
+		mdname(mddev), conf->raid_disks - mddev->degraded,
+	       mddev->raid_disks);
 	/*
 	 * Ok, everything is just fine now
 	 */
diff --git a/drivers/md/multipath.h b/drivers/md/multipath.h
index d1c2a8d..3c5a45e 100644
--- a/drivers/md/multipath.h
+++ b/drivers/md/multipath.h
@@ -9,7 +9,6 @@ struct multipath_private_data {
 	mddev_t			*mddev;
 	struct multipath_info	*multipaths;
 	int			raid_disks;
-	int			working_disks;
 	spinlock_t		device_lock;
 	struct list_head	retry_list;
 


