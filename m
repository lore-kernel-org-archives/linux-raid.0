From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 13 - Store rdev instead of bdev in per-personality status arrays
Date: Thu, 22 Aug 2002 10:33:56 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvA-000500-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Holding the rdev instead of the bdev does cause an extra 
de-reference, but it is conceptually cleaner and will allow
lots more tidying up.



 ----------- Diffstat output ------------
 ./drivers/md/linear.c            |   12 ++++++------
 ./drivers/md/multipath.c         |   20 ++++++++++----------
 ./drivers/md/raid1.c             |   39 +++++++++++++++++++--------------------
 ./drivers/md/raid5.c             |   36 +++++++++++++++++-------------------
 ./include/linux/raid/linear.h    |    2 +-
 ./include/linux/raid/multipath.h |    2 +-
 ./include/linux/raid/raid1.h     |    2 +-
 ./include/linux/raid/raid5.h     |   10 +++++-----
 8 files changed, 60 insertions(+), 63 deletions(-)

--- ./include/linux/raid/linear.h	2002/08/21 23:07:05	1.1
+++ ./include/linux/raid/linear.h	2002/08/21 23:07:28	1.2
@@ -4,7 +4,7 @@
 #include <linux/raid/md.h>
 
 struct dev_info {
-	struct block_device *bdev;
+	mdk_rdev_t	*rdev;
 	unsigned long	size;
 	unsigned long	offset;
 };
