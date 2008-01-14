From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 6] md: Change ITERATE_RDEV to rdev_for_each
Date: Mon, 14 Jan 2008 12:45:49 +1100
Message-ID: <1080114014549.20399@suse.de>
References: <20080114123726.19968.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


as this is morein line with common practice in the kernel.
Also swap the args around to be more like list_for_each.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c       |    4 +-
 ./drivers/md/faulty.c       |    2 -
 ./drivers/md/linear.c       |    2 -
 ./drivers/md/md.c           |   64 ++++++++++++++++++++++----------------------
 ./drivers/md/multipath.c    |    2 -
 ./drivers/md/raid0.c        |    8 ++---
 ./drivers/md/raid1.c        |    2 -
 ./drivers/md/raid10.c       |    2 -
 ./drivers/md/raid5.c        |    6 ++--
 ./include/linux/raid/md_k.h |    2 -
 10 files changed, 47 insertions(+), 47 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-01-11 15:01:13.000000000 +1100
+++ ./drivers/md/bitmap.c	2008-01-14 12:26:10.000000000 +1100
@@ -231,7 +231,7 @@ static struct page *read_sb_page(mddev_t
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	ITERATE_RDEV(mddev, rdev, tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (! test_bit(In_sync, &rdev->flags)
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
@@ -255,7 +255,7 @@ static int write_sb_page(struct bitmap *
 	struct list_head *tmp;
 	mddev_t *mddev = bitmap->mddev;
 
-	ITERATE_RDEV(mddev, rdev, tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		if (test_bit(In_sync, &rdev->flags)
 		    && !test_bit(Faulty, &rdev->flags)) {
 			int size = PAGE_SIZE;

diff .prev/drivers/md/faulty.c ./drivers/md/faulty.c
--- .prev/drivers/md/faulty.c	2008-01-11 15:01:13.000000000 +1100
+++ ./drivers/md/faulty.c	2008-01-14 12:26:10.000000000 +1100
@@ -294,7 +294,7 @@ static int run(mddev_t *mddev)
 	}
 	conf->nfaults = 0;
 
-	ITERATE_RDEV(mddev, rdev, tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		conf->rdev = rdev;
 
 	mddev->array_size = mddev->size;

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2008-01-11 15:01:13.000000000 +1100
+++ ./drivers/md/linear.c	2008-01-14 12:26:10.000000000 +1100
@@ -122,7 +122,7 @@ static linear_conf_t *linear_conf(mddev_
 	cnt = 0;
 	conf->array_size = 0;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
 

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-14 12:26:04.000000000 +1100
+++ ./drivers/md/md.c	2008-01-14 12:26:10.000000000 +1100
@@ -311,7 +311,7 @@ static mdk_rdev_t * find_rdev_nr(mddev_t
 	mdk_rdev_t * rdev;
 	struct list_head *tmp;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->desc_nr == nr)
 			return rdev;
 	}
@@ -323,7 +323,7 @@ static mdk_rdev_t * find_rdev(mddev_t * 
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->bdev->bd_dev == dev)
 			return rdev;
 	}
@@ -944,7 +944,7 @@ static void super_90_sync(mddev_t *mddev
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
 
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
-	ITERATE_RDEV(mddev,rdev2,tmp) {
+	rdev_for_each(rdev2, tmp, mddev) {
 		mdp_disk_t *d;
 		int desc_nr;
 		if (rdev2->raid_disk >= 0 && test_bit(In_sync, &rdev2->flags)
@@ -1297,7 +1297,7 @@ static void super_1_sync(mddev_t *mddev,
 	}
 
 	max_dev = 0;
-	ITERATE_RDEV(mddev,rdev2,tmp)
+	rdev_for_each(rdev2, tmp, mddev)
 		if (rdev2->desc_nr+1 > max_dev)
 			max_dev = rdev2->desc_nr+1;
 
@@ -1306,7 +1306,7 @@ static void super_1_sync(mddev_t *mddev,
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	
-	ITERATE_RDEV(mddev,rdev2,tmp) {
+	rdev_for_each(rdev2, tmp, mddev) {
 		i = rdev2->desc_nr;
 		if (test_bit(Faulty, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
@@ -1344,8 +1344,8 @@ static int match_mddev_units(mddev_t *md
 	struct list_head *tmp, *tmp2;
 	mdk_rdev_t *rdev, *rdev2;
 
-	ITERATE_RDEV(mddev1,rdev,tmp)
-		ITERATE_RDEV(mddev2, rdev2, tmp2)
+	rdev_for_each(rdev, tmp, mddev1)
+		rdev_for_each(rdev2, tmp2, mddev2)
 			if (rdev->bdev->bd_contains ==
 			    rdev2->bdev->bd_contains)
 				return 1;
@@ -1518,7 +1518,7 @@ static void export_array(mddev_t *mddev)
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (!rdev->mddev) {
 			MD_BUG();
 			continue;
@@ -1602,11 +1602,11 @@ static void md_print_devices(void)
 			bitmap_print_sb(mddev->bitmap);
 		else
 			printk("%s: ", mdname(mddev));
-		ITERATE_RDEV(mddev,rdev,tmp2)
+		rdev_for_each(rdev, tmp2, mddev)
 			printk("<%s>", bdevname(rdev->bdev,b));
 		printk("\n");
 
-		ITERATE_RDEV(mddev,rdev,tmp2)
+		rdev_for_each(rdev, tmp2, mddev)
 			print_rdev(rdev);
 	}
 	printk("md:	**********************************\n");
@@ -1625,7 +1625,7 @@ static void sync_sbs(mddev_t * mddev, in
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->sb_events == mddev->events ||
 		    (nospares &&
 		     rdev->raid_disk < 0 &&
@@ -1732,7 +1732,7 @@ repeat:
 		mdname(mddev),mddev->in_sync);
 
 	bitmap_update_sb(mddev->bitmap);
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		char b[BDEVNAME_SIZE];
 		dprintk(KERN_INFO "md: ");
 		if (rdev->sb_loaded != 1)
@@ -2018,7 +2018,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 			mdk_rdev_t *rdev2;
 
 			mddev_lock(mddev);
-			ITERATE_RDEV(mddev, rdev2, tmp2)
+			rdev_for_each(rdev2, tmp2, mddev)
 				if (test_bit(AllReserved, &rdev2->flags) ||
 				    (rdev->bdev == rdev2->bdev &&
 				     rdev != rdev2 &&
@@ -2204,7 +2204,7 @@ static void analyze_sbs(mddev_t * mddev)
 	char b[BDEVNAME_SIZE];
 
 	freshest = NULL;
-	ITERATE_RDEV(mddev,rdev,tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		switch (super_types[mddev->major_version].
 			load_super(rdev, freshest, mddev->minor_version)) {
 		case 1:
@@ -2225,7 +2225,7 @@ static void analyze_sbs(mddev_t * mddev)
 		validate_super(mddev, freshest);
 
 	i = 0;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev != freshest)
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
@@ -3319,7 +3319,7 @@ static int do_md_run(mddev_t * mddev)
 		}
 
 		/* devices must have minimum size of one chunk */
-		ITERATE_RDEV(mddev,rdev,tmp) {
+		rdev_for_each(rdev, tmp, mddev) {
 			if (test_bit(Faulty, &rdev->flags))
 				continue;
 			if (rdev->size < chunk_size / 1024) {
@@ -3346,7 +3346,7 @@ static int do_md_run(mddev_t * mddev)
 	 * the only valid external interface is through the md
 	 * device.
 	 */
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		sync_blockdev(rdev->bdev);
@@ -3412,8 +3412,8 @@ static int do_md_run(mddev_t * mddev)
 		mdk_rdev_t *rdev2;
 		struct list_head *tmp2;
 		int warned = 0;
-		ITERATE_RDEV(mddev, rdev, tmp) {
-			ITERATE_RDEV(mddev, rdev2, tmp2) {
+		rdev_for_each(rdev, tmp, mddev) {
+			rdev_for_each(rdev2, tmp2, mddev) {
 				if (rdev < rdev2 &&
 				    rdev->bdev->bd_contains ==
 				    rdev2->bdev->bd_contains) {
@@ -3473,7 +3473,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
 	mddev->in_sync = 1;
 
-	ITERATE_RDEV(mddev,rdev,tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		if (rdev->raid_disk >= 0) {
 			char nm[20];
 			sprintf(nm, "rd%d", rdev->raid_disk);
@@ -3506,7 +3506,7 @@ static int do_md_run(mddev_t * mddev)
 	if (mddev->degraded && !mddev->sync_thread) {
 		struct list_head *rtmp;
 		int spares = 0;
-		ITERATE_RDEV(mddev,rdev,rtmp)
+		rdev_for_each(rdev, rtmp, mddev)
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
 			    !test_bit(Faulty, &rdev->flags))
@@ -3683,7 +3683,7 @@ static int do_md_stop(mddev_t * mddev, i
 		}
 		mddev->bitmap_offset = 0;
 
-		ITERATE_RDEV(mddev,rdev,tmp)
+		rdev_for_each(rdev, tmp, mddev)
 			if (rdev->raid_disk >= 0) {
 				char nm[20];
 				sprintf(nm, "rd%d", rdev->raid_disk);
@@ -3724,7 +3724,7 @@ static void autorun_array(mddev_t *mddev
 
 	printk(KERN_INFO "md: running: ");
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		char b[BDEVNAME_SIZE];
 		printk("<%s>", bdevname(rdev->bdev,b));
 	}
@@ -3851,7 +3851,7 @@ static int get_array_info(mddev_t * mdde
 	struct list_head *tmp;
 
 	nr=working=active=failed=spare=0;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		nr++;
 		if (test_bit(Faulty, &rdev->flags))
 			failed++;
@@ -4391,7 +4391,7 @@ static int update_size(mddev_t *mddev, u
 	 */
 	if (mddev->sync_thread)
 		return -EBUSY;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		sector_t avail;
 		avail = rdev->size * 2;
 
@@ -5132,7 +5132,7 @@ static int md_seq_show(struct seq_file *
 		}
 
 		size = 0;
-		ITERATE_RDEV(mddev,rdev,tmp2) {
+		rdev_for_each(rdev, tmp2, mddev) {
 			char b[BDEVNAME_SIZE];
 			seq_printf(seq, " %s[%d]",
 				bdevname(rdev->bdev,b), rdev->desc_nr);
@@ -5287,7 +5287,7 @@ static int is_mddev_idle(mddev_t *mddev)
 	long curr_events;
 
 	idle = 1;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
 		curr_events = disk_stat_read(disk, sectors[0]) + 
 				disk_stat_read(disk, sectors[1]) - 
@@ -5514,7 +5514,7 @@ void md_do_sync(mddev_t *mddev)
 		/* recovery follows the physical size of devices */
 		max_sectors = mddev->size << 1;
 		j = MaxSector;
-		ITERATE_RDEV(mddev,rdev,rtmp)
+		rdev_for_each(rdev, rtmp, mddev)
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(In_sync, &rdev->flags) &&
@@ -5667,7 +5667,7 @@ void md_do_sync(mddev_t *mddev)
 		} else {
 			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 				mddev->curr_resync = MaxSector;
-			ITERATE_RDEV(mddev,rdev,rtmp)
+			rdev_for_each(rdev, rtmp, mddev)
 				if (rdev->raid_disk >= 0 &&
 				    !test_bit(Faulty, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags) &&
@@ -5705,7 +5705,7 @@ static int remove_and_add_spares(mddev_t
 	struct list_head *rtmp;
 	int spares = 0;
 
-	ITERATE_RDEV(mddev,rdev,rtmp)
+	rdev_for_each(rdev, rtmp, mddev)
 		if (rdev->raid_disk >= 0 &&
 		    !mddev->external &&
 		    (test_bit(Faulty, &rdev->flags) ||
@@ -5721,7 +5721,7 @@ static int remove_and_add_spares(mddev_t
 		}
 
 	if (mddev->degraded) {
-		ITERATE_RDEV(mddev,rdev,rtmp)
+		rdev_for_each(rdev, rtmp, mddev)
 			if (rdev->raid_disk < 0
 			    && !test_bit(Faulty, &rdev->flags)) {
 				rdev->recovery_offset = 0;
@@ -5835,7 +5835,7 @@ void md_check_recovery(mddev_t *mddev)
 			 * information must be scrapped
 			 */
 			if (!mddev->degraded)
-				ITERATE_RDEV(mddev,rdev,rtmp)
+				rdev_for_each(rdev, rtmp, mddev)
 					rdev->saved_raid_disk = -1;
 
 			mddev->recovery = 0;

diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
--- .prev/drivers/md/multipath.c	2008-01-11 15:01:13.000000000 +1100
+++ ./drivers/md/multipath.c	2008-01-14 12:26:10.000000000 +1100
@@ -436,7 +436,7 @@ static int multipath_run (mddev_t *mddev
 	}
 
 	conf->working_disks = 0;
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx < 0 ||
 		    disk_idx >= mddev->raid_disks)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2008-01-11 15:01:13.000000000 +1100
+++ ./drivers/md/raid0.c	2008-01-14 12:26:10.000000000 +1100
@@ -72,11 +72,11 @@ static int create_strip_zones (mddev_t *
 	 */
 	conf->nr_strip_zones = 0;
  
-	ITERATE_RDEV(mddev,rdev1,tmp1) {
+	rdev_for_each(rdev1, tmp1, mddev) {
 		printk("raid0: looking at %s\n",
 			bdevname(rdev1->bdev,b));
 		c = 0;
-		ITERATE_RDEV(mddev,rdev2,tmp2) {
+		rdev_for_each(rdev2, tmp2, mddev) {
 			printk("raid0:   comparing %s(%llu)",
 			       bdevname(rdev1->bdev,b),
 			       (unsigned long long)rdev1->size);
@@ -124,7 +124,7 @@ static int create_strip_zones (mddev_t *
 	cnt = 0;
 	smallest = NULL;
 	zone->dev = conf->devlist;
-	ITERATE_RDEV(mddev, rdev1, tmp1) {
+	rdev_for_each(rdev1, tmp1, mddev) {
 		int j = rdev1->raid_disk;
 
 		if (j < 0 || j >= mddev->raid_disks) {
@@ -293,7 +293,7 @@ static int raid0_run (mddev_t *mddev)
 
 	/* calculate array device size */
 	mddev->array_size = 0;
-	ITERATE_RDEV(mddev,rdev,tmp)
+	rdev_for_each(rdev, tmp, mddev)
 		mddev->array_size += rdev->size;
 
 	printk("raid0 : md_size is %llu blocks.\n", 

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-01-11 15:01:13.000000000 +1100
+++ ./drivers/md/raid10.c	2008-01-14 12:26:10.000000000 +1100
@@ -2026,7 +2026,7 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
-	ITERATE_RDEV(mddev, rdev, tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-01-11 15:01:13.000000000 +1100
+++ ./drivers/md/raid1.c	2008-01-14 12:26:10.000000000 +1100
@@ -1887,7 +1887,7 @@ static int run(mddev_t *mddev)
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
-	ITERATE_RDEV(mddev, rdev, tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-01-14 12:24:07.000000000 +1100
+++ ./drivers/md/raid5.c	2008-01-14 12:26:10.000000000 +1100
@@ -4129,7 +4129,7 @@ static int run(mddev_t *mddev)
 
 	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
+	rdev_for_each(rdev, tmp, mddev) {
 		raid_disk = rdev->raid_disk;
 		if (raid_disk >= conf->raid_disks
 		    || raid_disk < 0)
@@ -4542,7 +4542,7 @@ static int raid5_start_reshape(mddev_t *
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
-	ITERATE_RDEV(mddev, rdev, rtmp)
+	rdev_for_each(rdev, rtmp, mddev)
 		if (rdev->raid_disk < 0 &&
 		    !test_bit(Faulty, &rdev->flags))
 			spares++;
@@ -4564,7 +4564,7 @@ static int raid5_start_reshape(mddev_t *
 	/* Add some new drives, as many as will fit.
 	 * We know there are enough to make the newly sized array work.
 	 */
-	ITERATE_RDEV(mddev, rdev, rtmp)
+	rdev_for_each(rdev, rtmp, mddev)
 		if (rdev->raid_disk < 0 &&
 		    !test_bit(Faulty, &rdev->flags)) {
 			if (raid5_add_disk(mddev, rdev)) {

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-01-11 15:01:13.000000000 +1100
+++ ./include/linux/raid/md_k.h	2008-01-14 12:26:10.000000000 +1100
@@ -322,7 +322,7 @@ static inline char * mdname (mddev_t * m
 /*
  * iterates through the 'same array disks' ringlist
  */
-#define ITERATE_RDEV(mddev,rdev,tmp)					\
+#define rdev_for_each(rdev, tmp, mddev)				\
 	ITERATE_RDEV_GENERIC((mddev)->disks,rdev,tmp)
 
 /*
