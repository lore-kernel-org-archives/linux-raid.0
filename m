From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md - Factor out MD superblock handling code
Date: Thu, 31 Oct 2002 10:54:53 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15808.29005.326001.44555@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



###Comments for ChangeSet
Define an interface for interpreting and updating superblocks
so we can more easily define new formats.

With this patch, (almost) all superblock layout information is
locating in a small set of routines dedicated to superblock
handling.  This will allow us to provide a similar set for
a different format.

The two exceptions are:
 1/ autostart_array where the devices listed in the superblock
    are searched for.
 2/ raid5 'knows' the maximum number of devices for
     compute_parity.

These will be addressed in a later patch.
    



 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  708 +++++++++++++++++++++-----------------------
 ./drivers/md/multipath.c    |    6 
 ./include/linux/raid/md_k.h |    4 
 3 files changed, 351 insertions(+), 367 deletions(-)

--- ./drivers/md/md.c	2002/10/30 22:42:52	1.1
+++ ./drivers/md/md.c	2002/10/30 22:43:04	1.2
@@ -307,8 +307,6 @@ static int alloc_disk_sb(mdk_rdev_t * rd
 		printk(OUT_OF_MEM);
 		return -EINVAL;
 	}
-	rdev->sb = (mdp_super_t *) page_address(rdev->sb_page);
-	clear_page(rdev->sb);
 
 	return 0;
 }
