From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 3 - Cleanup #define TEXT text ... printk(TEXT)
Date: Wed, 26 Mar 2003 11:11:01 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18xyVR-0004U0-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Also reformat some printks so lines don't exceed 80chars.

Thanks to  Angus Sawyer <angus.sawyer@dsl.pipex.com>

 ----------- Diffstat output ------------
 ./drivers/md/linear.c    |    4 
 ./drivers/md/md.c        |  391 ++++++++++++++++++++++-------------------------
 ./drivers/md/multipath.c |  120 +++-----------
 ./drivers/md/raid0.c     |   43 +++--
 ./drivers/md/raid1.c     |  115 ++++---------
 ./drivers/md/raid5.c     |  118 +++++++++-----
 6 files changed, 365 insertions(+), 426 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-03-26 10:35:30.000000000 +1100
+++ ./drivers/md/linear.c	2003-03-26 10:35:11.000000000 +1100
@@ -193,7 +193,7 @@ static int linear_make_request (request_
 	block = bio->bi_sector >> 1;
   
 	if (unlikely(!tmp_dev)) {
-		printk ("linear_make_request : hash->dev1==NULL for block %llu\n",
+		printk("linear_make_request: hash->dev1==NULL for block %llu\n",
 			(unsigned long long)block);
 		bio_io_error(bio, bio->bi_size);
 		return 0;
@@ -203,7 +203,7 @@ static int linear_make_request (request_
 		     || block < tmp_dev->offset)) {
 		char b[BDEVNAME_SIZE];
 
-		printk ("linear_make_request: Block %llu out of bounds on "
+		printk("linear_make_request: Block %llu out of bounds on "
 			"dev %s size %ld offset %ld\n",
 			(unsigned long long)block,
 			bdevname(tmp_dev->rdev->bdev, b),

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-26 10:35:30.000000000 +1100
+++ ./drivers/md/md.c	2003-03-26 10:35:11.000000000 +1100
@@ -302,22 +302,6 @@ static sector_t zoned_raid_size(mddev_t 
 	return 0;
 }
 
-
-#define BAD_MAGIC KERN_ERR \
-"md: invalid raid superblock magic on %s\n"
-
-#define BAD_MINOR KERN_ERR \
-"md: %s: invalid raid minor (%x)\n"
-
-#define OUT_OF_MEM KERN_ALERT \
-"md: out of memory.\n"
-
-#define NO_SB KERN_ERR \
-"md: disabled device %s, could not read superblock.\n"
-
-#define BAD_CSUM KERN_WARNING \
-"md: invalid superblock checksum on %s\n"
-
 static int alloc_disk_sb(mdk_rdev_t * rdev)
 {
 	if (rdev->sb_page)
@@ -325,7 +309,7 @@ static int alloc_disk_sb(mdk_rdev_t * rd
 
 	rdev->sb_page = alloc_page(GFP_KERNEL);
 	if (!rdev->sb_page) {
-		printk(OUT_OF_MEM);
+		printk(KERN_ALERT "md: out of memory.\n");
 		return -EINVAL;
 	}
 
@@ -397,7 +381,8 @@ static int read_disk_sb(mdk_rdev_t * rde
 	return 0;
 
 fail:
-	printk(NO_SB,bdev_partition_name(rdev->bdev));
+	printk(KERN_ERR "md: disabled device %s, could not read superblock.\n",
+		bdev_partition_name(rdev->bdev));
 	return -EINVAL;
 }
 
@@ -526,27 +511,30 @@ static int super_90_load(mdk_rdev_t *rde
 	sb = (mdp_super_t*)page_address(rdev->sb_page);
 
 	if (sb->md_magic != MD_SB_MAGIC) {
-		printk(BAD_MAGIC, bdev_partition_name(rdev->bdev));
+		printk(KERN_ERR "md: invalid raid superblock magic on %s\n",
+			bdev_partition_name(rdev->bdev));
 		goto abort;
 	}
 
 	if (sb->major_version != 0 ||
 	    sb->minor_version != 90) {
 		printk(KERN_WARNING "Bad version number %d.%d on %s\n",
-		       sb->major_version, sb->minor_version,
-		       bdev_partition_name(rdev->bdev));
+			sb->major_version, sb->minor_version,
+			bdev_partition_name(rdev->bdev));
 		goto abort;
 	}
 
 	if (sb->md_minor >= MAX_MD_DEVS) {
-		printk(BAD_MINOR, bdev_partition_name(rdev->bdev), sb->md_minor);
+		printk(KERN_ERR "md: %s: invalid raid minor (%x)\n",
+			bdev_partition_name(rdev->bdev), sb->md_minor);
 		goto abort;
 	}
 	if (sb->raid_disks <= 0)
 		goto abort;
 
 	if (calc_sb_csum(sb) != sb->sb_csum) {
-		printk(BAD_CSUM, bdev_partition_name(rdev->bdev));
+		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
+			bdev_partition_name(rdev->bdev));
 		goto abort;
 	}
 
@@ -565,14 +553,15 @@ static int super_90_load(mdk_rdev_t *rde
 		mdp_super_t *refsb = (mdp_super_t*)page_address(refdev->sb_page);
 		if (!uuid_equal(refsb, sb)) {
 			printk(KERN_WARNING "md: %s has different UUID to %s\n",
-			       bdev_partition_name(rdev->bdev),
-			       bdev_partition_name(refdev->bdev));
+				bdev_partition_name(rdev->bdev),
+				bdev_partition_name(refdev->bdev));
 			goto abort;
 		}
 		if (!sb_equal(refsb, sb)) {
-			printk(KERN_WARNING "md: %s has same UUID but different superblock to %s\n",
-			       bdev_partition_name(rdev->bdev),
-			       bdev_partition_name(refdev->bdev));
+			printk(KERN_WARNING "md: %s has same UUID"
+				" but different superblock to %s\n",
+				bdev_partition_name(rdev->bdev),
+				bdev_partition_name(refdev->bdev));
 			goto abort;
 		}
 		ev1 = md_event(sb);
@@ -826,7 +815,8 @@ static int super_1_load(mdk_rdev_t *rdev
 		return -EINVAL;
 
 	if (calc_sb_1_csum(sb) != sb->sb_csum) {
-		printk(BAD_CSUM, bdev_partition_name(rdev->bdev));
+		printk("md: invalid superblock checksum on %s\n",
+			bdev_partition_name(rdev->bdev));
 		return -EINVAL;
 	}
 	rdev->preferred_minor = 0xffff;
@@ -843,9 +833,10 @@ static int super_1_load(mdk_rdev_t *rdev
 		    sb->level != refsb->level ||
 		    sb->layout != refsb->layout ||
 		    sb->chunksize != refsb->chunksize) {
-			printk(KERN_WARNING "md: %s has strangely different superblock to %s\n",
-			       bdev_partition_name(rdev->bdev),
-			       bdev_partition_name(refdev->bdev));
+			printk(KERN_WARNING "md: %s has strangely different"
+				" superblock to %s\n",
+				bdev_partition_name(rdev->bdev),
+				bdev_partition_name(refdev->bdev));
 			return -EINVAL;
 		}
 		ev1 = le64_to_cpu(sb->events);
@@ -1020,11 +1011,12 @@ static int bind_rdev_to_array(mdk_rdev_t
 	}
 	same_pdev = match_dev_unit(mddev, rdev);
 	if (same_pdev)
-		printk( KERN_WARNING
-"md%d: WARNING: %s appears to be on the same physical disk as %s. True\n"
-"     protection against single-disk failure might be compromised.\n",
+		printk(KERN_WARNING
+			"md%d: WARNING: %s appears to be on the same physical"
+	 		" disk as %s. True\n     protection against single-disk"
+			" failure might be compromised.\n",
 			mdidx(mddev), bdev_partition_name(rdev->bdev),
-				bdev_partition_name(same_pdev->bdev));
+			bdev_partition_name(same_pdev->bdev));
 
 	/* Verify rdev->desc_nr is unique.
 	 * If it is -1, assign a free number, else
@@ -1099,7 +1091,8 @@ void md_autodetect_dev(dev_t dev);
 
 static void export_rdev(mdk_rdev_t * rdev)
 {
-	printk(KERN_INFO "md: export_rdev(%s)\n",bdev_partition_name(rdev->bdev));
+	printk(KERN_INFO "md: export_rdev(%s)\n",
+		bdev_partition_name(rdev->bdev));
 	if (rdev->mddev)
 		MD_BUG();
 	free_disk_sb(rdev);
@@ -1135,11 +1128,6 @@ static void export_array(mddev_t *mddev)
 	mddev->major_version = 0;
 }
 
-#undef BAD_CSUM
-#undef BAD_MAGIC
-#undef OUT_OF_MEM
-#undef NO_SB
-
 static void print_desc(mdp_disk_t *desc)
 {
 	printk(" DISK<N:%d,%s(%d,%d),R:%d,S:%d>\n", desc->number,
@@ -1151,14 +1139,16 @@ static void print_sb(mdp_super_t *sb)
 {
 	int i;
 
-	printk(KERN_INFO "md:  SB: (V:%d.%d.%d) ID:<%08x.%08x.%08x.%08x> CT:%08x\n",
+	printk(KERN_INFO 
+		"md:  SB: (V:%d.%d.%d) ID:<%08x.%08x.%08x.%08x> CT:%08x\n",
 		sb->major_version, sb->minor_version, sb->patch_version,
 		sb->set_uuid0, sb->set_uuid1, sb->set_uuid2, sb->set_uuid3,
 		sb->ctime);
-	printk(KERN_INFO "md:     L%d S%08d ND:%d RD:%d md%d LO:%d CS:%d\n", sb->level,
-		sb->size, sb->nr_disks, sb->raid_disks, sb->md_minor,
-		sb->layout, sb->chunk_size);
-	printk(KERN_INFO "md:     UT:%08x ST:%d AD:%d WD:%d FD:%d SD:%d CSUM:%08x E:%08lx\n",
+	printk(KERN_INFO "md:     L%d S%08d ND:%d RD:%d md%d LO:%d CS:%d\n",
+		sb->level, sb->size, sb->nr_disks, sb->raid_disks,
+		sb->md_minor, sb->layout, sb->chunk_size);
+	printk(KERN_INFO "md:     UT:%08x ST:%d AD:%d WD:%d"
+		" FD:%d SD:%d CSUM:%08x E:%08lx\n",
 		sb->utime, sb->state, sb->active_disks, sb->working_disks,
 		sb->failed_disks, sb->spare_disks,
 		sb->sb_csum, (unsigned long)sb->events_lo);
@@ -1182,8 +1172,8 @@ static void print_sb(mdp_super_t *sb)
 static void print_rdev(mdk_rdev_t *rdev)
 {
 	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%d ",
-		bdev_partition_name(rdev->bdev),
-		(unsigned long long)rdev->size, rdev->faulty, rdev->in_sync, rdev->desc_nr);
+		bdev_partition_name(rdev->bdev), (unsigned long long)rdev->size,
+	       	rdev->faulty, rdev->in_sync, rdev->desc_nr);
 	if (rdev->sb_loaded) {
 		printk(KERN_INFO "md: rdev superblock:\n");
 		print_sb((mdp_super_t*)page_address(rdev->sb_page));
@@ -1227,13 +1217,15 @@ static int write_disk_sb(mdk_rdev_t * rd
 		return 1;
 	}
 
-	dprintk(KERN_INFO "(write) %s's sb offset: %llu\n", bdev_partition_name(rdev->bdev),
+	dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
+		bdev_partition_name(rdev->bdev),
 	       (unsigned long long)rdev->sb_offset);
   
 	if (sync_page_io(rdev->bdev, rdev->sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE))
 		return 0;
 
-	printk("md: write_disk_sb failed for device %s\n", bdev_partition_name(rdev->bdev));
+	printk("md: write_disk_sb failed for device %s\n", 
+		bdev_partition_name(rdev->bdev));
 	return 1;
 }
 
@@ -1278,8 +1270,9 @@ repeat:
 	if (!mddev->persistent)
 		return;
 
-	dprintk(KERN_INFO "md: updating md%d RAID superblock on device (in sync %d)\n",
-					mdidx(mddev),mddev->in_sync);
+	dprintk(KERN_INFO 
+		"md: updating md%d RAID superblock on device (in sync %d)\n",
+		mdidx(mddev),mddev->in_sync);
 
 	err = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -1298,10 +1291,12 @@ repeat:
 	}
 	if (err) {
 		if (--count) {
-			printk(KERN_ERR "md: errors occurred during superblock update, repeating\n");
+			printk(KERN_ERR "md: errors occurred during superblock"
+				" update, repeating\n");
 			goto repeat;
 		}
-		printk(KERN_ERR "md: excessive errors occurred during superblock update, exiting\n");
+		printk(KERN_ERR \
+			"md: excessive errors occurred during superblock update, exiting\n");
 	}
 }
 
@@ -1323,7 +1318,8 @@ static mdk_rdev_t *md_import_device(dev_
 
 	rdev = (mdk_rdev_t *) kmalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev) {
-		printk(KERN_ERR "md: could not alloc mem for %s!\n", partition_name(newdev));
+		printk(KERN_ERR "md: could not alloc mem for %s!\n", 
+			partition_name(newdev));
 		return ERR_PTR(-ENOMEM);
 	}
 	memset(rdev, 0, sizeof(*rdev));
@@ -1345,9 +1341,9 @@ static mdk_rdev_t *md_import_device(dev_
 
 	size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 	if (!size) {
-		printk(KERN_WARNING
-		       "md: %s has zero or unknown size, marking faulty!\n",
-		       bdev_partition_name(rdev->bdev));
+		printk(KERN_WARNING 
+			"md: %s has zero or unknown size, marking faulty!\n",
+			bdev_partition_name(rdev->bdev));
 		err = -EINVAL;
 		goto abort_free;
 	}
@@ -1356,13 +1352,15 @@ static mdk_rdev_t *md_import_device(dev_
 		err = super_types[super_format].
 			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
-			printk(KERN_WARNING "md: %s has invalid sb, not importing!\n",
-			       bdev_partition_name(rdev->bdev));
+			printk(KERN_WARNING 
+				"md: %s has invalid sb, not importing!\n",
+				bdev_partition_name(rdev->bdev));
 			goto abort_free;
 		}
 		if (err < 0) {
-			printk(KERN_WARNING "md: could not read %s's sb, not importing!\n",
-			       bdev_partition_name(rdev->bdev));
+			printk(KERN_WARNING 
+				"md: could not read %s's sb, not importing!\n",
+				bdev_partition_name(rdev->bdev));
 			goto abort_free;
 		}
 	}
@@ -1384,20 +1382,6 @@ abort_free:
  * Check a full RAID array for plausibility
  */
 
-#define INCONSISTENT KERN_ERR \
-"md: fatal superblock inconsistency in %s -- removing from array\n"
-
-#define OUT_OF_DATE KERN_ERR \
-"md: superblock update time inconsistency -- using the most recent one\n"
-
-#define OLD_VERSION KERN_ALERT \
-"md: md%d: unsupported raid array version %d.%d.%d\n"
-
-#define NOT_CLEAN_IGNORE KERN_ERR \
-"md: md%d: raid array is not clean -- starting background reconstruction\n"
-
-#define UNKNOWN_LEVEL KERN_ERR \
-"md: md%d: unsupported raid level %d\n"
 
 static int analyze_sbs(mddev_t * mddev)
 {
@@ -1415,7 +1399,10 @@ static int analyze_sbs(mddev_t * mddev)
 		case 0:
 			break;
 		default:
-			printk(INCONSISTENT, bdev_partition_name(rdev->bdev));
+			printk( KERN_ERR \
+				"md: fatal superblock inconsistency in %s"
+				" -- removing from array\n", 
+				bdev_partition_name(rdev->bdev));
 			kick_rdev_from_array(rdev);
 		}
 
@@ -1428,8 +1415,9 @@ static int analyze_sbs(mddev_t * mddev)
 		if (rdev != freshest)
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
-				printk(KERN_WARNING "md: kicking non-fresh %s from array!\n",
-				       bdev_partition_name(rdev->bdev));
+				printk(KERN_WARNING "md: kicking non-fresh %s"
+					" from array!\n",
+					bdev_partition_name(rdev->bdev));
 				kick_rdev_from_array(rdev);
 				continue;
 			}
@@ -1446,26 +1434,24 @@ static int analyze_sbs(mddev_t * mddev)
 	 */
 	if (mddev->major_version != MD_MAJOR_VERSION ||
 			mddev->minor_version > MD_MINOR_VERSION) {
-
-		printk(OLD_VERSION, mdidx(mddev), mddev->major_version,
-				mddev->minor_version, mddev->patch_version);
+		printk(KERN_ALERT 
+			"md: md%d: unsupported raid array version %d.%d.%d\n",
+			mdidx(mddev), mddev->major_version,
+			mddev->minor_version, mddev->patch_version);
 		goto abort;
 	}
 
 	if ((mddev->recovery_cp != MaxSector) && ((mddev->level == 1) ||
 			(mddev->level == 4) || (mddev->level == 5)))
-		printk(NOT_CLEAN_IGNORE, mdidx(mddev));
+		printk(KERN_ERR "md: md%d: raid array is not clean"
+			" -- starting background reconstruction\n", 
+			mdidx(mddev));
 
 	return 0;
 abort:
 	return 1;
 }
 
-#undef INCONSISTENT
-#undef OUT_OF_DATE
-#undef OLD_VERSION
-#undef OLD_LEVEL
-
 static int device_size_calculation(mddev_t * mddev)
 {
 	int data_disks = 0;
@@ -1484,9 +1470,11 @@ static int device_size_calculation(mddev
 			continue;
 		if (rdev->size < mddev->chunk_size / 1024) {
 			printk(KERN_WARNING
-				"md: Dev %s smaller than chunk_size: %lluk < %dk\n",
+				"md: Dev %s smaller than chunk_size:"
+				" %lluk < %dk\n",
 				bdev_partition_name(rdev->bdev),
-				(unsigned long long)rdev->size, mddev->chunk_size / 1024);
+				(unsigned long long)rdev->size,
+				mddev->chunk_size / 1024);
 			return -EINVAL;
 		}
 	}
@@ -1517,7 +1505,8 @@ static int device_size_calculation(mddev
 			data_disks = mddev->raid_disks-1;
 			break;
 		default:
-			printk(UNKNOWN_LEVEL, mdidx(mddev), mddev->level);
+			printk(KERN_ERR "md: md%d: unsupported raid level %d\n",
+				mdidx(mddev), mddev->level);
 			goto abort;
 	}
 	if (!md_size[mdidx(mddev)])
@@ -1539,7 +1528,7 @@ static int device_size_calculation(mddev
 
 	printk(KERN_INFO
 		"md%d: %d data-disks, max readahead per data-disk: %ldk\n",
-			mdidx(mddev), data_disks, readahead/data_disks*(PAGE_SIZE/1024));
+		mdidx(mddev), data_disks, readahead/data_disks*(PAGE_SIZE/1024));
 	return 0;
 abort:
 	return 1;
@@ -1589,14 +1578,6 @@ static void md_safemode_timeout(unsigned
 	md_wakeup_thread(mddev->thread);
 }
 
-#define TOO_BIG_CHUNKSIZE KERN_ERR \
-"too big chunk_size: %d > %d\n"
-
-#define TOO_SMALL_CHUNKSIZE KERN_ERR \
-"too small chunk_size: %d < %ld\n"
-
-#define BAD_CHUNKSIZE KERN_ERR \
-"no chunksize specified, see 'man raidtab'\n"
 
 static int do_md_run(mddev_t * mddev)
 {
@@ -1639,11 +1620,13 @@ static int do_md_run(mddev_t * mddev)
 			 * we abort here to be on the safe side. We don't
 			 * want to continue the bad practice.
 			 */
-			printk(BAD_CHUNKSIZE);
+			printk(KERN_ERR 
+				"no chunksize specified, see 'man raidtab'\n");
 			return -EINVAL;
 		}
 		if (chunk_size > MAX_CHUNK_SIZE) {
-			printk(TOO_BIG_CHUNKSIZE, chunk_size, MAX_CHUNK_SIZE);
+			printk(KERN_ERR "too big chunk_size: %d > %d\n",
+				chunk_size, MAX_CHUNK_SIZE);
 			return -EINVAL;
 		}
 		/*
@@ -1654,7 +1637,8 @@ static int do_md_run(mddev_t * mddev)
 			return -EINVAL;
 		}
 		if (chunk_size < PAGE_SIZE) {
-			printk(TOO_SMALL_CHUNKSIZE, chunk_size, PAGE_SIZE);
+			printk(KERN_ERR "too small chunk_size: %d < %ld\n",
+				chunk_size, PAGE_SIZE);
 			return -EINVAL;
 		}
 	}
@@ -1715,9 +1699,9 @@ static int do_md_run(mddev_t * mddev)
 
 	blk_queue_make_request(&mddev->queue, mddev->pers->make_request);
 	printk("%s: setting max_sectors to %d, segment boundary to %d\n",
-	       disk->disk_name,
-	       chunk_size >> 9,
-	       (chunk_size>>1)-1);
+		disk->disk_name,
+		chunk_size >> 9,
+		(chunk_size>>1)-1);
 	blk_queue_max_sectors(&mddev->queue, chunk_size >> 9);
 	blk_queue_segment_boundary(&mddev->queue, (chunk_size>>1) - 1);
 	mddev->queue.queuedata = mddev;
@@ -1741,9 +1725,6 @@ static int do_md_run(mddev_t * mddev)
 	return (0);
 }
 
-#undef TOO_BIG_CHUNKSIZE
-#undef BAD_CHUNKSIZE
-
 static int restart_array(mddev_t *mddev)
 {
 	struct gendisk *disk = disks[mdidx(mddev)];
@@ -1765,8 +1746,8 @@ static int restart_array(mddev_t *mddev)
 		mddev->ro = 0;
 		set_disk_ro(disk, 0);
 
-		printk(KERN_INFO
-			"md: md%d switched to read-write mode.\n", mdidx(mddev));
+		printk(KERN_INFO "md: md%d switched to read-write mode.\n",
+			mdidx(mddev));
 		/*
 		 * Kick recovery or resync if necessary
 		 */
@@ -1783,18 +1764,13 @@ out:
 	return err;
 }
 
-#define STILL_MOUNTED KERN_WARNING \
-"md: md%d still mounted.\n"
-#define	STILL_IN_USE \
-"md: md%d still in use.\n"
-
 static int do_md_stop(mddev_t * mddev, int ro)
 {
 	int err = 0;
 	struct gendisk *disk = disks[mdidx(mddev)];
 
 	if (atomic_read(&mddev->active)>2) {
-		printk(STILL_IN_USE, mdidx(mddev));
+		printk("md: md%d still in use.\n",mdidx(mddev));
 		err = -EBUSY;
 		goto out;
 	}
@@ -1850,7 +1826,8 @@ static int do_md_stop(mddev_t * mddev, i
 		if (disk)
 			set_capacity(disk, 0);
 	} else
-		printk(KERN_INFO "md: md%d switched to read-only mode.\n", mdidx(mddev));
+		printk(KERN_INFO "md: md%d switched to read-only mode.\n",
+			mdidx(mddev));
 	err = 0;
 out:
 	return err;
@@ -1905,11 +1882,13 @@ static void autorun_devices(void)
 		rdev0 = list_entry(pending_raid_disks.next,
 					 mdk_rdev_t, same_set);
 
-		printk(KERN_INFO "md: considering %s ...\n", bdev_partition_name(rdev0->bdev));
+		printk(KERN_INFO "md: considering %s ...\n",
+			bdev_partition_name(rdev0->bdev));
 		INIT_LIST_HEAD(&candidates);
 		ITERATE_RDEV_PENDING(rdev,tmp)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
-				printk(KERN_INFO "md:  adding %s ...\n", bdev_partition_name(rdev->bdev));
+				printk(KERN_INFO "md:  adding %s ...\n",
+					bdev_partition_name(rdev->bdev));
 				list_move(&rdev->same_set, &candidates);
 			}
 		/*
@@ -1920,7 +1899,8 @@ static void autorun_devices(void)
 
 		mddev = mddev_find(rdev0->preferred_minor);
 		if (!mddev) {
-			printk(KERN_ERR "md: cannot allocate memory for md drive.\n");
+			printk(KERN_ERR 
+				"md: cannot allocate memory for md drive.\n");
 			break;
 		}
 		if (mddev_lock(mddev)) 
@@ -1928,8 +1908,9 @@ static void autorun_devices(void)
 			       mdidx(mddev));
 		else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
-			printk(KERN_WARNING "md: md%d already running, cannot run %s\n",
-			       mdidx(mddev), bdev_partition_name(rdev0->bdev));
+			printk(KERN_WARNING 
+				"md: md%d already running, cannot run %s\n",
+				mdidx(mddev), bdev_partition_name(rdev0->bdev));
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
@@ -1956,33 +1937,6 @@ static void autorun_devices(void)
  * if possible, the array gets run as well.
  */
 
-#define BAD_VERSION KERN_ERR \
-"md: %s has RAID superblock version 0.%d, autodetect needs v0.90 or higher\n"
-
-#define OUT_OF_MEM KERN_ALERT \
-"md: out of memory.\n"
-
-#define NO_DEVICE KERN_ERR \
-"md: disabled device %s\n"
-
-#define AUTOADD_FAILED KERN_ERR \
-"md: auto-adding devices to md%d FAILED (error %d).\n"
-
-#define AUTOADD_FAILED_USED KERN_ERR \
-"md: cannot auto-add device %s to md%d, already used.\n"
-
-#define AUTORUN_FAILED KERN_ERR \
-"md: auto-running md%d FAILED (error %d).\n"
-
-#define MDDEV_BUSY KERN_ERR \
-"md: cannot auto-add to md%d, already running.\n"
-
-#define AUTOADDING KERN_INFO \
-"md: auto-adding devices to md%d, based on %s's superblock.\n"
-
-#define AUTORUNNING KERN_INFO \
-"md: auto-running md%d.\n"
-
 static int autostart_array(dev_t startdev)
 {
 	int err = -EINVAL, i;
@@ -1991,7 +1945,8 @@ static int autostart_array(dev_t startde
 
 	start_rdev = md_import_device(startdev, 0, 0);
 	if (IS_ERR(start_rdev)) {
-		printk(KERN_WARNING "md: could not import %s!\n", partition_name(startdev));
+		printk(KERN_WARNING "md: could not import %s!\n",
+			partition_name(startdev));
 		return err;
 	}
 
@@ -2005,8 +1960,9 @@ static int autostart_array(dev_t startde
 	}
 
 	if (start_rdev->faulty) {
-		printk(KERN_WARNING "md: can not autostart based on faulty %s!\n",
-						bdev_partition_name(start_rdev->bdev));
+		printk(KERN_WARNING 
+			"md: can not autostart based on faulty %s!\n",
+			bdev_partition_name(start_rdev->bdev));
 		export_rdev(start_rdev);
 		return err;
 	}
@@ -2025,8 +1981,9 @@ static int autostart_array(dev_t startde
 			continue;
 		rdev = md_import_device(dev, 0, 0);
 		if (IS_ERR(rdev)) {
-			printk(KERN_WARNING "md: could not import %s, trying to run array nevertheless.\n",
-			       partition_name(dev));
+			printk(KERN_WARNING "md: could not import %s,"
+				" trying to run array nevertheless.\n",
+				partition_name(dev));
 			continue;
 		}
 		list_add(&rdev->same_set, &pending_raid_disks);
@@ -2040,15 +1997,6 @@ static int autostart_array(dev_t startde
 
 }
 
-#undef BAD_VERSION
-#undef OUT_OF_MEM
-#undef NO_DEVICE
-#undef AUTOADD_FAILED_USED
-#undef AUTOADD_FAILED
-#undef AUTORUN_FAILED
-#undef AUTOADDING
-#undef AUTORUNNING
-
 
 static int get_version(void * arg)
 {
@@ -2113,8 +2061,6 @@ static int get_array_info(mddev_t * mdde
 
 	return 0;
 }
-#undef SET_FROM_SB
-
 
 static int get_disk_info(mddev_t * mddev, void * arg)
 {
@@ -2161,7 +2107,9 @@ static int add_new_disk(mddev_t * mddev,
 		/* expecting a device which has a superblock */
 		rdev = md_import_device(dev, mddev->major_version, mddev->minor_version);
 		if (IS_ERR(rdev)) {
-			printk(KERN_WARNING "md: md_import_device returned %ld\n", PTR_ERR(rdev));
+			printk(KERN_WARNING 
+				"md: md_import_device returned %ld\n",
+				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
 		if (!list_empty(&mddev->disks)) {
@@ -2170,8 +2118,10 @@ static int add_new_disk(mddev_t * mddev,
 			int err = super_types[mddev->major_version]
 				.load_super(rdev, rdev0, mddev->minor_version);
 			if (err < 0) {
-				printk(KERN_WARNING "md: %s has different UUID to %s\n",
-				       bdev_partition_name(rdev->bdev), bdev_partition_name(rdev0->bdev));
+				printk(KERN_WARNING 
+					"md: %s has different UUID to %s\n",
+					bdev_partition_name(rdev->bdev), 
+					bdev_partition_name(rdev0->bdev));
 				export_rdev(rdev);
 				return -EINVAL;
 			}
@@ -2190,14 +2140,17 @@ static int add_new_disk(mddev_t * mddev,
 	if (mddev->pers) {
 		int err;
 		if (!mddev->pers->hot_add_disk) {
-			printk(KERN_WARNING "md%d: personality does not support diskops!\n",
+			printk(KERN_WARNING 
+				"md%d: personality does not support diskops!\n",
 			       mdidx(mddev));
 			return -EINVAL;
 		}
 		rdev = md_import_device(dev, mddev->major_version,
 					mddev->minor_version);
 		if (IS_ERR(rdev)) {
-			printk(KERN_WARNING "md: md_import_device returned %ld\n", PTR_ERR(rdev));
+			printk(KERN_WARNING 
+				"md: md_import_device returned %ld\n",
+				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
 		rdev->in_sync = 0; /* just to be sure */
@@ -2223,7 +2176,9 @@ static int add_new_disk(mddev_t * mddev,
 		int err;
 		rdev = md_import_device (dev, -1, 0);
 		if (IS_ERR(rdev)) {
-			printk(KERN_WARNING "md: error, md_import_device() returned %ld\n", PTR_ERR(rdev));
+			printk(KERN_WARNING 
+				"md: error, md_import_device() returned %ld\n",
+				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
 		rdev->desc_nr = info->number;
@@ -2333,19 +2288,23 @@ static int hot_add_disk(mddev_t * mddev,
 		partition_name(dev), mdidx(mddev));
 
 	if (mddev->major_version != 0) {
-		printk(KERN_WARNING "md%d: HOT_ADD may only be used with version-0 superblocks.\n",
-		       mdidx(mddev));
+		printk(KERN_WARNING "md%d: HOT_ADD may only be used with"
+			" version-0 superblocks.\n",
+			mdidx(mddev));
 		return -EINVAL;
 	}
 	if (!mddev->pers->hot_add_disk) {
-		printk(KERN_WARNING "md%d: personality does not support diskops!\n",
-		       mdidx(mddev));
+		printk(KERN_WARNING 
+			"md%d: personality does not support diskops!\n",
+			mdidx(mddev));
 		return -EINVAL;
 	}
 
 	rdev = md_import_device (dev, -1, 0);
 	if (IS_ERR(rdev)) {
-		printk(KERN_WARNING "md: error, md_import_device() returned %ld\n", PTR_ERR(rdev));
+		printk(KERN_WARNING 
+			"md: error, md_import_device() returned %ld\n",
+			PTR_ERR(rdev));
 		return -EINVAL;
 	}
 
@@ -2354,16 +2313,18 @@ static int hot_add_disk(mddev_t * mddev,
 	rdev->size = size;
 
 	if (size < mddev->size) {
-		printk(KERN_WARNING "md%d: disk size %llu blocks < array size %llu\n",
-				mdidx(mddev), (unsigned long long)size, 
-				(unsigned long long)mddev->size);
+		printk(KERN_WARNING 
+			"md%d: disk size %llu blocks < array size %llu\n",
+			mdidx(mddev), (unsigned long long)size,
+			(unsigned long long)mddev->size);
 		err = -ENOSPC;
 		goto abort_export;
 	}
 
 	if (rdev->faulty) {
-		printk(KERN_WARNING "md: can not hot-add faulty %s disk to md%d!\n",
-				bdev_partition_name(rdev->bdev), mdidx(mddev));
+		printk(KERN_WARNING 
+			"md: can not hot-add faulty %s disk to md%d!\n",
+			bdev_partition_name(rdev->bdev), mdidx(mddev));
 		err = -EINVAL;
 		goto abort_export;
 	}
@@ -2378,7 +2339,7 @@ static int hot_add_disk(mddev_t * mddev,
 
 	if (rdev->desc_nr == mddev->max_disks) {
 		printk(KERN_WARNING "md%d: can not hot-add to full array!\n",
-		       mdidx(mddev));
+			mdidx(mddev));
 		err = -EBUSY;
 		goto abort_unbind_export;
 	}
@@ -2426,8 +2387,9 @@ static int set_array_info(mddev_t * mdde
 		    info->major_version >= sizeof(super_types)/sizeof(super_types[0]) ||
 		    super_types[info->major_version].name == NULL) {
 			/* maybe try to auto-load a module? */
-			printk(KERN_INFO "md: superblock version %d not known\n",
-			       info->major_version);
+			printk(KERN_INFO 
+				"md: superblock version %d not known\n",
+				info->major_version);
 			return -EINVAL;
 		}
 		mddev->major_version = info->major_version;
@@ -2540,7 +2502,7 @@ static int md_ioctl(struct inode *inode,
 		err = autostart_array(arg);
 		if (err) {
 			printk(KERN_WARNING "md: autostart %s failed!\n",
-			       partition_name(arg));
+				partition_name(arg));
 			goto abort;
 		}
 		goto done;
@@ -2548,8 +2510,9 @@ static int md_ioctl(struct inode *inode,
 
 	err = mddev_lock(mddev);
 	if (err) {
-		printk(KERN_INFO "md: ioctl lock interrupted, reason %d, cmd %d\n",
-		       err, cmd);
+		printk(KERN_INFO 
+			"md: ioctl lock interrupted, reason %d, cmd %d\n",
+			err, cmd);
 		goto abort;
 	}
 
@@ -2558,13 +2521,15 @@ static int md_ioctl(struct inode *inode,
 		case SET_ARRAY_INFO:
 
 			if (!list_empty(&mddev->disks)) {
-				printk(KERN_WARNING "md: array md%d already has disks!\n",
+				printk(KERN_WARNING 
+					"md: array md%d already has disks!\n",
 					mdidx(mddev));
 				err = -EBUSY;
 				goto abort_unlock;
 			}
 			if (mddev->raid_disks) {
-				printk(KERN_WARNING "md: array md%d already initialised!\n",
+				printk(KERN_WARNING 
+					"md: array md%d already initialised!\n",
 					mdidx(mddev));
 				err = -EBUSY;
 				goto abort_unlock;
@@ -2579,7 +2544,8 @@ static int md_ioctl(struct inode *inode,
 				}
 				err = set_array_info(mddev, &info);
 				if (err) {
-					printk(KERN_WARNING "md: couldn't set array info. %d\n", err);
+					printk(KERN_WARNING "md: couldn't set"
+						" array info. %d\n", err);
 					goto abort_unlock;
 				}
 			}
@@ -2701,9 +2667,10 @@ static int md_ioctl(struct inode *inode,
 
 		default:
 			if (_IOC_TYPE(cmd) == MD_MAJOR)
-				printk(KERN_WARNING "md: %s(pid %d) used obsolete MD ioctl, "
-				       "upgrade your software to use new ictls.\n",
-				       current->comm, current->pid);
+				printk(KERN_WARNING "md: %s(pid %d) used"
+					" obsolete MD ioctl, upgrade your"
+					" software to use new ictls.\n",
+					current->comm, current->pid);
 			err = -EINVAL;
 			goto abort_unlock;
 	}
@@ -2879,7 +2846,8 @@ void md_unregister_thread(mdk_thread_t *
 void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
-		MD_MAJOR,mdidx(mddev),MAJOR(rdev->bdev->bd_dev),MINOR(rdev->bdev->bd_dev),
+		MD_MAJOR,mdidx(mddev),
+		MAJOR(rdev->bdev->bd_dev), MINOR(rdev->bdev->bd_dev),
 		__builtin_return_address(0),__builtin_return_address(1),
 		__builtin_return_address(2),__builtin_return_address(3));
 
@@ -3228,7 +3196,8 @@ static inline void md_enter_safemode(mdd
 void md_handle_safemode(mddev_t *mddev)
 {
 	if (signal_pending(current)) {
-		printk(KERN_INFO "md: md%d in immediate safe mode\n",mdidx(mddev));
+		printk(KERN_INFO "md: md%d in immediate safe mode\n",
+			mdidx(mddev));
 		mddev->safemode = 2;
 		flush_signals(current);
 	}
@@ -3271,8 +3240,9 @@ static void md_do_sync(mddev_t *mddev)
 				continue;
 			if (mddev2->curr_resync && 
 			    match_mddev_units(mddev,mddev2)) {
-				printk(KERN_INFO "md: delaying resync of md%d until md%d "
-				       "has finished resync (they share one or more physical units)\n",
+				printk(KERN_INFO "md: delaying resync of md%d"
+					" until md%d has finished resync (they"
+				       	" share one or more physical units)\n",
 				       mdidx(mddev), mdidx(mddev2));
 				if (mddev < mddev2) {/* arbitrarily yield */
 					mddev->curr_resync = 1;
@@ -3295,7 +3265,8 @@ static void md_do_sync(mddev_t *mddev)
 	max_sectors = mddev->size << 1;
 
 	printk(KERN_INFO "md: syncing RAID array md%d\n", mdidx(mddev));
-	printk(KERN_INFO "md: minimum _guaranteed_ reconstruction speed: %d KB/sec/disc.\n", sysctl_speed_limit_min);
+	printk(KERN_INFO "md: minimum _guaranteed_ reconstruction speed:"
+		" %d KB/sec/disc.\n", sysctl_speed_limit_min);
 	printk(KERN_INFO "md: using maximum available idle IO bandwith "
 	       "(but not more than %d KB/sec) for reconstruction.\n",
 	       sysctl_speed_limit_max);
@@ -3318,14 +3289,16 @@ static void md_do_sync(mddev_t *mddev)
 	 */
 	window = 32*(PAGE_SIZE/512);
 	printk(KERN_INFO "md: using %dk window, over a total of %d blocks.\n",
-	       window/2,max_sectors/2);
+		window/2,max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
 	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
 
 	if (j)
-		printk(KERN_INFO "md: resuming recovery of md%d from checkpoint.\n", mdidx(mddev));
+		printk(KERN_INFO 
+			"md: resuming recovery of md%d from checkpoint.\n",
+			mdidx(mddev));
 
 	while (j < max_sectors) {
 		int sectors;
@@ -3367,7 +3340,8 @@ static void md_do_sync(mddev_t *mddev)
 			/*
 			 * got a signal, exit.
 			 */
-			printk(KERN_INFO "md: md_do_sync() got signal ... exiting\n");
+			printk(KERN_INFO 
+				"md: md_do_sync() got signal ... exiting\n");
 			flush_signals(current);
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto out;
@@ -3408,7 +3382,9 @@ static void md_do_sync(mddev_t *mddev)
 	    mddev->curr_resync > 2 &&
 	    mddev->curr_resync > mddev->recovery_cp) {
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
-			printk(KERN_INFO "md: checkpointing recovery of md%d.\n", mdidx(mddev));
+			printk(KERN_INFO 
+				"md: checkpointing recovery of md%d.\n",
+				mdidx(mddev));
 			mddev->recovery_cp = mddev->curr_resync;
 		} else
 			mddev->recovery_cp = MaxSector;
@@ -3526,7 +3502,9 @@ void md_check_recovery(mddev_t *mddev)
 								mddev,
 								"md%d_resync");
 			if (!mddev->sync_thread) {
-				printk(KERN_ERR "md%d: could not start resync thread...\n", mdidx(mddev));
+				printk(KERN_ERR "md%d: could not start resync"
+					" thread...\n", 
+					mdidx(mddev));
 				/* leave the spares where they are, it shouldn't hurt */
 				mddev->recovery = 0;
 			} else {
@@ -3590,7 +3568,8 @@ int __init md_init(void)
 {
 	int minor;
 
-	printk(KERN_INFO "md: md driver %d.%d.%d MAX_MD_DEVS=%d, MD_SB_DISKS=%d\n",
+	printk(KERN_INFO "md: md driver %d.%d.%d MAX_MD_DEVS=%d,"
+			" MD_SB_DISKS=%d\n",
 			MD_MAJOR_VERSION, MD_MINOR_VERSION,
 			MD_PATCHLEVEL_VERSION, MAX_MD_DEVS, MD_SB_DISKS);
 

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-03-26 10:35:30.000000000 +1100
+++ ./drivers/md/multipath.c	2003-03-26 10:36:40.000000000 +1100
@@ -78,7 +78,7 @@ static int multipath_map (mddev_t *mddev
 	}
 	spin_unlock_irq(&conf->device_lock);
 
-	printk (KERN_ERR "multipath_map(): no more operational IO paths?\n");
+	printk(KERN_ERR "multipath_map(): no more operational IO paths?\n");
 	return (-1);
 }
 
@@ -130,7 +130,8 @@ int multipath_end_request(struct bio *bi
 		 */
 		md_error (mp_bh->mddev, rdev);
 		printk(KERN_ERR "multipath: %s: rescheduling sector %llu\n", 
-		       bdev_partition_name(rdev->bdev), (unsigned long long)bio->bi_sector);
+		       bdev_partition_name(rdev->bdev), 
+		       (unsigned long long)bio->bi_sector);
 		multipath_reschedule_retry(mp_bh);
 	}
 	atomic_dec(&rdev->nr_pending);
@@ -198,16 +199,6 @@ static void multipath_status (struct seq
 	seq_printf (seq, "]");
 }
 
-#define LAST_DISK KERN_ALERT \
-"multipath: only one IO path left and IO error.\n"
-
-#define NO_SPARE_DISK KERN_ALERT \
-"multipath: no spare IO path left!\n"
-
-#define DISK_FAILED KERN_ALERT \
-"multipath: IO failure on %s, disabling IO path. \n" \
-"	Operation continuing on %d IO paths.\n"
-
 
 /*
  * Careful, this can execute in IRQ contexts as well!
@@ -222,7 +213,8 @@ static void multipath_error (mddev_t *md
 		 * first check if this is a queued request for a device
 		 * which has just failed.
 		 */
-		printk (LAST_DISK);
+		printk(KERN_ALERT 
+			"multipath: only one IO path left and IO error.\n");
 		/* leave it active... it's all we have */
 	} else {
 		/*
@@ -233,17 +225,15 @@ static void multipath_error (mddev_t *md
 			rdev->faulty = 1;
 			mddev->sb_dirty = 1;
 			conf->working_disks--;
-			printk (DISK_FAILED, bdev_partition_name (rdev->bdev),
+			printk(KERN_ALERT "multipath: IO failure on %s,"
+				" disabling IO path. \n	Operation continuing"
+				" on %d IO paths.\n",
+				bdev_partition_name (rdev->bdev),
 				conf->working_disks);
 		}
 	}
 }
 
-#undef LAST_DISK
-#undef NO_SPARE_DISK
-#undef DISK_FAILED
-
-
 static void print_multipath_conf (multipath_conf_t *conf)
 {
 	int i;
@@ -302,7 +292,7 @@ static int multipath_remove_disk(mddev_t
 	if (p->rdev) {
 		if (p->rdev->in_sync ||
 		    atomic_read(&p->rdev->nr_pending)) {
-			printk(KERN_ERR "hot-remove-disk, slot %d is identified but is still operational!\n", number);
+			printk(KERN_ERR "hot-remove-disk, slot %d is identified"				" but is still operational!\n", number);
 			err = -EBUSY;
 			goto abort;
 		}
@@ -318,11 +308,7 @@ abort:
 	return err;
 }
 
-#define IO_ERROR KERN_ALERT \
-"multipath: %s: unrecoverable IO read error for block %llu\n"
 
-#define REDIRECT_SECTOR KERN_ERR \
-"multipath: %s: redirecting sector %llu to another IO path\n"
 
 /*
  * This is a kernel thread which:
@@ -354,59 +340,22 @@ static void multipathd (mddev_t *mddev)
 		
 		rdev = NULL;
 		if (multipath_map (mddev, &rdev)<0) {
-			printk(IO_ERROR,
-				bdev_partition_name(bio->bi_bdev), (unsigned long long)bio->bi_sector);
+			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
+				" error for block %llu\n",
+				bdev_partition_name(bio->bi_bdev), 
+				(unsigned long long)bio->bi_sector);
 			multipath_end_bh_io(mp_bh, 0);
 		} else {
-			printk(REDIRECT_SECTOR,
-				bdev_partition_name(bio->bi_bdev), (unsigned long long)bio->bi_sector);
+			printk(KERN_ERR "multipath: %s: redirecting sector %llu"
+				" to another IO path\n",
+				bdev_partition_name(bio->bi_bdev), 
+				(unsigned long long)bio->bi_sector);
 			bio->bi_bdev = rdev->bdev;
 			generic_make_request(bio);
 		}
 	}
 	spin_unlock_irqrestore(&retry_list_lock, flags);
 }
-#undef IO_ERROR
-#undef REDIRECT_SECTOR
-
-#define INVALID_LEVEL KERN_WARNING \
-"multipath: md%d: raid level not set to multipath IO (%d)\n"
-
-#define NO_SB KERN_ERR \
-"multipath: disabled IO path %s (couldn't access raid superblock)\n"
-
-#define ERRORS KERN_ERR \
-"multipath: disabled IO path %s (errors detected)\n"
-
-#define NOT_IN_SYNC KERN_ERR \
-"multipath: making IO path %s a spare path (not in sync)\n"
-
-#define INCONSISTENT KERN_ERR \
-"multipath: disabled IO path %s (inconsistent descriptor)\n"
-
-#define ALREADY_RUNNING KERN_ERR \
-"multipath: disabled IO path %s (multipath %d already operational)\n"
-
-#define OPERATIONAL KERN_INFO \
-"multipath: device %s operational as IO path %d\n"
-
-#define MEM_ERROR KERN_ERR \
-"multipath: couldn't allocate memory for md%d\n"
-
-#define SPARE KERN_INFO \
-"multipath: spare IO path %s\n"
-
-#define NONE_OPERATIONAL KERN_ERR \
-"multipath: no operational IO paths for md%d\n"
-
-#define SB_DIFFERENCES KERN_ERR \
-"multipath: detected IO path differences!\n"
-
-#define ARRAY_IS_ACTIVE KERN_INFO \
-"multipath: array md%d active with %d out of %d IO paths\n"
-
-#define THREAD_ERROR KERN_ERR \
-"multipath: couldn't allocate thread for md%d\n"
 
 static int multipath_run (mddev_t *mddev)
 {
@@ -419,7 +368,8 @@ static int multipath_run (mddev_t *mddev
 	MOD_INC_USE_COUNT;
 
 	if (mddev->level != LEVEL_MULTIPATH) {
-		printk(INVALID_LEVEL, mdidx(mddev), mddev->level);
+		printk("multipath: md%d: raid level not set to multipath IO (%d)\n",
+		       mdidx(mddev), mddev->level);
 		goto out;
 	}
 	/*
@@ -431,7 +381,9 @@ static int multipath_run (mddev_t *mddev
 	conf = kmalloc(sizeof(multipath_conf_t), GFP_KERNEL);
 	mddev->private = conf;
 	if (!conf) {
-		printk(MEM_ERROR, mdidx(mddev));
+		printk(KERN_ERR 
+			"multipath: couldn't allocate memory for md%d\n",
+			mdidx(mddev));
 		goto out;
 	}
 	memset(conf, 0, sizeof(*conf));
@@ -455,7 +407,8 @@ static int multipath_run (mddev_t *mddev
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
 
 	if (!conf->working_disks) {
-		printk(NONE_OPERATIONAL, mdidx(mddev));
+		printk(KERN_ERR "multipath: no operational IO paths for md%d\n",
+			mdidx(mddev));
 		goto out_free_conf;
 	}
 	mddev->degraded = conf->raid_disks = conf->working_disks;
@@ -464,7 +417,9 @@ static int multipath_run (mddev_t *mddev
 				    mp_pool_alloc, mp_pool_free,
 				    NULL);
 	if (conf->pool == NULL) {
-		printk(MEM_ERROR, mdidx(mddev));
+		printk(KERN_ERR 
+			"multipath: couldn't allocate memory for md%d\n",
+			mdidx(mddev));
 		goto out_free_conf;
 	}
 
@@ -473,13 +428,15 @@ static int multipath_run (mddev_t *mddev
 
 		mddev->thread = md_register_thread(multipathd, mddev, name);
 		if (!mddev->thread) {
-			printk(THREAD_ERROR, mdidx(mddev));
+			printk(KERN_ERR "multipath: couldn't allocate thread"
+				" for md%d\n", mdidx(mddev));
 			goto out_free_conf;
 		}
 	}
 
-	printk(ARRAY_IS_ACTIVE, mdidx(mddev), conf->working_disks,
-			mddev->raid_disks);
+	printk(KERN_INFO 
+		"multipath: array md%d active with %d out of %d IO paths\n",
+		mdidx(mddev), conf->working_disks, mddev->raid_disks);
 	/*
 	 * Ok, everything is just fine now
 	 */
@@ -495,17 +452,6 @@ out:
 	return -EIO;
 }
 
-#undef INVALID_LEVEL
-#undef NO_SB
-#undef ERRORS
-#undef NOT_IN_SYNC
-#undef INCONSISTENT
-#undef ALREADY_RUNNING
-#undef OPERATIONAL
-#undef SPARE
-#undef NONE_OPERATIONAL
-#undef SB_DIFFERENCES
-#undef ARRAY_IS_ACTIVE
 
 static int multipath_stop (mddev_t *mddev)
 {

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-03-26 10:35:30.000000000 +1100
+++ ./drivers/md/raid0.c	2003-03-26 10:35:11.000000000 +1100
@@ -43,12 +43,15 @@ static int create_strip_zones (mddev_t *
 	conf->nr_strip_zones = 0;
  
 	ITERATE_RDEV(mddev,rdev1,tmp1) {
-		printk("raid0: looking at %s\n", bdev_partition_name(rdev1->bdev));
+		printk("raid0: looking at %s\n",
+			bdev_partition_name(rdev1->bdev));
 		c = 0;
 		ITERATE_RDEV(mddev,rdev2,tmp2) {
 			printk("raid0:   comparing %s(%llu) with %s(%llu)\n",
-			       bdev_partition_name(rdev1->bdev), (unsigned long long)rdev1->size,
-			       bdev_partition_name(rdev2->bdev), (unsigned long long)rdev2->size);
+				bdev_partition_name(rdev1->bdev),
+				(unsigned long long)rdev1->size,
+				bdev_partition_name(rdev2->bdev),
+				(unsigned long long)rdev2->size);
 			if (rdev2 == rdev1) {
 				printk("raid0:   END\n");
 				break;
@@ -94,7 +97,8 @@ static int create_strip_zones (mddev_t *
 			goto abort;
 		}
 		if (zone->dev[j]) {
-			printk("raid0: multiple devices for %d - aborting!\n", j);
+			printk("raid0: multiple devices for %d - aborting!\n",
+				j);
 			goto abort;
 		}
 		zone->dev[j] = rdev1;
@@ -103,8 +107,8 @@ static int create_strip_zones (mddev_t *
 		cnt++;
 	}
 	if (cnt != mddev->raid_disks) {
-		printk("raid0: too few disks (%d of %d) - aborting!\n", cnt, 
-		       mddev->raid_disks);
+		printk("raid0: too few disks (%d of %d) - aborting!\n",
+			cnt, mddev->raid_disks);
 		goto abort;
 	}
 	zone->nb_dev = cnt;
@@ -136,7 +140,7 @@ static int create_strip_zones (mddev_t *
 				if (!smallest || (rdev->size <smallest->size)) {
 					smallest = rdev;
 					printk("  (%llu) is smallest!.\n", 
-					       (unsigned long long)rdev->size);
+						(unsigned long long)rdev->size);
 				}
 			} else
 				printk(" nope.\n");
@@ -144,7 +148,8 @@ static int create_strip_zones (mddev_t *
 
 		zone->nb_dev = c;
 		zone->size = (smallest->size - current_offset) * c;
-		printk("raid0: zone->nb_dev: %d, size: %llu\n",zone->nb_dev, (unsigned long long)zone->size);
+		printk("raid0: zone->nb_dev: %d, size: %llu\n",
+			zone->nb_dev, (unsigned long long)zone->size);
 
 		if (!conf->smallest || (zone->size < conf->smallest->size))
 			conf->smallest = zone;
@@ -153,7 +158,8 @@ static int create_strip_zones (mddev_t *
 		curr_zone_offset += zone->size;
 
 		current_offset = smallest->size;
-		printk("raid0: current zone offset: %llu\n", (unsigned long long)current_offset);
+		printk("raid0: current zone offset: %llu\n",
+			(unsigned long long)current_offset);
 	}
 	printk("raid0: done.\n");
 	return 0;
@@ -201,8 +207,10 @@ static int raid0_run (mddev_t *mddev)
 	if (create_strip_zones (mddev)) 
 		goto out_free_conf;
 
-	printk("raid0 : md_size is %llu blocks.\n", (unsigned long long)md_size[mdidx(mddev)]);
-	printk("raid0 : conf->smallest->size is %llu blocks.\n", (unsigned long long)conf->smallest->size);
+	printk("raid0 : md_size is %llu blocks.\n", 
+		(unsigned long long)md_size[mdidx(mddev)]);
+	printk("raid0 : conf->smallest->size is %llu blocks.\n",
+		(unsigned long long)conf->smallest->size);
 	{
 #if __GNUC__ < 3
 		volatile
@@ -357,16 +365,21 @@ static int raid0_make_request (request_q
 	return 1;
 
 bad_map:
-	printk ("raid0_make_request bug: can't convert block across chunks or bigger than %dk %llu %d\n", chunk_size, (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
+	printk("raid0_make_request bug: can't convert block across chunks"
+		" or bigger than %dk %llu %d\n", chunk_size, 
+		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
 	goto outerr;
 bad_hash:
-	printk("raid0_make_request bug: hash==NULL for block %llu\n", (unsigned long long)block);
+	printk("raid0_make_request bug: hash==NULL for block %llu\n",
+		(unsigned long long)block);
 	goto outerr;
 bad_zone0:
-	printk ("raid0_make_request bug: hash->zone0==NULL for block %llu\n", (unsigned long long)block);
+	printk("raid0_make_request bug: hash->zone0==NULL for block %llu\n",
+		(unsigned long long)block);
 	goto outerr;
 bad_zone1:
-	printk ("raid0_make_request bug: hash->zone1==NULL for block %llu\n", (unsigned long long)block);
+	printk("raid0_make_request bug: hash->zone1==NULL for block %llu\n",
+			(unsigned long long)block);
  outerr:
 	bio_io_error(bio, bio->bi_size);
 	return 0;

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-03-26 10:35:30.000000000 +1100
+++ ./drivers/md/raid1.c	2003-03-26 10:36:08.000000000 +1100
@@ -217,7 +217,7 @@ static int map(mddev_t *mddev, mdk_rdev_
 	}
 	spin_unlock_irq(&conf->device_lock);
 
-	printk (KERN_ERR "raid1_map(): huh, no more operational devices?\n");
+	printk(KERN_ERR "raid1_map(): huh, no more operational devices?\n");
 	return -1;
 }
 
@@ -305,7 +305,7 @@ static int end_request(struct bio *bio, 
 			 * oops, read error:
 			 */
 			printk(KERN_ERR "raid1: %s: rescheduling sector %llu\n",
-			       bdev_partition_name(conf->mirrors[mirror].rdev->bdev), (unsigned long long)r1_bio->sector);
+				bdev_partition_name(conf->mirrors[mirror].rdev->bdev), (unsigned long long)r1_bio->sector);
 			reschedule_retry(r1_bio);
 		}
 	} else {
@@ -584,22 +584,6 @@ static void status(struct seq_file *seq,
 	seq_printf(seq, "]");
 }
 
-#define LAST_DISK KERN_ALERT \
-"raid1: only one disk left and IO error.\n"
-
-#define NO_SPARE_DISK KERN_ALERT \
-"raid1: no spare disk left, degrading mirror level by one.\n"
-
-#define DISK_FAILED KERN_ALERT \
-"raid1: Disk failure on %s, disabling device. \n" \
-"	Operation continuing on %d devices\n"
-
-#define START_SYNCING KERN_ALERT \
-"raid1: start syncing spare disk.\n"
-
-#define ALREADY_SYNCING KERN_INFO \
-"raid1: syncing already in progress.\n"
-
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
@@ -629,7 +613,9 @@ static void error(mddev_t *mddev, mdk_rd
 	rdev->in_sync = 0;
 	rdev->faulty = 1;
 	mddev->sb_dirty = 1;
-	printk(DISK_FAILED, bdev_partition_name(rdev->bdev), conf->working_disks);
+	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device. \n"
+		"	Operation continuing on %d devices\n",
+		bdev_partition_name(rdev->bdev), conf->working_disks);
 }
 
 static void print_conf(conf_t *conf)
@@ -643,14 +629,14 @@ static void print_conf(conf_t *conf)
 		return;
 	}
 	printk(" --- wd:%d rd:%d\n", conf->working_disks,
-			conf->raid_disks);
+		conf->raid_disks);
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
 			printk(" disk %d, wo:%d, o:%d, dev:%s\n",
-			       i, !tmp->rdev->in_sync, !tmp->rdev->faulty,
-			       bdev_partition_name(tmp->rdev->bdev));
+				i, !tmp->rdev->in_sync, !tmp->rdev->faulty,
+				bdev_partition_name(tmp->rdev->bdev));
 	}
 }
 
@@ -743,11 +729,6 @@ abort:
 	return err;
 }
 
-#define IO_ERROR KERN_ALERT \
-"raid1: %s: unrecoverable I/O read error for block %llu\n"
-
-#define REDIRECT_SECTOR KERN_ERR \
-"raid1: %s: redirecting sector %llu to another mirror\n"
 
 static int end_sync_read(struct bio *bio, unsigned int bytes_done, int error)
 {
@@ -823,7 +804,10 @@ static void sync_request_write(mddev_t *
 		 * There is no point trying a read-for-reconstruct as
 		 * reconstruct is about to be aborted
 		 */
-		printk(IO_ERROR, bdev_partition_name(bio->bi_bdev), (unsigned long long)r1_bio->sector);
+		printk(KERN_ALERT "raid1: %s: unrecoverable I/O read error"
+			" for block %llu\n",
+			bdev_partition_name(bio->bi_bdev), 
+			(unsigned long long)r1_bio->sector);
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
 		put_buf(r1_bio);
 		return;
@@ -874,7 +858,8 @@ static void sync_request_write(mddev_t *
 		 * Nowhere to write this to... I guess we
 		 * must be done
 		 */
-		printk(KERN_ALERT "raid1: sync aborting as there is nowhere to write sector %llu\n", 
+		printk(KERN_ALERT "raid1: sync aborting as there is nowhere"
+			" to write sector %llu\n", 
 			(unsigned long long)r1_bio->sector);
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
 		put_buf(r1_bio);
@@ -928,12 +913,17 @@ static void raid1d(mddev_t *mddev)
 		case READ:
 		case READA:
 			if (map(mddev, &rdev) == -1) {
-				printk(IO_ERROR, bdev_partition_name(bio->bi_bdev), (unsigned long long)r1_bio->sector);
+				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
+				" read error for block %llu\n",
+				bdev_partition_name(bio->bi_bdev), 
+				(unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio, 0);
 				break;
 			}
-			printk(REDIRECT_SECTOR,
-				bdev_partition_name(rdev->bdev), (unsigned long long)r1_bio->sector);
+			printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
+				" another mirror\n",
+				bdev_partition_name(rdev->bdev), 
+				(unsigned long long)r1_bio->sector);
 			bio->bi_bdev = rdev->bdev;
 			bio->bi_sector = r1_bio->sector + rdev->data_offset;
 			bio->bi_rw = r1_bio->cmd;
@@ -1063,45 +1053,6 @@ static int sync_request(mddev_t *mddev, 
 	return nr_sectors;
 }
 
-#define INVALID_LEVEL KERN_WARNING \
-"raid1: md%d: raid level not set to mirroring (%d)\n"
-
-#define NO_SB KERN_ERR \
-"raid1: disabled mirror %s (couldn't access raid superblock)\n"
-
-#define ERRORS KERN_ERR \
-"raid1: disabled mirror %s (errors detected)\n"
-
-#define NOT_IN_SYNC KERN_ERR \
-"raid1: disabled mirror %s (not in sync)\n"
-
-#define INCONSISTENT KERN_ERR \
-"raid1: disabled mirror %s (inconsistent descriptor)\n"
-
-#define ALREADY_RUNNING KERN_ERR \
-"raid1: disabled mirror %s (mirror %d already operational)\n"
-
-#define OPERATIONAL KERN_INFO \
-"raid1: device %s operational as mirror %d\n"
-
-#define MEM_ERROR KERN_ERR \
-"raid1: couldn't allocate memory for md%d\n"
-
-#define SPARE KERN_INFO \
-"raid1: spare disk %s\n"
-
-#define NONE_OPERATIONAL KERN_ERR \
-"raid1: no operational mirrors for md%d\n"
-
-#define ARRAY_IS_ACTIVE KERN_INFO \
-"raid1: raid set md%d active with %d out of %d mirrors\n"
-
-#define THREAD_ERROR KERN_ERR \
-"raid1: couldn't allocate thread for md%d\n"
-
-#define START_RESYNC KERN_WARNING \
-"raid1: raid set md%d not clean; reconstructing mirrors\n"
-
 static int run(mddev_t *mddev)
 {
 	conf_t *conf;
@@ -1113,7 +1064,8 @@ static int run(mddev_t *mddev)
 	MOD_INC_USE_COUNT;
 
 	if (mddev->level != 1) {
-		printk(INVALID_LEVEL, mdidx(mddev), mddev->level);
+		printk("raid1: md%d: raid level not set to mirroring (%d)\n",
+		       mdidx(mddev), mddev->level);
 		goto out;
 	}
 	/*
@@ -1124,7 +1076,8 @@ static int run(mddev_t *mddev)
 	conf = kmalloc(sizeof(conf_t), GFP_KERNEL);
 	mddev->private = conf;
 	if (!conf) {
-		printk(MEM_ERROR, mdidx(mddev));
+		printk(KERN_ERR "raid1: couldn't allocate memory for md%d\n",
+			mdidx(mddev));
 		goto out;
 	}
 	memset(conf, 0, sizeof(*conf));
@@ -1132,7 +1085,8 @@ static int run(mddev_t *mddev)
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
 						r1bio_pool_free, NULL);
 	if (!conf->r1bio_pool) {
-		printk(MEM_ERROR, mdidx(mddev));
+		printk(KERN_ERR "raid1: couldn't allocate memory for md%d\n", 
+			mdidx(mddev));
 		goto out;
 	}
 
@@ -1160,7 +1114,8 @@ static int run(mddev_t *mddev)
 	init_waitqueue_head(&conf->wait_resume);
 
 	if (!conf->working_disks) {
-		printk(NONE_OPERATIONAL, mdidx(mddev));
+		printk(KERN_ERR "raid1: no operational mirrors for md%d\n",
+			mdidx(mddev));
 		goto out_free_conf;
 	}
 
@@ -1190,12 +1145,16 @@ static int run(mddev_t *mddev)
 	{
 		mddev->thread = md_register_thread(raid1d, mddev, "md%d_raid1");
 		if (!mddev->thread) {
-			printk(THREAD_ERROR, mdidx(mddev));
+			printk(KERN_ERR 
+				"raid1: couldn't allocate thread for md%d\n", 
+				mdidx(mddev));
 			goto out_free_conf;
 		}
 	}
-
-	printk(ARRAY_IS_ACTIVE, mdidx(mddev), mddev->raid_disks - mddev->degraded, mddev->raid_disks);
+	printk(KERN_INFO 
+		"raid1: raid set md%d active with %d out of %d mirrors\n",
+		mdidx(mddev), mddev->raid_disks - mddev->degraded, 
+		mddev->raid_disks);
 	/*
 	 * Ok, everything is just fine now
 	 */

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-03-26 10:35:30.000000000 +1100
+++ ./drivers/md/raid5.c	2003-03-26 10:35:11.000000000 +1100
@@ -182,7 +182,8 @@ static inline void init_stripe(struct st
 		BUG();
 	
 	CHECK_DEVLOCK();
-	PRINTK("init_stripe called, stripe %llu\n", (unsigned long long)sh->sector);
+	PRINTK("init_stripe called, stripe %llu\n", 
+		(unsigned long long)sh->sector);
 
 	remove_hash(sh);
 	
@@ -338,7 +339,9 @@ static int raid5_end_read_request (struc
 		if (bi == &sh->dev[i].req)
 			break;
 
-	PRINTK("end_read_request %llu/%d, count: %d, uptodate %d.\n", (unsigned long long)sh->sector, i, atomic_read(&sh->count), uptodate);
+	PRINTK("end_read_request %llu/%d, count: %d, uptodate %d.\n", 
+		(unsigned long long)sh->sector, i, atomic_read(&sh->count), 
+		uptodate);
 	if (i == disks) {
 		BUG();
 		return 0;
@@ -409,7 +412,9 @@ static int raid5_end_write_request (stru
 		if (bi == &sh->dev[i].req)
 			break;
 
-	PRINTK("end_write_request %llu/%d, count %d, uptodate: %d.\n", (unsigned long long)sh->sector, i, atomic_read(&sh->count), uptodate);
+	PRINTK("end_write_request %llu/%d, count %d, uptodate: %d.\n", 
+		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
+		uptodate);
 	if (i == disks) {
 		BUG();
 		return 0;
@@ -533,7 +538,8 @@ static unsigned long raid5_compute_secto
 			*dd_idx = (*pd_idx + 1 + *dd_idx) % raid_disks;
 			break;
 		default:
-			printk ("raid5: unsupported algorithm %d\n", conf->algorithm);
+			printk("raid5: unsupported algorithm %d\n",
+				conf->algorithm);
 	}
 
 	/*
@@ -573,7 +579,8 @@ static sector_t compute_blocknr(struct s
 			i -= (sh->pd_idx + 1);
 			break;
 		default:
-			printk ("raid5: unsupported algorithm %d\n", conf->algorithm);
+			printk("raid5: unsupported algorithm %d\n",
+				conf->algorithm);
 	}
 
 	chunk_number = stripe * data_disks + i;
@@ -655,7 +662,8 @@ static void compute_block(struct stripe_
 	int i, count, disks = conf->raid_disks;
 	void *ptr[MAX_XOR_BLOCKS], *p;
 
-	PRINTK("compute_block, stripe %llu, idx %d\n", (unsigned long long)sh->sector, dd_idx);
+	PRINTK("compute_block, stripe %llu, idx %d\n", 
+		(unsigned long long)sh->sector, dd_idx);
 
 	ptr[0] = page_address(sh->dev[dd_idx].page);
 	memset(ptr[0], 0, STRIPE_SIZE);
@@ -667,7 +675,9 @@ static void compute_block(struct stripe_
 		if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
 			ptr[count++] = p;
 		else
-			printk("compute_block() %d, stripe %llu, %d not present\n", dd_idx, (unsigned long long)sh->sector, i);
+			printk("compute_block() %d, stripe %llu, %d"
+				" not present\n", dd_idx,
+				(unsigned long long)sh->sector, i);
 
 		check_xor();
 	}
@@ -683,7 +693,8 @@ static void compute_parity(struct stripe
 	void *ptr[MAX_XOR_BLOCKS];
 	struct bio *chosen;
 
-	PRINTK("compute_parity, stripe %llu, method %d\n", (unsigned long long)sh->sector, method);
+	PRINTK("compute_parity, stripe %llu, method %d\n",
+		(unsigned long long)sh->sector, method);
 
 	count = 1;
 	ptr[0] = page_address(sh->dev[pd_idx].page);
@@ -768,7 +779,9 @@ static void add_stripe_bio (struct strip
 	struct bio **bip;
 	raid5_conf_t *conf = sh->raid_conf;
 
-	PRINTK("adding bh b#%llu to stripe s#%llu\n", (unsigned long long)bi->bi_sector, (unsigned long long)sh->sector);
+	PRINTK("adding bh b#%llu to stripe s#%llu\n",
+		(unsigned long long)bi->bi_sector,
+		(unsigned long long)sh->sector);
 
 
 	spin_lock(&sh->lock);
@@ -789,7 +802,9 @@ static void add_stripe_bio (struct strip
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sh->lock);
 
-	PRINTK("added bi b#%llu to stripe s#%llu, disk %d.\n", (unsigned long long)bi->bi_sector, (unsigned long long)sh->sector, dd_idx);
+	PRINTK("added bi b#%llu to stripe s#%llu, disk %d.\n",
+		(unsigned long long)bi->bi_sector,
+		(unsigned long long)sh->sector, dd_idx);
 
 	if (forwrite) {
 		/* check if page is coverred */
@@ -838,7 +853,9 @@ static void handle_stripe(struct stripe_
 	int failed_num=0;
 	struct r5dev *dev;
 
-	PRINTK("handling stripe %llu, cnt=%d, pd_idx=%d\n", (unsigned long long)sh->sector, atomic_read(&sh->count), sh->pd_idx);
+	PRINTK("handling stripe %llu, cnt=%d, pd_idx=%d\n",
+		(unsigned long long)sh->sector, atomic_read(&sh->count),
+		sh->pd_idx);
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
@@ -853,8 +870,8 @@ static void handle_stripe(struct stripe_
 		clear_bit(R5_Insync, &dev->flags);
 		clear_bit(R5_Syncio, &dev->flags);
 
-		PRINTK("check %d: state 0x%lx read %p write %p written %p\n", i, 
-		       dev->flags, dev->toread, dev->towrite, dev->written);
+		PRINTK("check %d: state 0x%lx read %p write %p written %p\n",
+			i, dev->flags, dev->toread, dev->towrite, dev->written);
 		/* maybe we can reply to a read */
 		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
 			struct bio *rbi, *rbi2;
@@ -895,8 +912,9 @@ static void handle_stripe(struct stripe_
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
-	PRINTK("locked=%d uptodate=%d to_read=%d to_write=%d failed=%d failed_num=%d\n",
-	       locked, uptodate, to_read, to_write, failed, failed_num);
+	PRINTK("locked=%d uptodate=%d to_read=%d"
+		" to_write=%d failed=%d failed_num=%d\n",
+		locked, uptodate, to_read, to_write, failed, failed_num);
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
@@ -1015,7 +1033,8 @@ static void handle_stripe(struct stripe_
 					}
 #endif
 					locked++;
-					PRINTK("Reading block %d (sync=%d)\n", i, syncing);
+					PRINTK("Reading block %d (sync=%d)\n", 
+						i, syncing);
 					if (syncing)
 						md_sync_acct(conf->disks[i].rdev, STRIPE_SECTORS);
 				}
@@ -1055,7 +1074,8 @@ static void handle_stripe(struct stripe_
 				else rcw += 2*disks;
 			}
 		}
-		PRINTK("for sector %llu, rmw=%d rcw=%d\n", (unsigned long long)sh->sector, rmw, rcw);
+		PRINTK("for sector %llu, rmw=%d rcw=%d\n", 
+			(unsigned long long)sh->sector, rmw, rcw);
 		set_bit(STRIPE_HANDLE, &sh->state);
 		if (rmw < rcw && rmw > 0)
 			/* prefer read-modify-write, but need to get some data */
@@ -1204,7 +1224,8 @@ static void handle_stripe(struct stripe_
 				md_sync_acct(rdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
-			PRINTK("for %llu schedule op %ld on disc %d\n", (unsigned long long)sh->sector, bi->bi_rw, i);
+			PRINTK("for %llu schedule op %ld on disc %d\n",
+				(unsigned long long)sh->sector, bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			bi->bi_sector = sh->sector + rdev->data_offset;
 			bi->bi_flags = 1 << BIO_UPTODATE;
@@ -1217,7 +1238,8 @@ static void handle_stripe(struct stripe_
 			bi->bi_next = NULL;
 			generic_make_request(bi);
 		} else {
-			PRINTK("skip op %ld on disc %d for sector %llu\n", bi->bi_rw, i, (unsigned long long)sh->sector);
+			PRINTK("skip op %ld on disc %d for sector %llu\n",
+				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
@@ -1285,8 +1307,9 @@ static int make_request (request_queue_t
 		new_sector = raid5_compute_sector(logical_sector,
 						  raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 
-		PRINTK("raid5: make_request, sector %Lu logical %Lu\n", 
-		       (unsigned long long)new_sector, (unsigned long long)logical_sector);
+		PRINTK("raid5: make_request, sector %Lu logical %Lu\n",
+			(unsigned long long)new_sector, 
+			(unsigned long long)logical_sector);
 
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
@@ -1450,7 +1473,9 @@ static int run (mddev_t *mddev)
 		disk->rdev = rdev;
 
 		if (rdev->in_sync) {
-			printk(KERN_INFO "raid5: device %s operational as raid disk %d\n", bdev_partition_name(rdev->bdev), raid_disk);
+			printk(KERN_INFO "raid5: device %s operational as raid"
+				" disk %d\n", bdev_partition_name(rdev->bdev),
+				raid_disk);
 			conf->working_disks++;
 		}
 	}
@@ -1467,48 +1492,62 @@ static int run (mddev_t *mddev)
 	conf->max_nr_stripes = NR_STRIPES;
 
 	if (!conf->chunk_size || conf->chunk_size % 4) {
-		printk(KERN_ERR "raid5: invalid chunk size %d for md%d\n", conf->chunk_size, mdidx(mddev));
+		printk(KERN_ERR "raid5: invalid chunk size %d for md%d\n",
+			conf->chunk_size, mdidx(mddev));
 		goto abort;
 	}
 	if (conf->algorithm > ALGORITHM_RIGHT_SYMMETRIC) {
-		printk(KERN_ERR "raid5: unsupported parity algorithm %d for md%d\n", conf->algorithm, mdidx(mddev));
+		printk(KERN_ERR 
+			"raid5: unsupported parity algorithm %d for md%d\n",
+			conf->algorithm, mdidx(mddev));
 		goto abort;
 	}
 	if (mddev->degraded > 1) {
-		printk(KERN_ERR "raid5: not enough operational devices for md%d (%d/%d failed)\n", mdidx(mddev), conf->failed_disks, conf->raid_disks);
+		printk(KERN_ERR "raid5: not enough operational devices for md%d"
+			" (%d/%d failed)\n",
+			mdidx(mddev), conf->failed_disks, conf->raid_disks);
 		goto abort;
 	}
 
 	if (mddev->degraded == 1 &&
 	    mddev->recovery_cp != MaxSector) {
-		printk(KERN_ERR "raid5: cannot start dirty degraded array for md%d\n", mdidx(mddev));
+		printk(KERN_ERR 
+			"raid5: cannot start dirty degraded array for md%d\n",
+			mdidx(mddev));
 		goto abort;
 	}
 
 	{
 		mddev->thread = md_register_thread(raid5d, mddev, "md%d_raid5");
 		if (!mddev->thread) {
-			printk(KERN_ERR "raid5: couldn't allocate thread for md%d\n", mdidx(mddev));
+			printk(KERN_ERR 
+				"raid5: couldn't allocate thread for md%d\n",
+				mdidx(mddev));
 			goto abort;
 		}
 	}
-
-	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
+memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	if (grow_stripes(conf, conf->max_nr_stripes)) {
-		printk(KERN_ERR "raid5: couldn't allocate %dkB for buffers\n", memory);
+		printk(KERN_ERR 
+			"raid5: couldn't allocate %dkB for buffers\n", memory);
 		shrink_stripes(conf);
 		md_unregister_thread(mddev->thread);
 		goto abort;
 	} else
-		printk(KERN_INFO "raid5: allocated %dkB for md%d\n", memory, mdidx(mddev));
+		printk(KERN_INFO "raid5: allocated %dkB for md%d\n",
+			memory, mdidx(mddev));
 
 	if (mddev->degraded == 0)
-		printk("raid5: raid level %d set md%d active with %d out of %d devices, algorithm %d\n", conf->level, mdidx(mddev), 
-		       mddev->raid_disks-mddev->degraded, mddev->raid_disks, conf->algorithm);
+		printk("raid5: raid level %d set md%d active with %d out of %d"
+			" devices, algorithm %d\n", conf->level, mdidx(mddev), 
+			mddev->raid_disks-mddev->degraded, mddev->raid_disks,
+			conf->algorithm);
 	else
-		printk(KERN_ALERT "raid5: raid level %d set md%d active with %d out of %d devices, algorithm %d\n", conf->level, mdidx(mddev),
-		       mddev->raid_disks - mddev->degraded, mddev->raid_disks, conf->algorithm);
+		printk(KERN_ALERT "raid5: raid level %d set md%d active with %d"
+			" out of %d devices, algorithm %d\n", conf->level,
+			mdidx(mddev), mddev->raid_disks - mddev->degraded,
+			mddev->raid_disks, conf->algorithm);
 
 	print_raid5_conf(conf);
 
@@ -1549,11 +1588,14 @@ static void print_sh (struct stripe_head
 {
 	int i;
 
-	printk("sh %llu, pd_idx %d, state %ld.\n", (unsigned long long)sh->sector, sh->pd_idx, sh->state);
-	printk("sh %llu,  count %d.\n", (unsigned long long)sh->sector, atomic_read(&sh->count));
+	printk("sh %llu, pd_idx %d, state %ld.\n",
+		(unsigned long long)sh->sector, sh->pd_idx, sh->state);
+	printk("sh %llu,  count %d.\n",
+		(unsigned long long)sh->sector, atomic_read(&sh->count));
 	printk("sh %llu, ", (unsigned long long)sh->sector);
 	for (i = 0; i < sh->raid_conf->raid_disks; i++) {
-		printk("(cache%d: %p %ld) ", i, sh->dev[i].page, sh->dev[i].flags);
+		printk("(cache%d: %p %ld) ", 
+			i, sh->dev[i].page, sh->dev[i].flags);
 	}
 	printk("\n");
 }
