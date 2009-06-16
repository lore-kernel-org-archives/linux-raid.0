From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 010:013]: raid0: reshape core code
Date: Wed, 17 Jun 2009 00:58:49 +0300
Message-ID: <1245189529.3478.113.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

reshape core code. it includes:
. online reshape
. resume reshape
. reverse mapping ( from disk to raid ) is done by saving the raid0 offset in
  raid0_reshape_bio record allocated per bio.
. start_reshape is added to support resume reshape ( as a flag ).

Algorithm basics:
	. create a new temporary mapping.
	. raid0d start the reshape process.
	. in raid0_sync, i read a full zone strip, wait and write this strip 
		to its new raid position. once done, i update the superblocks.
	. reshape is complete when find_zone returns NULL.
	. raid0d calls spare_active to finish.
	. incoming ios redirected and never done in raid0_make_request context.
	. incoming ios are routed over a sliding window.
	. incoming ios have higher priority then reshape_ios.

 raid0.c |  685 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 675 insertions(+), 10 deletions(-)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 984d603..0b2c2e5 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -23,6 +23,47 @@
 #include "md.h"
 #include "raid0.h"
 
+#define RAID0_RESHAPE_START	0x01
+#define RAID0_RESHAPE_END	0x02
+
+static int reshape_init(mddev_t *mddev);
+/*
+ *	raid0d is used for:
+ *	start raid0_sync, stop raid0_sync
+ */
+static void raid0d(mddev_t *mddev)
+{
+	raid0_conf_t *conf = mddev->private;
+	if (!conf->reshape)
+		return;
+	if (test_bit(RAID0_RESHAPE_START, &conf->reshape->flags)
+		|| test_bit(RAID0_RESHAPE_END, &conf->reshape->flags)) {
+		if (mddev->sync_thread)
+			conf->reshape->flags = 0;
+		md_check_recovery(mddev);
+	}
+}
+
+/*
+* Create a reshape thread for serving writes, retries, delayed ios
+*/
+static int start_raid0d(mddev_t *mddev)
+{
+	if (mddev->thread) {
+		md_wakeup_thread(mddev->thread);
+		return 0;
+	}
+	mddev->thread = md_register_thread(raid0d,
+					mddev, "%s_raid0d");
+	if (!mddev->thread) {
+		printk(KERN_ERR
+			"raid0: couldn't allocate thread for %s\n",
+			mdname(mddev));
+		return -1;
+	}
+	md_wakeup_thread(mddev->thread);
+	return 0;
+}
 static void raid0_unplug(struct request_queue *q)
 {
 	mddev_t *mddev = q->queuedata;
@@ -372,7 +413,18 @@ static int raid0_run(mddev_t *mddev)
 	if (!conf)
 		goto abort;
 	mddev->private = conf;
-
+	/*
+	 *  I am doing it only to eliminate the
+	 *  resync=PENDING in mdstats with sb ver= 1.
+	*/
+	if (mddev->recovery_cp == 0)
+		mddev->recovery_cp = MaxSector;
+	if (mddev->reshape_position != MaxSector) {
+		mddev->recovery_cp = mddev->reshape_position;
+		printk(KERN_INFO "raid0: %s detected reshape "
+			"recovery. ended at=%lld\n", mdname(mddev),
+			(unsigned long long)mddev->recovery_cp);
+	}
 	if (create_strip_zones(conf, &mddev->disks,
 			mddev->chunk_sectors,  mddev->raid_disks))
 		goto abort;
@@ -394,6 +446,12 @@ static int raid0_run(mddev_t *mddev)
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	print_conf(mddev->private, mddev->raid_disks, mdname(mddev));
 	list_splice(&new_disks, &mddev->disks);
+	mutex_init(&conf->reshape_lock);
+	if (mddev->reshape_position != MaxSector) {
+		if (reshape_init(mddev))
+			goto abort;
+		start_raid0d(mddev);
+	}
 	return 0;
 abort:
 	{
@@ -410,6 +468,20 @@ static int raid0_stop(mddev_t *mddev)
 {
 	raid0_conf_t *conf = mddev->private;
 
+	if (mddev->thread) {
+		md_unregister_thread(mddev->thread);
+		mddev->thread = 0;
+	}
+	if (conf->reshape) {
+		struct raid0_reshape *reshape = conf->reshape;
+		/* a reshape process is going on */
+		printk(KERN_INFO "raid0: %s, stopping while reshape\n",
+				mdname(mddev));
+		kfree(reshape->conf->strip_zone);
+		kfree(reshape->conf->devlist);
+		kfree(reshape->conf);
+		kfree(reshape);
+	}
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
@@ -502,7 +574,6 @@ static int make_request(struct request_queue *q,
 			unsigned int chunk_sectors,
 			struct bio *bio)
 {
-	mddev_t *mddev = q->queuedata;
 	sector_t sector_offset;
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
@@ -539,15 +610,11 @@ static int make_request(struct request_queue *q,
 	}
 
 	sector_offset = bio->bi_sector;
-	zone =  find_zone(mddev->private, &sector_offset);
+	zone =  find_zone(conf , &sector_offset);
 	if (!zone)
 		BUG();
-	tmp_dev = map_sector(mddev->private,
-				chunk_sectors,
-				raid_disks,
-				zone,
-				bio->bi_sector,
-				&sector_offset);
+	tmp_dev = map_sector(conf, chunk_sectors, raid_disks, zone,
+				bio->bi_sector,	&sector_offset);
 	bio->bi_bdev = tmp_dev->bdev;
 	bio->bi_sector = sector_offset + zone->dev_start +
 		tmp_dev->data_offset;
@@ -581,7 +648,17 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
-
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
+		unsigned long flags;
+		/*
+		* IO must moves to reshape context,
+		*/
+		struct raid0_reshape *reshape = mddev_to_reshape(mddev);
+		spin_lock_irqsave(&reshape->lock, flags);
+		bio_list_add(&reshape->incoming_ios, bio);
+		spin_unlock_irqrestore(&reshape->lock, flags);
+		return 0;
+	}
 	return make_request(q, mddev->private,
 				mddev->raid_disks,
 				mddev->chunk_sectors, bio);
@@ -620,6 +697,581 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 }
 

+/*
+ * end read from source device. move io to write list.
+ * incase of an error just notify an error and leave
+*/
+static void reshape_read_endio(struct bio *bi, int error)
+{
+	int i;
+	struct raid0_reshape_bio *r = bi->bi_private;
+	struct raid0_reshape *reshape = r->reshape;
+
+	if (!error && test_bit(BIO_UPTODATE, &bi->bi_flags)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&reshape->lock, flags);
+		bio_list_add(&reshape->ios, bi);
+		spin_unlock_irqrestore(&reshape->lock, flags);
+		return;
+	}
+	printk(KERN_ERR "raid0: reshape read end io: io error sector=%llu\n",
+				(unsigned long long)bi->bi_sector);
+	for (i = 0; i < bi->bi_vcnt; i++)
+		safe_put_page(bi->bi_io_vec[i].bv_page);
+	bio_put(bi);
+	atomic_dec(&reshape->active_ios);
+}
+
+/*
+ *	reshape ending io. incase of an error just generate an
+*	error message and continue
+*/
+static void reshape_write_endio(struct bio *bi, int error)
+{
+	int i;
+	struct raid0_reshape_bio *r = bi->bi_private;
+	struct raid0_reshape *reshape = r->reshape;
+	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+
+	if (error || !uptodate) {
+		printk(KERN_ERR "raid0: reshape write endio:"
+				" io error sector=%llu\n",
+			(unsigned long long)bi->bi_sector);
+	}
+	for (i = 0; i < bi->bi_vcnt; i++)
+		safe_put_page(bi->bi_io_vec[i].bv_page);
+	bio_put(bi);
+	atomic_dec(&reshape->active_ios);
+	md_done_sync(reshape->mddev_src, r->bi_size>>9, 1);
+	kfree(r);
+}
+
+static sector_t real_to_virtual(struct bio *bi)
+{
+	struct raid0_reshape_bio *r = bi->bi_private;
+	return r->array_sector;
+}
+/*
+ * find the position of bio in the new raid
+ * generate the io
+*/
+static void process_reshape_writes(mddev_t *mddev, struct bio *bi)
+{
+	mdk_rdev_t *tmp_dev;
+	sector_t sector_offset;
+	struct strip_zone *zone;
+	struct raid0_reshape *reshape = mddev_to_reshape(mddev);
+	raid0_conf_t *conf_tgt  = reshape->conf;
+	/*
+	* re-assign the array's address
+	*/
+	bi->bi_sector = real_to_virtual(bi);
+	bi->bi_rw = WRITE;
+	bi->bi_idx = 0;
+	sector_offset = bi->bi_sector;
+	zone    =  find_zone(conf_tgt, &sector_offset);
+	if (!zone)
+		BUG();
+
+	tmp_dev = map_sector(reshape->conf,
+				mddev->chunk_sectors,
+				reshape->raid_disks,
+				zone, bi->bi_sector,
+				&sector_offset);
+
+	bi->bi_bdev   = tmp_dev->bdev;
+	bi->bi_sector = sector_offset + zone->dev_start +
+					tmp_dev->data_offset;
+	bi->bi_end_io  = reshape_write_endio;
+	bi->bi_size    = ((struct raid0_reshape_bio *)bi->bi_private)->bi_size;
+	generic_make_request(bi);
+}
+
+/*
+ * create the new raid ( the target ) mappings.
+ * This includes zones and disks.
+*/
+static int create_temp_target(mddev_t *mddev)
+{
+	int nraid_disks;
+	mdk_rdev_t *rdev = NULL;
+	raid0_conf_t *conf_src = mddev->private;
+	struct raid0_reshape *reshape = conf_src->reshape;
+
+	/*
+	* Enumerate each device with its new id
+	*
+	*/
+	nraid_disks = mddev->raid_disks;
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (!test_bit(In_sync, &rdev->flags)) {
+			if (rdev->raid_disk == -1
+				&& rdev->desc_nr == -1)
+					rdev->desc_nr = nraid_disks;
+			nraid_disks++;
+			rdev->raid_disk = rdev->desc_nr;
+			rdev->saved_raid_disk = rdev->raid_disk;
+		}
+	}
+	reshape->conf = kzalloc(sizeof(*reshape->conf), GFP_KERNEL);
+	if (!reshape->conf)
+		return -ENOMEM;
+	if (create_strip_zones(reshape->conf, &mddev->disks,
+				mddev->chunk_sectors, nraid_disks))
+		return -ENOMEM;
+	if (calc_zones(reshape->conf, &mddev->disks, nraid_disks)) {
+		kfree(reshape->conf->strip_zone);
+		kfree(reshape->conf->devlist);
+		kfree(reshape->conf);
+		return -EINVAL;
+	}
+	/*
+	* recalc the queues dimensions to fix the transfer size is need.
+	*/
+	reshape->raid_disks = nraid_disks;
+	mddev->delta_disks = nraid_disks - mddev->raid_disks;
+	set_queues(&mddev->disks, mddev->queue);
+	print_conf(reshape->conf, reshape->raid_disks, "new mappings");
+	return 0;
+}
+
+/*
+ *  Process all incoming ios.
+ *
+ *  a reshape window is :READ head + size of the zone stripe.
+ *   --------------[READ **************] ---------------
+ *     area A         reshape window            area B
+ *
+ *   area B: IO will processed from original mappings in reshape context.
+ *   area A: IO will processed from new mappings from this context.
+ *   Reshape Window: wait and process same as area A but from reshape context.
+*/
+static void process_incomings(mddev_t *mddev, int *go_faster)
+{
+	struct bio_list resched_bios;
+	struct raid0_reshape *reshape = mddev_to_reshape(mddev);
+	struct bio *bi;
+	unsigned long flags;
+
+	/*
+	* We do not work on the online list, as it grows all the time.
+	* so we copy the online list to a temporary
+	* list, and process it in a lockless manner.
+	*/
+	bio_list_init(&resched_bios);
+	spin_lock_irqsave(&reshape->lock, flags);
+	bio_list_merge(&resched_bios, &reshape->incoming_ios);
+	bio_list_init(&reshape->incoming_ios);
+	spin_unlock_irqrestore(&reshape->lock, flags);
+
+	while (!bio_list_empty(&resched_bios)) {
+		/*
+		 *  IO is in area A .submit it on new raid mappings.
+		 *  if make_request == 1 then IO should be transfered, else
+		 *  it was splitted and moved to incoming ios list.
+		 *  very much the same for area B.
+		*/
+		bi = bio_list_pop(&resched_bios);
+		if ((bi->bi_sector + bio_sectors(bi)) < mddev->recovery_cp) {
+			if (make_request(mddev->gendisk->queue,
+				reshape->conf,
+				reshape->raid_disks,
+				mddev->chunk_sectors,
+				bi) == 1)
+				generic_make_request(bi);
+			continue;
+		}
+		if ((bi->bi_sector >
+			(mddev->recovery_cp + reshape->window))) {
+			*go_faster = 0;
+			/*
+			*  IO is in area B .submit it on old raid mappings.
+			*/
+			if (make_request(mddev->gendisk->queue,
+				mddev->private,
+				mddev->raid_disks,
+				mddev->chunk_sectors,
+				bi) == 1)
+				generic_make_request(bi);
+			continue;
+		}
+		/* IO is still in reshape window , reschedule */
+		spin_lock_irqsave(&reshape->lock, flags);
+		bio_list_add(&reshape->incoming_ios, bi);
+		spin_unlock_irqrestore(&reshape->lock, flags);
+	}
+}
+
+/*
+ * Determine the amount of bios and their sizes that cover a single
+ * chunk.
+ * A chunk may be 1024bytes or 2^30bytes. Reshape works by reading an entire
+ * chunk from the old raid and writing to the new raid.
+ * There are three factors that determine the bio size,
+ * 1. the transfer size ( both the tubale max_sector
+ *    and the hardware constraint max_hw_sector)
+ * 2. predefined maximum bio size
+ * 3. chunk size
+ * We take the minimum of the three.
+ * we caluclate how many bios (nr_bios)are needed to cover a single chunk,
+ * in the case when chunk size is not a modulo 0 of the bio_size
+ * the last bio size is smaller (last_io_size)
+ * this procedure can never fail.
+*/
+static void reshape_iosize(mddev_t *mddev)
+{
+	int bio_max_size = BIO_MAX_PAGES*PAGE_SIZE;
+	raid0_conf_t *conf = mddev->private;
+	struct raid0_reshape *reshape = conf->reshape;
+	int chunk_size = mddev->chunk_sectors<<9;
+
+	reshape->nr_bios = 0;
+	reshape->last_bio_size = 0;
+	reshape->bio_size =  0;
+	reshape->bio_size =  min(chunk_size, bio_max_size);
+	reshape->bio_size =  min((int)queue_max_hw_sectors(mddev->queue)<<9,
+				reshape->bio_size);
+	reshape->bio_size =  min((int)queue_max_sectors(mddev->queue)<<9,
+				reshape->bio_size);
+
+	if ((mddev->chunk_sectors<<9) > reshape->bio_size) {
+		reshape->nr_bios = chunk_size/reshape->bio_size;
+		reshape->last_bio_size = chunk_size -
+			(reshape->nr_bios * reshape->bio_size);
+		if (reshape->last_bio_size)
+			reshape->nr_bios++;
+	} else{
+		reshape->nr_bios = 1;
+	}
+	printk(KERN_INFO "raid0: using reshape transfer"
+			" size of %ubytes.. \nraid0: tailed with %ubytes,"
+			" covered with %d bios\n",
+			reshape->bio_size,
+			reshape->last_bio_size,
+			reshape->nr_bios);
+}
+
+/*
+ * 1. Calculate size of io in pages.
+ * 2. Create a new raid0 as the temporary target.
+*/
+static int reshape_init(mddev_t *mddev)
+{
+	raid0_conf_t *conf = mddev->private;
+	conf->reshape = kzalloc(sizeof(*conf->reshape), GFP_NOIO);
+	if (!conf->reshape) {
+		printk(KERN_INFO "%s: failed to allocate"
+			" memory for reshape\n",
+			mdname(mddev));
+		return -1;
+	}
+	reshape_iosize(mddev);
+	conf->reshape->mddev_src = mddev;
+	printk(KERN_INFO "raid0: %s reshape, create a temporary mappings\n",
+			mdname(mddev));
+	if (create_temp_target(mddev)) {
+		printk(KERN_INFO "raid0: failed to"
+			" setup temporary mappings\n");
+		return -1;
+	}
+	mddev->resync_max_sectors = mddev->array_sectors;
+	mddev->resync_max = mddev->array_sectors;
+	spin_lock_init(&conf->reshape->lock);
+	bio_list_init(&conf->reshape->ios);
+	bio_list_init(&conf->reshape->incoming_ios);
+	atomic_set(&conf->reshape->active_ios, 0);
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+	conf->reshape->flags = 0 ;
+	set_bit(RAID0_RESHAPE_START, &conf->reshape->flags);
+	return 0;
+}
+
+struct bio *reshape_get_bio(struct raid0_reshape *reshape, int vcnt,
+				int bio_size)
+{
+	int i;
+	struct bio *bi = bio_alloc(GFP_NOIO, vcnt);
+	if (!bi) {
+		printk(KERN_ERR "raid0: failed too alloc bio for"
+			" reshaping.rejecting vcnt=%d\n", vcnt);
+		return NULL;
+	}
+	bi->bi_rw = READ;
+	bi->bi_size = 0;
+	bi->bi_vcnt = 0;
+	for (i = 0; i < vcnt; i++) {
+		bi->bi_io_vec[i].bv_len    = PAGE_SIZE;
+		if (bio_size < PAGE_SIZE)
+			bi->bi_io_vec[i].bv_len = bio_size;
+		bio_size -= bi->bi_io_vec[i].bv_len;
+		bi->bi_io_vec[i].bv_offset = 0;
+		bi->bi_io_vec[i].bv_page   = alloc_page(GFP_NOIO);
+		if (!bi->bi_io_vec[i].bv_page)
+			break;
+		bi->bi_vcnt++;
+		bi->bi_size += bi->bi_io_vec[i].bv_len;
+	}
+	bi->bi_next    		   = NULL;
+	bi->bi_end_io 		   = reshape_read_endio;
+	bi->bi_private  	   = kmalloc(sizeof(struct raid0_reshape_bio),
+						GFP_NOIO);
+	bi->bi_idx  		   = 0;
+	return bi;
+}
+
+static inline int is_last_bio_in_chunk(struct raid0_reshape *reshape, int idx)
+{
+	return  idx == (reshape->nr_bios - 1) && reshape->last_bio_size;
+}
+
+static void set_reshape_handle(sector_t sector,
+				struct bio *bi,
+				struct raid0_reshape *reshape)
+{
+	struct raid0_reshape_bio *r = bi->bi_private;
+	r->reshape = reshape;
+	r->bi_size = bi->bi_size;
+	r->array_sector = sector;
+}
+
+/*
+ * process all returning reads and process into the new raid.
+*/
+void do_reshape_writes(mddev_t *mddev)
+{
+	struct raid0_reshape *reshape = mddev_to_reshape(mddev);
+	/*
+	* process all reshape writes
+	*/
+	while (!bio_list_empty(&reshape->ios)) {
+		struct bio *bi;
+		unsigned long flags;
+
+		spin_lock_irqsave(&reshape->lock, flags);
+		bi = bio_list_pop(&reshape->ios);
+		spin_unlock_irqrestore(&reshape->lock, flags);
+		process_reshape_writes(mddev, bi);
+	}
+}
+
+/*
+ * 1.	allocate a read bio by the size of a chunk
+ * 2.   map bio to target device, process the next chunk in the stripe
+ * 3.   generate read ios
+ * 4.   wait for reads
+ * 5.   process incoming ios while waiting
+ * 6.   in return to a read we trasnmit a write
+ * 7.   wait for writes to complete
+ * 8.   a whole stripe is done, sync super blocks.
+*/
+sector_t raid0_sync(mddev_t *mddev, sector_t sector, int *skipped,
+			 int go_faster)
+{
+	struct bio *bi;
+	struct strip_zone *zone;
+	sector_t sector_offset;
+	mdk_rdev_t *tmp_dev;
+	int i = 0, chunk, chunks;
+	sector_t sectors = 0;
+	raid0_conf_t *conf = mddev->private;
+	struct raid0_reshape *reshape = mddev_to_reshape(mddev);
+
+	process_incomings(mddev, &go_faster);
+	if (!go_faster)
+		msleep(100);
+
+	/*
+	 * each zone has its own width, take it here.
+	*/
+	sector_offset = sector;
+	zone = find_zone(mddev->private, &sector_offset);
+	if (!zone) {
+		mdk_rdev_t *rdev;
+		struct strip_zone *z =
+			&conf->strip_zone[conf->nr_strip_zones-1];
+		int last_stripe = (mddev->chunk_sectors)*z->nb_dev;
+		/*
+		* md tells me this is the last sync, did we finish ?
+		*/
+		if ((mddev->recovery_cp + last_stripe) ==
+					mddev->array_sectors) {
+			mddev->recovery_cp = MaxSector;
+			printk(KERN_INFO "raid0: %s, reshape "
+					 "ended succefully at %lld\n",
+				mdname(mddev),
+				(unsigned long long)sector);
+		} else{
+			printk(KERN_INFO "raid0: %s, reshape was "
+					"interrupted at %lld\n",
+				mdname(mddev),
+				(unsigned long long)mddev->curr_resync);
+		}
+		/*
+		* either case, set all disk to sync
+		*/
+		list_for_each_entry(rdev, &mddev->disks, same_set)
+			set_bit(In_sync, &rdev->flags);
+		set_bit(RAID0_RESHAPE_END, &reshape->flags);
+		return 0;
+	}
+	chunks = zone->nb_dev;
+	if ((sector + chunks*(mddev->chunk_sectors)) >
+					mddev->array_sectors) {
+		printk(KERN_ERR "raid0: %s insane , %lld aborting reshape\n",
+			mdname(mddev),
+			(unsigned long long)sector);
+		return 0;
+	}
+	mutex_lock(&conf->reshape_lock);
+	/*
+	* mark currrent position. this way we have a window defined.
+	*/
+	mddev->recovery_cp = sector;
+	/*
+	* generate a serie of reads over the current stripe
+	*/
+	for (chunk = 0 ; chunk < chunks; chunk++) {
+		int bio_size = reshape->bio_size;
+		int vcnt     = (bio_size + PAGE_SIZE - 1)/PAGE_SIZE;
+		for (i = 0; i < reshape->nr_bios; i++) {
+			sector_offset = sector;
+			if (is_last_bio_in_chunk(reshape, i)) {
+				bio_size = reshape->last_bio_size;
+				vcnt = (bio_size + PAGE_SIZE - 1)/PAGE_SIZE;
+			}
+			bi = reshape_get_bio(reshape, vcnt, bio_size);
+			if (!bi) {
+				mutex_unlock(&conf->reshape_lock);
+				return sectors;
+			}
+			set_reshape_handle(sector, bi, reshape);
+			/*
+			 * map the bio
+			*/
+			zone =  find_zone(mddev->private, &sector_offset);
+			if (!zone)
+				BUG();
+
+			tmp_dev = map_sector(mddev->private,
+						mddev->chunk_sectors,
+						mddev->raid_disks,
+						zone, sector,
+						&sector_offset);
+			bi->bi_bdev = tmp_dev->bdev;
+			bi->bi_sector = sector_offset + zone->dev_start +
+							tmp_dev->data_offset;
+			atomic_inc(&reshape->active_ios);
+			generic_make_request(bi);
+			sectors += (bi->bi_size>>9);
+			sector  += (bi->bi_size>>9);
+		}
+	}
+	mutex_unlock(&conf->reshape_lock);
+	/* save last window size */
+	reshape->window = sectors;
+	/*
+	 * now wait on ios.
+	*/
+	do {
+		msleep(10);
+		process_incomings(mddev, &go_faster);
+		do_reshape_writes(mddev);
+	} while (atomic_read(&reshape->active_ios) > 0);
+
+	list_for_each_entry(tmp_dev, &mddev->disks, same_set) {
+		tmp_dev->sb_loaded = 1;
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	}
+	/* for resume reshape */
+	mddev->reshape_position = sector + sectors;
+	/* will update the super blocks */
+	md_check_recovery(mddev);
+	return sectors;
+}
+
+/*
+ * 1. Raise a device barrier and wait until all IO stops.
+ * 2. Create a temporary mddev mappings that include the new disks.
+ * 3. Set the resync flag and wake thread
+ */
+static int raid0_check_reshape(mddev_t *mddev)
+{
+	int err;
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+		return 0;
+	/* Cannot change chunk_size, layout, or level */
+	if (mddev->chunk_sectors  != mddev->new_chunk_sectors ||
+	    mddev->layout != mddev->new_layout ||
+	    mddev->level != mddev->new_level) {
+		mddev->new_chunk_sectors = mddev->chunk_sectors;
+		mddev->new_layout = mddev->layout;
+		mddev->new_level = mddev->level;
+		return -EINVAL;
+	}
+	err = md_allow_write(mddev);
+	if (err)
+		return err;
+	if (reshape_init(mddev)) {
+		printk(KERN_ERR "raid0: failed to start reshape\n");
+		return -1;
+	}
+	mddev->recovery_cp = 0;
+	return start_raid0d(mddev);
+}
+
+/*
+ * Find all not synce'd disks within the raid0's configuration
+ * and mark then sync. Then recompute the stripes zones and fix
+ * number of disks
+ */
+static int raid0_spare_active(mddev_t *mddev)
+{
+	int go_faster;
+	struct raid0_reshape *reshape = mddev_to_reshape(mddev);
+	raid0_conf_t *conf = mddev->private;
+
+	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+	/*
+	* we might be having incoming ios not processed yet,
+	* we drain them here. All ios must be released, else
+	* we have an error
+	*/
+	process_incomings(mddev, &go_faster);
+	mutex_lock(&conf->reshape_lock);
+	conf->reshape = NULL;
+	mutex_unlock(&conf->reshape_lock);
+	blk_plug_device_unlocked(mddev->queue);
+	/*
+	* recompute the raid's conf.
+	*/
+	mddev->raid_disks = reshape->raid_disks;
+	mddev->in_sync = 1;
+	mddev->delta_disks = 0;
+	mddev->recovery_cp = MaxSector;
+	mddev->reshape_position  = MaxSector;
+	raid0_run(mddev);
+	/* report media change */
+	set_capacity(mddev->gendisk, mddev->array_sectors);
+	mddev->changed = 1;
+	blk_unplug(mddev->queue);
+	md_allow_write(mddev);
+	/*
+	* now free unused memory
+	*/
+	kfree(reshape->conf->strip_zone);
+	kfree(reshape->conf->devlist);
+	kfree(reshape->conf);
+	kfree(reshape);
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
+	kfree(conf);
+	return 0;
+}
+
+
+
 static int raid0_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	char b[BDEVNAME_SIZE];
@@ -682,6 +1334,15 @@ static int raid0_remove_disk(mddev_t *mddev, int number)
 	return 0;
 }
 
+/*
+ * for the sake of resume reshape only. reshape is invoked
+ * automatically by raid0_run.
+*/
+int raid0_start_reshape(mddev_t *mddev)
+{
+	return -1;
+}
+
 static struct mdk_personality raid0_personality=
 {
 	.name		= "raid0",
@@ -694,6 +1355,10 @@ static struct mdk_personality raid0_personality=
 	.size		= raid0_size,
 	.hot_add_disk	= raid0_add_disk,
 	.hot_remove_disk = raid0_remove_disk,
+	.check_reshape	= raid0_check_reshape,
+	.spare_active	= raid0_spare_active,
+	.sync_request   = raid0_sync,
+	.start_reshape = raid0_start_reshape,
 };
 
 static int __init raid0_init (void)



