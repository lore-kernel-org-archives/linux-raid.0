From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 11 of 12 - Allow md to select between superblock formats
Date: Wed, 12 Mar 2003 14:59:38 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxP0-0004qQ-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

The code to understand a specific superblock format is
already highly localised in md.  This patch defines a
user-space interface for selecting which superblock format
to use, and obeys that selection.

Md currently has a concept of 3 version numbers:
 A major version number
 A minor version number
 A patch version number

There historically seems to be some confusion about whether
these refer to a version of the superblock layout,
or a version of the software.

We will now define that:
   the "major_version" defines the superblock handler.
      '0' is the current superblock format.  All new formats
          will need new numbers.
   the "minor_version" can specify minor variations in the
      superblock, such as different location on the device
   the "patch_version" will be used to indicate new extenstions
      to the software.. patch_version=1 will mean multiple superblock
      support.

A superblock version number is selected by specifing major_version
in SET_ARRAY_INFO ioctl.

This patch:
  Updates Documentation/md.txt with details of new interface.
  Generalises desc_nr handling and makes sure that an array never
  has two devices with the same desc_nr.
  makes sure mddev->major_version is always valid and is 0 by default.
  uses mddev->major_version to select superblock handlers.
  Modifies set_array_info to just record version number if raid_disks==0
  Makes sure max_disks is always set correctly.
  Determines device size when reading superblock, or a hot-add/add-new.

 ----------- Diffstat output ------------
 ./Documentation/md.txt |   68 ++++++++++-
 ./drivers/md/md.c      |  287 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 243 insertions(+), 112 deletions(-)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2003-03-12 13:46:27.000000000 +1100
+++ ./Documentation/md.txt	2003-03-12 13:46:37.000000000 +1100
@@ -1,10 +1,10 @@
 Tools that manage md devices can be found at
-   http://www.<country>.kernel.org/pub/linux/daemons/raid/....
+   http://www.<country>.kernel.org/pub/linux/utils/raid/....
 
 
 
-You can boot (if you selected boot support in the configuration) with your md 
-device with the following kernel command lines:
+You can boot with your md device with the following kernel command
+lines:
 
 for old raid arrays without persistent superblocks:
   md=<md device no.>,<raid level>,<chunk size factor>,<fault level>,dev0,dev1,...,devn
@@ -33,4 +33,64 @@ dev0-devn: e.g. /dev/hda1,/dev/hdc1,/dev
 A possible loadlin line (Harald Hoyer <HarryH@Royal.Net>)  looks like this:
 
 e:\loadlin\loadlin e:\zimage root=/dev/md0 md=0,0,4,0,/dev/hdb2,/dev/hdc3 ro
