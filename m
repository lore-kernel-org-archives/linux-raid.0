From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 4/4] md: linear: Make array_size sector-based and rename it to array_sectors.
Date: Fri, 18 Jul 2008 14:00:19 +0200
Message-ID: <1216382419-2560-5-git-send-email-maan@systemlinux.org>
References: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c         |   16 ++++++++--------
 include/linux/raid/linear.h |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 57644a7..1cafaa9 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -120,7 +120,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		return NULL;
 
 	cnt = 0;
-	conf->array_size = 0;
+	conf->array_sectors = 0;
 
 	rdev_for_each(rdev, tmp, mddev) {
 		int j = rdev->raid_disk;
@@ -144,7 +144,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->size = rdev->size;
-		conf->array_size += rdev->size;
+		conf->array_sectors += rdev->size * 2;
 
 		cnt++;
 	}
@@ -153,7 +153,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		goto out;
 	}
 
-	min_spacing = conf->array_size;
+	min_spacing = conf->array_sectors / 2;
 	sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
 
 	/* min_spacing is the minimum spacing that will fit the hash
@@ -162,7 +162,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	 * that is larger than min_spacing as use the size of that as
 	 * the actual spacing
 	 */
-	conf->hash_spacing = conf->array_size;
+	conf->hash_spacing = conf->array_sectors / 2;
 	for (i=0; i < cnt-1 ; i++) {
 		sector_t sz = 0;
 		int j;
@@ -192,7 +192,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		unsigned round;
 		unsigned long base;
 
-		sz = conf->array_size >> conf->preshift;
+		sz = conf->array_sectors >> (conf->preshift + 1);
 		sz += 1; /* force round-up */
 		base = conf->hash_spacing >> conf->preshift;
 		round = sector_div(sz, base);
@@ -219,7 +219,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	curr_offset = 0;
 	i = 0;
 	for (curr_offset = 0;
-	     curr_offset < conf->array_size;
+	     curr_offset < conf->array_sectors / 2;
 	     curr_offset += conf->hash_spacing) {
 
 		while (i < raid_disks-1 &&
@@ -256,7 +256,7 @@ static int linear_run (mddev_t *mddev)
 	if (!conf)
 		return 1;
 	mddev->private = conf;
-	mddev->array_sectors = conf->array_size * 2;
+	mddev->array_sectors = conf->array_sectors;
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
@@ -290,7 +290,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	newconf->prev = mddev_to_conf(mddev);
 	mddev->private = newconf;
 	mddev->raid_disks++;
-	mddev->array_sectors = newconf->array_size * 2;
+	mddev->array_sectors = newconf->array_sectors;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	return 0;
 }
diff --git a/include/linux/raid/linear.h b/include/linux/raid/linear.h
index ba15469..7e37511 100644
--- a/include/linux/raid/linear.h
+++ b/include/linux/raid/linear.h
@@ -16,7 +16,7 @@ struct linear_private_data
 	struct linear_private_data *prev;	/* earlier version */
 	dev_info_t		**hash_table;
 	sector_t		hash_spacing;
-	sector_t		array_size;
+	sector_t		array_sectors;
 	int			preshift; /* shift before dividing by hash_spacing */
 	dev_info_t		disks[0];
 };
-- 
1.5.3.8

