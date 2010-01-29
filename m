From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 2/3] md: Add support for Raid5->Raid0 and Raid10->Raid0
 takeover
Date: Fri, 29 Jan 2010 14:54:10 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01D16227@irsmsx002.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid0.c |  161 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 158 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 77605cd..410d4e9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -22,6 +22,7 @@
 #include <linux/seq_file.h>
 #include "md.h"
 #include "raid0.h"
+#include "raid5.h"
 
 static void raid0_unplug(struct request_queue *q)
 {
@@ -328,9 +329,13 @@ static int raid0_run(mddev_t *mddev)
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
-	ret = create_strip_zones(mddev);
-	if (ret < 0)
-		return ret;
+	/* if private is not null, we are here after takeover */
+	if (mddev->private == NULL)
+	{
+		ret = create_strip_zones(mddev);
+		if (ret < 0)
+			return ret;
+	} 
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
@@ -542,6 +547,154 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 	return;
 }
 
+static raid0_conf_t *setup_conf(mddev_t *mddev)
+{
+	raid0_conf_t *conf;
+	mdk_rdev_t *rdev, **dev;
+	struct strip_zone *zone;
+	int cnt;
+
+	if (mddev->new_level != 0)
+		return ERR_PTR(-EIO);
+	
+	conf = kzalloc(sizeof(raid0_conf_t), GFP_KERNEL);
+	if (conf == NULL)
+		goto abort;
+	
+	conf->nr_strip_zones = 1;		
+	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
+							   conf->nr_strip_zones, GFP_KERNEL);
+	if (!conf->strip_zone)
+		goto abort;
+	
+	conf->devlist = kzalloc(sizeof(mdk_rdev_t*)*
+							conf->nr_strip_zones*mddev->raid_disks,
+							GFP_KERNEL);
+	if (!conf->devlist)
+		goto abort;
+	
+	/* The first zone must contain all devices, so here we check that
+	 * there is a proper alignment of slots to devices and find them all
+	 */
+	zone = &conf->strip_zone[0];
+	dev = conf->devlist;
+	zone->dev_start = 0;
+	cnt = 0;
+
+	/* initialize device list */
+	list_for_each_entry(rdev, &mddev->disks, same_set) {	
+		dev[cnt] = rdev;
+		cnt++;
+	}
+	
+	if (cnt != mddev->raid_disks) {
+		printk(KERN_ERR "raid0: too few disks (%d of %d) - "
+			   "aborting!\n", cnt, mddev->raid_disks);
+		goto abort;
+	}
+	zone->nb_dev = cnt;
+	zone->zone_end = mddev->array_sectors;
+	return conf;
+
+ abort:
+	if (conf) {
+	        kfree(conf->strip_zone);
+		kfree(conf->devlist);
+		kfree(conf);
+		return ERR_PTR(-EIO);
+	} else
+		return ERR_PTR(-ENOMEM);
+}
+
+static void *raid0_takeover_raid5(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+
+	if (mddev->degraded != 1) {
+		printk("error: raid5 must be degraded! Degraded disks: %d\n", 
+			   mddev->degraded);
+		return ERR_PTR(-EINVAL);
+	}
+	
+	list_for_each_entry(rdev, &mddev->disks, same_set) {	
+		/* check slot number for a disk */
+		if (rdev->raid_disk == mddev->raid_disks-1) {
+		    printk("error: raid5 must have missing parity disk!\n");
+		    return ERR_PTR(-EINVAL);		  
+		}
+	}
+
+	/* Set new parameters */
+	mddev->new_level = 0;
+	mddev->degraded = 0;
+	mddev->raid_disks--;
+	mddev->delta_disks = -1;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	return setup_conf(mddev);
+}
+
+static void *raid0_takeover_raid10(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+
+	/* Check layout: 
+	 *  assuming that far_copies is 1 and disks number is even 
+	 *  also all mirrors must be already degraded
+	 */
+	if ((mddev->layout >> 8) != 1) {
+	    printk(KERN_ERR "error: Raid0 cannot takover layout: %x\n", mddev->layout);
+		return ERR_PTR(-EINVAL);
+	}
+	if (mddev->raid_disks & 1) {
+	    printk(KERN_ERR "error: Raid0 cannot takover Raid10 with odd disk number.\n");
+		return ERR_PTR(-EINVAL);
+	}
+	if (mddev->degraded != (mddev->raid_disks>>1)) {
+	    printk(KERN_ERR "error: All mirrors must be already degraded!\n");
+		return ERR_PTR(-EINVAL);
+	}
+	
+	/* Set new parameters */
+	mddev->new_level = 0;
+	mddev->raid_disks -= mddev->degraded;
+	mddev->delta_disks = -mddev->degraded;
+	mddev->degraded = 0;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	list_for_each_entry(rdev, &mddev->disks, same_set) {	
+		rdev->raid_disk /= 2;
+	}
+
+	return setup_conf(mddev);
+}
+
+static void *raid0_takeover(mddev_t *mddev)
+{
+	/* raid0 can take over:
+	 *  raid5 - providing it is Raid4 layout and one disk is faulty
+	 *  raid10 - assuming we have all necessary active disks
+	 */
+	if (mddev->level == 5) {
+	    if (mddev->layout == ALGORITHM_PARITY_N) {
+	        return raid0_takeover_raid5(mddev);	
+		}
+	    printk("Error: Raid can only takeover Raid5 with layout: %d\n", 
+			   ALGORITHM_PARITY_N);
+	}
+	
+	if (mddev->level == 10)
+	    return raid0_takeover_raid10(mddev);
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
@@ -552,6 +705,8 @@ static struct mdk_personality raid0_personality=
 	.stop		= raid0_stop,
 	.status		= raid0_status,
 	.size		= raid0_size,
+	.takeover	= raid0_takeover,	
+	.quiesce	= raid0_quiesce,
 };
 
 static int __init raid0_init (void)
-- 
1.6.3.3