-			    
+
+-------------------------------
+The md driver can support a variety of different superblock formats.
+(It doesn't yet, but it can)
+
+The kernel does *NOT* autodetect which format superblock is being
+used. It must be told.
+
+Superblock format '0' is treated differently to others for legacy
+reasons.
+
+
+General Rules - apply for all superblock formats
+------------------------------------------------
+
+An array is 'created' by writing appropriate superblocks to all
+devices.
+It is 'assembled' by associating each of these devices with an
+particular md virtual device.  Once it is completely assembled, it can
+be accessed.
+
+An array should be created by a user-space tool.  This will write
+superblocks to all devices.  It will usually mark the array as
+'unclean', or with some devices missing so that the kernel md driver
+can create approrpriate redundancy (copying in raid1, parity
+calculation in raid4/5).
+
+When an array is assembled, it is first initialised with the
+SET_ARRAY_INFO ioctl.  This contains, in particular, a major and minor
+version number.  The major version number selects which superblock
+format is to be used.  The minor number might be used to tune handling
+of the format, such as suggesting where on each device to look for the
+superblock.
+
+Then each device is added using the ADD_NEW_DISK ioctl.  This
+provides, in particular, a major and minor number identifying the
+device to add.
+
+The array is started with the RUN_ARRAY ioctl.
+
+Once started, new devices can be added.  They should have an
+appropriate superblock written to them, and then passed be in with
+ADD_NEW_DISK.
+
+Devices that have failed or are not yet active can be detached from an
+array using HOT_REMOVE_DISK.
+
+
+Specific Rules that apply to format-0 super block arrays, and
+       arrays with no superblock (non-presistant).
+-------------------------------------------------------------
+
+An array can be 'created' by describing the array (level, chunksize
+etc) in a SET_ARRAY_INFO ioctl.  This must has major_version==0 and
+raid_disks != 0.
+Then uninitialised devices can be added with ADD_NEW_DISK.  The
+structure passed to ADD_NEW_DISK must specify the state of the device
+and it's role in the array.
+
+One started with RUN_ARRAY, uninitialised spares can be added with
+HOT_ADD_DISK.

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 13:46:36.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 13:46:37.000000000 +1100
@@ -270,40 +270,35 @@ static mdk_rdev_t * find_rdev(mddev_t * 
 	return NULL;
 }
 
-static sector_t calc_dev_sboffset(struct block_device *bdev)
+inline static sector_t calc_dev_sboffset(struct block_device *bdev)
 {
 	sector_t size = bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 	return MD_NEW_SIZE_BLOCKS(size);
 }
 
-static sector_t calc_dev_size(struct block_device *bdev, mddev_t *mddev)
+static sector_t calc_dev_size(mdk_rdev_t *rdev, unsigned chunk_size)
 {
 	sector_t size;
 
-	if (mddev->persistent)
-		size = calc_dev_sboffset(bdev);
-	else
-		size = bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
-	if (mddev->chunk_size)
-		size &= ~((sector_t)mddev->chunk_size/1024 - 1);
+	size = rdev->sb_offset;
+
+	if (chunk_size)
+		size &= ~((sector_t)chunk_size/1024 - 1);
 	return size;
 }
 
 static sector_t zoned_raid_size(mddev_t *mddev)
 {
-	sector_t mask;
 	mdk_rdev_t * rdev;
 	struct list_head *tmp;
 
 	/*
 	 * do size and offset calculations.
 	 */
-	mask = ~((sector_t)mddev->chunk_size/1024 - 1);
 
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		rdev->size &= mask;
+	ITERATE_RDEV(mddev,rdev,tmp)
 		md_size[mdidx(mddev)] += rdev->size;
-	}
+
 	return 0;
 }
 
