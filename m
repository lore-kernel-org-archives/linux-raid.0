From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 26 of 27 - Change partition_name calls to bdev_partition_name were possible.
Date: Thu, 18 Jul 2002 23:34:37 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133437.5059@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Change partition_name calls to bdev_partition_name were possible.

All part of decreasing reliance on device numbers... atleast in
appearance.




 ----------- Diffstat output ------------
 ./drivers/md/md.c    |   75 +++++++++++++++++++++++++--------------------------
 ./drivers/md/raid0.c |   12 ++++----
 ./drivers/md/raid1.c |    2 -
 3 files changed, 44 insertions(+), 45 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:08:25	1.17
+++ ./drivers/md/md.c	2002/07/18 12:08:41	1.18
@@ -438,7 +438,7 @@ static int read_disk_sb(mdk_rdev_t * rde
 	return 0;
 
 fail:
-	printk(NO_SB,partition_name(rdev->dev));
+	printk(NO_SB,bdev_partition_name(rdev->bdev));
 	return -EINVAL;
 }
 
@@ -469,17 +469,17 @@ static int check_disk_sb(mdk_rdev_t * rd
 	}
 
 	if (sb->md_magic != MD_SB_MAGIC) {
-		printk(BAD_MAGIC, partition_name(rdev->dev));
+		printk(BAD_MAGIC, bdev_partition_name(rdev->bdev));
 		goto abort;
 	}
 
 	if (sb->md_minor >= MAX_MD_DEVS) {
-		printk(BAD_MINOR, partition_name(rdev->dev), sb->md_minor);
+		printk(BAD_MINOR, bdev_partition_name(rdev->bdev), sb->md_minor);
 		goto abort;
 	}
 
 	if (calc_sb_csum(sb) != sb->sb_csum) {
-		printk(BAD_CSUM, partition_name(rdev->dev));
+		printk(BAD_CSUM, bdev_partition_name(rdev->bdev));
 		goto abort;
 	}
 	ret = 0;
@@ -526,12 +526,12 @@ static void bind_rdev_to_array(mdk_rdev_
 		printk( KERN_WARNING
 "md%d: WARNING: %s appears to be on the same physical disk as %s. True\n"
 "     protection against single-disk failure might be compromised.\n",
-			mdidx(mddev), partition_name(rdev->dev),
-				partition_name(same_pdev->dev));
+			mdidx(mddev), bdev_partition_name(rdev->bdev),
+				bdev_partition_name(same_pdev->bdev));
 
 	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
-	printk(KERN_INFO "md: bind<%s>\n", partition_name(rdev->dev));
+	printk(KERN_INFO "md: bind<%s>\n", bdev_partition_name(rdev->bdev));
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -541,7 +541,7 @@ static void unbind_rdev_from_array(mdk_r
 		return;
 	}
 	list_del_init(&rdev->same_set);
-	printk(KERN_INFO "md: unbind<%s>\n", partition_name(rdev->dev));
+	printk(KERN_INFO "md: unbind<%s>\n", bdev_partition_name(rdev->bdev));
 	rdev->mddev = NULL;
 }
 
