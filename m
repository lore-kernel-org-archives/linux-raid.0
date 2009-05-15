From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 5/6] md: raid0: Allocate all buffers for the raid0 configuration in one function.
Date: Fri, 15 May 2009 15:18:17 +0200
Message-ID: <1242393498-7528-6-git-send-email-maan@systemlinux.org>
References: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Currently the raid0 configuration is allocated in raid0_run() while
the buffers for the strip_zone and the dev_list arrays are allocated
in create_strip_zones(). On errors, all three buffers are freed
in raid0_run().

It's easier and more readable to do the allocation and cleanup within
a single function. So move that code into create_strip_zones().

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c |   47 +++++++++++++++++------------------------------
 1 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 7f89843..74689ad 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -52,21 +52,18 @@ static int raid0_congested(void *data, int bits)
 	return ret;
 }
 
-static int create_strip_zones (mddev_t *mddev)
+static int create_strip_zones(mddev_t *mddev)
 {
-	int i, c, j;
+	int i, c, j, err;
 	sector_t current_start, curr_zone_start;
-	raid0_conf_t *conf = mddev_to_conf(mddev);
 	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
 	struct strip_zone *zone;
 	int cnt;
 	char b[BDEVNAME_SIZE];
- 
-	/*
-	 * The number of 'same size groups'
-	 */
-	conf->nr_strip_zones = 0;
- 
+	raid0_conf_t *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+
+	if (!conf)
+		return -ENOMEM;
 	list_for_each_entry(rdev1, &mddev->disks, same_set) {
 		printk(KERN_INFO "raid0: looking at %s\n",
 			bdevname(rdev1->bdev,b));
@@ -101,16 +98,16 @@ static int create_strip_zones (mddev_t *mddev)
 		}
 	}
 	printk(KERN_INFO "raid0: FINAL %d zones\n", conf->nr_strip_zones);
-
+	err = -ENOMEM;
 	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
 				conf->nr_strip_zones, GFP_KERNEL);
 	if (!conf->strip_zone)
-		return -ENOMEM;
+		goto abort;
 	conf->devlist = kzalloc(sizeof(mdk_rdev_t*)*
 				conf->nr_strip_zones*mddev->raid_disks,
 				GFP_KERNEL);
 	if (!conf->devlist)
-		return -ENOMEM;
+		goto abort;
 
 	/* The first zone must contain all devices, so here we check that
 	 * there is a proper alignment of slots to devices and find them all
@@ -119,6 +116,7 @@ static int create_strip_zones (mddev_t *mddev)
 	cnt = 0;
 	smallest = NULL;
 	zone->dev = conf->devlist;
+	err = -EINVAL;
 	list_for_each_entry(rdev1, &mddev->disks, same_set) {
 		int j = rdev1->raid_disk;
 
@@ -208,9 +206,14 @@ static int create_strip_zones (mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 
 	printk(KERN_INFO "raid0: done.\n");
+	mddev->private = conf;
 	return 0;
 abort:
-	return -EINVAL;
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
+	kfree(conf);
+	mddev->private = NULL;
+	return err;
 }
 
 /**
@@ -255,7 +258,6 @@ static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 
 static int raid0_run(mddev_t *mddev)
 {
-	raid0_conf_t *conf;
 	int ret;
 
 	if (mddev->chunk_size == 0) {
@@ -270,16 +272,9 @@ static int raid0_run(mddev_t *mddev)
 	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
-	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
-	if (!conf)
-		return -ENOMEM;
-	mddev->private = (void *)conf;
- 
-	conf->strip_zone = NULL;
-	conf->devlist = NULL;
 	ret = create_strip_zones(mddev);
 	if (ret < 0)
-		goto out_free_conf;
+		return ret;
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
@@ -301,16 +296,8 @@ static int raid0_run(mddev_t *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	return 0;
-
-out_free_conf:
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
-	kfree(conf);
-	mddev->private = NULL;
-	return ret;
 }
 
 static int raid0_stop (mddev_t *mddev)
-- 
1.5.4.3

