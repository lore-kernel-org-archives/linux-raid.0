From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 14 of 14 - Replace bdev_partition_name with calls to bdevname
Date: Tue, 27 May 2003 13:01:15 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUiB-0003Hl-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

 ----------- Diffstat output ------------
 ./drivers/md/linear.c     |    5 +-
 ./drivers/md/md.c         |   98 ++++++++++++++++++++++++++--------------------
 ./drivers/md/multipath.c  |   14 ++++--
 ./drivers/md/raid0.c      |   22 ++++++----
 ./drivers/md/raid1.c      |   17 +++++--
 ./drivers/md/raid5.c      |    9 ++--
 ./include/linux/raid/md.h |   15 -------
 7 files changed, 98 insertions(+), 82 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-05-27 12:01:35.000000000 +1000
+++ ./drivers/md/linear.c	2003-05-27 12:01:37.000000000 +1000
@@ -254,12 +254,13 @@ static void linear_status (struct seq_fi
 	seq_printf(seq, "      ");
 	for (j = 0; j < conf->nr_zones; j++)
 	{
+		char b[BDEVNAME_SIZE];
 		seq_printf(seq, "[%s",
-			bdev_partition_name(conf->hash_table[j].dev0->rdev->bdev));
+			   bdevname(conf->hash_table[j].dev0->rdev->bdev,b));
 
 		if (conf->hash_table[j].dev1)
 			seq_printf(seq, "/%s] ",
-			  bdev_partition_name(conf->hash_table[j].dev1->rdev->bdev));
+				   bdevname(conf->hash_table[j].dev1->rdev->bdev,b));
 		else
 			seq_printf(seq, "] ");
 	}

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-05-27 12:01:35.000000000 +1000
+++ ./drivers/md/md.c	2003-05-27 12:01:37.000000000 +1000
@@ -349,7 +349,7 @@ static int sync_page_io(struct block_dev
 
 static int read_disk_sb(mdk_rdev_t * rdev)
 {
-
+	char b[BDEVNAME_SIZE];
 	if (!rdev->sb_page) {
 		MD_BUG();
 		return -EINVAL;
@@ -365,7 +365,7 @@ static int read_disk_sb(mdk_rdev_t * rde
 
 fail:
 	printk(KERN_ERR "md: disabled device %s, could not read superblock.\n",
-		bdev_partition_name(rdev->bdev));
+		bdevname(rdev->bdev,b));
 	return -EINVAL;
 }
 
@@ -473,6 +473,7 @@ struct super_type  {
  */
 static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 {
+	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	mdp_super_t *sb;
 	int ret;
 	sector_t sb_offset;
@@ -491,11 +492,12 @@ static int super_90_load(mdk_rdev_t *rde
 
 	ret = -EINVAL;
 
+	bdevname(rdev->bdev, b);
 	sb = (mdp_super_t*)page_address(rdev->sb_page);
 
 	if (sb->md_magic != MD_SB_MAGIC) {
 		printk(KERN_ERR "md: invalid raid superblock magic on %s\n",
-			bdev_partition_name(rdev->bdev));
+		       b);
 		goto abort;
 	}
 
@@ -503,13 +505,13 @@ static int super_90_load(mdk_rdev_t *rde
 	    sb->minor_version != 90) {
 		printk(KERN_WARNING "Bad version number %d.%d on %s\n",
 			sb->major_version, sb->minor_version,
-			bdev_partition_name(rdev->bdev));
+			b);
 		goto abort;
 	}
 
 	if (sb->md_minor >= MAX_MD_DEVS) {
 		printk(KERN_ERR "md: %s: invalid raid minor (%x)\n",
-			bdev_partition_name(rdev->bdev), sb->md_minor);
+			b, sb->md_minor);
 		goto abort;
 	}
 	if (sb->raid_disks <= 0)
@@ -517,7 +519,7 @@ static int super_90_load(mdk_rdev_t *rde
 
 	if (calc_sb_csum(sb) != sb->sb_csum) {
 		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
-			bdev_partition_name(rdev->bdev));
+			b);
 		goto abort;
 	}
 
@@ -536,15 +538,13 @@ static int super_90_load(mdk_rdev_t *rde
 		mdp_super_t *refsb = (mdp_super_t*)page_address(refdev->sb_page);
 		if (!uuid_equal(refsb, sb)) {
 			printk(KERN_WARNING "md: %s has different UUID to %s\n",
-				bdev_partition_name(rdev->bdev),
-				bdev_partition_name(refdev->bdev));
+				b, bdevname(refdev->bdev,b2));
 			goto abort;
 		}
 		if (!sb_equal(refsb, sb)) {
 			printk(KERN_WARNING "md: %s has same UUID"
-				" but different superblock to %s\n",
-				bdev_partition_name(rdev->bdev),
-				bdev_partition_name(refdev->bdev));
+			       " but different superblock to %s\n",
+			       b, bdevname(refdev->bdev, b2));
 			goto abort;
 		}
 		ev1 = md_event(sb);
