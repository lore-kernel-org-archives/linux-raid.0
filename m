From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/28] md: Add support for Raid0->Raid10 takeover
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415062107.5126.14092.stgit@notabene.brown>
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
 drivers/md/raid10.c |  193 ++++++++++++++++++++++++++++++++++++++-------------
 drivers/md/raid10.h |   12 +++
 2 files changed, 154 insertions(+), 51 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 044c115..beab7f6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -23,6 +23,7 @@
 #include <linux/seq_file.h>
 #include "md.h"
 #include "raid10.h"
+#include "raid0.h"
 #include "bitmap.h"
 
 /*
@@ -2141,7 +2142,7 @@ raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	if (!raid_disks)
 		raid_disks = conf->raid_disks;
 	if (!sectors)
-		sectors = mddev->dev_sectors;
+		sectors = conf->dev_sectors;
 
 	size = sectors >> conf->chunk_shift;
 	sector_div(size, conf->far_copies);
@@ -2151,62 +2152,60 @@ raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	return size << conf->chunk_shift;
 }
 
-static int run(mddev_t *mddev)
+
+static conf_t *setup_conf(mddev_t *mddev)
 {
-	conf_t *conf;
-	int i, disk_idx, chunk_size;
-	mirror_info_t *disk;
-	mdk_rdev_t *rdev;
+	conf_t *conf = NULL;
 	int nc, fc, fo;
 	sector_t stride, size;
+	int err = -EINVAL;
 
 	if (mddev->chunk_sectors < (PAGE_SIZE >> 9) ||
 	    !is_power_of_2(mddev->chunk_sectors)) {
 		printk(KERN_ERR "md/raid10: chunk size must be "
 		       "at least PAGE_SIZE(%ld) and be a power of 2.\n", PAGE_SIZE);
-		return -EINVAL;
+		goto out;
 	}
 
 	nc = mddev->layout & 255;
 	fc = (mddev->layout >> 8) & 255;
 	fo = mddev->layout & (1<<16);
+
 	if ((nc*fc) <2 || (nc*fc) > mddev->raid_disks ||
 	    (mddev->layout >> 17)) {
 		printk(KERN_ERR "raid10: %s: unsupported raid10 layout: 0x%8x\n",
 		       mdname(mddev), mddev->layout);
 		goto out;
 	}
-	/*
-	 * copy the already verified devices into our private RAID10
-	 * bookkeeping area. [whatever we allocate in run(),
-	 * should be freed in stop()]
-	 */
+
+	err = -ENOMEM;
 	conf = kzalloc(sizeof(conf_t), GFP_KERNEL);
-	mddev->private = conf;
-	if (!conf) {
-		printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
-			mdname(mddev));
+	if (!conf)
 		goto out;
-	}
+
 	conf->mirrors = kzalloc(sizeof(struct mirror_info)*mddev->raid_disks,
-				 GFP_KERNEL);
-	if (!conf->mirrors) {
-		printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
-		       mdname(mddev));
-		goto out_free_conf;
-	}
+				GFP_KERNEL);
+	if (!conf->mirrors)
+		goto out;
 
 	conf->tmppage = alloc_page(GFP_KERNEL);
 	if (!conf->tmppage)
-		goto out_free_conf;
+		goto out;
+
 
 	conf->raid_disks = mddev->raid_disks;
 	conf->near_copies = nc;
 	conf->far_copies = fc;
 	conf->copies = nc*fc;
 	conf->far_offset = fo;
-	conf->chunk_mask = mddev->chunk_sectors - 1;
-	conf->chunk_shift = ffz(~mddev->chunk_sectors);
+	conf->chunk_mask = mddev->new_chunk_sectors - 1;
+	conf->chunk_shift = ffz(~mddev->new_chunk_sectors);
+
+	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
+					   r10bio_pool_free, conf);
+	if (!conf->r10bio_pool)
+		goto out;
+
 	size = mddev->dev_sectors >> conf->chunk_shift;
 	sector_div(size, fc);
 	size = size * conf->raid_disks;
@@ -2220,7 +2219,8 @@ static int run(mddev_t *mddev)
 	 */
 	stride += conf->raid_disks - 1;
 	sector_div(stride, conf->raid_disks);
-	mddev->dev_sectors = stride << conf->chunk_shift;
+
+	conf->dev_sectors = stride << conf->chunk_shift;
 
 	if (fo)
 		stride = 1;
@@ -2228,18 +2228,63 @@ static int run(mddev_t *mddev)
 		sector_div(stride, fc);
 	conf->stride = stride << conf->chunk_shift;
 
-	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
-						r10bio_pool_free, conf);
-	if (!conf->r10bio_pool) {
-		printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
-			mdname(mddev));
-		goto out_free_conf;
-	}
 
-	conf->mddev = mddev;
 	spin_lock_init(&conf->device_lock);