@@ -586,7 +586,7 @@ void md_autodetect_dev(kdev_t dev);
 
 static void export_rdev(mdk_rdev_t * rdev)
 {
-	printk(KERN_INFO "md: export_rdev(%s)\n",partition_name(rdev->dev));
+	printk(KERN_INFO "md: export_rdev(%s)\n",bdev_partition_name(rdev->bdev));
 	if (rdev->mddev)
 		MD_BUG();
 	free_disk_sb(rdev);
@@ -682,7 +682,7 @@ static void print_sb(mdp_super_t *sb)
 static void print_rdev(mdk_rdev_t *rdev)
 {
 	printk(KERN_INFO "md: rdev %s, SZ:%08ld F:%d DN:%d ",
-		partition_name(rdev->dev),
+		bdev_partition_name(rdev->bdev),
 		rdev->size, rdev->faulty, rdev->desc_nr);
 	if (rdev->sb) {
 		printk(KERN_INFO "md: rdev superblock:\n");
@@ -705,7 +705,7 @@ void md_print_devices(void)
 		printk("md%d: ", mdidx(mddev));
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
-			printk("<%s>", partition_name(rdev->dev));
+			printk("<%s>", bdev_partition_name(rdev->bdev));
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
 			print_rdev(rdev);
@@ -765,7 +765,6 @@ static int uuid_equal(mdk_rdev_t *rdev1,
 
 static int write_disk_sb(mdk_rdev_t * rdev)
 {
-	kdev_t dev = rdev->dev;
 	unsigned long sb_offset, size;
 
 	if (!rdev->sb) {
@@ -784,7 +783,7 @@ static int write_disk_sb(mdk_rdev_t * rd
 	sb_offset = calc_dev_sboffset(rdev->bdev);
 	if (rdev->sb_offset != sb_offset) {
 		printk(KERN_INFO "%s's sb offset has changed from %ld to %ld, skipping\n",
-		       partition_name(dev), rdev->sb_offset, sb_offset);
+		       bdev_partition_name(rdev->bdev), rdev->sb_offset, sb_offset);
 		goto skip;
 	}
 	/*
@@ -795,18 +794,18 @@ static int write_disk_sb(mdk_rdev_t * rd
 	size = calc_dev_size(rdev->bdev, rdev->mddev);
 	if (size != rdev->size) {
 		printk(KERN_INFO "%s's size has changed from %ld to %ld since import, skipping\n",
-		       partition_name(dev), rdev->size, size);
+		       bdev_partition_name(rdev->bdev), rdev->size, size);
 		goto skip;
 	}
 
-	printk(KERN_INFO "(write) %s's sb offset: %ld\n", partition_name(dev), sb_offset);
+	printk(KERN_INFO "(write) %s's sb offset: %ld\n", bdev_partition_name(rdev->bdev), sb_offset);
 
 	if (!sync_page_io(rdev->bdev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE))
 		goto fail;
 skip:
 	return 0;
 fail:
-	printk("md: write_disk_sb failed for device %s\n", partition_name(dev));
+	printk("md: write_disk_sb failed for device %s\n", bdev_partition_name(rdev->bdev));
 	return 1;
 }
 
@@ -958,7 +957,7 @@ repeat:
 		if (rdev->alias_device)
 			printk("(skipping alias ");
 
-		printk("%s ", partition_name(rdev->dev));
+		printk("%s ", bdev_partition_name(rdev->bdev));
 		if (!rdev->faulty && !rdev->alias_device) {
 			printk("[events: %08lx]",
 				(unsigned long)rdev->sb->events_lo);
@@ -1015,7 +1014,7 @@ static mdk_rdev_t *md_import_device(kdev
 	if (!size) {
 		printk(KERN_WARNING
 		       "md: %s has zero or unknown size, marking faulty!\n",
-		       partition_name(newdev));
+		       bdev_partition_name(rdev->bdev));
 		err = -EINVAL;
 		goto abort_free;
 	}
@@ -1023,12 +1022,12 @@ static mdk_rdev_t *md_import_device(kdev
 	if (on_disk) {
 		if ((err = read_disk_sb(rdev))) {
 			printk(KERN_WARNING "md: could not read %s's sb, not importing!\n",
-			       partition_name(newdev));
+			       bdev_partition_name(rdev->bdev));
 			goto abort_free;
 		}
 		if ((err = check_disk_sb(rdev))) {
 			printk(KERN_WARNING "md: %s has invalid sb, not importing!\n",
-			       partition_name(newdev));
+			       bdev_partition_name(rdev->bdev));
 			goto abort_free;
 		}
 	}
@@ -1102,7 +1101,7 @@ static int analyze_sbs(mddev_t * mddev)
 			continue;
 		}
 		if (!sb_equal(sb, rdev->sb)) {
-			printk(INCONSISTENT, partition_name(rdev->dev));
+			printk(INCONSISTENT, bdev_partition_name(rdev->bdev));
 			kick_rdev_from_array(rdev);
 			continue;
 		}
@@ -1129,7 +1128,7 @@ static int analyze_sbs(mddev_t * mddev)
 		}
 
 		printk(KERN_INFO "md: %s's event counter: %08lx\n",
-		       partition_name(rdev->dev),
+		       bdev_partition_name(rdev->bdev),
 			(unsigned long)rdev->sb->events_lo);
 		if (!freshest) {
 			freshest = rdev;
@@ -1148,7 +1147,7 @@ static int analyze_sbs(mddev_t * mddev)
 	}
 	if (out_of_date) {
 		printk(OUT_OF_DATE);
-		printk(KERN_INFO "md: freshest: %s\n", partition_name(freshest->dev));
+		printk(KERN_INFO "md: freshest: %s\n", bdev_partition_name(freshest->bdev));
 	}
 
 	sb = freshest->sb;
@@ -1187,7 +1186,7 @@ static int analyze_sbs(mddev_t * mddev)
 		++ev1;
 		if (ev1 < mddev->events) {
 			printk(KERN_WARNING "md: kicking non-fresh %s from array!\n",
-						partition_name(rdev->dev));
+						bdev_partition_name(rdev->bdev));
 			kick_rdev_from_array(rdev);
 			continue;
 		}
@@ -1270,7 +1269,7 @@ static int device_size_calculation(mddev
 		if (rdev->size < mddev->chunk_size / 1024) {
 			printk(KERN_WARNING
 				"md: Dev %s smaller than chunk_size: %ldk < %dk\n",
-				partition_name(rdev->dev),
+				bdev_partition_name(rdev->bdev),
 				rdev->size, mddev->chunk_size / 1024);
 			return -EINVAL;
 		}
@@ -1624,7 +1623,7 @@ static void autorun_array(mddev_t *mddev
 	printk(KERN_INFO "md: running: ");
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		printk("<%s>", partition_name(rdev->dev));
+		printk("<%s>", bdev_partition_name(rdev->bdev));
 	}
 	printk("\n");
 
@@ -1663,17 +1662,17 @@ static void autorun_devices(void)
 		rdev0 = list_entry(pending_raid_disks.next,
 					 mdk_rdev_t, same_set);
 
-		printk(KERN_INFO "md: considering %s ...\n", partition_name(rdev0->dev));
+		printk(KERN_INFO "md: considering %s ...\n", bdev_partition_name(rdev0->bdev));
 		INIT_LIST_HEAD(&candidates);
 		ITERATE_RDEV_PENDING(rdev,tmp) {
 			if (uuid_equal(rdev0, rdev)) {
 				if (!sb_equal(rdev0->sb, rdev->sb)) {
 					printk(KERN_WARNING
 					       "md: %s has same UUID as %s, but superblocks differ ...\n",
-					       partition_name(rdev->dev), partition_name(rdev0->dev));
+					       bdev_partition_name(rdev->bdev), bdev_partition_name(rdev0->bdev));
 					continue;
 				}
-				printk(KERN_INFO "md:  adding %s ...\n", partition_name(rdev->dev));
+				printk(KERN_INFO "md:  adding %s ...\n", bdev_partition_name(rdev->bdev));
 				list_move(&rdev->same_set, &candidates);
 			}
 		}
@@ -1693,7 +1692,7 @@ static void autorun_devices(void)
 			       mdidx(mddev));
 		else if (mddev->raid_disks || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING "md: md%d already running, cannot run %s\n",
-			       mdidx(mddev), partition_name(rdev0->dev));
+			       mdidx(mddev), bdev_partition_name(rdev0->bdev));
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
@@ -1760,7 +1759,7 @@ static int autostart_array(kdev_t startd
 
 	if (start_rdev->faulty) {
 		printk(KERN_WARNING "md: can not autostart based on faulty %s!\n",
-						partition_name(startdev));
+						bdev_partition_name(start_rdev->bdev));
 		goto abort;
 	}
 	list_add(&start_rdev->same_set, &pending_raid_disks);
@@ -1937,13 +1936,13 @@ static int add_new_disk(mddev_t * mddev,
 							mdk_rdev_t, same_set);
 			if (!uuid_equal(rdev0, rdev)) {
 				printk(KERN_WARNING "md: %s has different UUID to %s\n",
-				       partition_name(rdev->dev), partition_name(rdev0->dev));
+				       bdev_partition_name(rdev->bdev), bdev_partition_name(rdev0->bdev));
 				export_rdev(rdev);
 				return -EINVAL;
 			}
 			if (!sb_equal(rdev0->sb, rdev->sb)) {
 				printk(KERN_WARNING "md: %s has same UUID but different superblock to %s\n",
-				       partition_name(rdev->dev), partition_name(rdev0->dev));
+				       bdev_partition_name(rdev->bdev), bdev_partition_name(rdev0->bdev));
 				export_rdev(rdev);
 				return -EINVAL;
 			}
@@ -2056,7 +2055,7 @@ static int hot_remove_disk(mddev_t * mdd
 	return 0;
 busy:
 	printk(KERN_WARNING "md: cannot remove active disk %s from md%d ... \n",
-		partition_name(dev), mdidx(mddev));
+		bdev_partition_name(rdev->bdev), mdidx(mddev));
 	return -EBUSY;
 }
 
@@ -2095,7 +2094,7 @@ static int hot_add_disk(mddev_t * mddev,
 
 	if (rdev->faulty) {
 		printk(KERN_WARNING "md: can not hot-add faulty %s disk to md%d!\n",
-				partition_name(dev), mdidx(mddev));
+				bdev_partition_name(rdev->bdev), mdidx(mddev));
 		err = -EINVAL;
 		goto abort_export;
 	}
@@ -2668,7 +2667,7 @@ static int status_unused(char * page)
 	ITERATE_RDEV_PENDING(rdev,tmp) {
 		i++;
 		sz += sprintf(page + sz, "%s ",
-			      partition_name(rdev->dev));
+			      bdev_partition_name(rdev->bdev));
 	}
 	if (!i)
 		sz += sprintf(page + sz, "<none>");
@@ -2756,7 +2755,7 @@ static int md_status_read_proc(char *pag
 		size = 0;
 		ITERATE_RDEV(mddev,rdev,tmp2) {
 			sz += sprintf(page + sz, " %s[%d]",
-				partition_name(rdev->dev), rdev->desc_nr);
+				bdev_partition_name(rdev->bdev), rdev->desc_nr);
 			if (rdev->faulty) {
 				sz += sprintf(page + sz, "(F)");
 				continue;
@@ -3122,7 +3121,7 @@ void md_do_recovery(void *data)
 				       "-- continuing in degraded mode\n", mdidx(mddev));
 			else
 				printk(KERN_INFO "md%d: resyncing spare disk %s to replace failed disk\n",
-				       mdidx(mddev), partition_name(mddev->spare->dev));
+				       mdidx(mddev), bdev_partition_name(mddev->spare->bdev));
 		}
 		if (!mddev->spare && mddev->in_sync) {
 			/* nothing we can do ... */
--- ./drivers/md/raid1.c	2002/07/18 12:08:11	1.12
+++ ./drivers/md/raid1.c	2002/07/18 12:08:41	1.13
@@ -293,7 +293,7 @@ static void end_request(struct bio *bio)
 		 * oops, read error:
 		 */
 		printk(KERN_ERR "raid1: %s: rescheduling sector %lu\n",
-			bdev_partition_name(bio->bi_bdev), r1_bio->sector);
+			bdev_partition_name(conf->mirrors[mirror].bdev), r1_bio->sector);
 		reschedule_retry(r1_bio);
 		return;
 	}
--- ./drivers/md/raid0.c	2002/07/18 12:08:11	1.2
+++ ./drivers/md/raid0.c	2002/07/18 12:08:41	1.3
@@ -43,12 +43,12 @@ static int create_strip_zones (mddev_t *
 	conf->nr_strip_zones = 0;
  
 	ITERATE_RDEV(mddev,rdev1,tmp1) {
-		printk("raid0: looking at %s\n", partition_name(rdev1->dev));
+		printk("raid0: looking at %s\n", bdev_partition_name(rdev1->bdev));
 		c = 0;
 		ITERATE_RDEV(mddev,rdev2,tmp2) {
 			printk("raid0:   comparing %s(%ld) with %s(%ld)\n",
-			       partition_name(rdev1->dev), rdev1->size,
-			       partition_name(rdev2->dev), rdev2->size);
+			       bdev_partition_name(rdev1->bdev), rdev1->size,
+			       bdev_partition_name(rdev2->bdev), rdev2->size);
 			if (rdev2 == rdev1) {
 				printk("raid0:   END\n");
 				break;
@@ -127,7 +127,7 @@ static int create_strip_zones (mddev_t *
 
 		for (j=0; j<cnt; j++) {
 			rdev = conf->strip_zone[0].dev[j];
-			printk("raid0: checking %s ...", partition_name(rdev->dev));
+			printk("raid0: checking %s ...", bdev_partition_name(rdev->bdev));
 			if (rdev->size > current_offset)
 			{
 				printk(" contained as device %d\n", c);
@@ -351,8 +351,8 @@ static int raid0_status (char *page, mdd
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		sz += sprintf(page + sz, "      z%d=[", j);
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			sz += sprintf (page+sz, "%s/", partition_name(
-				conf->strip_zone[j].dev[k]->dev));
+			sz += sprintf (page+sz, "%s/", bdev_partition_name(
+				conf->strip_zone[j].dev[k]->bdev));
 		sz--;
 		sz += sprintf (page+sz, "] zo=%d do=%d s=%d\n",
 				conf->strip_zone[j].zone_offset,
