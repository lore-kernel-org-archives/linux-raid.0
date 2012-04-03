From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/10] md/raid10: collect some geometry fields into a
 dedicated structure.
Date: Tue, 03 Apr 2012 15:53:01 +1000
Message-ID: <20120403055301.19495.80329.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We will shortly be adding reshape support for RAID10 which will
require it having 2 concurrent geometries (before and after).
To make that easier, collect most geometry fields into 'struct geom'
and access them from there.  Then we will more easily be able to add
a second set of fields.

Note that 'copies' is not in this struct and so cannot be changed.
There is little need to change this number and doing so is a lot
more difficult as it requires reallocating more things.
So leave it out for now.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  192 ++++++++++++++++++++++++++-------------------------
 drivers/md/raid10.h |   23 +++---
 2 files changed, 111 insertions(+), 104 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b642841..39f5239 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -511,42 +511,43 @@ static void raid10_find_phys(struct r10conf *conf, struct r10bio *r10bio)
 	sector_t chunk;
 	sector_t stripe;
 	int dev;
+	struct geom *geo = &conf->geo;
 
 	int slot = 0;
 
 	/* now calculate first sector/dev */
-	chunk = r10bio->sector >> conf->chunk_shift;
-	sector = r10bio->sector & conf->chunk_mask;
+	chunk = r10bio->sector >> geo->chunk_shift;
+	sector = r10bio->sector & geo->chunk_mask;
 
-	chunk *= conf->near_copies;
+	chunk *= geo->near_copies;
 	stripe = chunk;
-	dev = sector_div(stripe, conf->raid_disks);
-	if (conf->far_offset)
-		stripe *= conf->far_copies;
+	dev = sector_div(stripe, geo->raid_disks);
+	if (geo->far_offset)
+		stripe *= geo->far_copies;
 
-	sector += stripe << conf->chunk_shift;
+	sector += stripe << geo->chunk_shift;
 
 	/* and calculate all the others */
