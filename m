From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [PATCH 2/3] md: Add support for Raid5->Raid0 and Raid10->Raid0
 takeover
Date: Wed, 3 Feb 2010 12:10:45 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01DCD36F@irsmsx002.ger.corp.intel.com>
References: <F2A46F4A087B8547923AD59C289DC90E01D16227@irsmsx002.ger.corp.intel.com>
 <20100201110549.162aa9f5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100201110549.162aa9f5@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids


> You assume here that near_copies is 2, but you never check for that.
> 

Fixed.

> Also - and this applies to raid5 and raid10 - the devices may not be
> all the
> same size.  raid5 and raid10 will just use the size of the smallest
> device,
> but raid0 won't.  For for a seamless conversion, you need to handle the
> case
> that the devices are not the same size.  Either disallow that case, or
> make
> use of the extra space.
> 

I've removed setup_conf() from the original patch.
Now raid0 reuses create_strip_zones() when takeovering from Raid5 and from Raid10,
so multiply zones are supported.
Is it the right solution for the second problem?

Thanks,
Maciek Trela.


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid0.c |  116 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 111 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 77605cd..35d1869 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -22,6 +22,7 @@
 #include <linux/seq_file.h>
 #include "md.h"
 #include "raid0.h"
+#include "raid5.h"
 
 static void raid0_unplug(struct request_queue *q)
 {
@@ -87,7 +88,7 @@ static void dump_zones(mddev_t *mddev)
 	printk(KERN_INFO "**********************************\n\n");
 }
 
-static int create_strip_zones(mddev_t *mddev)
+static int create_strip_zones(mddev_t *mddev, void** private_conf)
 {
 	int i, c, err;
 	sector_t curr_zone_end, sectors;
@@ -260,7 +261,9 @@ static int create_strip_zones(mddev_t *mddev)
 			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
 
 	printk(KERN_INFO "raid0: done.\n");
-	mddev->private = conf;
+	if (private_conf)
+		*private_conf = conf;
+
 	return 0;
 abort:
 	kfree(conf->strip_zone);
@@ -328,9 +331,13 @@ static int raid0_run(mddev_t *mddev)
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
-	ret = create_strip_zones(mddev);
-	if (ret < 0)
-		return ret;
+	/* if private is not null, we are here after takeover */
+	if (mddev->private == NULL)
+	{
+		ret = create_strip_zones(mddev, &mddev->private);
+		if (ret < 0)
+			return ret;
+	} 
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
@@ -542,6 +549,103 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 	return;
 }
 
+static void *raid0_takeover_raid5(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	raid0_conf_t *priv_conf;
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
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
+	mddev->degraded = 0;
+	mddev->raid_disks--;
+	mddev->delta_disks = -1;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	create_strip_zones(mddev, (void**)&priv_conf);
+	return priv_conf;
+}
+
+static void *raid0_takeover_raid10(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	raid0_conf_t *priv_conf;
+
+	/* Check layout: 
+	 *  - far_copies must be 1
+	 *  - near_copies must be 2
+	 *  - disks number must be even 
+	 *  - all mirrors must be already degraded
+	 */
+	if (mddev->layout != ((1 << 8) + 2)) {
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
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
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
+	create_strip_zones(mddev, (void**)&priv_conf);
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
@@ -552,6 +656,8 @@ static struct mdk_personality raid0_personality=
 	.stop		= raid0_stop,
 	.status		= raid0_status,
 	.size		= raid0_size,
+	.takeover	= raid0_takeover,	
+	.quiesce	= raid0_quiesce,
 };
 
 static int __init raid0_init (void)
-- 
1.6.3.3

