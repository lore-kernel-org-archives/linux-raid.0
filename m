From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 8 of 8 - Support reshaping raid1 arrays - adding or removing drives.
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BTb7N-0002U9-H3@notabene.cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This allows the number of "raid_disks" in a raid1 to be changed.

This requires allocating a new pool of "r1bio" structures which a different
number of bios, suspending IO, and swapping the new pool in place of the old.
(and a few other related changes).

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   31 +++++++-
 ./drivers/md/raid1.c        |  163 ++++++++++++++++++++++++++++++++++----------
 ./include/linux/raid/md_k.h |    1 
 3 files changed, 156 insertions(+), 39 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-05-28 16:29:57.000000000 +1000
+++ ./drivers/md/md.c	2004-05-28 16:29:57.000000000 +1000
@@ -2422,18 +2422,23 @@ static int set_array_info(mddev_t * mdde
 static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 {
 	int rv = 0;
+	int cnt = 0;
 
 	if (mddev->major_version != info->major_version ||
 	    mddev->minor_version != info->minor_version ||
 /*	    mddev->patch_version != info->patch_version || */
 	    mddev->ctime         != info->ctime         ||
 	    mddev->level         != info->level         ||
-	    mddev->raid_disks    != info->raid_disks    ||
 	    mddev->layout        != info->layout        ||
 	    !mddev->persistent	 != info->not_persistent||
 	    mddev->chunk_size    != info->chunk_size    )
 		return -EINVAL;
-	/* that leaves only size */
+	/* Check there is only one change */
+	if (mddev->size != info->size) cnt++;
+	if (mddev->raid_disks != info->raid_disks) cnt++;
+	if (cnt == 0) return 0;
+	if (cnt > 1) return -EINVAL;
+
 	if (mddev->size != info->size) {
 		mdk_rdev_t * rdev;
 		struct list_head *tmp;
@@ -2477,6 +2482,28 @@ static int update_array_info(mddev_t *md
 			}
 		}
 	}
+	if (mddev->raid_disks    != info->raid_disks) {
+		/* change the number of raid disks */
+		if (mddev->pers->reshape == NULL)
+			return -EINVAL;
+		if (info->raid_disks <= 0 ||
+		    info->raid_disks >= mddev->max_disks)
+			return -EINVAL;
+		if (mddev->sync_thread)
+			return -EBUSY;
+		rv = mddev->pers->reshape(mddev, info->raid_disks);
+		if (!rv) {
+			struct block_device *bdev;
+
+			bdev = bdget_disk(mddev->gendisk, 0);
+			if (bdev) {
+				down(&bdev->bd_inode->i_sem);
+				i_size_write(bdev->bd_inode, mddev->array_size << 10);
+				up(&bdev->bd_inode->i_sem);
+				bdput(bdev);
+			}
+		}
+	}
 	md_update_sb(mddev);
 	return rv;
 }

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-05-28 16:29:57.000000000 +1000
+++ ./drivers/md/raid1.c	2004-05-28 16:29:57.000000000 +1000
@@ -42,16 +42,17 @@ static void unplug_slaves(mddev_t *mddev
 
 static void * r1bio_pool_alloc(int gfp_flags, void *data)
 {
-	mddev_t *mddev = data;
+	struct pool_info *pi = data;
 	r1bio_t *r1_bio;
 
 	/* allocate a r1bio with room for raid_disks entries in the bios array */
-	r1_bio = kmalloc(sizeof(r1bio_t) + sizeof(struct bio*)*mddev->raid_disks,
+	r1_bio = kmalloc(sizeof(r1bio_t) + sizeof(struct bio*)*pi->raid_disks,
 			 gfp_flags);
 	if (r1_bio)
-		memset(r1_bio, 0, sizeof(*r1_bio) + sizeof(struct bio*)*mddev->raid_disks);
+		memset(r1_bio, 0, sizeof(*r1_bio) + 
+			       sizeof(struct bio*) * pi->raid_disks);
 	else
-		unplug_slaves(mddev);
+		unplug_slaves(pi->mddev);
 
 	return r1_bio;
 }
@@ -69,22 +70,22 @@ static void r1bio_pool_free(void *r1_bio
 
 static void * r1buf_pool_alloc(int gfp_flags, void *data)
 {
-	conf_t *conf = data;
+	struct pool_info *pi = data;
 	struct page *page;
 	r1bio_t *r1_bio;
 	struct bio *bio;
 	int i, j;
 
-	r1_bio = r1bio_pool_alloc(gfp_flags, conf->mddev);
+	r1_bio = r1bio_pool_alloc(gfp_flags, pi);
 	if (!r1_bio) {
-		unplug_slaves(conf->mddev);
+		unplug_slaves(pi->mddev);
 		return NULL;
 	}
 
 	/*
 	 * Allocate bios : 1 for reading, n-1 for writing
 	 */
-	for (j = conf->raid_disks ; j-- ; ) {
+	for (j = pi->raid_disks ; j-- ; ) {
 		bio = bio_alloc(gfp_flags, RESYNC_PAGES);
 		if (!bio)
 			goto out_free_bio;
@@ -111,16 +112,16 @@ out_free_pages:
 	for ( ; i > 0 ; i--)
 		__free_page(bio->bi_io_vec[i-1].bv_page);
 out_free_bio:
-	while ( ++j < conf->raid_disks )
+	while ( ++j < pi->raid_disks )
 		bio_put(r1_bio->bios[j]);
-	r1bio_pool_free(r1_bio, conf->mddev);
+	r1bio_pool_free(r1_bio, data);
 	return NULL;
 }
 
 static void r1buf_pool_free(void *__r1_bio, void *data)
 {
+	struct pool_info *pi = data;
 	int i;
-	conf_t *conf = data;
 	r1bio_t *r1bio = __r1_bio;
 	struct bio *bio = r1bio->bios[0];
 
@@ -128,10 +129,10 @@ static void r1buf_pool_free(void *__r1_b
 		__free_page(bio->bi_io_vec[i].bv_page);
 		bio->bi_io_vec[i].bv_page = NULL;
 	}
-	for (i=0 ; i < conf->raid_disks; i++)
+	for (i=0 ; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
 
-	r1bio_pool_free(r1bio, conf->mddev);
+	r1bio_pool_free(r1bio, data);
 }
 
 static void put_all_bios(conf_t *conf, r1bio_t *r1_bio)
@@ -536,7 +537,7 @@ static int make_request(request_queue_t 
 	mirror_info_t *mirror;
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
-	int i, disks = conf->raid_disks;
+	int i, disks;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -596,6 +597,7 @@ static int make_request(request_queue_t 
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
 	 */
+	disks = conf->raid_disks;
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0;  i < disks; i++) {
 		if (conf->mirrors[i].rdev &&
@@ -979,7 +981,8 @@ static int init_resync(conf_t *conf)
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
 	if (conf->r1buf_pool)
 		BUG();
-	conf->r1buf_pool = mempool_create(buffs, r1buf_pool_alloc, r1buf_pool_free, conf);
+	conf->r1buf_pool = mempool_create(buffs, r1buf_pool_alloc, r1buf_pool_free,
+					  conf->poolinfo);
 	if (!conf->r1buf_pool)
 		return -ENOMEM;
 	conf->next_resync = 0;
@@ -1162,28 +1165,28 @@ static int run(mddev_t *mddev)
 	 */
 	conf = kmalloc(sizeof(conf_t), GFP_KERNEL);
 	mddev->private = conf;
-	if (!conf) {
-		printk(KERN_ERR "raid1: couldn't allocate memory for %s\n",
-			mdname(mddev));
-		goto out;
-	}
+	if (!conf)
+		goto out_no_mem;
+
 	memset(conf, 0, sizeof(*conf));
 	conf->mirrors = kmalloc(sizeof(struct mirror_info)*mddev->raid_disks, 
 				 GFP_KERNEL);
-	if (!conf->mirrors) {
-		printk(KERN_ERR "raid1: couldn't allocate memory for %s\n",
-		       mdname(mddev));
-		goto out_free_conf;
-	}
+	if (!conf->mirrors)
+		goto out_no_mem;
+
 	memset(conf->mirrors, 0, sizeof(struct mirror_info)*mddev->raid_disks);
 
+	conf->poolinfo = kmalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
+	if (!conf->poolinfo)
+		goto out_no_mem;
+	conf->poolinfo->mddev = mddev;
+	conf->poolinfo->raid_disks = mddev->raid_disks;
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
-						r1bio_pool_free, mddev);
-	if (!conf->r1bio_pool) {
-		printk(KERN_ERR "raid1: couldn't allocate memory for %s\n", 
-			mdname(mddev));
-		goto out_free_conf;
-	}
+					  r1bio_pool_free, 
+					  conf->poolinfo);
+	if (!conf->r1bio_pool)
+		goto out_no_mem;
+
 	mddev->queue->unplug_fn = raid1_unplug;
 
 	mddev->queue->issue_flush_fn = raid1_issue_flush;
@@ -1270,13 +1273,21 @@ static int run(mddev_t *mddev)
 
 	return 0;
 
+out_no_mem:
+	printk(KERN_ERR "raid1: couldn't allocate memory for %s\n",
+	       mdname(mddev));
+	
 out_free_conf:
-	if (conf->r1bio_pool)
-		mempool_destroy(conf->r1bio_pool);
-	if (conf->mirrors)
-		kfree(conf->mirrors);
-	kfree(conf);
-	mddev->private = NULL;
+	if (conf) {
+		if (conf->r1bio_pool)
+			mempool_destroy(conf->r1bio_pool);
+		if (conf->mirrors)
+			kfree(conf->mirrors);
+		if (conf->poolinfo)
+			kfree(conf->poolinfo);
+		kfree(conf);
+		mddev->private = NULL;
+	}
 out:
 	return -EIO;
 }
@@ -1291,6 +1302,8 @@ static int stop(mddev_t *mddev)
 		mempool_destroy(conf->r1bio_pool);
 	if (conf->mirrors)
 		kfree(conf->mirrors);
+	if (conf->poolinfo)
+		kfree(conf->poolinfo);
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;
@@ -1316,6 +1329,81 @@ static int raid1_resize(mddev_t *mddev, 
 	return 0;
 }
 
+static int raid1_reshape(mddev_t *mddev, int raid_disks)
+{
+	/* We need to:
+	 * 1/ resize the r1bio_pool
+	 * 2/ resize conf->mirrors
+	 *
+	 * We allocate a new r1bio_pool if we can.
+	 * Then raise a device barrier and wait until all IO stops.
+	 * Then resize conf->mirrors and swap in the new r1bio pool.
+	 */
+	mempool_t *newpool, *oldpool;
+	struct pool_info *newpoolinfo;
+	mirror_info_t *newmirrors;
+	conf_t *conf = mddev_to_conf(mddev);
+	
+	int d;
+
+	for (d= raid_disks; d < conf->raid_disks; d++)
+		if (conf->mirrors[d].rdev)
+			return -EBUSY;
+	
+	newpoolinfo = kmalloc(sizeof(newpoolinfo), GFP_KERNEL);
+	if (!newpoolinfo)
+		return -ENOMEM;
+	newpoolinfo->mddev = mddev;
+	newpoolinfo->raid_disks = raid_disks;
+
+	newpool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
+				 r1bio_pool_free, newpoolinfo);
+	if (!newpool) {
+		kfree(newpoolinfo);
+		return -ENOMEM;
+	}
+	newmirrors = kmalloc(sizeof(struct mirror_info) * raid_disks, GFP_KERNEL);
+	if (!newmirrors) {
+		kfree(newpoolinfo);
+		mempool_destroy(newpool);
+		return -ENOMEM;
+	}
+	memset(newmirrors, 0, sizeof(struct mirror_info)*raid_disks);
+
+	spin_lock_irq(&conf->resync_lock);
+	conf->barrier++;
+	wait_event_lock_irq(conf->wait_idle, !conf->nr_pending, 
+			    conf->resync_lock, unplug_slaves(mddev));
+	spin_unlock_irq(&conf->resync_lock);
+
+	/* ok, everything is stopped */
+	oldpool = conf->r1bio_pool;
+	conf->r1bio_pool = newpool;
+	for (d=0; d < raid_disks && d < conf->raid_disks; d++)
+		newmirrors[d] = conf->mirrors[d];
+	kfree(conf->mirrors);
+	conf->mirrors = newmirrors;
+	kfree(conf->poolinfo);
+	conf->poolinfo = newpoolinfo;
+	
+	mddev->degraded += (raid_disks - conf->raid_disks);
+	conf->raid_disks = mddev->raid_disks = raid_disks;
+
+	spin_lock_irq(&conf->resync_lock);
+	conf->barrier--;
+	spin_unlock_irq(&conf->resync_lock);
+	wake_up(&conf->wait_resume);
+	wake_up(&conf->wait_idle);
+
+
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
+
+	mempool_destroy(oldpool);
+	return 0;
+}
+	
+
 static mdk_personality_t raid1_personality =
 {
 	.name		= "raid1",
@@ -1330,6 +1418,7 @@ static mdk_personality_t raid1_personali
 	.spare_active	= raid1_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid1_resize,
+	.reshape	= raid1_reshape,
 };
 
 static int __init raid_init(void)

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-05-28 16:29:57.000000000 +1000
+++ ./include/linux/raid/md_k.h	2004-05-28 16:29:57.000000000 +1000
@@ -280,6 +280,7 @@ struct mdk_personality_s
 	int (*spare_active) (mddev_t *mddev);
 	int (*sync_request)(mddev_t *mddev, sector_t sector_nr, int go_faster);
 	int (*resize) (mddev_t *mddev, sector_t sectors);
+	int (*reshape) (mddev_t *mddev, int raid_disks);
 };
 
 
