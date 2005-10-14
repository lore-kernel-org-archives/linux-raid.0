From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 006 of 8] Convert 'faulty' and 'in_sync' fields to bits in 'flags' field.
Date: Fri, 14 Oct 2005 12:26:22 +1000
Message-ID: <1051014022622.11832@suse.de>
References: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This has the advantage of removing the confusion caused by
'rdev_t' and 'mddev_t' both having 'in_sync' fields.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c       |    6 +-
 ./drivers/md/md.c           |   92 +++++++++++++++++++++-----------------------
 ./drivers/md/multipath.c    |   23 +++++------
 ./drivers/md/raid1.c        |   52 ++++++++++++------------
 ./drivers/md/raid10.c       |   41 ++++++++++---------
 ./drivers/md/raid5.c        |   36 ++++++++---------
 ./drivers/md/raid6main.c    |   32 +++++++--------
 ./include/linux/raid/md_k.h |    8 +--
 8 files changed, 146 insertions(+), 144 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-10-14 12:01:38.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-10-14 12:18:10.000000000 +1000
@@ -272,7 +272,8 @@ static struct page *read_sb_page(mddev_t
 		return ERR_PTR(-ENOMEM);
 
 	ITERATE_RDEV(mddev, rdev, tmp) {
-		if (! rdev->in_sync || rdev->faulty)
+		if (! test_bit(In_sync, &rdev->flags)
+		    || test_bit(Faulty, &rdev->flags))
 			continue;
 
 		target = (rdev->sb_offset << 1) + offset + index * (PAGE_SIZE/512);
@@ -292,7 +293,8 @@ static int write_sb_page(mddev_t *mddev,
 	struct list_head *tmp;
 
 	ITERATE_RDEV(mddev, rdev, tmp)
-		if (rdev->in_sync && !rdev->faulty)
+		if (test_bit(In_sync, &rdev->flags)
+		    && !test_bit(Faulty, &rdev->flags))
 			md_super_write(mddev, rdev,
 				       (rdev->sb_offset<<1) + offset
 				       + page->index * (PAGE_SIZE/512),

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-14 12:16:55.000000000 +1000
+++ ./drivers/md/md.c	2005-10-14 12:18:10.000000000 +1000
@@ -610,7 +610,7 @@ static int super_90_validate(mddev_t *md
 	mdp_super_t *sb = (mdp_super_t *)page_address(rdev->sb_page);
 
 	rdev->raid_disk = -1;
-	rdev->in_sync = 0;
+	rdev->flags = 0;
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 0;
 		mddev->minor_version = sb->minor_version;
@@ -671,21 +671,19 @@ static int super_90_validate(mddev_t *md
 		return 0;
 
 	if (mddev->level != LEVEL_MULTIPATH) {
-		rdev->faulty = 0;
-		rdev->flags = 0;
 		desc = sb->disks + rdev->desc_nr;
 
 		if (desc->state & (1<<MD_DISK_FAULTY))
-			rdev->faulty = 1;
+			set_bit(Faulty, &rdev->flags);
 		else if (desc->state & (1<<MD_DISK_SYNC) &&
 			 desc->raid_disk < mddev->raid_disks) {
-			rdev->in_sync = 1;
+			set_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = desc->raid_disk;
 		}
 		if (desc->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
 	} else /* MULTIPATH are always insync */
-		rdev->in_sync = 1;
+		set_bit(In_sync, &rdev->flags);
 	return 0;
 }
 
@@ -761,7 +759,8 @@ static void super_90_sync(mddev_t *mddev
 	ITERATE_RDEV(mddev,rdev2,tmp) {
 		mdp_disk_t *d;
 		int desc_nr;
-		if (rdev2->raid_disk >= 0 && rdev2->in_sync && !rdev2->faulty)
+		if (rdev2->raid_disk >= 0 && test_bit(In_sync, &rdev2->flags)
+		    && !test_bit(Faulty, &rdev2->flags))
 			desc_nr = rdev2->raid_disk;
 		else
 			desc_nr = next_spare++;
@@ -780,14 +779,15 @@ static void super_90_sync(mddev_t *mddev
 		d->number = rdev2->desc_nr;
 		d->major = MAJOR(rdev2->bdev->bd_dev);
 		d->minor = MINOR(rdev2->bdev->bd_dev);
-		if (rdev2->raid_disk >= 0 && rdev2->in_sync && !rdev2->faulty)
+		if (rdev2->raid_disk >= 0 && test_bit(In_sync, &rdev2->flags)
+		    && !test_bit(Faulty, &rdev2->flags))
 			d->raid_disk = rdev2->raid_disk;
 		else
 			d->raid_disk = rdev2->desc_nr; /* compatibility */
-		if (rdev2->faulty) {
+		if (test_bit(Faulty, &rdev2->flags)) {
 			d->state = (1<<MD_DISK_FAULTY);
 			failed++;
-		} else if (rdev2->in_sync) {
+		} else if (test_bit(In_sync, &rdev2->flags)) {
 			d->state = (1<<MD_DISK_ACTIVE);
 			d->state |= (1<<MD_DISK_SYNC);
 			active++;
@@ -975,7 +975,7 @@ static int super_1_validate(mddev_t *mdd
 	struct mdp_superblock_1 *sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
 
 	rdev->raid_disk = -1;
-	rdev->in_sync = 0;
+	rdev->flags = 0;
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 1;
 		mddev->patch_version = 0;
@@ -1027,22 +1027,19 @@ static int super_1_validate(mddev_t *mdd
 		role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
 		switch(role) {
 		case 0xffff: /* spare */
-			rdev->faulty = 0;
 			break;
 		case 0xfffe: /* faulty */
-			rdev->faulty = 1;
+			set_bit(Faulty, &rdev->flags);
 			break;
 		default:
-			rdev->in_sync = 1;
-			rdev->faulty = 0;
+			set_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = role;
 			break;
 		}
-		rdev->flags = 0;
 		if (sb->devflags & WriteMostly1)
 			set_bit(WriteMostly, &rdev->flags);
 	} else /* MULTIPATH are always insync */
-		rdev->in_sync = 1;
+		set_bit(In_sync, &rdev->flags);
 
 	return 0;
 }
@@ -1086,9 +1083,9 @@ static void super_1_sync(mddev_t *mddev,
 	
 	ITERATE_RDEV(mddev,rdev2,tmp) {
 		i = rdev2->desc_nr;
-		if (rdev2->faulty)
+		if (test_bit(Faulty, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
-		else if (rdev2->in_sync)
+		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else
 			sb->dev_roles[i] = cpu_to_le16(0xffff);
@@ -1327,7 +1324,8 @@ static void print_rdev(mdk_rdev_t *rdev)
 	char b[BDEVNAME_SIZE];
 	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%u\n",
 		bdevname(rdev->bdev,b), (unsigned long long)rdev->size,
-	       	rdev->faulty, rdev->in_sync, rdev->desc_nr);
+	        test_bit(Faulty, &rdev->flags), test_bit(In_sync, &rdev->flags),
+	        rdev->desc_nr);
 	if (rdev->sb_loaded) {
 		printk(KERN_INFO "md: rdev superblock:\n");
 		print_sb((mdp_super_t*)page_address(rdev->sb_page));
@@ -1421,11 +1419,11 @@ repeat:
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		char b[BDEVNAME_SIZE];
 		dprintk(KERN_INFO "md: ");
-		if (rdev->faulty)
+		if (test_bit(Faulty, &rdev->flags))
 			dprintk("(skipping faulty ");
 
 		dprintk("%s ", bdevname(rdev->bdev,b));
-		if (!rdev->faulty) {
+		if (!test_bit(Faulty, &rdev->flags)) {
 			md_super_write(mddev,rdev,
 				       rdev->sb_offset<<1, rdev->sb_size,
 				       rdev->sb_page);
@@ -1466,15 +1464,16 @@ rdev_show_state(mdk_rdev_t *rdev, char *
 	char *sep = "";
 	int len=0;
 
-	if (rdev->faulty) {
+	if (test_bit(Faulty, &rdev->flags)) {
 		len+= sprintf(page+len, "%sfaulty",sep);
 		sep = ",";
 	}
-	if (rdev->in_sync) {
+	if (test_bit(In_sync, &rdev->flags)) {
 		len += sprintf(page+len, "%sin_sync",sep);
 		sep = ",";
 	}
-	if (!rdev->faulty && !rdev->in_sync) {
+	if (!test_bit(Faulty, &rdev->flags) &&
+	    !test_bit(In_sync, &rdev->flags)) {
 		len += sprintf(page+len, "%sspare", sep);
 		sep = ",";
 	}
@@ -1578,8 +1577,7 @@ static mdk_rdev_t *md_import_device(dev_
 	kobject_init(&rdev->kobj);
 
 	rdev->desc_nr = -1;
-	rdev->faulty = 0;
-	rdev->in_sync = 0;
+	rdev->flags = 0;
 	rdev->data_offset = 0;
 	atomic_set(&rdev->nr_pending, 0);
 	atomic_set(&rdev->read_errors, 0);
@@ -1670,7 +1668,7 @@ static void analyze_sbs(mddev_t * mddev)
 		if (mddev->level == LEVEL_MULTIPATH) {
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
-			rdev->in_sync = 1;
+			set_bit(In_sync, &rdev->flags);
 		}
 	}
 
@@ -1939,7 +1937,7 @@ static int do_md_run(mddev_t * mddev)
 
 		/* devices must have minimum size of one chunk */
 		ITERATE_RDEV(mddev,rdev,tmp) {
-			if (rdev->faulty)
+			if (test_bit(Faulty, &rdev->flags))
 				continue;
 			if (rdev->size < chunk_size / 1024) {
 				printk(KERN_WARNING
@@ -1967,7 +1965,7 @@ static int do_md_run(mddev_t * mddev)
 	 * Also find largest hardsector size
 	 */
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->faulty)
+		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		sync_blockdev(rdev->bdev);
 		invalidate_bdev(rdev->bdev, 0);
@@ -2304,7 +2302,7 @@ static int autostart_array(dev_t startde
 		return err;
 	}
 
-	if (start_rdev->faulty) {
+	if (test_bit(Faulty, &start_rdev->flags)) {
 		printk(KERN_WARNING 
 			"md: can not autostart based on faulty %s!\n",
 			bdevname(start_rdev->bdev,b));
@@ -2363,11 +2361,11 @@ static int get_array_info(mddev_t * mdde
 	nr=working=active=failed=spare=0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		nr++;
-		if (rdev->faulty)
+		if (test_bit(Faulty, &rdev->flags))
 			failed++;
 		else {
 			working++;
-			if (rdev->in_sync)
+			if (test_bit(In_sync, &rdev->flags))
 				active++;	
 			else
 				spare++;
@@ -2458,9 +2456,9 @@ static int get_disk_info(mddev_t * mddev
 		info.minor = MINOR(rdev->bdev->bd_dev);
 		info.raid_disk = rdev->raid_disk;
 		info.state = 0;
-		if (rdev->faulty)
+		if (test_bit(Faulty, &rdev->flags))
 			info.state |= (1<<MD_DISK_FAULTY);
-		else if (rdev->in_sync) {
+		else if (test_bit(In_sync, &rdev->flags)) {
 			info.state |= (1<<MD_DISK_ACTIVE);
 			info.state |= (1<<MD_DISK_SYNC);
 		}
@@ -2553,7 +2551,7 @@ static int add_new_disk(mddev_t * mddev,
 				validate_super(mddev, rdev);
 		rdev->saved_raid_disk = rdev->raid_disk;
 
-		rdev->in_sync = 0; /* just to be sure */
+		clear_bit(In_sync, &rdev->flags); /* just to be sure */
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
 
@@ -2591,11 +2589,11 @@ static int add_new_disk(mddev_t * mddev,
 		else
 			rdev->raid_disk = -1;
 
-		rdev->faulty = 0;
+		rdev->flags = 0;
+
 		if (rdev->raid_disk < mddev->raid_disks)
-			rdev->in_sync = (info->state & (1<<MD_DISK_SYNC));
-		else
-			rdev->in_sync = 0;
+			if (info->state & (1<<MD_DISK_SYNC))
+				set_bit(In_sync, &rdev->flags);
 
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
@@ -2694,14 +2692,14 @@ static int hot_add_disk(mddev_t * mddev,
 		goto abort_export;
 	}
 
-	if (rdev->faulty) {
+	if (test_bit(Faulty, &rdev->flags)) {
 		printk(KERN_WARNING 
 			"md: can not hot-add faulty %s disk to %s!\n",
 			bdevname(rdev->bdev,b), mdname(mddev));
 		err = -EINVAL;
 		goto abort_export;
 	}
-	rdev->in_sync = 0;
+	clear_bit(In_sync, &rdev->flags);
 	rdev->desc_nr = -1;
 	bind_rdev_to_array(rdev, mddev);
 
@@ -3427,7 +3425,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 		return;
 	}
 
-	if (!rdev || rdev->faulty)
+	if (!rdev || test_bit(Faulty, &rdev->flags))
 		return;
 /*
 	dprintk("md_error dev:%s, rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
@@ -3625,7 +3623,7 @@ static int md_seq_show(struct seq_file *
 				bdevname(rdev->bdev,b), rdev->desc_nr);
 			if (test_bit(WriteMostly, &rdev->flags))
 				seq_printf(seq, "(W)");
-			if (rdev->faulty) {
+			if (test_bit(Faulty, &rdev->flags)) {
 				seq_printf(seq, "(F)");
 				continue;
 			} else if (rdev->raid_disk < 0)
@@ -4170,7 +4168,7 @@ void md_check_recovery(mddev_t *mddev)
 		 */
 		ITERATE_RDEV(mddev,rdev,rtmp)
 			if (rdev->raid_disk >= 0 &&
-			    (rdev->faulty || ! rdev->in_sync) &&
+			    (test_bit(Faulty, &rdev->flags) || ! test_bit(In_sync, &rdev->flags)) &&
 			    atomic_read(&rdev->nr_pending)==0) {
 				if (mddev->pers->hot_remove_disk(mddev, rdev->raid_disk)==0) {
 					char nm[20];
@@ -4183,7 +4181,7 @@ void md_check_recovery(mddev_t *mddev)
 		if (mddev->degraded) {
 			ITERATE_RDEV(mddev,rdev,rtmp)
 				if (rdev->raid_disk < 0
-				    && !rdev->faulty) {
+				    && !test_bit(Faulty, &rdev->flags)) {
 					if (mddev->pers->hot_add_disk(mddev,rdev)) {
 						char nm[20];
 						sprintf(nm, "rd%d", rdev->raid_disk);
@@ -4343,7 +4341,7 @@ static void autostart_arrays(int part)
 		if (IS_ERR(rdev))
 			continue;
 
-		if (rdev->faulty) {
+		if (test_bit(Faulty, &rdev->flags)) {
 			MD_BUG();
 			continue;
 		}

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2005-10-14 12:15:25.000000000 +1000
+++ ./drivers/md/multipath.c	2005-10-14 12:18:10.000000000 +1000
@@ -64,7 +64,7 @@ static int multipath_map (multipath_conf
 	rcu_read_lock();
 	for (i = 0; i < disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
-		if (rdev && rdev->in_sync) {
+		if (rdev && test_bit(In_sync, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
 			return i;
@@ -140,7 +140,8 @@ static void unplug_slaves(mddev_t *mddev
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
-		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !test_bit(Faulty, &rdev->flags)
+		    && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
@@ -215,7 +216,7 @@ static void multipath_status (struct seq
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf (seq, "%s",
 			       conf->multipaths[i].rdev && 
-			       conf->multipaths[i].rdev->in_sync ? "U" : "_");
+			       test_bit(In_sync, &conf->multipaths[i].rdev->flags) ? "U" : "_");
 	seq_printf (seq, "]");
 }
 
@@ -229,7 +230,7 @@ static int multipath_issue_flush(request
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
-		if (rdev && !rdev->faulty) {
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
 
@@ -269,10 +270,10 @@ static void multipath_error (mddev_t *md
 		/*
 		 * Mark disk as unusable
 		 */
-		if (!rdev->faulty) {
+		if (!test_bit(Faulty, &rdev->flags)) {
 			char b[BDEVNAME_SIZE];
-			rdev->in_sync = 0;
-			rdev->faulty = 1;
+			clear_bit(In_sync, &rdev->flags);
+			set_bit(Faulty, &rdev->flags);
 			mddev->sb_dirty = 1;
 			conf->working_disks--;
 			printk(KERN_ALERT "multipath: IO failure on %s,"
@@ -302,7 +303,7 @@ static void print_multipath_conf (multip
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
 			printk(" disk%d, o:%d, dev:%s\n",
-				i,!tmp->rdev->faulty,
+				i,!test_bit(Faulty, &tmp->rdev->flags),
 			       bdevname(tmp->rdev->bdev,b));
 	}
 }
@@ -334,7 +335,7 @@ static int multipath_add_disk(mddev_t *m
 
 			conf->working_disks++;
 			rdev->raid_disk = path;
-			rdev->in_sync = 1;
+			set_bit(In_sync, &rdev->flags);
 			rcu_assign_pointer(p->rdev, rdev);
 			found = 1;
 		}
@@ -354,7 +355,7 @@ static int multipath_remove_disk(mddev_t
 
 	rdev = p->rdev;
 	if (rdev) {
-		if (rdev->in_sync ||
+		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			printk(KERN_ERR "hot-remove-disk, slot %d is identified"				" but is still operational!\n", number);
 			err = -EBUSY;
@@ -486,7 +487,7 @@ static int multipath_run (mddev_t *mddev
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
-		if (!rdev->faulty) 
+		if (!test_bit(Faulty, &rdev->flags))
 			conf->working_disks++;
 	}
 

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-10-14 12:15:25.000000000 +1000
+++ ./drivers/md/raid1.c	2005-10-14 12:18:10.000000000 +1000
@@ -417,11 +417,11 @@ static int read_balance(conf_t *conf, r1
 		new_disk = 0;
 
 		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
-		     !rdev || !rdev->in_sync
+		     !rdev || !test_bit(In_sync, &rdev->flags)
 			     || test_bit(WriteMostly, &rdev->flags);
 		     rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
 
-			if (rdev && rdev->in_sync)
+			if (rdev && test_bit(In_sync, &rdev->flags))
 				wonly_disk = new_disk;
 
 			if (new_disk == conf->raid_disks - 1) {
@@ -435,11 +435,11 @@ static int read_balance(conf_t *conf, r1
 
 	/* make sure the disk is operational */
 	for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
-	     !rdev || !rdev->in_sync ||
+	     !rdev || !test_bit(In_sync, &rdev->flags) ||
 		     test_bit(WriteMostly, &rdev->flags);
 	     rdev = rcu_dereference(conf->mirrors[new_disk].rdev)) {
 
-		if (rdev && rdev->in_sync)
+		if (rdev && test_bit(In_sync, &rdev->flags))
 			wonly_disk = new_disk;
 
 		if (new_disk <= 0)
@@ -477,7 +477,7 @@ static int read_balance(conf_t *conf, r1
 		rdev = rcu_dereference(conf->mirrors[disk].rdev);
 
 		if (!rdev ||
-		    !rdev->in_sync ||
+		    !test_bit(In_sync, &rdev->flags) ||
 		    test_bit(WriteMostly, &rdev->flags))
 			continue;
 
@@ -500,7 +500,7 @@ static int read_balance(conf_t *conf, r1
 		if (!rdev)
 			goto retry;
 		atomic_inc(&rdev->nr_pending);
-		if (!rdev->in_sync) {
+		if (!test_bit(In_sync, &rdev->flags)) {
 			/* cannot risk returning a device that failed
 			 * before we inc'ed nr_pending
 			 */
@@ -523,7 +523,7 @@ static void unplug_slaves(mddev_t *mddev
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
@@ -557,7 +557,7 @@ static int raid1_issue_flush(request_que
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev && !rdev->faulty) {
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
 
@@ -733,9 +733,9 @@ static int make_request(request_queue_t 
 	rcu_read_lock();
 	for (i = 0;  i < disks; i++) {
 		if ((rdev=rcu_dereference(conf->mirrors[i].rdev)) != NULL &&
-		    !rdev->faulty) {
+		    !test_bit(Faulty, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
-			if (rdev->faulty) {
+			if (test_bit(Faulty, &rdev->flags)) {
 				atomic_dec(&rdev->nr_pending);
 				r1_bio->bios[i] = NULL;
 			} else
@@ -828,7 +828,7 @@ static void status(struct seq_file *seq,
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf(seq, "%s",
 			      conf->mirrors[i].rdev &&
-			      conf->mirrors[i].rdev->in_sync ? "U" : "_");
+			      test_bit(In_sync, &conf->mirrors[i].rdev->flags) ? "U" : "_");
 	seq_printf(seq, "]");
 }
 
@@ -844,14 +844,14 @@ static void error(mddev_t *mddev, mdk_rd
 	 * next level up know.
 	 * else mark the drive as failed
 	 */
-	if (rdev->in_sync
+	if (test_bit(In_sync, &rdev->flags)
 	    && conf->working_disks == 1)
 		/*
 		 * Don't fail the drive, act as though we were just a
 		 * normal single drive
 		 */
 		return;
-	if (rdev->in_sync) {
+	if (test_bit(In_sync, &rdev->flags)) {
 		mddev->degraded++;
 		conf->working_disks--;
 		/*
@@ -859,8 +859,8 @@ static void error(mddev_t *mddev, mdk_rd
 		 */
 		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 	}
-	rdev->in_sync = 0;
-	rdev->faulty = 1;
+	clear_bit(In_sync, &rdev->flags);
+	set_bit(Faulty, &rdev->flags);
 	mddev->sb_dirty = 1;
 	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device. \n"
 		"	Operation continuing on %d devices\n",
@@ -885,7 +885,7 @@ static void print_conf(conf_t *conf)
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
 			printk(" disk %d, wo:%d, o:%d, dev:%s\n",
-				i, !tmp->rdev->in_sync, !tmp->rdev->faulty,
+				i, !test_bit(In_sync, &tmp->rdev->flags), !test_bit(Faulty, &tmp->rdev->flags),
 				bdevname(tmp->rdev->bdev,b));
 	}
 }
@@ -917,11 +917,11 @@ static int raid1_spare_active(mddev_t *m
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->mirrors + i;
 		if (tmp->rdev 
-		    && !tmp->rdev->faulty
-		    && !tmp->rdev->in_sync) {
+		    && !test_bit(Faulty, &tmp->rdev->flags)
+		    && !test_bit(In_sync, &tmp->rdev->flags)) {
 			conf->working_disks++;
 			mddev->degraded--;
-			tmp->rdev->in_sync = 1;
+			set_bit(In_sync, &tmp->rdev->flags);
 		}
 	}
 
@@ -976,7 +976,7 @@ static int raid1_remove_disk(mddev_t *md
 	print_conf(conf);
 	rdev = p->rdev;
 	if (rdev) {
-		if (rdev->in_sync ||
+		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
@@ -1286,11 +1286,11 @@ static sector_t sync_request(mddev_t *md
 	/* make sure disk is operational */
 	wonly = disk;
 	while (conf->mirrors[disk].rdev == NULL ||
-	       !conf->mirrors[disk].rdev->in_sync ||
+	       !test_bit(In_sync, &conf->mirrors[disk].rdev->flags) ||
 	       test_bit(WriteMostly, &conf->mirrors[disk].rdev->flags)
 		) {
 		if (conf->mirrors[disk].rdev  &&
-		    conf->mirrors[disk].rdev->in_sync)
+		    test_bit(In_sync, &conf->mirrors[disk].rdev->flags))
 			wonly = disk;
 		if (disk <= 0)
 			disk = conf->raid_disks;
@@ -1337,10 +1337,10 @@ static sector_t sync_request(mddev_t *md
 			bio->bi_rw = READ;
 			bio->bi_end_io = end_sync_read;
 		} else if (conf->mirrors[i].rdev == NULL ||
-			   conf->mirrors[i].rdev->faulty) {
+			   test_bit(Faulty, &conf->mirrors[i].rdev->flags)) {
 			still_degraded = 1;
 			continue;
-		} else if (!conf->mirrors[i].rdev->in_sync ||
+		} else if (!test_bit(In_sync, &conf->mirrors[i].rdev->flags) ||
 			   sector_nr + RESYNC_SECTORS > mddev->recovery_cp) {
 			bio->bi_rw = WRITE;
 			bio->bi_end_io = end_sync_write;
@@ -1482,7 +1482,7 @@ static int run(mddev_t *mddev)
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->head_position = 0;
-		if (!rdev->faulty && rdev->in_sync)
+		if (!test_bit(Faulty, &rdev->flags) && test_bit(In_sync, &rdev->flags))
 			conf->working_disks++;
 	}
 	conf->raid_disks = mddev->raid_disks;
@@ -1522,7 +1522,7 @@ static int run(mddev_t *mddev)
 	 */
 	for (j = 0; j < conf->raid_disks &&
 		     (!conf->mirrors[j].rdev ||
-		      !conf->mirrors[j].rdev->in_sync) ; j++)
+		      !test_bit(In_sync, &conf->mirrors[j].rdev->flags)) ; j++)
 		/* nothing */;
 	conf->last_used = j;
 

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-10-14 12:15:25.000000000 +1000
+++ ./drivers/md/raid10.c	2005-10-14 12:18:10.000000000 +1000
@@ -512,7 +512,7 @@ static int read_balance(conf_t *conf, r1
 		disk = r10_bio->devs[slot].devnum;
 
 		while ((rdev = rcu_dereference(conf->mirrors[disk].rdev)) == NULL ||
-		       !rdev->in_sync) {
+		       !test_bit(In_sync, &rdev->flags)) {
 			slot++;
 			if (slot == conf->copies) {
 				slot = 0;
@@ -529,7 +529,7 @@ static int read_balance(conf_t *conf, r1
 	slot = 0;
 	disk = r10_bio->devs[slot].devnum;
 	while ((rdev=rcu_dereference(conf->mirrors[disk].rdev)) == NULL ||
-	       !rdev->in_sync) {
+	       !test_bit(In_sync, &rdev->flags)) {
 		slot ++;
 		if (slot == conf->copies) {
 			disk = -1;
@@ -549,7 +549,7 @@ static int read_balance(conf_t *conf, r1
 
 
 		if ((rdev=rcu_dereference(conf->mirrors[ndisk].rdev)) == NULL ||
-		    !rdev->in_sync)
+		    !test_bit(In_sync, &rdev->flags))
 			continue;
 
 		if (!atomic_read(&rdev->nr_pending)) {
@@ -585,7 +585,7 @@ static void unplug_slaves(mddev_t *mddev
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
@@ -616,7 +616,7 @@ static int raid10_issue_flush(request_qu
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev && !rdev->faulty) {
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
 
@@ -775,7 +775,7 @@ static int make_request(request_queue_t 
 		int d = r10_bio->devs[i].devnum;
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[d].rdev);
 		if (rdev &&
-		    !rdev->faulty) {
+		    !test_bit(Faulty, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
 			r10_bio->devs[i].bio = bio;
 		} else
@@ -830,7 +830,7 @@ static void status(struct seq_file *seq,
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf(seq, "%s",
 			      conf->mirrors[i].rdev &&
-			      conf->mirrors[i].rdev->in_sync ? "U" : "_");
+			      test_bit(In_sync, &conf->mirrors[i].rdev->flags) ? "U" : "_");
 	seq_printf(seq, "]");
 }
 
@@ -845,7 +845,7 @@ static void error(mddev_t *mddev, mdk_rd
 	 * next level up know.
 	 * else mark the drive as failed
 	 */
-	if (rdev->in_sync
+	if (test_bit(In_sync, &rdev->flags)
 	    && conf->working_disks == 1)
 		/*
 		 * Don't fail the drive, just return an IO error.
@@ -855,7 +855,7 @@ static void error(mddev_t *mddev, mdk_rd
 		 * really dead" tests...
 		 */
 		return;
-	if (rdev->in_sync) {
+	if (test_bit(In_sync, &rdev->flags)) {
 		mddev->degraded++;
 		conf->working_disks--;
 		/*
@@ -863,8 +863,8 @@ static void error(mddev_t *mddev, mdk_rd
 		 */
 		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 	}
-	rdev->in_sync = 0;
-	rdev->faulty = 1;
+	clear_bit(In_sync, &rdev->flags);
+	set_bit(Faulty, &rdev->flags);
 	mddev->sb_dirty = 1;
 	printk(KERN_ALERT "raid10: Disk failure on %s, disabling device. \n"
 		"	Operation continuing on %d devices\n",
@@ -889,7 +889,8 @@ static void print_conf(conf_t *conf)
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
 			printk(" disk %d, wo:%d, o:%d, dev:%s\n",
-				i, !tmp->rdev->in_sync, !tmp->rdev->faulty,
+				i, !test_bit(In_sync, &tmp->rdev->flags),
+			        !test_bit(Faulty, &tmp->rdev->flags),
 				bdevname(tmp->rdev->bdev,b));
 	}
 }
@@ -942,11 +943,11 @@ static int raid10_spare_active(mddev_t *
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->mirrors + i;
 		if (tmp->rdev
-		    && !tmp->rdev->faulty
-		    && !tmp->rdev->in_sync) {
+		    && !test_bit(Faulty, &tmp->rdev->flags)
+		    && !test_bit(In_sync, &tmp->rdev->flags)) {
 			conf->working_disks++;
 			mddev->degraded--;
-			tmp->rdev->in_sync = 1;
+			set_bit(In_sync, &tmp->rdev->flags);
 		}
 	}
 
@@ -1004,7 +1005,7 @@ static int raid10_remove_disk(mddev_t *m
 	print_conf(conf);
 	rdev = p->rdev;
 	if (rdev) {
-		if (rdev->in_sync ||
+		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
@@ -1420,7 +1421,7 @@ static sector_t sync_request(mddev_t *md
 
 		for (i=0 ; i<conf->raid_disks; i++)
 			if (conf->mirrors[i].rdev &&
-			    !conf->mirrors[i].rdev->in_sync) {
+			    !test_bit(In_sync, &conf->mirrors[i].rdev->flags)) {
 				/* want to reconstruct this device */
 				r10bio_t *rb2 = r10_bio;
 
@@ -1441,7 +1442,7 @@ static sector_t sync_request(mddev_t *md
 				for (j=0; j<conf->copies;j++) {
 					int d = r10_bio->devs[j].devnum;
 					if (conf->mirrors[d].rdev &&
-					    conf->mirrors[d].rdev->in_sync) {
+					    test_bit(In_sync, &conf->mirrors[d].rdev->flags)) {
 						/* This is where we read from */
 						bio = r10_bio->devs[0].bio;
 						bio->bi_next = biolist;
@@ -1517,7 +1518,7 @@ static sector_t sync_request(mddev_t *md
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
 			if (conf->mirrors[d].rdev == NULL ||
-			    conf->mirrors[d].rdev->faulty)
+			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
 			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 			atomic_inc(&r10_bio->remaining);
@@ -1703,7 +1704,7 @@ static int run(mddev_t *mddev)
 			mddev->queue->max_sectors = (PAGE_SIZE>>9);
 
 		disk->head_position = 0;
-		if (!rdev->faulty && rdev->in_sync)
+		if (!test_bit(Faulty, &rdev->flags) && test_bit(In_sync, &rdev->flags))
 			conf->working_disks++;
 	}
 	conf->raid_disks = mddev->raid_disks;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-10-14 12:16:55.000000000 +1000
+++ ./drivers/md/raid5.c	2005-10-14 12:18:10.000000000 +1000
@@ -525,19 +525,19 @@ static void error(mddev_t *mddev, mdk_rd
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	PRINTK("raid5: error called\n");
 
-	if (!rdev->faulty) {
+	if (!test_bit(Faulty, &rdev->flags)) {
 		mddev->sb_dirty = 1;
-		if (rdev->in_sync) {
+		if (test_bit(In_sync, &rdev->flags)) {
 			conf->working_disks--;
 			mddev->degraded++;
 			conf->failed_disks++;
-			rdev->in_sync = 0;
+			clear_bit(In_sync, &rdev->flags);
 			/*
 			 * if recovery was running, make sure it aborts.
 			 */
 			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 		}
-		rdev->faulty = 1;
+		set_bit(Faulty, &rdev->flags);
 		printk (KERN_ALERT
 			"raid5: Disk failure on %s, disabling device."
 			" Operation continuing on %d devices\n",
@@ -1003,12 +1003,12 @@ static void handle_stripe(struct stripe_
 		}
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
-		if (!rdev || !rdev->in_sync) {
+		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag wil just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
 			clear_bit(R5_ReWrite, &dev->flags);
 		}
-		if (!rdev || !rdev->in_sync
+		if (!rdev || !test_bit(In_sync, &rdev->flags)
 		    || test_bit(R5_ReadError, &dev->flags)) {
 			failed++;
 			failed_num = i;
@@ -1027,7 +1027,7 @@ static void handle_stripe(struct stripe_
 
 			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 				mdk_rdev_t *rdev = conf->disks[i].rdev;
-				if (rdev && rdev->in_sync)
+				if (rdev && test_bit(In_sync, &rdev->flags))
 					/* multiple read failures in one stripe */
 					md_error(conf->mddev, rdev);
 			}
@@ -1384,7 +1384,7 @@ static void handle_stripe(struct stripe_
  
 		rcu_read_lock();
 		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && rdev->faulty)
+		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = NULL;
 		if (rdev)
 			atomic_inc(&rdev->nr_pending);
@@ -1458,7 +1458,7 @@ static void unplug_slaves(mddev_t *mddev
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
@@ -1503,7 +1503,7 @@ static int raid5_issue_flush(request_que
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && !rdev->faulty) {
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
 
@@ -1854,7 +1854,7 @@ static int run(mddev_t *mddev)
 
 		disk->rdev = rdev;
 
-		if (rdev->in_sync) {
+		if (test_bit(In_sync, &rdev->flags)) {
 			char b[BDEVNAME_SIZE];
 			printk(KERN_INFO "raid5: device %s operational as raid"
 				" disk %d\n", bdevname(rdev->bdev,b),
@@ -2033,7 +2033,7 @@ static void status (struct seq_file *seq
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf (seq, "%s",
 			       conf->disks[i].rdev &&
-			       conf->disks[i].rdev->in_sync ? "U" : "_");
+			       test_bit(In_sync, &conf->disks[i].rdev->flags) ? "U" : "_");
 	seq_printf (seq, "]");
 #if RAID5_DEBUG
 #define D(x) \
@@ -2060,7 +2060,7 @@ static void print_raid5_conf (raid5_conf
 		tmp = conf->disks + i;
 		if (tmp->rdev)
 		printk(" disk %d, o:%d, dev:%s\n",
-			i, !tmp->rdev->faulty,
+			i, !test_bit(Faulty, &tmp->rdev->flags),
 			bdevname(tmp->rdev->bdev,b));
 	}
 }
@@ -2074,12 +2074,12 @@ static int raid5_spare_active(mddev_t *m
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
 		if (tmp->rdev
-		    && !tmp->rdev->faulty
-		    && !tmp->rdev->in_sync) {
+		    && !test_bit(Faulty, &tmp->rdev->flags)
+		    && !test_bit(In_sync, &tmp->rdev->flags)) {
 			mddev->degraded--;
 			conf->failed_disks--;
 			conf->working_disks++;
-			tmp->rdev->in_sync = 1;
+			set_bit(In_sync, &tmp->rdev->flags);
 		}
 	}
 	print_raid5_conf(conf);
@@ -2096,7 +2096,7 @@ static int raid5_remove_disk(mddev_t *md
 	print_raid5_conf(conf);
 	rdev = p->rdev;
 	if (rdev) {
-		if (rdev->in_sync ||
+		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
@@ -2131,7 +2131,7 @@ static int raid5_add_disk(mddev_t *mddev
 	 */
 	for (disk=0; disk < mddev->raid_disks; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
-			rdev->in_sync = 0;
+			clear_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = disk;
 			found = 1;
 			if (rdev->saved_raid_disk != disk)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-10-14 12:15:25.000000000 +1000
+++ ./drivers/md/raid6main.c	2005-10-14 12:18:10.000000000 +1000
@@ -507,19 +507,19 @@ static void error(mddev_t *mddev, mdk_rd
 	raid6_conf_t *conf = (raid6_conf_t *) mddev->private;
 	PRINTK("raid6: error called\n");
 
-	if (!rdev->faulty) {
+	if (!test_bit(Faulty, &rdev->flags)) {
 		mddev->sb_dirty = 1;
-		if (rdev->in_sync) {
+		if (test_bit(In_sync, &rdev->flags)) {
 			conf->working_disks--;
 			mddev->degraded++;
 			conf->failed_disks++;
-			rdev->in_sync = 0;
+			clear_bit(In_sync, &rdev->flags);
 			/*
 			 * if recovery was running, make sure it aborts.
 			 */
 			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 		}
-		rdev->faulty = 1;
+		set_bit(Faulty, &rdev->flags);
 		printk (KERN_ALERT
 			"raid6: Disk failure on %s, disabling device."
 			" Operation continuing on %d devices\n",
@@ -1071,7 +1071,7 @@ static void handle_stripe(struct stripe_
 		}
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
-		if (!rdev || !rdev->in_sync) {
+		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			if ( failed < 2 )
 				failed_num[failed] = i;
 			failed++;
@@ -1465,7 +1465,7 @@ static void handle_stripe(struct stripe_
 
 		rcu_read_lock();
 		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && rdev->faulty)
+		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = NULL;
 		if (rdev)
 			atomic_inc(&rdev->nr_pending);
@@ -1539,7 +1539,7 @@ static void unplug_slaves(mddev_t *mddev
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && !rdev->faulty && atomic_read(&rdev->nr_pending)) {
+		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
 			request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
 
 			atomic_inc(&rdev->nr_pending);
@@ -1584,7 +1584,7 @@ static int raid6_issue_flush(request_que
 	rcu_read_lock();
 	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && !rdev->faulty) {
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
 
@@ -1872,7 +1872,7 @@ static int run(mddev_t *mddev)
 
 		disk->rdev = rdev;
 
-		if (rdev->in_sync) {
+		if (test_bit(In_sync, &rdev->flags)) {
 			char b[BDEVNAME_SIZE];
 			printk(KERN_INFO "raid6: device %s operational as raid"
 			       " disk %d\n", bdevname(rdev->bdev,b),
@@ -2056,7 +2056,7 @@ static void status (struct seq_file *seq
 	for (i = 0; i < conf->raid_disks; i++)
  		seq_printf (seq, "%s",
 			    conf->disks[i].rdev &&
-			    conf->disks[i].rdev->in_sync ? "U" : "_");
+			    test_bit(In_sync, &conf->disks[i].rdev->flags) ? "U" : "_");
 	seq_printf (seq, "]");
 #if RAID6_DUMPSTATE
 	seq_printf (seq, "\n");
@@ -2082,7 +2082,7 @@ static void print_raid6_conf (raid6_conf
 		tmp = conf->disks + i;
 		if (tmp->rdev)
 		printk(" disk %d, o:%d, dev:%s\n",
-			i, !tmp->rdev->faulty,
+			i, !test_bit(Faulty, &tmp->rdev->flags),
 			bdevname(tmp->rdev->bdev,b));
 	}
 }
@@ -2096,12 +2096,12 @@ static int raid6_spare_active(mddev_t *m
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
 		if (tmp->rdev
-		    && !tmp->rdev->faulty
-		    && !tmp->rdev->in_sync) {
+		    && !test_bit(Faulty, &tmp->rdev->flags)
+		    && !test_bit(In_sync, &tmp->rdev->flags)) {
 			mddev->degraded--;
 			conf->failed_disks--;
 			conf->working_disks++;
-			tmp->rdev->in_sync = 1;
+			set_bit(In_sync, &tmp->rdev->flags);
 		}
 	}
 	print_raid6_conf(conf);
@@ -2118,7 +2118,7 @@ static int raid6_remove_disk(mddev_t *md
 	print_raid6_conf(conf);
 	rdev = p->rdev;
 	if (rdev) {
-		if (rdev->in_sync ||
+		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
@@ -2153,7 +2153,7 @@ static int raid6_add_disk(mddev_t *mddev
 	 */
 	for (disk=0; disk < mddev->raid_disks; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
-			rdev->in_sync = 0;
+			clear_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = disk;
 			found = 1;
 			if (rdev->saved_raid_disk != disk)

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-10-14 12:16:55.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-10-14 12:18:10.000000000 +1000
@@ -117,10 +117,10 @@ struct mdk_rdev_s
 	 * It can never have faulty==1, in_sync==1
 	 * This reduces the burden of testing multiple flags in many cases
 	 */
-	int faulty;			/* if faulty do not issue IO requests */
-	int in_sync;			/* device is a full member of the array */
 
-	unsigned long	flags;		/* Should include faulty and in_sync here. */
+	unsigned long	flags;
+#define	Faulty		1		/* device is known to have a fault */
+#define	In_sync		2		/* device is in_sync with rest of array */
 #define	WriteMostly	4		/* Avoid reading if at all possible */
 
 	int desc_nr;			/* descriptor index in the superblock */
@@ -247,7 +247,7 @@ struct mddev_s
 
 static inline void rdev_dec_pending(mdk_rdev_t *rdev, mddev_t *mddev)
 {
-	int faulty = rdev->faulty;
+	int faulty = test_bit(Faulty, &rdev->flags);
 	if (atomic_dec_and_test(&rdev->nr_pending) && faulty)
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 }