@@ -317,7 +315,7 @@ static void free_disk_sb(mdk_rdev_t * rd
 {
 	if (rdev->sb_page) {
 		page_cache_release(rdev->sb_page);
-		rdev->sb = NULL;
+		rdev->sb_loaded = 0;
 		rdev->sb_page = NULL;
 		rdev->sb_offset = 0;
 		rdev->size = 0;
@@ -365,10 +363,12 @@ static int read_disk_sb(mdk_rdev_t * rde
 {
 	sector_t sb_offset;
 
-	if (!rdev->sb) {
+	if (!rdev->sb_page) {
 		MD_BUG();
 		return -EINVAL;
 	}
+	if (rdev->sb_loaded)
+		return 0;
 
 	/*
 	 * Calculate the position of the superblock,
@@ -382,7 +382,6 @@ static int read_disk_sb(mdk_rdev_t * rde
 	if (!sync_page_io(rdev->bdev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, READ))
 		goto fail;
-
-	printk(KERN_INFO " [events: %08lx]\n", (unsigned long)rdev->sb->events_lo);
+	rdev->sb_loaded = 1;
 	return 0;
 
 fail:
@@ -390,6 +389,56 @@ fail:
 	return -EINVAL;
 }
 
+static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+{
+	if (	(sb1->set_uuid0 == sb2->set_uuid0) &&
+		(sb1->set_uuid1 == sb2->set_uuid1) &&
+		(sb1->set_uuid2 == sb2->set_uuid2) &&
+		(sb1->set_uuid3 == sb2->set_uuid3))
+
+		return 1;
+
+	return 0;
+}
+
+
+static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+{
+	int ret;
+	mdp_super_t *tmp1, *tmp2;
+
+	tmp1 = kmalloc(sizeof(*tmp1),GFP_KERNEL);
+	tmp2 = kmalloc(sizeof(*tmp2),GFP_KERNEL);
+
+	if (!tmp1 || !tmp2) {
+		ret = 0;
+		printk(KERN_INFO "md.c: sb1 is not equal to sb2!\n");
+		goto abort;
+	}
+
+	*tmp1 = *sb1;
+	*tmp2 = *sb2;
+
+	/*
+	 * nr_disks is not constant
+	 */
+	tmp1->nr_disks = 0;
+	tmp2->nr_disks = 0;
+
+	if (memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * 4))
+		ret = 0;
+	else
+		ret = 1;
+
+abort:
+	if (tmp1)
+		kfree(tmp1);
+	if (tmp2)
+		kfree(tmp2);
+
+	return ret;
+}
+
 static unsigned int calc_sb_csum(mdp_super_t * sb)
 {
 	unsigned int disk_csum, csum;
@@ -402,39 +451,284 @@ static unsigned int calc_sb_csum(mdp_sup
 }
 
 /*
- * Check one RAID superblock for generic plausibility
+ * Handle superblock details.
+ * We want to be able to handle multiple superblock formats
+ * so we have a common interface to them all, and an array of
+ * different handlers.
+ * We rely on user-space to write the initial superblock, and support
+ * reading and updating of superblocks.
+ * Interface methods are:
+ *   int load_super(mdk_rdev_t *dev, mdk_rdev_t *refdev)
+ *      loads and validates a superblock on dev.
+ *      if refdev != NULL, compare superblocks on both devices
+ *    Return:
+ *      0 - dev has a superblock that is compatible with refdev
+ *      1 - dev has a superblock that is compatible and newer than refdev
+ *          so dev should be used as the refdev in future
+ *     -EINVAL superblock incompatible or invalid
+ *     -othererror e.g. -EIO
+ *
+ *   int validate_super(mddev_t *mddev, mdk_rdev_t *dev)
+ *      Verify that dev is acceptable into mddev.
+ *       The first time, mddev->raid_disks will be 0, and data from
+ *       dev should be merged in.  Subsequent calls check that dev
+ *       is new enough.  Return 0 or -EINVAL
+ *
+ *   void sync_super(mddev_t *mddev, mdk_rdev_t *dev)
+ *     Update the superblock for rdev with data in mddev
+ *     This does not write to disc.
+ *
  */
 
-static int check_disk_sb(mdk_rdev_t * rdev)
+struct super_type  {
+	char 		*name;
+	struct module	*owner;
+	int		(*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev);
+	int		(*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev);
+	void		(*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
+};
+
+/*
+ * load_super for 0.90.0 
+ */
+static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev)
 {
 	mdp_super_t *sb;
-	int ret = -EINVAL;
+	int ret;
 
-	sb = rdev->sb;
-	if (!sb) {
-		MD_BUG();
-		goto abort;
-	}
+	ret = read_disk_sb(rdev);
+	if (ret) return ret;
+
+	ret = -EINVAL;
+
+	sb = (mdp_super_t*)page_address(rdev->sb_page);
 
 	if (sb->md_magic != MD_SB_MAGIC) {
 		printk(BAD_MAGIC, bdev_partition_name(rdev->bdev));
 		goto abort;
 	}
 
+	if (sb->major_version != 0 ||
+	    sb->minor_version != 90) {
+		printk(KERN_WARNING "Bad version number %d.%d on %s\n",
+		       sb->major_version, sb->minor_version,
+		       bdev_partition_name(rdev->bdev));
+		goto abort;
+	}
+
 	if (sb->md_minor >= MAX_MD_DEVS) {
 		printk(BAD_MINOR, bdev_partition_name(rdev->bdev), sb->md_minor);
 		goto abort;
 	}
+	if (sb->raid_disks <= 0)
+		goto abort;
 
 	if (calc_sb_csum(sb) != sb->sb_csum) {
 		printk(BAD_CSUM, bdev_partition_name(rdev->bdev));
 		goto abort;
 	}
-	ret = 0;
-abort:
+
+	rdev->preferred_minor = sb->md_minor;
+
+	if (refdev == 0)
+		ret = 1;
+	else {
+		__u64 ev1, ev2;
+		mdp_super_t *refsb = (mdp_super_t*)page_address(refdev->sb_page);
+		if (!uuid_equal(refsb, sb)) {
+			printk(KERN_WARNING "md: %s has different UUID to %s\n",
+			       bdev_partition_name(rdev->bdev),
+			       bdev_partition_name(refdev->bdev));
+			goto abort;
+		}
+		if (!sb_equal(refsb, sb)) {
+			printk(KERN_WARNING "md: %s has same UUID but different superblock to %s\n",
+			       bdev_partition_name(rdev->bdev),
+			       bdev_partition_name(refdev->bdev));
+			goto abort;
+		}
+		ev1 = md_event(sb);
+		ev2 = md_event(refsb);
+		if (ev1 > ev2)
+			ret = 1;
+		else 
+			ret = 0;
+	}
+
+
+ abort:
 	return ret;
 }
 
+/*
+ * validate_super for 0.90.0
+ */
+static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	mdp_disk_t *desc;
+	mdp_super_t *sb = (mdp_super_t *)page_address(rdev->sb_page);
+
+	if (mddev->raid_disks == 0) {
+		mddev->major_version = sb->major_version;
+		mddev->minor_version = sb->minor_version;
+		mddev->patch_version = sb->patch_version;
+		mddev->persistent = ! sb->not_persistent;
+		mddev->chunk_size = sb->chunk_size;
+		mddev->ctime = sb->ctime;
+		mddev->utime = sb->utime;
+		mddev->level = sb->level;
+		mddev->layout = sb->layout;
+		mddev->raid_disks = sb->raid_disks;
+		mddev->state = sb->state;
+		mddev->size = sb->size;
+		mddev->events = md_event(sb);
+	
+		memcpy(mddev->uuid+0, &sb->set_uuid0, 4);
+		memcpy(mddev->uuid+4, &sb->set_uuid1, 4);
+		memcpy(mddev->uuid+8, &sb->set_uuid2, 4);
+		memcpy(mddev->uuid+12,&sb->set_uuid3, 4);
+
+		mddev->max_disks = MD_SB_DISKS;
+	} else {
+		__u64 ev1;
+		ev1 = md_event(sb);
+		++ev1;
+		if (ev1 < mddev->events) 
+			return -EINVAL;
+	}
+	if (mddev->level != LEVEL_MULTIPATH) {
+		rdev->desc_nr = sb->this_disk.number;
+		rdev->raid_disk = -1;
+		rdev->in_sync = rdev->faulty = 0;
+		desc = sb->disks + rdev->desc_nr;
+
+		if (desc->state & (1<<MD_DISK_FAULTY))
+			rdev->faulty = 1;
+		else if (desc->state & (1<<MD_DISK_SYNC) &&
+			 desc->raid_disk < mddev->raid_disks) {
+			rdev->in_sync = 1;
+			rdev->raid_disk = desc->raid_disk;
+		}
+	}
+	return 0;
+}
+
+/*
+ * sync_super for 0.90.0
+ */
+static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	mdp_super_t *sb;
+	struct list_head *tmp;
+	mdk_rdev_t *rdev2;
+	int next_spare = mddev->raid_disks;
+
+	/* make rdev->sb match mddev data..
+	 *
+	 * 1/ zero out disks
+	 * 2/ Add info for each disk, keeping track of highest desc_nr
+	 * 3/ any empty disks < highest become removed
+	 *
+	 * disks[0] gets initialised to REMOVED because
+	 * we cannot be sure from other fields if it has
+	 * been initialised or not.
+	 */
+	int highest = 0;
+	int i;
+	int active=0, working=0,failed=0,spare=0,nr_disks=0;
+
+	sb = (mdp_super_t*)page_address(rdev->sb_page);
+
+	memset(sb, 0, sizeof(*sb));
+
+	sb->md_magic = MD_SB_MAGIC;
+	sb->major_version = mddev->major_version;
+	sb->minor_version = mddev->minor_version;
+	sb->patch_version = mddev->patch_version;
+	sb->gvalid_words  = 0; /* ignored */
+	memcpy(&sb->set_uuid0, mddev->uuid+0, 4);
+	memcpy(&sb->set_uuid1, mddev->uuid+4, 4);
+	memcpy(&sb->set_uuid2, mddev->uuid+8, 4);
+	memcpy(&sb->set_uuid3, mddev->uuid+12,4);
+
+	sb->ctime = mddev->ctime;
+	sb->level = mddev->level;
+	sb->size  = mddev->size;
+	sb->raid_disks = mddev->raid_disks;
+	sb->md_minor = mddev->__minor;
+	sb->not_persistent = !mddev->persistent;
+	sb->utime = mddev->utime;
+	sb->state = mddev->state;
+	sb->events_hi = (mddev->events>>32);
+	sb->events_lo = (u32)mddev->events;
+
+	sb->layout = mddev->layout;
+	sb->chunk_size = mddev->chunk_size;
+
+	sb->disks[0].state = (1<<MD_DISK_REMOVED);
+	ITERATE_RDEV(mddev,rdev2,tmp) {
+		mdp_disk_t *d;
+		if (rdev2->raid_disk >= 0)
+			rdev2->desc_nr = rdev2->raid_disk;
+		else
+			rdev2->desc_nr = next_spare++;
+		d = &sb->disks[rdev2->desc_nr];
+		nr_disks++;
+		d->number = rdev2->desc_nr;
+		d->major = MAJOR(rdev2->bdev->bd_dev);
+		d->minor = MINOR(rdev2->bdev->bd_dev);
+		if (rdev2->raid_disk >= 0)
+			d->raid_disk = rdev2->raid_disk;
+		else
+			d->raid_disk = rdev2->desc_nr; /* compatability */
+		if (rdev2->faulty) {
+			d->state = (1<<MD_DISK_FAULTY);
+			failed++;
+		} else if (rdev2->in_sync) {
+			d->state = (1<<MD_DISK_ACTIVE);
+			d->state |= (1<<MD_DISK_SYNC);
+			active++;
+			working++;
+		} else {
+			d->state = 0;
+			spare++;
+			working++;
+		}
+		if (rdev2->desc_nr > highest)
+			highest = rdev2->desc_nr;
+	}
+	
+	/* now set the "removed" bit on any non-trailing holes */
+	for (i=0; i<highest; i++) {
+		mdp_disk_t *d = &sb->disks[i];
+		if (d->state == 0 && d->number == 0) {
+			d->number = i;
+			d->raid_disk = i;
+			d->state = (1<<MD_DISK_REMOVED);
+		}
+	}
+	sb->nr_disks = nr_disks;
+	sb->active_disks = active;
+	sb->working_disks = working;
+	sb->failed_disks = failed;
+	sb->spare_disks = spare;
+
+	sb->this_disk = sb->disks[rdev->desc_nr];
+	sb->sb_csum = calc_sb_csum(sb);
+}
+
+struct super_type super_types[] = {
+	[0] = {
+		.name	= "0.90.0",
+		.owner	= THIS_MODULE,
+		.load_super	= super_90_load,
+		.validate_super	= super_90_validate,
+		.sync_super	= super_90_sync,
+	},
+};
+
+
+	
 static mdk_rdev_t * match_dev_unit(mddev_t *mddev, mdk_rdev_t *dev)
 {
 	struct list_head *tmp;
@@ -618,9 +912,9 @@ static void print_rdev(mdk_rdev_t *rdev)
 	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%d ",
 		bdev_partition_name(rdev->bdev),
 		(unsigned long long)rdev->size, rdev->faulty, rdev->in_sync, rdev->desc_nr);
-	if (rdev->sb) {
+	if (rdev->sb_loaded) {
 		printk(KERN_INFO "md: rdev superblock:\n");
-		print_sb(rdev->sb);
+		print_sb((mdp_super_t*)page_address(rdev->sb_page));
 	} else
 		printk(KERN_INFO "md: no rdev superblock!\n");
 }
@@ -648,61 +942,13 @@ void md_print_devices(void)
 	printk("\n");
 }
 
-static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
-{
-	int ret;
-	mdp_super_t *tmp1, *tmp2;
-
-	tmp1 = kmalloc(sizeof(*tmp1),GFP_KERNEL);
-	tmp2 = kmalloc(sizeof(*tmp2),GFP_KERNEL);
-
-	if (!tmp1 || !tmp2) {
-		ret = 0;
-		printk(KERN_INFO "md.c: sb1 is not equal to sb2!\n");
-		goto abort;
-	}
-
-	*tmp1 = *sb1;
-	*tmp2 = *sb2;
-
-	/*
-	 * nr_disks is not constant
-	 */
-	tmp1->nr_disks = 0;
-	tmp2->nr_disks = 0;
-
-	if (memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * 4))
-		ret = 0;
-	else
-		ret = 1;
-
-abort:
-	if (tmp1)
-		kfree(tmp1);
-	if (tmp2)
-		kfree(tmp2);
-
-	return ret;
-}
-
-static int uuid_equal(mdk_rdev_t *rdev1, mdk_rdev_t *rdev2)
-{
-	if (	(rdev1->sb->set_uuid0 == rdev2->sb->set_uuid0) &&
-		(rdev1->sb->set_uuid1 == rdev2->sb->set_uuid1) &&
-		(rdev1->sb->set_uuid2 == rdev2->sb->set_uuid2) &&
-		(rdev1->sb->set_uuid3 == rdev2->sb->set_uuid3))
-
-		return 1;
-
-	return 0;
-}
 
 static int write_disk_sb(mdk_rdev_t * rdev)
 {
 	sector_t sb_offset;
 	sector_t size;
 
-	if (!rdev->sb) {
+	if (!rdev->sb_loaded) {
 		MD_BUG();
 		return 1;
 	}
@@ -710,10 +956,6 @@ static int write_disk_sb(mdk_rdev_t * rd
 		MD_BUG();
 		return 1;
 	}
-	if (rdev->sb->md_magic != MD_SB_MAGIC) {
-		MD_BUG();
-		return 1;
-	}
 
 	sb_offset = calc_dev_sboffset(rdev->bdev);
 	if (rdev->sb_offset != sb_offset) {
@@ -751,116 +993,10 @@ fail:
 static void sync_sbs(mddev_t * mddev)
 {
 	mdk_rdev_t *rdev;
-	mdp_super_t *sb;
 	struct list_head *tmp;
-	int next_spare = mddev->raid_disks;
 
-	/* make all rdev->sb match mddev data..
-	 * we setup the data in the first rdev and copy it
-	 * to the others.
-	 *
-	 * 1/ zero out disks
-	 * 2/ Add info for each disk, keeping track of highest desc_nr
-	 * 3/ any empty disks < highest become removed
-	 *
-	 * disks[0] gets initialised to REMOVED because
-	 * we cannot be sure from other fields if it has
-	 * been initialised or not.
-	 */
-	int highest = 0;
-	int i;
-	int active=0, working=0,failed=0,spare=0,nr_disks=0;
-
-	if (list_empty(&mddev->disks)) {
-		MD_BUG();
-		return;
-	}
-	rdev = list_entry(mddev->disks.next, mdk_rdev_t, same_set);
-	sb = rdev->sb;
-
-	memset(sb, 0, sizeof(*sb));
-
-	sb->md_magic = MD_SB_MAGIC;
-	sb->major_version = mddev->major_version;
-	sb->minor_version = mddev->minor_version;
-	sb->patch_version = mddev->patch_version;
-	sb->gvalid_words  = 0; /* ignored */
-	memcpy(&sb->set_uuid0, mddev->uuid+0, 4);
-	memcpy(&sb->set_uuid1, mddev->uuid+4, 4);
-	memcpy(&sb->set_uuid2, mddev->uuid+8, 4);
-	memcpy(&sb->set_uuid3, mddev->uuid+12,4);
-
-	sb->ctime = mddev->ctime;
-	sb->level = mddev->level;
-	sb->size  = mddev->size;
-	sb->raid_disks = mddev->raid_disks;
-	sb->md_minor = mddev->__minor;
-	sb->not_persistent = !mddev->persistent;
-	sb->utime = mddev->utime;
-	sb->state = mddev->state;
-	sb->events_hi = (mddev->events>>32);
-	sb->events_lo = (u32)mddev->events;
-
-	sb->layout = mddev->layout;
-	sb->chunk_size = mddev->chunk_size;
-
-	sb->disks[0].state = (1<<MD_DISK_REMOVED);
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		mdp_disk_t *d;
-		if (rdev->raid_disk >= 0)
-			rdev->desc_nr = rdev->raid_disk;
-		else
-			rdev->desc_nr = next_spare++;
-		d = &sb->disks[rdev->desc_nr];
-		nr_disks++;
-		d->number = rdev->desc_nr;
-		d->major = MAJOR(rdev->bdev->bd_dev);
-		d->minor = MINOR(rdev->bdev->bd_dev);
-		if (rdev->raid_disk >= 0)
-			d->raid_disk = rdev->raid_disk;
-		else
-			d->raid_disk = rdev->desc_nr; /* compatability */
-		if (rdev->faulty) {
-			d->state = (1<<MD_DISK_FAULTY);
-			failed++;
-		} else if (rdev->in_sync) {
-			d->state = (1<<MD_DISK_ACTIVE);
-			d->state |= (1<<MD_DISK_SYNC);
-			active++;
-			working++;
-		} else {
-			d->state = 0;
-			spare++;
-			working++;
-		}
-		if (rdev->desc_nr > highest)
-			highest = rdev->desc_nr;
-	}
-	
-	/* now set the "removed" bit on any non-trailing holes */
-	for (i=0; i<highest; i++) {
-		mdp_disk_t *d = &sb->disks[i];
-		if (d->state == 0 && d->number == 0) {
-			d->number = i;
-			d->raid_disk = i;
-			d->state = (1<<MD_DISK_REMOVED);
-		}
-	}
-	sb->nr_disks = nr_disks;
-	sb->active_disks = active;
-	sb->working_disks = working;
-	sb->failed_disks = failed;
-	sb->spare_disks = spare;
-
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		mdp_super_t *this_sb;
-		
-		this_sb = rdev->sb;
-		if (this_sb != sb)
-			*this_sb = *sb;
-		this_sb->this_disk = this_sb->disks[rdev->desc_nr];
-		this_sb->sb_csum = calc_sb_csum(this_sb);
-	}
+	ITERATE_RDEV(mddev,rdev,tmp)
+		super_90_sync(mddev, rdev);
 }
 
 static void md_update_sb(mddev_t * mddev)
@@ -903,8 +1039,6 @@ repeat:
 
 		printk("%s ", bdev_partition_name(rdev->bdev));
 		if (!rdev->faulty) {
-			printk("[events: %08lx]",
-				(unsigned long)rdev->sb->events_lo);
 			err += write_disk_sb(rdev);
 		} else
 			printk(")\n");
@@ -968,13 +1102,14 @@ static mdk_rdev_t *md_import_device(dev_
 	}
 
 	if (on_disk) {
-		if ((err = read_disk_sb(rdev))) {
-			printk(KERN_WARNING "md: could not read %s's sb, not importing!\n",
+		err = super_90_load(rdev, NULL);
+		if (err == -EINVAL) {
+			printk(KERN_WARNING "md: %s has invalid sb, not importing!\n",
 			       bdev_partition_name(rdev->bdev));
 			goto abort_free;
 		}
-		if ((err = check_disk_sb(rdev))) {
-			printk(KERN_WARNING "md: %s has invalid sb, not importing!\n",
+		if (err < 0) {
+			printk(KERN_WARNING "md: could not read %s's sb, not importing!\n",
 			       bdev_partition_name(rdev->bdev));
 			goto abort_free;
 		}
@@ -984,7 +1119,7 @@ static mdk_rdev_t *md_import_device(dev_
 	return rdev;
 
 abort_free:
-	if (rdev->sb) {
+	if (rdev->sb_page) {
 		if (rdev->bdev)
 			unlock_rdev(rdev);
 		free_disk_sb(rdev);
@@ -1014,155 +1149,39 @@ abort_free:
 
 static int analyze_sbs(mddev_t * mddev)
 {
-	int out_of_date = 0, i;
+	int i;
 	struct list_head *tmp;
 	mdk_rdev_t *rdev, *freshest;
-	mdp_super_t *sb;
-
-	/*
-	 * Verify the RAID superblock on each real device
-	 */
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->faulty) {
-			MD_BUG();
-			goto abort;
-		}
-		if (!rdev->sb) {
-			MD_BUG();
-			goto abort;
-		}
-		if (check_disk_sb(rdev))
-			goto abort;
-	}
-
-	/*
-	 * The superblock constant part has to be the same
-	 * for all disks in the array.
-	 */
-	sb = NULL;
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (!sb) {
-			sb = rdev->sb;
-			continue;
-		}
-		if (!sb_equal(sb, rdev->sb)) {
+	freshest = NULL;
+	ITERATE_RDEV(mddev,rdev,tmp)
+		switch (super_90_load(rdev, freshest)) {
+		case 1:
+			freshest = rdev;
+			break;
+		case 0:
+			break;
+		default:
 			printk(INCONSISTENT, bdev_partition_name(rdev->bdev));
 			kick_rdev_from_array(rdev);
-			continue;
-		}
-	}
-
-	/*
-	 * OK, we have all disks and the array is ready to run. Let's
-	 * find the freshest superblock, that one will be the superblock
-	 * that represents the whole array.
-	 */
-	freshest = NULL;
-
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		__u64 ev1, ev2;
-		/*
-		 * if the checksum is invalid, use the superblock
-		 * only as a last resort. (decrease it's age by
-		 * one event)
-		 */
-		if (calc_sb_csum(rdev->sb) != rdev->sb->sb_csum) {
-			if (rdev->sb->events_lo || rdev->sb->events_hi)
-				if (!(rdev->sb->events_lo--))
-					rdev->sb->events_hi--;
 		}
 
-		printk(KERN_INFO "md: %s's event counter: %08lx\n",
-		       bdev_partition_name(rdev->bdev),
-			(unsigned long)rdev->sb->events_lo);
-		if (!freshest) {
-			freshest = rdev;
-			continue;
-		}
-		/*
-		 * Find the newest superblock version
-		 */
-		ev1 = md_event(rdev->sb);
-		ev2 = md_event(freshest->sb);
-		if (ev1 != ev2) {
-			out_of_date = 1;
-			if (ev1 > ev2)
-				freshest = rdev;
-		}
-	}
-	if (out_of_date) {
-		printk(OUT_OF_DATE);
-		printk(KERN_INFO "md: freshest: %s\n", bdev_partition_name(freshest->bdev));
-	}
-
-	sb = freshest->sb;
-
-	mddev->major_version = sb->major_version;
-	mddev->minor_version = sb->minor_version;
-	mddev->patch_version = sb->patch_version;
-	mddev->persistent = ! sb->not_persistent;
-	mddev->chunk_size = sb->chunk_size;
-	mddev->ctime = sb->ctime;
-	mddev->utime = sb->utime;
-	mddev->level = sb->level;
-	mddev->layout = sb->layout;
-	mddev->raid_disks = sb->raid_disks;
-	mddev->state = sb->state;
-	mddev->size = sb->size;
-	mddev->events = md_event(sb);
-	
-	memcpy(mddev->uuid+0, &sb->set_uuid0, 4);
-	memcpy(mddev->uuid+4, &sb->set_uuid1, 4);
-	memcpy(mddev->uuid+8, &sb->set_uuid2, 4);
-	memcpy(mddev->uuid+12,&sb->set_uuid3, 4);
 
-	/*
-	 * at this point we have picked the 'best' superblock
-	 * from all available superblocks.
-	 * now we validate this superblock and kick out possibly
-	 * failed disks.
-	 */
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		/*
-		 * Kick all non-fresh devices
-		 */
-		__u64 ev1;
-		ev1 = md_event(rdev->sb);
-		++ev1;
-		if (ev1 < mddev->events) {
-			printk(KERN_WARNING "md: kicking non-fresh %s from array!\n",
-						bdev_partition_name(rdev->bdev));
-			kick_rdev_from_array(rdev);
-			continue;
-		}
-	}
+	super_90_validate(mddev, freshest);
 
-	/* set rdev->desc_nr for each device.
-	 * for MULTIPATH, we just us sequential number as
-	 * nothing else is meaningful
-	 */
 	i = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
+		if (rdev != freshest)
+			if (super_90_validate(mddev, rdev)) {
+				printk(KERN_WARNING "md: kicking non-fresh %s from array!\n",
+				       bdev_partition_name(rdev->bdev));
+				kick_rdev_from_array(rdev);
+				continue;
+			}
 		if (mddev->level == LEVEL_MULTIPATH) {
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
 			rdev->in_sync = 1;
-		} else {
-			mdp_disk_t *desc;
-			rdev->desc_nr = rdev->sb->this_disk.number;
-			desc = sb->disks + rdev->desc_nr;
-			rdev->raid_disk = -1;
-			rdev->in_sync = rdev->faulty = 0;
-
-			if (desc->state & (1<<MD_DISK_FAULTY)) {
-				rdev->faulty = 1;
-				kick_rdev_from_array(rdev);
-			} else if (desc->state & (1<<MD_DISK_SYNC) &&
-				   desc->raid_disk < mddev->raid_disks) {
-				rdev->in_sync = 1;
-				rdev->raid_disk = desc->raid_disk;
-			}
 		}
 	}
 
@@ -1579,20 +1598,6 @@ out:
 	return err;
 }
 
-/*
- * We have to safely support old arrays too.
- */
-int detect_old_array(mdp_super_t *sb)
-{
-	if (sb->major_version > 0)
-		return 0;
-	if (sb->minor_version >= 90)
-		return 0;
-
-	return -EINVAL;
-}
-
-
 static void autorun_array(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
@@ -1648,25 +1653,18 @@ static void autorun_devices(void)
 
 		printk(KERN_INFO "md: considering %s ...\n", bdev_partition_name(rdev0->bdev));
 		INIT_LIST_HEAD(&candidates);
-		ITERATE_RDEV_PENDING(rdev,tmp) {
-			if (uuid_equal(rdev0, rdev)) {
-				if (!sb_equal(rdev0->sb, rdev->sb)) {
-					printk(KERN_WARNING
-					       "md: %s has same UUID as %s, but superblocks differ ...\n",
-					       bdev_partition_name(rdev->bdev), bdev_partition_name(rdev0->bdev));
-					continue;
-				}
+		ITERATE_RDEV_PENDING(rdev,tmp)
+			if (super_90_load(rdev, rdev0) >= 0) {
 				printk(KERN_INFO "md:  adding %s ...\n", bdev_partition_name(rdev->bdev));
 				list_move(&rdev->same_set, &candidates);
 			}
-		}
 		/*
 		 * now we have a set of devices, with all of them having
 		 * mostly sane superblocks. It's time to allocate the
 		 * mddev.
 		 */
 
-		mddev = mddev_find(rdev0->sb->md_minor);
+		mddev = mddev_find(rdev0->preferred_minor);
 		if (!mddev) {
 			printk(KERN_ERR "md: cannot allocate memory for md drive.\n");
 			break;
@@ -1748,15 +1746,6 @@ static int autostart_array(dev_t startde
 	}
 	list_add(&start_rdev->same_set, &pending_raid_disks);
 
-	sb = start_rdev->sb;
-
-	err = detect_old_array(sb);
-	if (err) {
-		printk(KERN_WARNING "md: array version is too old to be autostarted ,"
-		       "use raidtools 0.90 mkraid --upgrade to upgrade the array "
-		       "without data loss!\n");
-		goto abort;
-	}
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		mdp_disk_t *desc;
@@ -1875,8 +1864,6 @@ static int get_disk_info(mddev_t * mddev
 		return -EFAULT;
 
 	nr = info.number;
-	if (nr >= MD_SB_DISKS)
-		return -EINVAL;
 
 	rdev = find_rdev_nr(mddev, nr);
 	if (rdev) {
@@ -1918,18 +1905,13 @@ static int add_new_disk(mddev_t * mddev,
 		if (!list_empty(&mddev->disks)) {
 			mdk_rdev_t *rdev0 = list_entry(mddev->disks.next,
 							mdk_rdev_t, same_set);
-			if (!uuid_equal(rdev0, rdev)) {
+			int err = super_90_load(rdev, NULL);
+			if (err < 0) {
 				printk(KERN_WARNING "md: %s has different UUID to %s\n",
 				       bdev_partition_name(rdev->bdev), bdev_partition_name(rdev0->bdev));
 				export_rdev(rdev);
 				return -EINVAL;
 			}
-			if (!sb_equal(rdev0->sb, rdev->sb)) {
-				printk(KERN_WARNING "md: %s has same UUID but different superblock to %s\n",
-				       bdev_partition_name(rdev->bdev), bdev_partition_name(rdev0->bdev));
-				export_rdev(rdev);
-				return -EINVAL;
-			}
 		}
 		bind_rdev_to_array(rdev, mddev);
 		return 0;
@@ -2080,11 +2062,11 @@ static int hot_add_disk(mddev_t * mddev,
 	rdev->size = size;
 	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
 
-	for (i = mddev->raid_disks; i < MD_SB_DISKS; i++)
+	for (i = mddev->raid_disks; i < mddev->max_disks; i++)
 		if (find_rdev_nr(mddev,i)==NULL)
 			break;
 
-	if (i == MD_SB_DISKS) {
+	if (i == mddev->max_disks) {
 		printk(KERN_WARNING "md%d: can not hot-add to full array!\n",
 		       mdidx(mddev));
 		err = -EBUSY;
--- ./drivers/md/multipath.c	2002/10/30 22:42:52	1.1
+++ ./drivers/md/multipath.c	2002/10/30 22:43:04	1.2
@@ -59,7 +59,7 @@ static void mp_pool_free(void *mpb, void
 static int multipath_map (mddev_t *mddev, mdk_rdev_t **rdevp)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
-	int i, disks = MD_SB_DISKS;
+	int i, disks = mddev->max_disks;
 
 	/*
 	 * Later we do read balancing on the read side 
@@ -147,7 +147,7 @@ static int multipath_read_balance (multi
 {
 	int disk;
 
-	for (disk = 0; disk < MD_SB_DISKS; disk++) {
+	for (disk = 0; disk < conf->mddev->max_disks; disk++) {
 		mdk_rdev_t *rdev = conf->multipaths[disk].rdev;
 		if (rdev && rdev->in_sync)
 			return disk;
@@ -259,7 +259,7 @@ static void print_multipath_conf (multip
 	printk(" --- wd:%d rd:%d\n", conf->working_disks,
 			 conf->raid_disks);
 
-	for (i = 0; i < MD_SB_DISKS; i++) {
+	for (i = 0; i < conf->mddev->max_disks; i++) {
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
 			printk(" disk%d, o:%d, dev:%s\n",
--- ./include/linux/raid/md_k.h	2002/10/30 22:42:53	1.1
+++ ./include/linux/raid/md_k.h	2002/10/30 22:43:05	1.2
@@ -151,8 +151,9 @@ struct mdk_rdev_s
 	struct block_device *bdev;	/* block device handle */
 
 	struct page	*sb_page;
-	mdp_super_t	*sb;
+	int		sb_loaded;
 	sector_t	sb_offset;
+	int		preferred_minor;	/* autorun support */
 
 	/* A device can be in one of three states based on two flags:
 	 * Not working:   faulty==1 in_sync==0
@@ -196,6 +197,7 @@ struct mddev_s
 	time_t				ctime, utime;
 	int				level, layout;
 	int				raid_disks;
+	int				max_disks;
 	unsigned long			state;
 	sector_t			size; /* used size of component devices */
 	__u64				events;