-	for (n=0; n < conf->near_copies; n++) {
+	for (n = 0; n < geo->near_copies; n++) {
 		int d = dev;
 		sector_t s = sector;
 		r10bio->devs[slot].addr = sector;
 		r10bio->devs[slot].devnum = d;
 		slot++;
 
-		for (f = 1; f < conf->far_copies; f++) {
-			d += conf->near_copies;
-			if (d >= conf->raid_disks)
-				d -= conf->raid_disks;
-			s += conf->stride;
+		for (f = 1; f < geo->far_copies; f++) {
+			d += geo->near_copies;
+			if (d >= geo->raid_disks)
+				d -= geo->raid_disks;
+			s += geo->stride;
 			r10bio->devs[slot].devnum = d;
 			r10bio->devs[slot].addr = s;
 			slot++;
 		}
 		dev++;
-		if (dev >= conf->raid_disks) {
+		if (dev >= geo->raid_disks) {
 			dev = 0;
-			sector += (conf->chunk_mask + 1);
+			sector += (geo->chunk_mask + 1);
 		}
 	}
 	BUG_ON(slot != conf->copies);
@@ -555,28 +556,29 @@ static void raid10_find_phys(struct r10conf *conf, struct r10bio *r10bio)
 static sector_t raid10_find_virt(struct r10conf *conf, sector_t sector, int dev)
 {
 	sector_t offset, chunk, vchunk;
+	struct geom *geo = &conf->geo;
 
-	offset = sector & conf->chunk_mask;
-	if (conf->far_offset) {
+	offset = sector & geo->chunk_mask;
+	if (geo->far_offset) {
 		int fc;
-		chunk = sector >> conf->chunk_shift;
-		fc = sector_div(chunk, conf->far_copies);
-		dev -= fc * conf->near_copies;
+		chunk = sector >> geo->chunk_shift;
+		fc = sector_div(chunk, geo->far_copies);
+		dev -= fc * geo->near_copies;
 		if (dev < 0)
-			dev += conf->raid_disks;
+			dev += geo->raid_disks;
 	} else {
-		while (sector >= conf->stride) {
-			sector -= conf->stride;
-			if (dev < conf->near_copies)
-				dev += conf->raid_disks - conf->near_copies;
+		while (sector >= geo->stride) {
+			sector -= geo->stride;
+			if (dev < geo->near_copies)
+				dev += geo->raid_disks - geo->near_copies;
 			else
-				dev -= conf->near_copies;
+				dev -= geo->near_copies;
 		}
-		chunk = sector >> conf->chunk_shift;
+		chunk = sector >> geo->chunk_shift;
 	}
-	vchunk = chunk * conf->raid_disks + dev;
-	sector_div(vchunk, conf->near_copies);
-	return (vchunk << conf->chunk_shift) + offset;
+	vchunk = chunk * geo->raid_disks + dev;
+	sector_div(vchunk, geo->near_copies);
+	return (vchunk << geo->chunk_shift) + offset;
 }
 
 /**
@@ -599,8 +601,9 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
+	struct geom *geo = &conf->geo;
 
-	if (conf->near_copies < conf->raid_disks) {
+	if (geo->near_copies < geo->raid_disks) {
 		max = (chunk_sectors - ((sector & (chunk_sectors - 1))
 					+ bio_sectors)) << 9;
 		if (max < 0)
@@ -681,6 +684,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 	struct md_rdev *rdev, *best_rdev;
 	int do_balance;
 	int best_slot;
+	struct geom *geo = &conf->geo;
 
 	raid10_find_phys(conf, r10_bio);
 	rcu_read_lock();
@@ -761,11 +765,11 @@ retry:
 		 * sequential read speed for 'far copies' arrays.  So only
 		 * keep it for 'near' arrays, and review those later.
 		 */
-		if (conf->near_copies > 1 && !atomic_read(&rdev->nr_pending))
+		if (geo->near_copies > 1 && !atomic_read(&rdev->nr_pending))
 			break;
 
 		/* for far > 1 always use the lowest address */
-		if (conf->far_copies > 1)
+		if (geo->far_copies > 1)
 			new_distance = r10_bio->devs[slot].addr;
 		else
 			new_distance = abs(r10_bio->devs[slot].addr -
@@ -812,7 +816,7 @@ static int raid10_congested(void *data, int bits)
 	if (mddev_congested(mddev, bits))
 		return 1;
 	rcu_read_lock();
-	for (i = 0; i < conf->raid_disks && ret == 0; i++) {
+	for (i = 0; i < conf->geo.raid_disks && ret == 0; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct request_queue *q = bdev_get_queue(rdev->bdev);
@@ -979,7 +983,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	struct r10bio *r10_bio;
 	struct bio *read_bio;
 	int i;
-	int chunk_sects = conf->chunk_mask + 1;
+	sector_t chunk_mask = conf->geo.chunk_mask;
+	int chunk_sects = chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
@@ -997,9 +1002,9 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	/* If this request crosses a chunk boundary, we need to
 	 * split it.  This will only happen for 1 PAGE (or less) requests.
 	 */
-	if (unlikely( (bio->bi_sector & conf->chunk_mask) + (bio->bi_size >> 9)
-		      > chunk_sects &&
-		    conf->near_copies < conf->raid_disks)) {
+	if (unlikely((bio->bi_sector & chunk_mask) + (bio->bi_size >> 9)
+		     > chunk_sects
+		     && conf->geo.near_copies < conf->geo.raid_disks)) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
 		if (bio->bi_vcnt != 1 ||
@@ -1368,19 +1373,19 @@ static void status(struct seq_file *seq, struct mddev *mddev)
 	struct r10conf *conf = mddev->private;
 	int i;
 
-	if (conf->near_copies < conf->raid_disks)
+	if (conf->geo.near_copies < conf->geo.raid_disks)
 		seq_printf(seq, " %dK chunks", mddev->chunk_sectors / 2);
-	if (conf->near_copies > 1)
-		seq_printf(seq, " %d near-copies", conf->near_copies);
-	if (conf->far_copies > 1) {
-		if (conf->far_offset)
-			seq_printf(seq, " %d offset-copies", conf->far_copies);
+	if (conf->geo.near_copies > 1)
+		seq_printf(seq, " %d near-copies", conf->geo.near_copies);
+	if (conf->geo.far_copies > 1) {
+		if (conf->geo.far_offset)
+			seq_printf(seq, " %d offset-copies", conf->geo.far_copies);
 		else
-			seq_printf(seq, " %d far-copies", conf->far_copies);
+			seq_printf(seq, " %d far-copies", conf->geo.far_copies);
 	}
-	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
-					conf->raid_disks - mddev->degraded);
-	for (i = 0; i < conf->raid_disks; i++)
+	seq_printf(seq, " [%d/%d] [", conf->geo.raid_disks,
+					conf->geo.raid_disks - mddev->degraded);
+	for (i = 0; i < conf->geo.raid_disks; i++)
 		seq_printf(seq, "%s",
 			      conf->mirrors[i].rdev &&
 			      test_bit(In_sync, &conf->mirrors[i].rdev->flags) ? "U" : "_");
@@ -1403,7 +1408,7 @@ static int enough(struct r10conf *conf, int ignore)
 			if (conf->mirrors[first].rdev &&
 			    first != ignore)
 				cnt++;
-			first = (first+1) % conf->raid_disks;
+			first = (first+1) % conf->geo.raid_disks;
 		}
 		if (cnt == 0)
 			return 0;
@@ -1445,7 +1450,7 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 	       "md/raid10:%s: Disk failure on %s, disabling device.\n"
 	       "md/raid10:%s: Operation continuing on %d devices.\n",
 	       mdname(mddev), bdevname(rdev->bdev, b),
-	       mdname(mddev), conf->raid_disks - mddev->degraded);
+	       mdname(mddev), conf->geo.raid_disks - mddev->degraded);
 }
 
 static void print_conf(struct r10conf *conf)
@@ -1458,10 +1463,10 @@ static void print_conf(struct r10conf *conf)
 		printk(KERN_DEBUG "(!conf)\n");
 		return;
 	}
-	printk(KERN_DEBUG " --- wd:%d rd:%d\n", conf->raid_disks - conf->mddev->degraded,
-		conf->raid_disks);
+	printk(KERN_DEBUG " --- wd:%d rd:%d\n", conf->geo.raid_disks - conf->mddev->degraded,
+		conf->geo.raid_disks);
 
-	for (i = 0; i < conf->raid_disks; i++) {
+	for (i = 0; i < conf->geo.raid_disks; i++) {
 		char b[BDEVNAME_SIZE];
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
@@ -1493,7 +1498,7 @@ static int raid10_spare_active(struct mddev *mddev)
 	 * Find all non-in_sync disks within the RAID10 configuration
 	 * and mark them in_sync
 	 */
-	for (i = 0; i < conf->raid_disks; i++) {
+	for (i = 0; i < conf->geo.raid_disks; i++) {
 		tmp = conf->mirrors + i;
 		if (tmp->replacement
 		    && tmp->replacement->recovery_offset == MaxSector
@@ -1535,7 +1540,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int err = -EEXIST;
 	int mirror;
 	int first = 0;
-	int last = conf->raid_disks - 1;
+	int last = conf->geo.raid_disks - 1;
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
 
 	if (mddev->recovery_cp < MaxSector)
@@ -2603,7 +2608,7 @@ static int init_resync(struct r10conf *conf)
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
 	BUG_ON(conf->r10buf_pool);
 	conf->have_replacement = 0;
-	for (i = 0; i < conf->raid_disks; i++)
+	for (i = 0; i < conf->geo.raid_disks; i++)
 		if (conf->mirrors[i].replacement)
 			conf->have_replacement = 1;
 	conf->r10buf_pool = mempool_create(buffs, r10buf_pool_alloc, r10buf_pool_free, conf);
@@ -2657,6 +2662,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 	sector_t sync_blocks;
 	sector_t sectors_skipped = 0;
 	int chunks_skipped = 0;
+	sector_t chunk_mask = conf->geo.chunk_mask;
 
 	if (!conf->r10buf_pool)
 		if (init_resync(conf))
@@ -2680,7 +2686,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 				bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
 						&sync_blocks, 1);
-			else for (i=0; i<conf->raid_disks; i++) {
+			else for (i = 0; i < conf->geo.raid_disks; i++) {
 				sector_t sect =
 					raid10_find_virt(conf, mddev->curr_resync, i);
 				bitmap_end_sync(mddev->bitmap, sect,
@@ -2694,7 +2700,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				/* Completed a full sync so the replacements
 				 * are now fully recovered.
 				 */
-				for (i = 0; i < conf->raid_disks; i++)
+				for (i = 0; i < conf->geo.raid_disks; i++)
 					if (conf->mirrors[i].replacement)
 						conf->mirrors[i].replacement
 							->recovery_offset
@@ -2707,7 +2713,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		*skipped = 1;
 		return sectors_skipped;
 	}
-	if (chunks_skipped >= conf->raid_disks) {
+	if (chunks_skipped >= conf->geo.raid_disks) {
 		/* if there has been nothing to do on any drive,
 		 * then there is nothing to do at all..
 		 */
@@ -2721,9 +2727,9 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 	/* make sure whole request will fit in a chunk - if chunks
 	 * are meaningful
 	 */
-	if (conf->near_copies < conf->raid_disks &&
-	    max_sector > (sector_nr | conf->chunk_mask))
-		max_sector = (sector_nr | conf->chunk_mask) + 1;
+	if (conf->geo.near_copies < conf->geo.raid_disks &&
+	    max_sector > (sector_nr | chunk_mask))
+		max_sector = (sector_nr | chunk_mask) + 1;
 	/*
 	 * If there is non-resync activity waiting for us then
 	 * put in a delay to throttle resync.
@@ -2752,7 +2758,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		int j;
 		r10_bio = NULL;
 
-		for (i=0 ; i<conf->raid_disks; i++) {
+		for (i = 0 ; i < conf->geo.raid_disks; i++) {
 			int still_degraded;
 			struct r10bio *rb2;
 			sector_t sect;
@@ -2806,7 +2812,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			/* Need to check if the array will still be
 			 * degraded
 			 */
-			for (j=0; j<conf->raid_disks; j++)
+			for (j = 0; j < conf->geo.raid_disks; j++)
 				if (conf->mirrors[j].rdev == NULL ||
 				    test_bit(Faulty, &conf->mirrors[j].rdev->flags)) {
 					still_degraded = 1;
@@ -2984,9 +2990,9 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		r10_bio->sector = sector_nr;
 		set_bit(R10BIO_IsSync, &r10_bio->state);
 		raid10_find_phys(conf, r10_bio);
-		r10_bio->sectors = (sector_nr | conf->chunk_mask) - sector_nr +1;
+		r10_bio->sectors = (sector_nr | chunk_mask) - sector_nr + 1;
 
-		for (i=0; i<conf->copies; i++) {
+		for (i = 0; i < conf->copies; i++) {
 			int d = r10_bio->devs[i].devnum;
 			sector_t first_bad, sector;
 			int bad_sectors;
@@ -3152,16 +3158,16 @@ raid10_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 	struct r10conf *conf = mddev->private;
 
 	if (!raid_disks)
-		raid_disks = conf->raid_disks;
+		raid_disks = conf->geo.raid_disks;
 	if (!sectors)
 		sectors = conf->dev_sectors;
 
-	size = sectors >> conf->chunk_shift;
-	sector_div(size, conf->far_copies);
+	size = sectors >> conf->geo.chunk_shift;
+	sector_div(size, conf->geo.far_copies);
 	size = size * raid_disks;
-	sector_div(size, conf->near_copies);
+	sector_div(size, conf->geo.near_copies);
 
-	return size << conf->chunk_shift;
+	return size << conf->geo.chunk_shift;
 }
 
 
@@ -3206,22 +3212,22 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 		goto out;
 
 
-	conf->raid_disks = mddev->raid_disks;
-	conf->near_copies = nc;
-	conf->far_copies = fc;
+	conf->geo.raid_disks = mddev->raid_disks;
+	conf->geo.near_copies = nc;
+	conf->geo.far_copies = fc;
 	conf->copies = nc*fc;
-	conf->far_offset = fo;
-	conf->chunk_mask = mddev->new_chunk_sectors - 1;
-	conf->chunk_shift = ffz(~mddev->new_chunk_sectors);
+	conf->geo.far_offset = fo;
+	conf->geo.chunk_mask = mddev->new_chunk_sectors - 1;
+	conf->geo.chunk_shift = ffz(~mddev->new_chunk_sectors);
 
 	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
 					   r10bio_pool_free, conf);
 	if (!conf->r10bio_pool)
 		goto out;
 
-	size = mddev->dev_sectors >> conf->chunk_shift;
+	size = mddev->dev_sectors >> conf->geo.chunk_shift;
 	sector_div(size, fc);
-	size = size * conf->raid_disks;
+	size = size * conf->geo.raid_disks;
 	sector_div(size, nc);
 	/* 'size' is now the number of chunks in the array */
 	/* calculate "used chunks per device" in 'stride' */
@@ -3230,16 +3236,16 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	/* We need to round up when dividing by raid_disks to
 	 * get the stride size.
 	 */
-	stride += conf->raid_disks - 1;
-	sector_div(stride, conf->raid_disks);
+	stride += conf->geo.raid_disks - 1;
+	sector_div(stride, conf->geo.raid_disks);
 
-	conf->dev_sectors = stride << conf->chunk_shift;
+	conf->dev_sectors = stride << conf->geo.chunk_shift;
 
 	if (fo)
 		stride = 1;
 	else
 		sector_div(stride, fc);
-	conf->stride = stride << conf->chunk_shift;
+	conf->geo.stride = stride << conf->geo.chunk_shift;
 
 
 	spin_lock_init(&conf->device_lock);
@@ -3297,16 +3303,16 @@ static int run(struct mddev *mddev)
 
 	chunk_size = mddev->chunk_sectors << 9;
 	blk_queue_io_min(mddev->queue, chunk_size);
-	if (conf->raid_disks % conf->near_copies)
-		blk_queue_io_opt(mddev->queue, chunk_size * conf->raid_disks);
+	if (conf->geo.raid_disks % conf->geo.near_copies)
+		blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
 	else
 		blk_queue_io_opt(mddev->queue, chunk_size *
-				 (conf->raid_disks / conf->near_copies));
+				 (conf->geo.raid_disks / conf->geo.near_copies));
 
 	rdev_for_each(rdev, mddev) {
 
 		disk_idx = rdev->raid_disk;
-		if (disk_idx >= conf->raid_disks
+		if (disk_idx >= conf->geo.raid_disks
 		    || disk_idx < 0)
 			continue;
 		disk = conf->mirrors + disk_idx;
@@ -3334,7 +3340,7 @@ static int run(struct mddev *mddev)
 	}
 
 	mddev->degraded = 0;
-	for (i = 0; i < conf->raid_disks; i++) {
+	for (i = 0; i < conf->geo.raid_disks; i++) {
 
 		disk = conf->mirrors + i;
 
@@ -3361,8 +3367,8 @@ static int run(struct mddev *mddev)
 		       mdname(mddev));
 	printk(KERN_INFO
 		"md/raid10:%s: active with %d out of %d devices\n",
-		mdname(mddev), conf->raid_disks - mddev->degraded,
-		conf->raid_disks);
+		mdname(mddev), conf->geo.raid_disks - mddev->degraded,
+		conf->geo.raid_disks);
 	/*
 	 * Ok, everything is just fine now
 	 */
@@ -3379,9 +3385,9 @@ static int run(struct mddev *mddev)
 	 * maybe...
 	 */
 	{
-		int stripe = conf->raid_disks *
+		int stripe = conf->geo.raid_disks *
 			((mddev->chunk_sectors << 9) / PAGE_SIZE);
-		stripe /= conf->near_copies;
+		stripe /= conf->geo.near_copies;
 		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
@@ -3453,7 +3459,7 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	struct r10conf *conf = mddev->private;
 	sector_t oldsize, size;
 
-	if (conf->far_copies > 1 && !conf->far_offset)
+	if (conf->geo.far_copies > 1 && !conf->geo.far_offset)
 		return -EINVAL;
 
 	oldsize = raid10_size(mddev, 0, 0);
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 7c615613..4c4942a 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -14,33 +14,34 @@ struct mirror_info {
 struct r10conf {
 	struct mddev		*mddev;
 	struct mirror_info	*mirrors;
-	int			raid_disks;
 	spinlock_t		device_lock;
 
 	/* geometry */
-	int			near_copies;  /* number of copies laid out
+	struct geom {
+		int		raid_disks;
+		int		near_copies;  /* number of copies laid out
 					       * raid0 style */
-	int 			far_copies;   /* number of copies laid out
+		int		far_copies;   /* number of copies laid out
 					       * at large strides across drives
 					       */
-	int			far_offset;   /* far_copies are offset by 1
+		int		far_offset;   /* far_copies are offset by 1
 					       * stripe instead of many
 					       */
-	int			copies;	      /* near_copies * far_copies.
-					       * must be <= raid_disks
-					       */
-	sector_t		stride;	      /* distance between far copies.
+		sector_t	stride;	      /* distance between far copies.
 					       * This is size / far_copies unless
 					       * far_offset, in which case it is
 					       * 1 stripe.
 					       */
+		int		chunk_shift; /* shift from chunks to sectors */
+		sector_t	chunk_mask;
+	} geo;
+	int			copies;	      /* near_copies * far_copies.
+					       * must be <= raid_disks
+					       */
 
 	sector_t		dev_sectors;  /* temp copy of
 					       * mddev->dev_sectors */
 
-	int			chunk_shift; /* shift from chunks to sectors */
-	sector_t		chunk_mask;
-
 	struct list_head	retry_list;
 	/* queue pending writes and submit them on unplug */
 	struct bio_list		pending_bio_list;


