From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 25 of 27 - Remove the sb from the mddev
Date: Thu, 18 Jul 2002 23:34:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133432.5040@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Remove the sb from the mddev

Now that al the important information is in mddev, we don't need
to have an sb off the mddev.  We only keep the per-device ones.

Previously we determined if "set_array_info" had been run byb checking
mddev->sb.  Now we check mddev->raid_disks on the assumption that
any valid array MUST have a non-zero number of devices.




 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   87 ++++++++++++++++----------------------------
 ./include/linux/raid/md_k.h |    1 
 2 files changed, 33 insertions(+), 55 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:08:11	1.16
+++ ./drivers/md/md.c	2002/07/18 12:08:25	1.17
@@ -175,7 +175,7 @@ static void mddev_put(mddev_t *mddev)
 {
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
-	if (!mddev->sb && list_empty(&mddev->disks)) {
+	if (!mddev->raid_disks && list_empty(&mddev->disks)) {
 		list_del(&mddev->all_mddevs);
 		mddev_map[mdidx(mddev)] = NULL;
 		kfree(mddev);
@@ -350,20 +350,6 @@ static unsigned int zoned_raid_size(mdde
 #define BAD_CSUM KERN_WARNING \
 "md: invalid superblock checksum on %s\n"
 
-static int alloc_array_sb(mddev_t * mddev)
-{
-	if (mddev->sb) {
-		MD_BUG();
-		return 0;
-	}
-
-	mddev->sb = (mdp_super_t *) __get_free_page (GFP_KERNEL);
-	if (!mddev->sb)
-		return -ENOMEM;
-	clear_page(mddev->sb);
-	return 0;
-}
-
 static int alloc_disk_sb(mdk_rdev_t * rdev)
 {
 	if (rdev->sb_page)
@@ -624,12 +610,6 @@ static void export_array(mddev_t *mddev)
 {
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
-	mdp_super_t *sb = mddev->sb;
-
-	if (mddev->sb) {
-		mddev->sb = NULL;
-		free_page((unsigned long) sb);
-	}
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (!rdev->mddev) {
@@ -640,6 +620,7 @@ static void export_array(mddev_t *mddev)
 	}
 	if (!list_empty(&mddev->disks))
 		MD_BUG();
+	mddev->raid_disks = 0;
 }
 
 static void free_mddev(mddev_t *mddev)
@@ -726,12 +707,6 @@ void md_print_devices(void)
 		ITERATE_RDEV(mddev,rdev,tmp2)
 			printk("<%s>", partition_name(rdev->dev));
 
-		if (mddev->sb) {
-			printk(" array superblock:\n");
-			print_sb(mddev->sb);
-		} else
-			printk(" no array superblock.\n");
-
 		ITERATE_RDEV(mddev,rdev,tmp2)
 			print_rdev(rdev);
 	}
@@ -835,13 +810,16 @@ fail:
 	return 1;
 }
 
-static int sync_sbs(mddev_t * mddev)
+static void sync_sbs(mddev_t * mddev)
 {
 	mdk_rdev_t *rdev;
 	mdp_super_t *sb;
 	struct list_head *tmp;
 
-	/* make sb->disks match mddev->disks 
+	/* make all rdev->sb match mddev data..
+	 * we setup the data in the first rdev and copy it
+	 * to the others.
+	 *
 	 * 1/ zero out disks
 	 * 2/ Add info for each disk, keeping track of highest desc_nr
 	 * 3/ any empty disks < highest become removed
@@ -854,7 +832,13 @@ static int sync_sbs(mddev_t * mddev)
 	int i;
 	int active=0, working=0,failed=0,spare=0,nr_disks=0;
 
-	sb = mddev->sb;
+	if (list_empty(&mddev->disks)) {
+		MD_BUG();
+		return;
+	}
+	rdev = list_entry(&mddev->disks.next, mdk_rdev_t, same_set);
+	sb = rdev->sb;
+
 	memset(sb, 0, sizeof(*sb));
 
 	sb->md_magic = MD_SB_MAGIC;
@@ -922,14 +906,16 @@ static int sync_sbs(mddev_t * mddev)
 	sb->spare_disks = spare;
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
+		mdp_super_t *this_sb;
+		
 		if (rdev->faulty || rdev->alias_device)
 			continue;
-		sb = rdev->sb;
-		*sb = *mddev->sb;
-		sb->this_disk = sb->disks[rdev->desc_nr];
-		sb->sb_csum = calc_sb_csum(sb);
+		this_sb = rdev->sb;
+		if (this_sb != sb)
+			*this_sb = *sb;
+		this_sb->this_disk = this_sb->disks[rdev->desc_nr];
+		this_sb->sb_csum = calc_sb_csum(this_sb);
 	}
-	return 0;
 }
 
 static void md_update_sb(mddev_t * mddev)
@@ -1127,9 +1113,6 @@ static int analyze_sbs(mddev_t * mddev)
 	 * find the freshest superblock, that one will be the superblock
 	 * that represents the whole array.
 	 */
-	if (alloc_array_sb(mddev))
-		goto abort;
-	sb = mddev->sb;
 	freshest = NULL;
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -1167,7 +1150,8 @@ static int analyze_sbs(mddev_t * mddev)
 		printk(OUT_OF_DATE);
 		printk(KERN_INFO "md: freshest: %s\n", partition_name(freshest->dev));
 	}
-	memcpy (sb, freshest->sb, sizeof(*sb));
+
+	sb = freshest->sb;
 
 	mddev->major_version = sb->major_version;
 	mddev->minor_version = sb->minor_version;
@@ -1381,7 +1365,7 @@ static int do_md_run(mddev_t * mddev)
 	/*
 	 * Analyze all RAID superblock(s)
 	 */
-	if (!mddev->sb && analyze_sbs(mddev)) {
+	if (!mddev->raid_disks && analyze_sbs(mddev)) {
 		MD_BUG();
 		return -EINVAL;
 	}
@@ -1584,7 +1568,7 @@ static int do_md_stop(mddev_t * mddev, i
 			if (mddev->ro)
 				mddev->ro = 0;
 		}
-		if (mddev->sb) {
+		if (mddev->raid_disks) {
 			/*
 			 * mark it clean only if there was no resync
 			 * interrupted.
@@ -1707,7 +1691,7 @@ static void autorun_devices(void)
 		if (mddev_lock(mddev)) 
 			printk(KERN_WARNING "md: md%d locked, cannot run\n",
 			       mdidx(mddev));
-		else if (mddev->sb || !list_empty(&mddev->disks)) {
+		else if (mddev->raid_disks || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING "md: md%d already running, cannot run %s\n",
 			       mdidx(mddev), partition_name(rdev0->dev));
 			mddev_unlock(mddev);
@@ -1941,7 +1925,7 @@ static int add_new_disk(mddev_t * mddev,
 	mdk_rdev_t *rdev;
 	kdev_t dev;
 	dev = mk_kdev(info->major,info->minor);
-	if (!mddev->sb) {
+	if (!mddev->raid_disks) {
 		/* expecting a device which has a superblock */
 		rdev = md_import_device(dev, 1);
 		if (IS_ERR(rdev)) {
@@ -2166,9 +2150,6 @@ abort_export:
 static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 {
 
-	if (alloc_array_sb(mddev))
-		return -ENOMEM;
-
 	mddev->major_version = MD_MAJOR_VERSION;
 	mddev->minor_version = MD_MINOR_VERSION;
 	mddev->patch_version = MD_PATCHLEVEL_VERSION;
@@ -2316,8 +2297,8 @@ static int md_ioctl(struct inode *inode,
 				err = -EBUSY;
 				goto abort_unlock;
 			}
-			if (mddev->sb) {
-				printk(KERN_WARNING "md: array md%d already has a superblock!\n",
+			if (mddev->raid_disks) {
+				printk(KERN_WARNING "md: array md%d already initialised!\n",
 					mdidx(mddev));
 				err = -EBUSY;
 				goto abort_unlock;
@@ -2342,8 +2323,8 @@ static int md_ioctl(struct inode *inode,
 	/*
 	 * Commands querying/configuring an existing array:
 	 */
-	/* if we don't have a superblock yet, only ADD_NEW_DISK or STOP_ARRAY is allowed */
-	if (!mddev->sb && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY && cmd != RUN_ARRAY) {
+	/* if we are initialised yet, only ADD_NEW_DISK or STOP_ARRAY is allowed */
+	if (!mddev->raid_disks && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY && cmd != RUN_ARRAY) {
 		err = -ENODEV;
 		goto abort_unlock;
 	}
@@ -3086,14 +3067,12 @@ static void md_do_sync(void *data)
 void md_do_recovery(void *data)
 {
 	mddev_t *mddev;
-	mdp_super_t *sb;
 	struct list_head *tmp;
 
 	dprintk(KERN_INFO "md: recovery thread got woken up ...\n");
 
 	ITERATE_MDDEV(mddev,tmp) if (mddev_lock(mddev)==0) {
-		sb = mddev->sb;
-		if (!sb || !mddev->pers || mddev->ro)
+		if (!mddev->raid_disks || !mddev->pers || mddev->ro)
 			goto unlock;
 		if (mddev->sb_dirty)
 			md_update_sb(mddev);
@@ -3483,7 +3462,7 @@ void __init md_setup_drive(void)
 			continue;
 		}
 
-		if (mddev->sb || !list_empty(&mddev->disks)) {
+		if (mddev->raid_disks || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING
 			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
 			       minor);
--- ./include/linux/raid/md_k.h	2002/07/18 12:08:11	1.11
+++ ./include/linux/raid/md_k.h	2002/07/18 12:08:25	1.12
@@ -170,7 +170,6 @@ struct mddev_s
 	void				*private;
 	mdk_personality_t		*pers;
 	int				__minor;
-	mdp_super_t			*sb;
 	struct list_head 		disks;
 	int				sb_dirty;
 	int				ro;