@@ -756,6 +756,7 @@ static int super_1_load(mdk_rdev_t *rdev
 	struct mdp_superblock_1 *sb;
 	int ret;
 	sector_t sb_offset;
+	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 
 	/*
 	 * Calculate the position of the superblock.
@@ -799,7 +800,7 @@ static int super_1_load(mdk_rdev_t *rdev
 
 	if (calc_sb_1_csum(sb) != sb->sb_csum) {
 		printk("md: invalid superblock checksum on %s\n",
-			bdev_partition_name(rdev->bdev));
+			bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
 	rdev->preferred_minor = 0xffff;
@@ -818,8 +819,8 @@ static int super_1_load(mdk_rdev_t *rdev
 		    sb->chunksize != refsb->chunksize) {
 			printk(KERN_WARNING "md: %s has strangely different"
 				" superblock to %s\n",
-				bdev_partition_name(rdev->bdev),
-				bdev_partition_name(refdev->bdev));
+				bdevname(rdev->bdev,b),
+				bdevname(refdev->bdev,b2));
 			return -EINVAL;
 		}
 		ev1 = le64_to_cpu(sb->events);
@@ -987,6 +988,7 @@ static LIST_HEAD(pending_raid_disks);
 static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 {
 	mdk_rdev_t *same_pdev;
+	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 
 	if (rdev->mddev) {
 		MD_BUG();
@@ -998,8 +1000,8 @@ static int bind_rdev_to_array(mdk_rdev_t
 			"md%d: WARNING: %s appears to be on the same physical"
 	 		" disk as %s. True\n     protection against single-disk"
 			" failure might be compromised.\n",
-			mdidx(mddev), bdev_partition_name(rdev->bdev),
-			bdev_partition_name(same_pdev->bdev));
+			mdidx(mddev), bdevname(rdev->bdev,b),
+			bdevname(same_pdev->bdev,b2));
 
 	/* Verify rdev->desc_nr is unique.
 	 * If it is -1, assign a free number, else
@@ -1018,18 +1020,19 @@ static int bind_rdev_to_array(mdk_rdev_t
 			
 	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
-	printk(KERN_INFO "md: bind<%s>\n", bdev_partition_name(rdev->bdev));
+	printk(KERN_INFO "md: bind<%s>\n", bdevname(rdev->bdev,b));
 	return 0;
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 {
+	char b[BDEVNAME_SIZE];
 	if (!rdev->mddev) {
 		MD_BUG();
 		return;
 	}
 	list_del_init(&rdev->same_set);
-	printk(KERN_INFO "md: unbind<%s>\n", bdev_partition_name(rdev->bdev));
+	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
 }
 
@@ -1071,8 +1074,9 @@ void md_autodetect_dev(dev_t dev);
 
 static void export_rdev(mdk_rdev_t * rdev)
 {
+	char b[BDEVNAME_SIZE];
 	printk(KERN_INFO "md: export_rdev(%s)\n",
-		bdev_partition_name(rdev->bdev));
+		bdevname(rdev->bdev,b));
 	if (rdev->mddev)
 		MD_BUG();
 	free_disk_sb(rdev);
@@ -1153,8 +1157,9 @@ static void print_sb(mdp_super_t *sb)
 
 static void print_rdev(mdk_rdev_t *rdev)
 {
+	char b[BDEVNAME_SIZE];
 	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%u\n",
-		bdev_partition_name(rdev->bdev), (unsigned long long)rdev->size,
+		bdevname(rdev->bdev,b), (unsigned long long)rdev->size,
 	       	rdev->faulty, rdev->in_sync, rdev->desc_nr);
 	if (rdev->sb_loaded) {
 		printk(KERN_INFO "md: rdev superblock:\n");
@@ -1168,6 +1173,7 @@ void md_print_devices(void)
 	struct list_head *tmp, *tmp2;
 	mdk_rdev_t *rdev;
 	mddev_t *mddev;
+	char b[BDEVNAME_SIZE];
 
 	printk("\n");
 	printk("md:	**********************************\n");
@@ -1177,7 +1183,7 @@ void md_print_devices(void)
 		printk("md%d: ", mdidx(mddev));
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
-			printk("<%s>", bdev_partition_name(rdev->bdev));
+			printk("<%s>", bdevname(rdev->bdev,b));
 		printk("\n");
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
@@ -1190,7 +1196,7 @@ void md_print_devices(void)
 
 static int write_disk_sb(mdk_rdev_t * rdev)
 {
-
+	char b[BDEVNAME_SIZE];
 	if (!rdev->sb_loaded) {
 		MD_BUG();
 		return 1;
@@ -1201,14 +1207,14 @@ static int write_disk_sb(mdk_rdev_t * rd
 	}
 
 	dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
-		bdev_partition_name(rdev->bdev),
+		bdevname(rdev->bdev,b),
 	       (unsigned long long)rdev->sb_offset);
   
 	if (sync_page_io(rdev->bdev, rdev->sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE))
 		return 0;
 
 	printk("md: write_disk_sb failed for device %s\n", 
-		bdev_partition_name(rdev->bdev));
+		bdevname(rdev->bdev,b));
 	return 1;
 }
 
@@ -1259,11 +1265,12 @@ repeat:
 
 	err = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
+		char b[BDEVNAME_SIZE];
 		dprintk(KERN_INFO "md: ");
 		if (rdev->faulty)
 			dprintk("(skipping faulty ");
 
-		dprintk("%s ", bdev_partition_name(rdev->bdev));
+		dprintk("%s ", bdevname(rdev->bdev,b));
 		if (!rdev->faulty) {
 			err += write_disk_sb(rdev);
 		} else
@@ -1327,7 +1334,7 @@ static mdk_rdev_t *md_import_device(dev_
 	if (!size) {
 		printk(KERN_WARNING 
 			"md: %s has zero or unknown size, marking faulty!\n",
-			bdev_partition_name(rdev->bdev));
+			bdevname(rdev->bdev,b));
 		err = -EINVAL;
 		goto abort_free;
 	}
@@ -1338,13 +1345,13 @@ static mdk_rdev_t *md_import_device(dev_
 		if (err == -EINVAL) {
 			printk(KERN_WARNING 
 				"md: %s has invalid sb, not importing!\n",
-				bdev_partition_name(rdev->bdev));
+				bdevname(rdev->bdev,b));
 			goto abort_free;
 		}
 		if (err < 0) {
 			printk(KERN_WARNING 
 				"md: could not read %s's sb, not importing!\n",
-				bdev_partition_name(rdev->bdev));
+				bdevname(rdev->bdev,b));
 			goto abort_free;
 		}
 	}
@@ -1372,6 +1379,7 @@ static int analyze_sbs(mddev_t * mddev)
 	int i;
 	struct list_head *tmp;
 	mdk_rdev_t *rdev, *freshest;
+	char b[BDEVNAME_SIZE];
 
 	freshest = NULL;
 	ITERATE_RDEV(mddev,rdev,tmp)
@@ -1386,7 +1394,7 @@ static int analyze_sbs(mddev_t * mddev)
 			printk( KERN_ERR \
 				"md: fatal superblock inconsistency in %s"
 				" -- removing from array\n", 
-				bdev_partition_name(rdev->bdev));
+				bdevname(rdev->bdev,b));
 			kick_rdev_from_array(rdev);
 		}
 
@@ -1401,7 +1409,7 @@ static int analyze_sbs(mddev_t * mddev)
 			    validate_super(mddev, rdev)) {
 				printk(KERN_WARNING "md: kicking non-fresh %s"
 					" from array!\n",
-					bdev_partition_name(rdev->bdev));
+					bdevname(rdev->bdev,b));
 				kick_rdev_from_array(rdev);
 				continue;
 			}
@@ -1489,6 +1497,7 @@ static int do_md_run(mddev_t * mddev)
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 	struct gendisk *disk;
+	char b[BDEVNAME_SIZE];
 
 	if (list_empty(&mddev->disks)) {
 		MD_BUG();
@@ -1547,7 +1556,7 @@ static int do_md_run(mddev_t * mddev)
 				printk(KERN_WARNING
 					"md: Dev %s smaller than chunk_size:"
 					" %lluk < %dk\n",
-					bdev_partition_name(rdev->bdev),
+					bdevname(rdev->bdev,b),
 					(unsigned long long)rdev->size,
 					chunk_size / 1024);
 				return -EINVAL;
@@ -1747,7 +1756,8 @@ static void autorun_array(mddev_t *mddev
 	printk(KERN_INFO "md: running: ");
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		printk("<%s>", bdev_partition_name(rdev->bdev));
+		char b[BDEVNAME_SIZE];
+		printk("<%s>", bdevname(rdev->bdev,b));
 	}
 	printk("\n");
 
@@ -1776,6 +1786,7 @@ static void autorun_devices(void)
 	struct list_head *tmp;
 	mdk_rdev_t *rdev0, *rdev;
 	mddev_t *mddev;
+	char b[BDEVNAME_SIZE];
 
 	printk(KERN_INFO "md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
@@ -1783,12 +1794,12 @@ static void autorun_devices(void)
 					 mdk_rdev_t, same_set);
 
 		printk(KERN_INFO "md: considering %s ...\n",
-			bdev_partition_name(rdev0->bdev));
+			bdevname(rdev0->bdev,b));
 		INIT_LIST_HEAD(&candidates);
 		ITERATE_RDEV_PENDING(rdev,tmp)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				printk(KERN_INFO "md:  adding %s ...\n",
-					bdev_partition_name(rdev->bdev));
+					bdevname(rdev->bdev,b));
 				list_move(&rdev->same_set, &candidates);
 			}
 		/*
@@ -1810,7 +1821,7 @@ static void autorun_devices(void)
 			 || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING 
 				"md: md%d already running, cannot run %s\n",
-				mdidx(mddev), bdev_partition_name(rdev0->bdev));
+				mdidx(mddev), bdevname(rdev0->bdev,b));
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
@@ -1863,7 +1874,7 @@ static int autostart_array(dev_t startde
 	if (start_rdev->faulty) {
 		printk(KERN_WARNING 
 			"md: can not autostart based on faulty %s!\n",
-			bdev_partition_name(start_rdev->bdev));
+			bdevname(start_rdev->bdev,b));
 		export_rdev(start_rdev);
 		return err;
 	}
@@ -2000,6 +2011,7 @@ static int get_disk_info(mddev_t * mddev
 
 static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 {
+	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
 	dev_t dev;
 	dev = MKDEV(info->major,info->minor);
@@ -2021,8 +2033,8 @@ static int add_new_disk(mddev_t * mddev,
 			if (err < 0) {
 				printk(KERN_WARNING 
 					"md: %s has different UUID to %s\n",
-					bdev_partition_name(rdev->bdev), 
-					bdev_partition_name(rdev0->bdev));
+					bdevname(rdev->bdev,b), 
+					bdevname(rdev0->bdev,b2));
 				export_rdev(rdev);
 				return -EINVAL;
 			}
@@ -2174,7 +2186,7 @@ static int hot_remove_disk(mddev_t * mdd
 	return 0;
 busy:
 	printk(KERN_WARNING "md: cannot remove active disk %s from md%d ... \n",
-		bdev_partition_name(rdev->bdev), mdidx(mddev));
+		bdevname(rdev->bdev,b), mdidx(mddev));
 	return -EBUSY;
 }
 
@@ -2228,7 +2240,7 @@ static int hot_add_disk(mddev_t * mddev,
 	if (rdev->faulty) {
 		printk(KERN_WARNING 
 			"md: can not hot-add faulty %s disk to md%d!\n",
-			bdev_partition_name(rdev->bdev), mdidx(mddev));
+			bdevname(rdev->bdev,b), mdidx(mddev));
 		err = -EINVAL;
 		goto abort_export;
 	}
@@ -2781,9 +2793,10 @@ static void status_unused(struct seq_fil
 	seq_printf(seq, "unused devices: ");
 
 	ITERATE_RDEV_PENDING(rdev,tmp) {
+		char b[BDEVNAME_SIZE];
 		i++;
 		seq_printf(seq, "%s ",
-			      bdev_partition_name(rdev->bdev));
+			      bdevname(rdev->bdev,b));
 	}
 	if (!i)
 		seq_printf(seq, "<none>");
@@ -2938,8 +2951,9 @@ static int md_seq_show(struct seq_file *
 
 		size = 0;
 		ITERATE_RDEV(mddev,rdev,tmp2) {
+			char b[BDEVNAME_SIZE];
 			seq_printf(seq, " %s[%d]",
-				bdev_partition_name(rdev->bdev), rdev->desc_nr);
+				bdevname(rdev->bdev,b), rdev->desc_nr);
 			if (rdev->faulty) {
 				seq_printf(seq, "(F)");
 				continue;

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-05-27 12:01:35.000000000 +1000
+++ ./drivers/md/multipath.c	2003-05-27 12:01:37.000000000 +1000
@@ -127,9 +127,10 @@ int multipath_end_request(struct bio *bi
 		/*
 		 * oops, IO error:
 		 */
+		char b[BDEVNAME_SIZE];
 		md_error (mp_bh->mddev, rdev);
 		printk(KERN_ERR "multipath: %s: rescheduling sector %llu\n", 
-		       bdev_partition_name(rdev->bdev), 
+		       bdevname(rdev->bdev,b), 
 		       (unsigned long long)bio->bi_sector);
 		multipath_reschedule_retry(mp_bh);
 	}