+	INIT_LIST_HEAD(&conf->retry_list);
+
+	spin_lock_init(&conf->resync_lock);
+	init_waitqueue_head(&conf->wait_barrier);
+
+	conf->thread = md_register_thread(raid10d, mddev, NULL);
+	if (!conf->thread)
+		goto out;
+
+	conf->scale_disks = 0;
+	conf->mddev = mddev;
+	return conf;
+
+ out:
+	printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
+	       mdname(mddev));
+	if (conf) {
+		if (conf->r10bio_pool)
+			mempool_destroy(conf->r10bio_pool);
+		kfree(conf->mirrors);
+		safe_put_page(conf->tmppage);
+		kfree(conf);
+	}
+	return ERR_PTR(err);
+}
+
+static int run(mddev_t *mddev)
+{
+	conf_t *conf;
+	int i, disk_idx, chunk_size;
+	mirror_info_t *disk;
+	mdk_rdev_t *rdev;
+	sector_t size;
+
+	/*
+	 * copy the already verified devices into our private RAID10
+	 * bookkeeping area. [whatever we allocate in run(),
+	 * should be freed in stop()]
+	 */
+
+	if (mddev->private == NULL) {
+		conf = setup_conf(mddev);
+		if (IS_ERR(conf))
+			return PTR_ERR(conf);
+		mddev->private = conf;
+	}
+	conf = mddev->private;
+	if (!conf)
+		goto out;
+
 	mddev->queue->queue_lock = &conf->device_lock;
 
+	mddev->thread = conf->thread;
+	conf->thread = NULL;
+
 	chunk_size = mddev->chunk_sectors << 9;
 	blk_queue_io_min(mddev->queue, chunk_size);
 	if (conf->raid_disks % conf->near_copies)
@@ -2253,6 +2298,11 @@ static int run(mddev_t *mddev)
 		if (disk_idx >= conf->raid_disks
 		    || disk_idx < 0)
 			continue;
+		if (conf->scale_disks) {
+			disk_idx *= conf->scale_disks;
+			rdev->raid_disk = disk_idx;
+			/* MOVE 'rd%d' link !! */
+		}
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
@@ -2270,11 +2320,6 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
-	INIT_LIST_HEAD(&conf->retry_list);
-
-	spin_lock_init(&conf->resync_lock);
-	init_waitqueue_head(&conf->wait_barrier);
-
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf)) {
 		printk(KERN_ERR "raid10: not enough operational mirrors for %s\n",
@@ -2296,15 +2341,6 @@ static int run(mddev_t *mddev)
 		}
 	}
 
-
-	mddev->thread = md_register_thread(raid10d, mddev, NULL);
-	if (!mddev->thread) {
-		printk(KERN_ERR
-		       "raid10: couldn't allocate thread for %s\n",
-		       mdname(mddev));
-		goto out_free_conf;
-	}
-
 	if (mddev->recovery_cp != MaxSector)
 		printk(KERN_NOTICE "raid10: %s is not clean"
 		       " -- starting background reconstruction\n",
@@ -2316,8 +2352,9 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	md_set_array_sectors(mddev, raid10_size(mddev, 0, 0));
-	mddev->resync_max_sectors = raid10_size(mddev, 0, 0);
+	mddev->dev_sectors = conf->dev_sectors;
+	size = raid10_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, size);
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid10_congested;
@@ -2347,6 +2384,7 @@ out_free_conf:
 	kfree(conf->mirrors);
 	kfree(conf);
 	mddev->private = NULL;
+	md_unregister_thread(mddev->thread);
 out:
 	return -EIO;
 }
@@ -2383,6 +2421,58 @@ static void raid10_quiesce(mddev_t *mddev, int state)
 	}
 }
 
+static void *raid10_takeover_raid0(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	conf_t *conf;
+
+	if (mddev->degraded > 0) {
+		printk(KERN_ERR "error: degraded raid0!\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* Update slot numbers to obtain
+	 * degraded raid10 with missing mirrors
+	 */
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		rdev->raid_disk *= 2;
+	}
+
+	/* Set new parameters */
+	mddev->new_level = 10;
+	/* new layout: far_copies = 1, near_copies = 2 */
+	mddev->new_layout = (1<<8) + 2;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
+	mddev->delta_disks = mddev->raid_disks;
+	mddev->degraded = mddev->raid_disks;
+	mddev->raid_disks *= 2;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	conf = setup_conf(mddev);
+	conf->scale_disks = 2;
+	return conf;
+}
+
+static void *raid10_takeover(mddev_t *mddev)
+{
+	struct raid0_private_data *raid0_priv;
+
+	/* raid10 can take over:
+	 *  raid0 - providing it has only two drives
+	 */
+	if (mddev->level == 0) {
+		/* for raid0 takeover only one zone is supported */
+		raid0_priv = mddev->private;
+		if (raid0_priv->nr_strip_zones > 1) {
+			printk(KERN_ERR "md: cannot takeover raid 0 with more than one zone.\n");
+			return ERR_PTR(-EINVAL);
+		}
+		return raid10_takeover_raid0(mddev);
+	}
+	return ERR_PTR(-EINVAL);
+}
+
 static struct mdk_personality raid10_personality =
 {
 	.name		= "raid10",
@@ -2399,6 +2489,7 @@ static struct mdk_personality raid10_personality =
 	.sync_request	= sync_request,
 	.quiesce	= raid10_quiesce,
 	.size		= raid10_size,
+	.takeover	= raid10_takeover,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 59cd1ef..3824a08 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -33,9 +33,16 @@ struct r10_private_data_s {
 					       * 1 stripe.
 					       */
 
+	sector_t		dev_sectors;  /* temp copy of mddev->dev_sectors */
+
 	int chunk_shift; /* shift from chunks to sectors */
 	sector_t chunk_mask;
 
+	int			scale_disks;  /* When starting array, multiply
+					       * each ->raid_disk by this.
+					       * Need for raid0->raid10 migration
+					       */
+
 	struct list_head	retry_list;
 	/* queue pending writes and submit them on unplug */
 	struct bio_list		pending_bio_list;
@@ -57,6 +64,11 @@ struct r10_private_data_s {
 	mempool_t *r10bio_pool;
 	mempool_t *r10buf_pool;
 	struct page		*tmppage;
+
+	/* When taking over an array from a different personality, we store
+	 * the new thread here until we fully activate the array.
+	 */
+	struct mdk_thread_s	*thread;
 };
 
 typedef struct r10_private_data_s conf_t;