@@ -387,7 +382,6 @@ static int sync_page_io(struct block_dev
 
 static int read_disk_sb(mdk_rdev_t * rdev)
 {
-	sector_t sb_offset;
 
 	if (!rdev->sb_page) {
 		MD_BUG();
@@ -396,16 +390,8 @@ static int read_disk_sb(mdk_rdev_t * rde
 	if (rdev->sb_loaded)
 		return 0;
 
-	/*
-	 * Calculate the position of the superblock,
-	 * it's at the end of the disk.
-	 *
-	 * It also happens to be a multiple of 4Kb.
-	 */
-	sb_offset = calc_dev_sboffset(rdev->bdev);
-	rdev->sb_offset = sb_offset;
 
-	if (!sync_page_io(rdev->bdev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, READ))
+	if (!sync_page_io(rdev->bdev, rdev->sb_offset<<1, MD_SB_BYTES, rdev->sb_page, READ))
 		goto fail;
 	rdev->sb_loaded = 1;
 	return 0;
@@ -484,7 +470,7 @@ static unsigned int calc_sb_csum(mdp_sup
  * We rely on user-space to write the initial superblock, and support
  * reading and updating of superblocks.
  * Interface methods are:
- *   int load_super(mdk_rdev_t *dev, mdk_rdev_t *refdev)
+ *   int load_super(mdk_rdev_t *dev, mdk_rdev_t *refdev, int minor_version)
  *      loads and validates a superblock on dev.
  *      if refdev != NULL, compare superblocks on both devices
  *    Return:
@@ -509,7 +495,7 @@ static unsigned int calc_sb_csum(mdp_sup
 struct super_type  {
 	char 		*name;
 	struct module	*owner;
-	int		(*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev);
+	int		(*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version);
 	int		(*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev);
 	void		(*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
 };
@@ -517,10 +503,20 @@ struct super_type  {
 /*
  * load_super for 0.90.0 
  */
-static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev)
+static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 {
 	mdp_super_t *sb;
 	int ret;
+	sector_t sb_offset;
+
+	/*
+	 * Calculate the position of the superblock,
+	 * it's at the end of the disk.
+	 *
+	 * It also happens to be a multiple of 4Kb.
+	 */
+	sb_offset = calc_dev_sboffset(rdev->bdev);
+	rdev->sb_offset = sb_offset;
 
 	ret = read_disk_sb(rdev);
 	if (ret) return ret;
@@ -557,6 +553,11 @@ static int super_90_load(mdk_rdev_t *rde
 	rdev->preferred_minor = sb->md_minor;
 	rdev->data_offset = 0;
 
+	if (sb->level == MULTIPATH)
+		rdev->desc_nr = -1;
+	else
+		rdev->desc_nr = sb->this_disk.number;
+
 	if (refdev == 0)
 		ret = 1;
 	else {
@@ -581,7 +582,7 @@ static int super_90_load(mdk_rdev_t *rde
 		else 
 			ret = 0;
 	}
-
+	rdev->size = calc_dev_size(rdev, sb->chunk_size);
 
  abort:
 	return ret;
@@ -596,7 +597,7 @@ static int super_90_validate(mddev_t *md
 	mdp_super_t *sb = (mdp_super_t *)page_address(rdev->sb_page);
 
 	if (mddev->raid_disks == 0) {
-		mddev->major_version = sb->major_version;
+		mddev->major_version = 0;
 		mddev->minor_version = sb->minor_version;
 		mddev->patch_version = sb->patch_version;
 		mddev->persistent = ! sb->not_persistent;
@@ -633,7 +634,6 @@ static int super_90_validate(mddev_t *md
 			return -EINVAL;
 	}
 	if (mddev->level != LEVEL_MULTIPATH) {
-		rdev->desc_nr = sb->this_disk.number;
 		rdev->raid_disk = -1;
 		rdev->in_sync = rdev->faulty = 0;
 		desc = sb->disks + rdev->desc_nr;
@@ -801,13 +801,13 @@ static int match_mddev_units(mddev_t *md
 
 static LIST_HEAD(pending_raid_disks);
 
-static void bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
+static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 {
 	mdk_rdev_t *same_pdev;
 
 	if (rdev->mddev) {
 		MD_BUG();
-		return;
+		return -EINVAL;
 	}
 	same_pdev = match_dev_unit(mddev, rdev);
 	if (same_pdev)
@@ -817,9 +817,25 @@ static void bind_rdev_to_array(mdk_rdev_
 			mdidx(mddev), bdev_partition_name(rdev->bdev),
 				bdev_partition_name(same_pdev->bdev));
 
+	/* Verify rdev->desc_nr is unique.
+	 * If it is -1, assign a free number, else
+	 * check number is not in use
+	 */
+	if (rdev->desc_nr < 0) {
+		int choice = 0;
+		if (mddev->pers) choice = mddev->raid_disks;
+		while (find_rdev_nr(mddev, choice))
+			choice++;
+		rdev->desc_nr = choice;
+	} else {
+		if (find_rdev_nr(mddev, rdev->desc_nr))
+			return -EBUSY;
+	}
+			
 	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", bdev_partition_name(rdev->bdev));
+	return 0;
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -907,6 +923,7 @@ static void export_array(mddev_t *mddev)
 	if (!list_empty(&mddev->disks))
 		MD_BUG();
 	mddev->raid_disks = 0;
+	mddev->major_version = 0;
 }
 
 #undef BAD_CSUM
@@ -991,8 +1008,6 @@ void md_print_devices(void)
 
 static int write_disk_sb(mdk_rdev_t * rdev)
 {
-	sector_t sb_offset;
-	sector_t size;
 
 	if (!rdev->sb_loaded) {
 		MD_BUG();
@@ -1003,35 +1018,12 @@ static int write_disk_sb(mdk_rdev_t * rd
 		return 1;
 	}
 
-	sb_offset = calc_dev_sboffset(rdev->bdev);
-	if (rdev->sb_offset != sb_offset) {
-		printk("%s's sb offset has changed from %llu to %llu, skipping\n",
-		       bdev_partition_name(rdev->bdev), 
-		    (unsigned long long)rdev->sb_offset, 
-		    (unsigned long long)sb_offset);
-		goto skip;
-	}
-	/*
-	 * If the disk went offline meanwhile and it's just a spare, then
-	 * its size has changed to zero silently, and the MD code does
-	 * not yet know that it's faulty.
-	 */
-	size = calc_dev_size(rdev->bdev, rdev->mddev);
-	if (size != rdev->size) {
-		printk(KERN_INFO "%s's size has changed from %llu to %llu since import, skipping\n",
-		       bdev_partition_name(rdev->bdev),
-		       (unsigned long long)rdev->size, 
-		       (unsigned long long)size);
-		goto skip;
-	}
-
-	dprintk("(write) %s's sb offset: %llu\n", bdev_partition_name(rdev->bdev), (unsigned long long)sb_offset);
+	dprintk(KERN_INFO "(write) %s's sb offset: %llu\n", bdev_partition_name(rdev->bdev),
+	       (unsigned long long)rdev->sb_offset);
+  
+	if (sync_page_io(rdev->bdev, rdev->sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE))
+		return 0;
 
-	if (!sync_page_io(rdev->bdev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE))
-		goto fail;
-skip:
-	return 0;
-fail:
 	printk("md: write_disk_sb failed for device %s\n", bdev_partition_name(rdev->bdev));
 	return 1;
 }
@@ -1042,7 +1034,8 @@ static void sync_sbs(mddev_t * mddev)
 	struct list_head *tmp;
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		super_90_sync(mddev, rdev);
+		super_types[mddev->major_version].
+			sync_super(mddev, rdev);
 		rdev->sb_loaded = 1;
 	}
 }
@@ -1104,7 +1097,7 @@ repeat:
 }
 
 /*
- * Import a device. If 'on_disk', then sanity check the superblock
+ * Import a device. If 'super_format' >= 0, then sanity check the superblock
  *
  * mark the device faulty if:
  *
@@ -1113,7 +1106,7 @@ repeat:
  *
  * a faulty rdev _never_ has rdev->sb set.
  */
-static mdk_rdev_t *md_import_device(dev_t newdev, int on_disk)
+static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_minor)
 {
 	int err;
 	mdk_rdev_t *rdev;
@@ -1150,8 +1143,9 @@ static mdk_rdev_t *md_import_device(dev_
 		goto abort_free;
 	}
 
-	if (on_disk) {
-		err = super_90_load(rdev, NULL);
+	if (super_format >= 0) {
+		err = super_types[super_format].
+			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
 			printk(KERN_WARNING "md: %s has invalid sb, not importing!\n",
 			       bdev_partition_name(rdev->bdev));
@@ -1204,7 +1198,8 @@ static int analyze_sbs(mddev_t * mddev)
 
 	freshest = NULL;
 	ITERATE_RDEV(mddev,rdev,tmp)
-		switch (super_90_load(rdev, freshest)) {
+		switch (super_types[mddev->major_version].
+			load_super(rdev, freshest, mddev->minor_version)) {
 		case 1:
 			freshest = rdev;
 			break;
@@ -1216,12 +1211,14 @@ static int analyze_sbs(mddev_t * mddev)
 		}
 
 
-	super_90_validate(mddev, freshest);
+	super_types[mddev->major_version].
+		validate_super(mddev, freshest);
 
 	i = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (rdev != freshest)
-			if (super_90_validate(mddev, rdev)) {
+			if (super_types[mddev->major_version].
+			    validate_super(mddev, rdev)) {
 				printk(KERN_WARNING "md: kicking non-fresh %s from array!\n",
 				       bdev_partition_name(rdev->bdev));
 				kick_rdev_from_array(rdev);
@@ -1276,11 +1273,6 @@ static int device_size_calculation(mddev
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (rdev->faulty)
 			continue;
-		if (rdev->size) {
-			MD_BUG();
-			continue;
-		}
-		rdev->size = calc_dev_size(rdev->bdev, mddev);
 		if (rdev->size < mddev->chunk_size / 1024) {
 			printk(KERN_WARNING
 				"md: Dev %s smaller than chunk_size: %lluk < %dk\n",
@@ -1709,7 +1701,7 @@ static void autorun_devices(void)
 		printk(KERN_INFO "md: considering %s ...\n", bdev_partition_name(rdev0->bdev));
 		INIT_LIST_HEAD(&candidates);
 		ITERATE_RDEV_PENDING(rdev,tmp)
-			if (super_90_load(rdev, rdev0) >= 0) {
+			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				printk(KERN_INFO "md:  adding %s ...\n", bdev_partition_name(rdev->bdev));
 				list_move(&rdev->same_set, &candidates);
 			}
@@ -1727,7 +1719,8 @@ static void autorun_devices(void)
 		if (mddev_lock(mddev)) 
 			printk(KERN_WARNING "md: md%d locked, cannot run\n",
 			       mdidx(mddev));
-		else if (mddev->raid_disks || !list_empty(&mddev->disks)) {
+		else if (mddev->raid_disks || mddev->major_version
+			 || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING "md: md%d already running, cannot run %s\n",
 			       mdidx(mddev), bdev_partition_name(rdev0->bdev));
 			mddev_unlock(mddev);
@@ -1735,7 +1728,8 @@ static void autorun_devices(void)
 			printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
 			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
 				list_del_init(&rdev->same_set);
-				bind_rdev_to_array(rdev, mddev);
+				if (bind_rdev_to_array(rdev, mddev))
+					export_rdev(rdev);
 			}
 			autorun_array(mddev);
 			mddev_unlock(mddev);
@@ -1788,7 +1782,7 @@ static int autostart_array(dev_t startde
 	mdp_super_t *sb = NULL;
 	mdk_rdev_t *start_rdev = NULL, *rdev;
 
-	start_rdev = md_import_device(startdev, 1);
+	start_rdev = md_import_device(startdev, 0, 0);
 	if (IS_ERR(start_rdev)) {
 		printk(KERN_WARNING "md: could not import %s!\n", partition_name(startdev));
 		return err;
@@ -1822,7 +1816,7 @@ static int autostart_array(dev_t startde
 			continue;
 		if (dev == startdev)
 			continue;
-		rdev = md_import_device(dev, 1);
+		rdev = md_import_device(dev, 0, 0);
 		if (IS_ERR(rdev)) {
 			printk(KERN_WARNING "md: could not import %s, trying to run array nevertheless.\n",
 			       partition_name(dev));
@@ -1885,9 +1879,8 @@ static int get_array_info(mddev_t * mdde
 	}
 
 	info.major_version = mddev->major_version;
-	info.major_version = mddev->major_version;
 	info.minor_version = mddev->minor_version;
-	info.patch_version = mddev->patch_version;
+	info.patch_version = 1;
 	info.ctime         = mddev->ctime;
 	info.level         = mddev->level;
 	info.size          = mddev->size;
@@ -1953,13 +1946,13 @@ static int get_disk_info(mddev_t * mddev
 
 static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 {
-	sector_t size;
 	mdk_rdev_t *rdev;
 	dev_t dev;
 	dev = MKDEV(info->major,info->minor);
 	if (!mddev->raid_disks) {
+		int err;
 		/* expecting a device which has a superblock */
-		rdev = md_import_device(dev, 1);
+		rdev = md_import_device(dev, mddev->major_version, mddev->minor_version);
 		if (IS_ERR(rdev)) {
 			printk(KERN_WARNING "md: md_import_device returned %ld\n", PTR_ERR(rdev));
 			return PTR_ERR(rdev);
@@ -1967,7 +1960,8 @@ static int add_new_disk(mddev_t * mddev,
 		if (!list_empty(&mddev->disks)) {
 			mdk_rdev_t *rdev0 = list_entry(mddev->disks.next,
 							mdk_rdev_t, same_set);
-			int err = super_90_load(rdev, rdev0);
+			int err = super_types[mddev->major_version]
+				.load_super(rdev, rdev0, mddev->minor_version);
 			if (err < 0) {
 				printk(KERN_WARNING "md: %s has different UUID to %s\n",
 				       bdev_partition_name(rdev->bdev), bdev_partition_name(rdev0->bdev));
@@ -1975,12 +1969,52 @@ static int add_new_disk(mddev_t * mddev,
 				return -EINVAL;
 			}
 		}
-		bind_rdev_to_array(rdev, mddev);
-		return 0;
+		err = bind_rdev_to_array(rdev, mddev);
+		if (err)
+			export_rdev(rdev);
+		return err;
+	}
+
+	/*
+	 * add_new_disk can be used once the array is assembled
+	 * to add "hot spares".  They must already have a superblock
+	 * written
+	 */
+	if (mddev->pers) {
+		int err;
+		if (!mddev->pers->hot_add_disk) {
+			printk(KERN_WARNING "md%d: personality does not support diskops!\n",
+			       mdidx(mddev));
+			return -EINVAL;
+		}
+		rdev = md_import_device(dev, mddev->major_version,
+					mddev->minor_version);
+		if (IS_ERR(rdev)) {
+			printk(KERN_WARNING "md: md_import_device returned %ld\n", PTR_ERR(rdev));
+			return PTR_ERR(rdev);
+		}
+		rdev->in_sync = 0; /* just to be sure */
+		rdev->raid_disk = -1;
+		err = bind_rdev_to_array(rdev, mddev);
+		if (err)
+			export_rdev(rdev);
+		if (mddev->thread)
+			md_wakeup_thread(mddev->thread);
+		return err;
+	}
+
+	/* otherwise, add_new_disk is only allowed
+	 * for major_version==0 superblocks
+	 */
+	if (mddev->major_version != 0) {
+		printk(KERN_WARNING "md%d: ADD_NEW_DISK not supported\n",
+		       mdidx(mddev));
+		return -EINVAL;
 	}
 
 	if (!(info->state & (1<<MD_DISK_FAULTY))) {
-		rdev = md_import_device (dev, 0);
+		int err;
+		rdev = md_import_device (dev, -1, 0);
 		if (IS_ERR(rdev)) {
 			printk(KERN_WARNING "md: error, md_import_device() returned %ld\n", PTR_ERR(rdev));
 			return PTR_ERR(rdev);
@@ -1997,16 +2031,21 @@ static int add_new_disk(mddev_t * mddev,
 		else
 			rdev->in_sync = 0;
 
-		bind_rdev_to_array(rdev, mddev);
+		err = bind_rdev_to_array(rdev, mddev);
+		if (err) {
+			export_rdev(rdev);
+			return err;
+		}
 
-		if (!mddev->persistent)
+		if (!mddev->persistent) {
 			printk(KERN_INFO "md: nonpersistent superblock ...\n");
+			rdev->sb_offset = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
+		} else 
+			rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+		rdev->size = calc_dev_size(rdev, mddev->chunk_size);
 
-		size = calc_dev_size(rdev->bdev, mddev);
-		rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
-
-		if (!mddev->size || (mddev->size > size))
-			mddev->size = size;
+		if (!mddev->size || (mddev->size > rdev->size))
+			mddev->size = rdev->size;
 	}
 
 	return 0;
@@ -2076,7 +2115,7 @@ busy:
 
 static int hot_add_disk(mddev_t * mddev, dev_t dev)
 {
-	int i, err;
+	int err;
 	unsigned int size;
 	mdk_rdev_t *rdev;
 
@@ -2086,19 +2125,26 @@ static int hot_add_disk(mddev_t * mddev,
 	printk(KERN_INFO "md: trying to hot-add %s to md%d ... \n",
 		partition_name(dev), mdidx(mddev));
 
+	if (mddev->major_version != 0) {
+		printk(KERN_WARNING "md%d: HOT_ADD may only be used with version-0 superblocks.\n",
+		       mdidx(mddev));
+		return -EINVAL;
+	}
 	if (!mddev->pers->hot_add_disk) {
 		printk(KERN_WARNING "md%d: personality does not support diskops!\n",
 		       mdidx(mddev));
 		return -EINVAL;
 	}
 
-	rdev = md_import_device (dev, 0);
+	rdev = md_import_device (dev, -1, 0);
 	if (IS_ERR(rdev)) {
 		printk(KERN_WARNING "md: error, md_import_device() returned %ld\n", PTR_ERR(rdev));
 		return -EINVAL;
 	}
 
-	size = calc_dev_size(rdev->bdev, mddev);
+	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+	size = calc_dev_size(rdev, mddev->chunk_size);
+	rdev->size = size;
 
 	if (size < mddev->size) {
 		printk(KERN_WARNING "md%d: disk size %llu blocks < array size %llu\n",
@@ -2115,27 +2161,21 @@ static int hot_add_disk(mddev_t * mddev,
 		goto abort_export;
 	}
 	rdev->in_sync = 0;
+	rdev->desc_nr = -1;
 	bind_rdev_to_array(rdev, mddev);
 
 	/*
 	 * The rest should better be atomic, we can have disk failures
 	 * noticed in interrupt contexts ...
 	 */
-	rdev->size = size;
-	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
 
-	for (i = mddev->raid_disks; i < mddev->max_disks; i++)
-		if (find_rdev_nr(mddev,i)==NULL)
-			break;
-
-	if (i == mddev->max_disks) {
+	if (rdev->desc_nr == mddev->max_disks) {
 		printk(KERN_WARNING "md%d: can not hot-add to full array!\n",
 		       mdidx(mddev));
 		err = -EBUSY;
 		goto abort_unbind_export;
 	}
 
-	rdev->desc_nr = i;
 	rdev->raid_disk = -1;
 
 	md_update_sb(mddev);
@@ -2157,9 +2197,37 @@ abort_export:
 	return err;
 }
 
+/*
+ * set_array_info is used two different ways
+ * The original usage is when creating a new array.
+ * In this usage, raid_disks is > = and it together with
+ *  level, size, not_persistent,layout,chunksize determine the
+ *  shape of the array.
+ *  This will always create an array with a type-0.90.0 superblock.
+ * The newer usage is when assembling an array.
+ *  In this case raid_disks will be 0, and the major_version field is
+ *  use to determine which style super-blocks are to be found on the devices.
+ *  The minor and patch _version numbers are also kept incase the
+ *  super_block handler wishes to interpret them.
+ */
 static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 {
 
+	if (info->raid_disks == 0) {
+		/* just setting version number for superblock loading */
+		if (info->major_version < 0 ||
+		    info->major_version >= sizeof(super_types)/sizeof(super_types[0]) ||
+		    super_types[info->major_version].name == NULL) {
+			/* maybe try to auto-load a module? */
+			printk(KERN_INFO "md: superblock version %d not known\n",
+			       info->major_version);
+			return -EINVAL;
+		}
+		mddev->major_version = info->major_version;
+		mddev->minor_version = info->minor_version;
+		mddev->patch_version = info->patch_version;
+		return 0;
+	}
 	mddev->major_version = MD_MAJOR_VERSION;
 	mddev->minor_version = MD_MINOR_VERSION;
 	mddev->patch_version = MD_PATCHLEVEL_VERSION;
@@ -2180,6 +2248,7 @@ static int set_array_info(mddev_t * mdde
 	mddev->layout        = info->layout;
 	mddev->chunk_size    = info->chunk_size;
 
+	mddev->max_disks     = MD_SB_DISKS;
 
 
 	/*
@@ -2293,9 +2362,11 @@ static int md_ioctl(struct inode *inode,
 				err = -EBUSY;
 				goto abort_unlock;
 			}
-			if (arg) {
+			{
 				mdu_array_info_t info;
-				if (copy_from_user(&info, (void*)arg, sizeof(info))) {
+				if (!arg)
+					memset(&info, 0, sizeof(info));
+				else if (copy_from_user(&info, (void*)arg, sizeof(info))) {
 					err = -EFAULT;
 					goto abort_unlock;
 				}
@@ -3365,7 +3436,7 @@ static void autostart_arrays(void)
 	for (i = 0; i < dev_cnt; i++) {
 		dev_t dev = detected_devices[i];
 
-		rdev = md_import_device(dev,1);
+		rdev = md_import_device(dev,0, 0);
 		if (IS_ERR(rdev)) {
 			printk(KERN_ALERT "md: could not import %s!\n",
 				partition_name(dev));