--- ./include/linux/raid/raid1.h	2002/08/21 23:07:05	1.1
+++ ./include/linux/raid/raid1.h	2002/08/21 23:07:28	1.2
@@ -6,7 +6,7 @@
 typedef struct mirror_info mirror_info_t;
 
 struct mirror_info {
-	struct block_device *bdev;
+	mdk_rdev_t	*rdev;
 	sector_t	head_position;
 	atomic_t	nr_pending;
 
--- ./include/linux/raid/raid5.h	2002/08/21 23:07:05	1.1
+++ ./include/linux/raid/raid5.h	2002/08/21 23:07:28	1.2
@@ -192,11 +192,11 @@ struct stripe_head {
  
 
 struct disk_info {
-	struct block_device *bdev;
-	int	operational;
-	int	write_only;
-	int	spare;
-	int	used_slot;
+	mdk_rdev_t	*rdev;
+	int		operational;
+	int		write_only;
+	int		spare;
+	int		used_slot;
 };
 
 struct raid5_private_data {
--- ./include/linux/raid/multipath.h	2002/08/21 23:07:05	1.1
+++ ./include/linux/raid/multipath.h	2002/08/21 23:07:28	1.2
@@ -5,7 +5,7 @@
 #include <linux/bio.h>
 
 struct multipath_info {
-	struct block_device *bdev;
+	mdk_rdev_t	*rdev;
 
 	/*
 	 * State bits:
--- ./drivers/md/raid5.c	2002/08/21 11:24:29	1.2
+++ ./drivers/md/raid5.c	2002/08/21 23:07:28	1.3
@@ -371,7 +371,7 @@ static void raid5_end_read_request (stru
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 #endif		
 	} else {
-		md_error(conf->mddev, conf->disks[i].bdev);
+		md_error(conf->mddev, conf->disks[i].rdev->bdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 	}
 #if 0
@@ -407,7 +407,7 @@ static void raid5_end_write_request (str
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	if (!uptodate)
-		md_error(conf->mddev, conf->disks[i].bdev);
+		md_error(conf->mddev, conf->disks[i].rdev->bdev);
 	
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -420,7 +420,6 @@ static unsigned long compute_blocknr(str
 	
 static void raid5_build_block (struct stripe_head *sh, int i)
 {
-	raid5_conf_t *conf = sh->raid_conf;
 	struct r5dev *dev = &sh->dev[i];
 
 	bio_init(&dev->req);
@@ -430,7 +429,6 @@ static void raid5_build_block (struct st
 	dev->vec.bv_len = STRIPE_SIZE;
 	dev->vec.bv_offset = 0;
 
-	dev->req.bi_bdev = conf->disks[i].bdev;
 	dev->req.bi_sector = sh->sector;
 	dev->req.bi_private = sh;
 
@@ -448,7 +446,7 @@ static int error(mddev_t *mddev, struct 
 	PRINTK("raid5: error called\n");
 
 	for (i = 0, disk = conf->disks; i < conf->raid_disks; i++, disk++) {
-		if (disk->bdev != bdev)
+		if (disk->rdev->bdev != bdev)
 			continue;
 		if (disk->operational) {
 			disk->operational = 0;
@@ -468,7 +466,7 @@ static int error(mddev_t *mddev, struct 
 	 */
 	if (conf->spare) {
 		disk = conf->spare;
-		if (disk->bdev == bdev) {
+		if (disk->rdev->bdev == bdev) {
 			printk (KERN_ALERT
 				"raid5: Disk failure on spare %s\n",
 				bdev_partition_name (bdev));
@@ -1003,7 +1001,7 @@ static void handle_stripe(struct stripe_
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n", i, syncing);
 					if (syncing)
-						md_sync_acct(conf->disks[i].bdev, STRIPE_SECTORS);
+						md_sync_acct(conf->disks[i].rdev->bdev, STRIPE_SECTORS);
 				}
 			}
 		}
@@ -1142,9 +1140,9 @@ static void handle_stripe(struct stripe_
 			locked++;
 			set_bit(STRIPE_INSYNC, &sh->state);
 			if (conf->disks[failed_num].operational)
-				md_sync_acct(conf->disks[failed_num].bdev, STRIPE_SECTORS);
+				md_sync_acct(conf->disks[failed_num].rdev->bdev, STRIPE_SECTORS);
 			else if ((spare=conf->spare))
-				md_sync_acct(spare->bdev, STRIPE_SECTORS);
+				md_sync_acct(spare->rdev->bdev, STRIPE_SECTORS);
 
 		}
 	}
@@ -1170,9 +1168,9 @@ static void handle_stripe(struct stripe_
 			else
 				bi->bi_end_io = raid5_end_write_request;
 			if (conf->disks[i].operational)
-				bi->bi_bdev = conf->disks[i].bdev;
+				bi->bi_bdev = conf->disks[i].rdev->bdev;
 			else if (spare && action[i] == WRITE+1)
-				bi->bi_bdev = spare->bdev;
+				bi->bi_bdev = spare->rdev->bdev;
 			else skip=1;
 			if (!skip) {
 				PRINTK("for %ld schedule op %d on disc %d\n", sh->sector, action[i]-1, i);
@@ -1409,7 +1407,7 @@ static int run (mddev_t *mddev)
 
 		if (rdev->faulty) {
 			printk(KERN_ERR "raid5: disabled device %s (errors detected)\n", bdev_partition_name(rdev->bdev));
-			disk->bdev = rdev->bdev;
+			disk->rdev = rdev;
 
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1424,7 +1422,7 @@ static int run (mddev_t *mddev)
 			}
 			printk(KERN_INFO "raid5: device %s operational as raid disk %d\n", bdev_partition_name(rdev->bdev), raid_disk);
 	
-			disk->bdev = rdev->bdev;
+			disk->rdev = rdev;
 			disk->operational = 1;
 			disk->used_slot = 1;
 
@@ -1434,7 +1432,7 @@ static int run (mddev_t *mddev)
 			 * Must be a spare disk ..
 			 */
 			printk(KERN_INFO "raid5: spare disk %s\n", bdev_partition_name(rdev->bdev));
-			disk->bdev = rdev->bdev;
+			disk->rdev = rdev;
 
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1447,7 +1445,7 @@ static int run (mddev_t *mddev)
 		disk = conf->disks + i;
 
 		if (!disk->used_slot) {
-			disk->bdev = NULL;
+			disk->rdev = NULL;
 
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1628,7 +1626,7 @@ static void print_raid5_conf (raid5_conf
 		printk(" disk %d, s:%d, o:%d, us:%d dev:%s\n",
 			i, tmp->spare,tmp->operational,
 			tmp->used_slot,
-			bdev_partition_name(tmp->bdev));
+			bdev_partition_name(tmp->rdev->bdev));
 	}
 }
 
@@ -1695,7 +1693,7 @@ static int raid5_spare_active(mddev_t *m
 	 * disk. (this means we switch back these values)
 	 */
 
-	if (!sdisk->bdev)
+	if (!sdisk->rdev)
 		sdisk->used_slot = 0;
 
 	/*
@@ -1778,7 +1776,7 @@ static int raid5_remove_disk(mddev_t *md
 			err = -EBUSY;
 			goto abort;
 		}
-		p->bdev = NULL;
+		p->rdev = NULL;
 		p->used_slot = 0;
 		err = 0;
 	}
@@ -1804,7 +1802,7 @@ static int raid5_add_disk(mddev_t *mddev
 
 	if (!p->used_slot) {
 		/* it will be held open by rdev */
-		p->bdev = rdev->bdev;
+		p->rdev = rdev;
 		p->operational = 0;
 		p->write_only = 0;
 		p->spare = 1;
--- ./drivers/md/linear.c	2002/08/21 23:07:06	1.1
+++ ./drivers/md/linear.c	2002/08/21 23:07:28	1.2
@@ -55,12 +55,12 @@ static int linear_run (mddev_t *mddev)
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
 
-		if (j < 0 || j > mddev->raid_disks || disk->bdev) {
+		if (j < 0 || j > mddev->raid_disks || disk->rdev) {
 			printk("linear: disk numbering problem. Aborting!\n");
 			goto out;
 		}
 
-		disk->bdev = rdev->bdev;
+		disk->rdev = rdev;
 		disk->size = rdev->size;
 
 		if (!conf->smallest || (disk->size < conf->smallest->size))
@@ -153,11 +153,11 @@ static int linear_make_request (request_
     
 	if (block >= (tmp_dev->size + tmp_dev->offset)
 				|| block < tmp_dev->offset) {
-		printk ("linear_make_request: Block %ld out of bounds on dev %s size %ld offset %ld\n", block, bdevname(tmp_dev->bdev), tmp_dev->size, tmp_dev->offset);
+		printk ("linear_make_request: Block %ld out of bounds on dev %s size %ld offset %ld\n", block, bdevname(tmp_dev->rdev->bdev), tmp_dev->size, tmp_dev->offset);
 		bio_io_error(bio);
 		return 0;
 	}
-	bio->bi_bdev = tmp_dev->bdev;
+	bio->bi_bdev = tmp_dev->rdev->bdev;
 	bio->bi_sector = bio->bi_sector - (tmp_dev->offset << 1);
 
 	return 1;
@@ -176,11 +176,11 @@ static int linear_status (char *page, md
 	for (j = 0; j < conf->nr_zones; j++)
 	{
 		sz += sprintf(page+sz, "[%s",
-			bdev_partition_name(conf->hash_table[j].dev0->bdev));
+			bdev_partition_name(conf->hash_table[j].dev0->rdev->bdev));
 
 		if (conf->hash_table[j].dev1)
 			sz += sprintf(page+sz, "/%s] ",
-			  bdev_partition_name(conf->hash_table[j].dev1->bdev));
+			  bdev_partition_name(conf->hash_table[j].dev1->rdev->bdev));
 		else
 			sz += sprintf(page+sz, "] ");
 	}
--- ./drivers/md/raid1.c	2002/08/21 23:07:06	1.1
+++ ./drivers/md/raid1.c	2002/08/21 23:07:28	1.2
@@ -200,7 +200,7 @@ static int map(mddev_t *mddev, struct bl
 
 	for (i = 0; i < disks; i++) {
 		if (conf->mirrors[i].operational) {
-			*bdev = conf->mirrors[i].bdev;
+			*bdev = conf->mirrors[i].rdev->bdev;
 			return 0;
 		}
 	}
@@ -265,7 +265,7 @@ static void end_request(struct bio *bio)
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
 	if (!uptodate)
-		md_error(r1_bio->mddev, conf->mirrors[mirror].bdev);
+		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev->bdev);
 	else
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
@@ -293,7 +293,7 @@ static void end_request(struct bio *bio)
 		 * oops, read error:
 		 */
 		printk(KERN_ERR "raid1: %s: rescheduling sector %lu\n",
-			bdev_partition_name(conf->mirrors[mirror].bdev), r1_bio->sector);
+			bdev_partition_name(conf->mirrors[mirror].rdev->bdev), r1_bio->sector);
 		reschedule_retry(r1_bio);
 		return;
 	}
@@ -478,7 +478,7 @@ static int make_request(request_queue_t 
 		r1_bio->read_bio = read_bio;
 
 		read_bio->bi_sector = r1_bio->sector;
-		read_bio->bi_bdev = mirror->bdev;
+		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = end_request;
 		read_bio->bi_rw = r1_bio->cmd;
 		read_bio->bi_private = r1_bio;
@@ -502,7 +502,7 @@ static int make_request(request_queue_t 
 		r1_bio->write_bios[i] = mbio;
 
 		mbio->bi_sector	= r1_bio->sector;
-		mbio->bi_bdev = conf->mirrors[i].bdev;
+		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= end_request;
 		mbio->bi_rw = r1_bio->cmd;
 		mbio->bi_private = r1_bio;
@@ -582,7 +582,7 @@ static void mark_disk_bad(mddev_t *mddev
 		conf->working_disks--;
 	}
 	mddev->sb_dirty = 1;
-	printk(DISK_FAILED, bdev_partition_name(mirror->bdev), conf->working_disks);
+	printk(DISK_FAILED, bdev_partition_name(mirror->rdev->bdev), conf->working_disks);
 }
 
 static int error(mddev_t *mddev, struct block_device *bdev)
@@ -600,7 +600,7 @@ static int error(mddev_t *mddev, struct 
 	 * else mark the drive as failed
 	 */
 	for (i = 0; i < disks; i++)
-		if (mirrors[i].bdev == bdev && mirrors[i].operational)
+		if (mirrors[i].operational && mirrors[i].rdev->bdev == bdev)
 			break;
 	if (i == disks)
 		return 0;
@@ -633,7 +633,7 @@ static void print_conf(conf_t *conf)
 		printk(" disk %d, s:%d, o:%d, us:%d dev:%s\n",
 			i, tmp->spare, tmp->operational,
 			tmp->used_slot,
-			bdev_partition_name(tmp->bdev));
+			bdev_partition_name(tmp->rdev->bdev));
 	}
 }
 
@@ -718,7 +718,7 @@ static int raid1_spare_active(mddev_t *m
 	 * disk. (this means we switch back these values)
 	 */
 
-	if (!sdisk->bdev)
+	if (!sdisk->rdev)
 		sdisk->used_slot = 0;
 	/*
 	 * this really activates the spare.
@@ -792,8 +792,7 @@ static int raid1_add_disk(mddev_t *mddev
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	if (!p->used_slot) {
-		/* it will be held open by rdev */
-		p->bdev = rdev->bdev;
+		p->rdev = rdev;
 		p->operational = 0;
 		p->write_only = 0;
 		p->spare = 1;
@@ -822,7 +821,7 @@ static int raid1_remove_disk(mddev_t *md
 			err = -EBUSY;
 			goto abort;
 		}
-		p->bdev = NULL;
+		p->rdev = NULL;
 		p->used_slot = 0;
 		err = 0;
 	}
@@ -857,7 +856,7 @@ static void end_sync_read(struct bio *bi
 	 */
 	if (!uptodate)
 		md_error(r1_bio->mddev,
-			 conf->mirrors[r1_bio->read_disk].bdev);
+			 conf->mirrors[r1_bio->read_disk].rdev->bdev);
 	else
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 	reschedule_retry(r1_bio);
@@ -878,7 +877,7 @@ static void end_sync_write(struct bio *b
 			break;
 		}
 	if (!uptodate)
-		md_error(mddev, conf->mirrors[mirror].bdev);
+		md_error(mddev, conf->mirrors[mirror].rdev->bdev);
 	update_head_pos(mirror, r1_bio);
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
@@ -931,7 +930,7 @@ static void sync_request_write(mddev_t *
 		if (r1_bio->write_bios[i])
 			BUG();
 		r1_bio->write_bios[i] = mbio;
-		mbio->bi_bdev = conf->mirrors[i].bdev;
+		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_sector = r1_bio->sector;
 		mbio->bi_end_io	= end_sync_write;
 		mbio->bi_rw = WRITE;
@@ -1119,7 +1118,7 @@ static int sync_request(mddev_t *mddev, 
 	read_bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
 
 	read_bio->bi_sector = sector_nr;
-	read_bio->bi_bdev = mirror->bdev;
+	read_bio->bi_bdev = mirror->rdev->bdev;
 	read_bio->bi_end_io = end_sync_read;
 	read_bio->bi_rw = READ;
 	read_bio->bi_private = r1_bio;
@@ -1228,7 +1227,7 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		if (rdev->faulty) {
-			disk->bdev = rdev->bdev;
+			disk->rdev = rdev;
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 0;
@@ -1245,7 +1244,7 @@ static int run(mddev_t *mddev)
 			}
 			printk(OPERATIONAL, bdev_partition_name(rdev->bdev),
 					disk_idx);
-			disk->bdev = rdev->bdev;
+			disk->rdev = rdev;
 			disk->operational = 1;
 			disk->write_only = 0;
 			disk->spare = 0;
@@ -1257,7 +1256,7 @@ static int run(mddev_t *mddev)
 		 * Must be a spare disk ..
 		 */
 			printk(SPARE, bdev_partition_name(rdev->bdev));
-			disk->bdev = rdev->bdev;
+			disk->rdev = rdev;
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 1;
@@ -1284,7 +1283,7 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + i;
 
 		if (!disk->used_slot) {
-			disk->bdev = NULL;
+			disk->rdev = NULL;
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 0;
--- ./drivers/md/multipath.c	2002/08/21 23:07:06	1.1
+++ ./drivers/md/multipath.c	2002/08/21 23:07:28	1.2
@@ -82,7 +82,7 @@ static int multipath_map (mddev_t *mddev
 
 	for (i = 0; i < disks; i++) {
 		if (conf->multipaths[i].operational) {
-			*bdev = conf->multipaths[i].bdev;
+			*bdev = conf->multipaths[i].rdev->bdev;
 			return (0);
 		}
 	}
@@ -136,7 +136,7 @@ void multipath_end_request(struct bio *b
 	 * oops, IO error:
 	 */
 	conf = mddev_to_conf(mp_bh->mddev);
-	bdev = conf->multipaths[mp_bh->path].bdev;
+	bdev = conf->multipaths[mp_bh->path].rdev->bdev;
 	md_error (mp_bh->mddev, bdev);
 	printk(KERN_ERR "multipath: %s: rescheduling sector %lu\n", 
 		 bdev_partition_name(bdev), bio->bi_sector);
@@ -179,7 +179,7 @@ static int multipath_make_request (reque
 	multipath = conf->multipaths + mp_bh->path;
 
 	mp_bh->bio = *bio;
-	mp_bh->bio.bi_bdev = multipath->bdev;
+	mp_bh->bio.bi_bdev = multipath->rdev->bdev;
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
 	generic_make_request(&mp_bh->bio);
@@ -218,7 +218,7 @@ static void mark_disk_bad (mddev_t *mdde
 	multipath->operational = 0;
 	mddev->sb_dirty = 1;
 	conf->working_disks--;
-	printk (DISK_FAILED, bdev_partition_name (multipath->bdev),
+	printk (DISK_FAILED, bdev_partition_name (multipath->rdev->bdev),
 				 conf->working_disks);
 }
 
@@ -240,7 +240,7 @@ static int multipath_error (mddev_t *mdd
 		 * which has just failed.
 		 */
 		for (i = 0; i < disks; i++) {
-			if (multipaths[i].bdev == bdev && !multipaths[i].operational)
+			if (multipaths[i].rdev->bdev == bdev && !multipaths[i].operational)
 				return 0;
 		}
 		printk (LAST_DISK);
@@ -250,7 +250,7 @@ static int multipath_error (mddev_t *mdd
 		 * Mark disk as unusable
 		 */
 		for (i = 0; i < disks; i++) {
-			if (multipaths[i].bdev == bdev && multipaths[i].operational) {
+			if (multipaths[i].rdev->bdev == bdev && multipaths[i].operational) {
 				mark_disk_bad(mddev, i);
 				break;
 			}
@@ -283,7 +283,7 @@ static void print_multipath_conf (multip
 			printk(" disk%d, o:%d, us:%d dev:%s\n",
 				i,tmp->operational,
 				tmp->used_slot,
-				bdev_partition_name(tmp->bdev));
+				bdev_partition_name(tmp->rdev->bdev));
 	}
 }
 
@@ -297,7 +297,7 @@ static int multipath_add_disk(mddev_t *m
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	if (!p->used_slot) {
-		p->bdev = rdev->bdev;
+		p->rdev = rdev;
 		p->operational = 1;
 		p->used_slot = 1;
 		conf->working_disks++;
@@ -326,7 +326,7 @@ static int multipath_remove_disk(mddev_t
 			err = -EBUSY;
 			goto abort;
 		}
-		p->bdev = NULL;
+		p->rdev = NULL;
 		p->used_slot = 0;
 		err = 0;
 	}
@@ -485,7 +485,7 @@ static int multipath_run (mddev_t *mddev
 		 * spares.  multipath_read_balance deals with choose
 		 * the "best" operational device.
 		 */
-		disk->bdev = rdev->bdev;
+		disk->rdev = rdev;
 		disk->operational = 1;
 		disk->used_slot = 1;
 		num_rdevs++;