@@ -220,6 +221,7 @@ static void multipath_error (mddev_t *md
 		 * Mark disk as unusable
 		 */
 		if (!rdev->faulty) {
+			char b[BDEVNAME_SIZE];
 			rdev->in_sync = 0;
 			rdev->faulty = 1;
 			mddev->sb_dirty = 1;
@@ -227,7 +229,7 @@ static void multipath_error (mddev_t *md
 			printk(KERN_ALERT "multipath: IO failure on %s,"
 				" disabling IO path. \n	Operation continuing"
 				" on %d IO paths.\n",
-				bdev_partition_name (rdev->bdev),
+				bdevname (rdev->bdev,b),
 				conf->working_disks);
 		}
 	}
@@ -247,11 +249,12 @@ static void print_multipath_conf (multip
 			 conf->raid_disks);
 
 	for (i = 0; i < conf->raid_disks; i++) {
+		char b[BDEVNAME_SIZE];
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
 			printk(" disk%d, o:%d, dev:%s\n",
 				i,!tmp->rdev->faulty,
-			       bdev_partition_name(tmp->rdev->bdev));
+			       bdevname(tmp->rdev->bdev,b));
 	}
 }
 
@@ -326,6 +329,7 @@ static void multipathd (mddev_t *mddev)
 
 	md_check_recovery(mddev);
 	for (;;) {
+		char b[BDEVNAME_SIZE];
 		spin_lock_irqsave(&retry_list_lock, flags);
 		mp_bh = multipath_retry_list;
 		if (!mp_bh)
@@ -341,13 +345,13 @@ static void multipathd (mddev_t *mddev)
 		if (multipath_map (mddev, &rdev)<0) {
 			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
 				" error for block %llu\n",
-				bdev_partition_name(bio->bi_bdev), 
+				bdevname(bio->bi_bdev,b),
 				(unsigned long long)bio->bi_sector);
 			multipath_end_bh_io(mp_bh, 0);
 		} else {
 			printk(KERN_ERR "multipath: %s: redirecting sector %llu"
 				" to another IO path\n",
-				bdev_partition_name(bio->bi_bdev), 
+				bdevname(bio->bi_bdev,b),
 				(unsigned long long)bio->bi_sector);
 			bio->bi_bdev = rdev->bdev;
 			generic_make_request(bio);

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-05-27 12:01:35.000000000 +1000
+++ ./drivers/md/raid0.c	2003-05-27 12:01:37.000000000 +1000
@@ -36,6 +36,7 @@ static int create_strip_zones (mddev_t *
 	struct list_head *tmp1, *tmp2;
 	struct strip_zone *zone;
 	int cnt;
+	char b[BDEVNAME_SIZE];
  
 	/*
 	 * The number of 'same size groups'
@@ -44,14 +45,15 @@ static int create_strip_zones (mddev_t *
  
 	ITERATE_RDEV(mddev,rdev1,tmp1) {
 		printk("raid0: looking at %s\n",
-			bdev_partition_name(rdev1->bdev));
+			bdevname(rdev1->bdev,b));
 		c = 0;
 		ITERATE_RDEV(mddev,rdev2,tmp2) {
-			printk("raid0:   comparing %s(%llu) with %s(%llu)\n",
-				bdev_partition_name(rdev1->bdev),
-				(unsigned long long)rdev1->size,
-				bdev_partition_name(rdev2->bdev),
-				(unsigned long long)rdev2->size);
+			printk("raid0:   comparing %s(%llu)",
+			       bdevname(rdev1->bdev,b),
+			       (unsigned long long)rdev1->size);
+			printk(" with %s(%llu)\n",
+			       bdevname(rdev2->bdev,b),
+			       (unsigned long long)rdev2->size);
 			if (rdev2 == rdev1) {
 				printk("raid0:   END\n");
 				break;
@@ -138,8 +140,9 @@ static int create_strip_zones (mddev_t *
 		c = 0;
 
 		for (j=0; j<cnt; j++) {
+			char b[BDEVNAME_SIZE];
 			rdev = conf->strip_zone[0].dev[j];
-			printk("raid0: checking %s ...", bdev_partition_name(rdev->bdev));
+			printk("raid0: checking %s ...", bdevname(rdev->bdev,b));
 			if (rdev->size > current_offset)
 			{
 				printk(" contained as device %d\n", c);
@@ -404,6 +407,7 @@ static void raid0_status (struct seq_fil
 #undef MD_DEBUG
 #ifdef MD_DEBUG
 	int j, k, h;
+	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = mddev_to_conf(mddev);
   
 	h = 0;
@@ -413,8 +417,8 @@ static void raid0_status (struct seq_fil
 			seq_printf("(h%d)", h++);
 		seq_printf(seq, "=[");
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			seq_printf (seq, "%s/", bdev_partition_name(
-				conf->strip_zone[j].dev[k]->bdev));
+			seq_printf (seq, "%s/", bdevname(
+				conf->strip_zone[j].dev[k]->bdev,b));
 
 		seq_printf (seq, "] zo=%d do=%d s=%d\n",
 				conf->strip_zone[j].zone_offset,

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-05-27 12:01:35.000000000 +1000
+++ ./drivers/md/raid1.c	2003-05-27 12:01:37.000000000 +1000
@@ -308,8 +308,9 @@ static int raid1_end_request(struct bio 
 			/*
 			 * oops, read error:
 			 */
+			char b[BDEVNAME_SIZE];
 			printk(KERN_ERR "raid1: %s: rescheduling sector %llu\n",
-				bdev_partition_name(conf->mirrors[mirror].rdev->bdev), (unsigned long long)r1_bio->sector);
+				bdevname(conf->mirrors[mirror].rdev->bdev,b), (unsigned long long)r1_bio->sector);
 			reschedule_retry(r1_bio);
 		}
 	} else {
@@ -597,6 +598,7 @@ static void status(struct seq_file *seq,
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
+	char b[BDEVNAME_SIZE];
 	conf_t *conf = mddev_to_conf(mddev);
 
 	/*
@@ -625,7 +627,7 @@ static void error(mddev_t *mddev, mdk_rd
 	mddev->sb_dirty = 1;
 	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device. \n"
 		"	Operation continuing on %d devices\n",
-		bdev_partition_name(rdev->bdev), conf->working_disks);
+		bdevname(rdev->bdev,b), conf->working_disks);
 }
 
 static void print_conf(conf_t *conf)
@@ -642,11 +644,12 @@ static void print_conf(conf_t *conf)
 		conf->raid_disks);
 
 	for (i = 0; i < conf->raid_disks; i++) {
+		char b[BDEVNAME_SIZE];
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
 			printk(" disk %d, wo:%d, o:%d, dev:%s\n",
 				i, !tmp->rdev->in_sync, !tmp->rdev->faulty,
-				bdev_partition_name(tmp->rdev->bdev));
+				bdevname(tmp->rdev->bdev,b));
 	}
 }
 
@@ -814,9 +817,10 @@ static void sync_request_write(mddev_t *
 		 * There is no point trying a read-for-reconstruct as
 		 * reconstruct is about to be aborted
 		 */
+		char b[BDEVNAME_SIZE];
 		printk(KERN_ALERT "raid1: %s: unrecoverable I/O read error"
 			" for block %llu\n",
-			bdev_partition_name(bio->bi_bdev), 
+			bdevname(bio->bi_bdev,b), 
 			(unsigned long long)r1_bio->sector);
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
 		put_buf(r1_bio);
@@ -906,6 +910,7 @@ static void raid1d(mddev_t *mddev)
 	md_handle_safemode(mddev);
 	
 	for (;;) {
+		char b[BDEVNAME_SIZE];
 		spin_lock_irqsave(&retry_list_lock, flags);
 		if (list_empty(head))
 			break;
@@ -925,14 +930,14 @@ static void raid1d(mddev_t *mddev)
 			if (map(mddev, &rdev) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
 				" read error for block %llu\n",
-				bdev_partition_name(bio->bi_bdev), 
+				bdevname(bio->bi_bdev,b),
 				(unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
 				break;
 			}
 			printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
 				" another mirror\n",
-				bdev_partition_name(rdev->bdev), 
+				bdevname(rdev->bdev,b),
 				(unsigned long long)r1_bio->sector);
 			bio->bi_bdev = rdev->bdev;
 			bio->bi_sector = r1_bio->sector + rdev->data_offset;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-05-27 12:01:35.000000000 +1000
+++ ./drivers/md/raid5.c	2003-05-27 12:01:37.000000000 +1000
@@ -457,6 +457,7 @@ static void raid5_build_block (struct st
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
+	char b[BDEVNAME_SIZE];
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	PRINTK("raid5: error called\n");
 
@@ -476,7 +477,7 @@ static void error(mddev_t *mddev, mdk_rd
 		printk (KERN_ALERT
 			"raid5: Disk failure on %s, disabling device."
 			" Operation continuing on %d devices\n",
-			bdev_partition_name(rdev->bdev), conf->working_disks);
+			bdevname(rdev->bdev,b), conf->working_disks);
 	}
 }	
 
@@ -1486,8 +1487,9 @@ static int run (mddev_t *mddev)
 		disk->rdev = rdev;
 
 		if (rdev->in_sync) {
+			char b[BDEVNAME_SIZE];
 			printk(KERN_INFO "raid5: device %s operational as raid"
-				" disk %d\n", bdev_partition_name(rdev->bdev),
+				" disk %d\n", bdevname(rdev->bdev,b),
 				raid_disk);
 			conf->working_disks++;
 		}
@@ -1663,11 +1665,12 @@ static void print_raid5_conf (raid5_conf
 		 conf->working_disks, conf->failed_disks);
 
 	for (i = 0; i < conf->raid_disks; i++) {
+		char b[BDEVNAME_SIZE];
 		tmp = conf->disks + i;
 		if (tmp->rdev)
 		printk(" disk %d, o:%d, dev:%s\n",
 			i, !tmp->rdev->faulty,
-			bdev_partition_name(tmp->rdev->bdev));
+			bdevname(tmp->rdev->bdev,b));
 	}
 }
 

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2003-05-27 12:01:35.000000000 +1000
+++ ./include/linux/raid/md.h	2003-05-27 12:01:37.000000000 +1000
@@ -62,21 +62,6 @@
 #define MD_MINOR_VERSION                90
 #define MD_PATCHLEVEL_VERSION           0
 
-/*
- * XXX(hch): This function is broken.  Someone who understands the md
- * code needs to go through all callers, check whether bdev could
- * be NULL and replace it with direct calls to bdevmame.
- *
- * This would also fix the returns buffer on stack issue nicely :)
- */
-static inline const char *bdev_partition_name (struct block_device *bdev)
-{
-	char b[BDEVNAME_SIZE];
-
-	if (!bdev)
-		return __bdevname(0, b);
-	return bdevname(bdev, b);
-}
 extern int register_md_personality (int p_num, mdk_personality_t *p);
 extern int unregister_md_personality (int p_num);
 extern mdk_thread_t * md_register_thread (void (*run) (mddev_t *mddev),
