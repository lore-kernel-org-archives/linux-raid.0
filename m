From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/28] md: Add support for Raid5->Raid0 and Raid10->Raid0
	takeover
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415062107.5126.27519.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Maciej Trela <maciej.trela@intel.com>
List-Id: linux-raid.ids

From: Trela, Maciej <Maciej.Trela@intel.com>

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |    7 +++
 drivers/md/raid0.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid0.h |    3 +
 3 files changed, 129 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ccfbd4a..be16462 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3000,6 +3000,13 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	mddev->layout = mddev->new_layout;
 	mddev->chunk_sectors = mddev->new_chunk_sectors;
 	mddev->delta_disks = 0;
+	if (mddev->pers->sync_request == NULL) {
+		/* this is now an array without redundancy, so
+		 * it must always be in_sync
+		 */
+		mddev->in_sync = 1;
+		del_timer_sync(&mddev->safemode_timer);
+	}
 	pers->run(mddev);
 	mddev_resume(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c2e0d1d..afddf62 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -22,6 +22,7 @@
 #include <linux/seq_file.h>
 #include "md.h"
 #include "raid0.h"
+#include "raid5.h"
 
 static void raid0_unplug(struct request_queue *q)
 {
@@ -90,7 +91,7 @@ static void dump_zones(mddev_t *mddev)
 	printk(KERN_INFO "**********************************\n\n");
 }
 
-static int create_strip_zones(mddev_t *mddev)
+static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
 {
 	int i, c, err;
 	sector_t curr_zone_end, sectors;
@@ -164,6 +165,10 @@ static int create_strip_zones(mddev_t *mddev)
 	list_for_each_entry(rdev1, &mddev->disks, same_set) {
 		int j = rdev1->raid_disk;
 
+		if (mddev->level == 10)
+			/* taking over a raid10-n2 array */
+			j /= 2;
+
 		if (j < 0 || j >= mddev->raid_disks) {
 			printk(KERN_ERR "raid0: bad disk number %d - "
 				"aborting!\n", j);
@@ -264,13 +269,14 @@ static int create_strip_zones(mddev_t *mddev)
 			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
 
 	printk(KERN_INFO "raid0: done.\n");
-	mddev->private = conf;
+	*private_conf = conf;
+
 	return 0;
 abort:
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	mddev->private = NULL;
+	*private_conf = NULL;
 	return err;
 }
 
@@ -321,6 +327,7 @@ static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 
 static int raid0_run(mddev_t *mddev)
 {
+	raid0_conf_t *conf;
 	int ret;
 
 	if (mddev->chunk_sectors == 0) {
@@ -332,9 +339,20 @@ static int raid0_run(mddev_t *mddev)
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
-	ret = create_strip_zones(mddev);
-	if (ret < 0)
-		return ret;
+	/* if private is not null, we are here after takeover */
+	if (mddev->private == NULL) {
+		ret = create_strip_zones(mddev, &conf);
+		if (ret < 0)
+			return ret;
+		mddev->private = conf;
+	}
+	conf = mddev->private;
+	if (conf->scale_raid_disks) {
+		int i;
+		for (i=0; i < conf->strip_zone[0].nb_dev; i++)
+			conf->devlist[i]->raid_disk /= conf->scale_raid_disks;
+		/* FIXME update sysfs rd links */
+	}
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
@@ -548,6 +566,99 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 	return;
 }
 
+static void *raid0_takeover_raid5(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	raid0_conf_t *priv_conf;
+
+	if (mddev->degraded != 1) {
+		printk(KERN_ERR "md: raid5 must be degraded! Degraded disks: %d\n",
+		       mddev->degraded);
+		return ERR_PTR(-EINVAL);
+	}
+
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		/* check slot number for a disk */
+		if (rdev->raid_disk == mddev->raid_disks-1) {
+			printk(KERN_ERR "md: raid5 must have missing parity disk!\n");
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	/* Set new parameters */
+	mddev->new_level = 0;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
+	mddev->raid_disks--;
+	mddev->delta_disks = -1;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	create_strip_zones(mddev, &priv_conf);
+	return priv_conf;
+}
+
+static void *raid0_takeover_raid10(mddev_t *mddev)
+{
+	raid0_conf_t *priv_conf;
+
+	/* Check layout:
+	 *  - far_copies must be 1
+	 *  - near_copies must be 2
+	 *  - disks number must be even
+	 *  - all mirrors must be already degraded
+	 */
+	if (mddev->layout != ((1 << 8) + 2)) {
+		printk(KERN_ERR "md: Raid0 cannot takover layout: %x\n",
+		       mddev->layout);
+		return ERR_PTR(-EINVAL);
+	}
+	if (mddev->raid_disks & 1) {
+		printk(KERN_ERR "md: Raid0 cannot takover Raid10 with odd disk number.\n");
+		return ERR_PTR(-EINVAL);
+	}
+	if (mddev->degraded != (mddev->raid_disks>>1)) {
+		printk(KERN_ERR "md: All mirrors must be already degraded!\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* Set new parameters */
+	mddev->new_level = 0;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
+	mddev->delta_disks = - mddev->raid_disks / 2;
+	mddev->raid_disks += mddev->delta_disks;
+	mddev->degraded = 0;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	create_strip_zones(mddev, &priv_conf);
+	priv_conf->scale_raid_disks = 2;
+	return priv_conf;
+}
+
+static void *raid0_takeover(mddev_t *mddev)
+{
+	/* raid0 can take over:
+	 *  raid5 - providing it is Raid4 layout and one disk is faulty
+	 *  raid10 - assuming we have all necessary active disks
+	 */
+	if (mddev->level == 5) {
+		if (mddev->layout == ALGORITHM_PARITY_N)
+			return raid0_takeover_raid5(mddev);
+
+		printk(KERN_ERR "md: Raid can only takeover Raid5 with layout: %d\n",
+		       ALGORITHM_PARITY_N);
+	}
+
+	if (mddev->level == 10)
+		return raid0_takeover_raid10(mddev);
+
+	return ERR_PTR(-EINVAL);
+}
+
+static void raid0_quiesce(mddev_t *mddev, int state)
+{
+}
+
 static struct mdk_personality raid0_personality=
 {
 	.name		= "raid0",
@@ -558,6 +669,8 @@ static struct mdk_personality raid0_personality=
 	.stop		= raid0_stop,
 	.status		= raid0_status,
 	.size		= raid0_size,
+	.takeover	= raid0_takeover,
+	.quiesce	= raid0_quiesce,
 };
 
 static int __init raid0_init (void)
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 91f8e87..d724e66 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -13,6 +13,9 @@ struct raid0_private_data
 	struct strip_zone *strip_zone;
 	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
+	int scale_raid_disks; /* divide rdev->raid_disks by this in run()
+			       * to handle conversion from raid10
+			       */
 };
 
 typedef struct raid0_private_data raid0_conf_t;


