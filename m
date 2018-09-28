From: Andrey Abramov <st5pub@yandex.ru>
Subject: [PATCH] Fixed code style issues in the drivers/md/md.c
Date: Fri, 28 Sep 2018 20:12:45 +0300
Message-ID: <20180928171245.31177-1-st5pub@yandex.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Andrey Abramov <st5pub@yandex.ru>
List-Id: linux-raid.ids

Fixed many code style issues in the drivers/md/md.c.
I used scripts/checkpatch.pl utility to find and fix code style issues and also fixed some by hands.
I reviewed all changes made by scripts/checkpatch.pl.
And of course compiled it (kernel) successfully.

Signed-off-by: Andrey Abramov <st5pub@yandex.ru>
---
 drivers/md/md.c | 397 ++++++++++++++++++++++++++++--------------------
 1 file changed, 231 insertions(+), 166 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 63ceabb4e020..b9a453e63b5b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -35,11 +35,11 @@
    Please use:
      pr_crit() for error conditions that risk data loss
      pr_err() for error conditions that are unexpected, like an IO error
-         or internal inconsistency
+	 or internal inconsistency
      pr_warn() for error conditions that could have been predicated, like
-         adding a device to an array when it has incompatible metadata
+	 adding a device to an array when it has incompatible metadata
      pr_info() for every interesting, very rare events, like an array starting
-         or stopping, or resync starting or stopping
+	 or stopping, or resync starting or stopping
      pr_debug() for everything else.
 
 */
@@ -132,16 +132,16 @@ static inline int speed_max(struct mddev *mddev)
 		mddev->sync_speed_max : sysctl_speed_limit_max;
 }
 
-static void * flush_info_alloc(gfp_t gfp_flags, void *data)
+static void *flush_info_alloc(gfp_t gfp_flags, void *data)
 {
-        return kzalloc(sizeof(struct flush_info), gfp_flags);
+	return kzalloc(sizeof(struct flush_info), gfp_flags);
 }
 static void flush_info_free(void *flush_info, void *data)
 {
-        kfree(flush_info);
+	kfree(flush_info);
 }
 
-static void * flush_bio_alloc(gfp_t gfp_flags, void *data)
+static void *flush_bio_alloc(gfp_t gfp_flags, void *data)
 {
 	return kzalloc(sizeof(struct flush_bio), gfp_flags);
 }
@@ -260,19 +260,19 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
  * Any code which breaks out of this loop while own
  * a reference to the current mddev and must mddev_put it.
  */
-#define for_each_mddev(_mddev,_tmp)					\
+#define for_each_mddev(_mddev, _tmp)					\
 									\
 	for (({ spin_lock(&all_mddevs_lock);				\
 		_tmp = all_mddevs.next;					\
-		_mddev = NULL;});					\
+		_mddev = NULL; });					\
 	     ({ if (_tmp != &all_mddevs)				\
 			mddev_get(list_entry(_tmp, struct mddev, all_mddevs));\
 		spin_unlock(&all_mddevs_lock);				\
 		if (_mddev) mddev_put(_mddev);				\
 		_mddev = list_entry(_tmp, struct mddev, all_mddevs);	\
-		_tmp != &all_mddevs;});					\
+		_tmp != &all_mddevs; });					\
 	     ({ spin_lock(&all_mddevs_lock);				\
-		_tmp = _tmp->next;})					\
+		_tmp = _tmp->next; })					\
 		)
 
 /* Rather than calling directly into the personality make_request function,
@@ -303,6 +303,7 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 	rcu_read_lock();
 	if (is_suspended(mddev, bio)) {
 		DEFINE_WAIT(__wait);
+
 		for (;;) {
 			prepare_to_wait(&mddev->sb_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
@@ -423,6 +424,7 @@ EXPORT_SYMBOL_GPL(mddev_congested);
 static int md_congested(void *data, int bits)
 {
 	struct mddev *mddev = data;
+
 	return mddev_congested(mddev, bits);
 }
 
@@ -486,6 +488,7 @@ void md_flush_request(struct mddev *mddev, struct bio *bio)
 			 */
 			struct bio *bi;
 			struct flush_bio *fb;
+
 			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
@@ -606,6 +609,7 @@ static struct mddev *mddev_find(dev_t unit)
 		int start = next_minor;
 		int is_free = 0;
 		int dev = 0;
+
 		while (!is_free) {
 			dev = MKDEV(MD_MAJOR, next_minor);
 			next_minor++;
@@ -667,6 +671,7 @@ void mddev_unlock(struct mddev *mddev)
 		 * is seen.
 		 */
 		struct attribute_group *to_remove = mddev->to_remove;
+
 		mddev->to_remove = NULL;
 		mddev->sysfs_active = 1;
 		mutex_unlock(&mddev->reconfig_mutex);
@@ -734,10 +739,11 @@ EXPORT_SYMBOL_GPL(md_find_rdev_rcu);
 static struct md_personality *find_pers(int level, char *clevel)
 {
 	struct md_personality *pers;
+
 	list_for_each_entry(pers, &pers_list, list) {
 		if (level != LEVEL_NONE && pers->level == level)
 			return pers;
-		if (strcmp(pers->name, clevel)==0)
+		if (strcmp(pers->name, clevel) == 0)
 			return pers;
 	}
 	return NULL;
@@ -747,6 +753,7 @@ static struct md_personality *find_pers(int level, char *clevel)
 static inline sector_t calc_dev_sboffset(struct md_rdev *rdev)
 {
 	sector_t num_sectors = i_size_read(rdev->bdev->bd_inode) / 512;
+
 	return MD_NEW_SIZE_SECTORS(num_sectors);
 }
 
@@ -838,7 +845,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 int md_super_wait(struct mddev *mddev)
 {
 	/* wait for all superblock writes that were scheduled to complete */
-	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
+	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes) == 0);
 	if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
 		return -EAGAIN;
 	return 0;
@@ -887,7 +894,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 
 fail:
 	pr_err("md: disabled device %s, could not read superblock.\n",
-	       bdevname(rdev->bdev,b));
+	       bdevname(rdev->bdev, b));
 	return -EINVAL;
 }
 
@@ -904,8 +911,8 @@ static int md_sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 	int ret;
 	mdp_super_t *tmp1, *tmp2;
 
-	tmp1 = kmalloc(sizeof(*tmp1),GFP_KERNEL);
-	tmp2 = kmalloc(sizeof(*tmp2),GFP_KERNEL);
+	tmp1 = kmalloc(sizeof(*tmp1), GFP_KERNEL);
+	tmp2 = kmalloc(sizeof(*tmp2), GFP_KERNEL);
 
 	if (!tmp1 || !tmp2) {
 		ret = 0;
@@ -937,7 +944,7 @@ static u32 md_csum_fold(u32 csum)
 static unsigned int calc_sb_csum(mdp_super_t *sb)
 {
 	u64 newcsum = 0;
-	u32 *sb32 = (u32*)sb;
+	u32 *sb32 = (u32 *)sb;
 	int i;
 	unsigned int disk_csum, csum;
 
@@ -1091,9 +1098,10 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	} else {
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
+
 		if (!md_uuid_equal(refsb, sb)) {
 			pr_warn("md: %s has different UUID to %s\n",
-				b, bdevname(refdev->bdev,b2));
+				b, bdevname(refdev->bdev, b2));
 			goto abort;
 		}
 		if (!md_sb_equal(refsb, sb)) {
@@ -1190,7 +1198,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 		memcpy(mddev->uuid+0, &sb->set_uuid0, 4);
 		memcpy(mddev->uuid+4, &sb->set_uuid1, 4);
 		memcpy(mddev->uuid+8, &sb->set_uuid2, 4);
-		memcpy(mddev->uuid+12,&sb->set_uuid3, 4);
+		memcpy(mddev->uuid+12, &sb->set_uuid3, 4);
 
 		mddev->max_disks = MD_SB_DISKS;
 
@@ -1272,7 +1280,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	 * been initialised or not.
 	 */
 	int i;
-	int active=0, working=0,failed=0,spare=0,nr_disks=0;
+	int active = 0, working = 0, failed = 0, spare = 0, nr_disks = 0;
 
 	rdev->sb_size = MD_SB_BYTES;
 
@@ -1287,7 +1295,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	memcpy(&sb->set_uuid0, mddev->uuid+0, 4);
 	memcpy(&sb->set_uuid1, mddev->uuid+4, 4);
 	memcpy(&sb->set_uuid2, mddev->uuid+8, 4);
-	memcpy(&sb->set_uuid3, mddev->uuid+12,4);
+	memcpy(&sb->set_uuid3, mddev->uuid+12, 4);
 
 	sb->ctime = clamp_t(time64_t, mddev->ctime, 0, U32_MAX);
 	sb->level = mddev->level;
@@ -1311,13 +1319,12 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->new_chunk = mddev->new_chunk_sectors << 9;
 	}
 	mddev->minor_version = sb->minor_version;
-	if (mddev->in_sync)
-	{
+	if (mddev->in_sync) {
 		sb->recovery_cp = mddev->recovery_cp;
 		sb->cp_events_hi = (mddev->events>>32);
 		sb->cp_events_lo = (u32)mddev->events;
 		if (mddev->recovery_cp == MaxSector)
-			sb->state = (1<< MD_SB_CLEAN);
+			sb->state = (1 << MD_SB_CLEAN);
 	} else
 		sb->recovery_cp = 0;
 
@@ -1376,8 +1383,9 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			d->state |= (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
-	for (i=0 ; i < mddev->raid_disks ; i++) {
+	for (i = 0 ; i < mddev->raid_disks ; i++) {
 		mdp_disk_t *d = &sb->disks[i];
+
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
 			d->raid_disk = i;
@@ -1439,7 +1447,7 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 *sb)
 	u32 csum;
 	unsigned long long newcsum;
 	int size = 256 + le32_to_cpu(sb->max_dev)*2;
-	__le32 *isuper = (__le32*)sb;
+	__le32 *isuper = (__le32 *)sb;
 
 	disk_csum = sb->sb_csum;
 	sb->sb_csum = 0;
@@ -1448,7 +1456,7 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 *sb)
 		newcsum += le32_to_cpu(*isuper++);
 
 	if (size == 2)
-		newcsum += le16_to_cpu(*(__le16*) isuper);
+		newcsum += le16_to_cpu(*(__le16 *) isuper);
 
 	csum = (newcsum & 0xffffffff) + (newcsum >> 32);
 	sb->sb_csum = disk_csum;
@@ -1472,7 +1480,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	 * 1: At start of device
 	 * 2: 4K from start of device.
 	 */
-	switch(minor_version) {
+	switch (minor_version) {
 	case 0:
 		sb_start = i_size_read(rdev->bdev->bd_inode) >> 9;
 		sb_start -= 8*2;
@@ -1493,7 +1501,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	 * and it is safe to read 4k, so we do that
 	 */
 	ret = read_disk_sb(rdev, 4096);
-	if (ret) return ret;
+	if (ret)
+		return ret;
 
 	sb = page_address(rdev->sb_page);
 
@@ -1506,12 +1515,12 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 
 	if (calc_sb_1_csum(sb) != sb->sb_csum) {
 		pr_warn("md: invalid superblock checksum on %s\n",
-			bdevname(rdev->bdev,b));
+			bdevname(rdev->bdev, b));
 		return -EINVAL;
 	}
 	if (le64_to_cpu(sb->data_size) < 10) {
 		pr_warn("md: data_size too small on %s\n",
-			bdevname(rdev->bdev,b));
+			bdevname(rdev->bdev, b));
 		return -EINVAL;
 	}
 	if (sb->pad0 ||
@@ -1560,6 +1569,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		u64 *bbp;
 		int i;
 		int sectors = le16_to_cpu(sb->bblog_size);
+
 		if (sectors > (PAGE_SIZE / 512))
 			return -EINVAL;
 		offset = le32_to_cpu(sb->bblog_offset);
@@ -1575,6 +1585,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			u64 bb = le64_to_cpu(*bbp);
 			int count = bb & (0x3ff);
 			u64 sector = bb >> 10;
+
 			sector <<= sb->bblog_shift;
 			count <<= sb->bblog_shift;
 			if (bb + 1 == 0)
@@ -1603,8 +1614,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		    sb->layout != refsb->layout ||
 		    sb->chunksize != refsb->chunksize) {
 			pr_warn("md: %s has strangely different superblock to %s\n",
-				bdevname(rdev->bdev,b),
-				bdevname(refdev->bdev,b2));
+				bdevname(rdev->bdev, b),
+				bdevname(refdev->bdev, b2));
 			return -EINVAL;
 		}
 		ev1 = le64_to_cpu(sb->events);
@@ -1741,13 +1752,14 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 	}
 	if (mddev->level != LEVEL_MULTIPATH) {
 		int role;
+
 		if (rdev->desc_nr < 0 ||
 		    rdev->desc_nr >= le32_to_cpu(sb->max_dev)) {
 			role = MD_DISK_ROLE_SPARE;
 			rdev->desc_nr = -1;
 		} else
 			role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
-		switch(role) {
+		switch (role) {
 		case MD_DISK_ROLE_SPARE: /* spare */
 			break;
 		case MD_DISK_ROLE_FAULTY: /* faulty */
@@ -1875,7 +1887,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_CLUSTERED);
 
 	if (rdev->badblocks.count == 0)
-		/* Nothing to do for bad blocks*/ ;
+		/* Nothing to do for bad blocks*/;
 	else if (sb->bblog_offset == 0)
 		/* Cannot record bad blocks on this device */
 		md_error(mddev, rdev);
@@ -1883,9 +1895,10 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		struct badblocks *bb = &rdev->badblocks;
 		u64 *bbp = (u64 *)page_address(rdev->bb_page);
 		u64 *p = bb->page;
+
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
 		if (bb->changed) {
-			unsigned seq;
+			unsigned int seq;
 
 retry:
 			seq = read_seqbegin(&bb->lock);
@@ -1915,6 +1928,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (max_dev > le32_to_cpu(sb->max_dev)) {
 		int bmask;
+
 		sb->max_dev = cpu_to_le32(max_dev);
 		rdev->sb_size = max_dev * 2 + 256;
 		bmask = queue_logical_block_size(rdev->bdev->bd_disk->queue)-1;
@@ -1923,7 +1937,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	} else
 		max_dev = le32_to_cpu(sb->max_dev);
 
-	for (i=0; i<max_dev;i++)
+	for (i = 0; i < max_dev; i++)
 		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_SPARE);
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
@@ -1961,6 +1975,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 {
 	struct mdp_superblock_1 *sb;
 	sector_t max_sectors;
+
 	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
 		return 0; /* component must fit device */
 	if (rdev->data_offset != rdev->new_data_offset)
@@ -1977,6 +1992,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	} else {
 		/* minor version 0; superblock after data */
 		sector_t sb_start;
+
 		sb_start = (i_size_read(rdev->bdev->bd_inode) >> 9) - 8*2;
 		sb_start &= ~(sector_t)(4*2 - 1);
 		max_sectors = rdev->sectors + sb_start - rdev->sb_start;
@@ -2002,6 +2018,7 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 {
 	/* All necessary checks on new >= old have been done */
 	struct bitmap *bitmap;
+
 	if (new_offset >= rdev->data_offset)
 		return 1;
 
@@ -2205,6 +2222,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	rcu_read_lock();
 	if (rdev->desc_nr < 0) {
 		int choice = 0;
+
 		if (mddev->pers)
 			choice = mddev->raid_disks;
 		while (md_find_rdev_nr_rcu(mddev, choice))
@@ -2223,13 +2241,14 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 			mdname(mddev), mddev->max_disks);
 		return -EBUSY;
 	}
-	bdevname(rdev->bdev,b);
+	bdevname(rdev->bdev, b);
 	strreplace(b, '/', '!');
 
 	rdev->mddev = mddev;
 	pr_debug("md: bind<%s>\n", b);
 
-	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
+	err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b);
+	if (err)
 		goto fail;
 
 	ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
@@ -2254,6 +2273,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 static void md_delayed_delete(struct work_struct *ws)
 {
 	struct md_rdev *rdev = container_of(ws, struct md_rdev, del_work);
+
 	kobject_del(&rdev->kobj);
 	kobject_put(&rdev->kobj);
 }
@@ -2264,7 +2284,7 @@ static void unbind_rdev_from_array(struct md_rdev *rdev)
 
 	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
-	pr_debug("md: unbind<%s>\n", bdevname(rdev->bdev,b));
+	pr_debug("md: unbind<%s>\n", bdevname(rdev->bdev, b));
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
 	sysfs_put(rdev->sysfs_state);
@@ -2304,6 +2324,7 @@ static int lock_rdev(struct md_rdev *rdev, dev_t dev, int shared)
 static void unlock_rdev(struct md_rdev *rdev)
 {
 	struct block_device *bdev = rdev->bdev;
+
 	rdev->bdev = NULL;
 	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
@@ -2314,7 +2335,7 @@ static void export_rdev(struct md_rdev *rdev)
 {
 	char b[BDEVNAME_SIZE];
 
-	pr_debug("md: export_rdev(%s)\n", bdevname(rdev->bdev,b));
+	pr_debug("md: export_rdev(%s)\n", bdevname(rdev->bdev, b));
 	md_rdev_clear(rdev);
 #ifndef MODULE
 	if (test_bit(AutoDetected, &rdev->flags))
@@ -2380,6 +2401,7 @@ static void sync_sbs(struct mddev *mddev, int nospares)
 	 * with the rest of the array)
 	 */
 	struct md_rdev *rdev;
+
 	rdev_for_each(rdev, mddev) {
 		if (rdev->sb_events == mddev->events ||
 		    (nospares &&
@@ -2414,7 +2436,7 @@ static bool does_sb_need_changing(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
 		/* Device activated? */
-		if (role == 0xffff && rdev->raid_disk >=0 &&
+		if (role == 0xffff && rdev->raid_disk >= 0 &&
 		    !test_bit(Faulty, &rdev->flags))
 			return true;
 		/* Device turned faulty? */
@@ -2541,7 +2563,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 		mddev->can_decrease_events = 0;
 	} else {
 		/* otherwise we have to go forward and ... */
-		mddev->events ++;
+		mddev->events++;
 		mddev->can_decrease_events = nospares;
 	}
 
@@ -2576,7 +2598,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			continue; /* no noise on spare devices */
 
 		if (!test_bit(Faulty, &rdev->flags)) {
-			md_super_write(mddev,rdev,
+			md_super_write(mddev, rdev,
 				       rdev->sb_start, rdev->sb_size,
 				       rdev->sb_page);
 			pr_debug("md: (write) %s's sb offset: %llu\n",
@@ -2747,6 +2769,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	 *  {,-}failfast - set/clear FailFast
 	 */
 	int err = -EINVAL;
+
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
 		md_error(rdev->mddev, rdev);
 		if (test_bit(Faulty, &rdev->flags))
@@ -2762,6 +2785,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			err = -EBUSY;
 		else {
 			struct mddev *mddev = rdev->mddev;
+
 			err = 0;
 			if (mddev_is_clustered(mddev))
 				err = md_cluster_ops->remove_disk(mddev, rdev);
@@ -2931,7 +2955,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 
 	if (test_bit(Journal, &rdev->flags))
 		return -EBUSY;
-	if (strncmp(buf, "none", 4)==0)
+	if (strncmp(buf, "none", 4) == 0)
 		slot = -1;
 	else {
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
@@ -3020,6 +3044,7 @@ static ssize_t
 offset_store(struct md_rdev *rdev, const char *buf, size_t len)
 {
 	unsigned long long offset;
+
 	if (kstrtoull(buf, 10, &offset) < 0)
 		return -EINVAL;
 	if (rdev->mddev->pers && rdev->raid_disk >= 0)
@@ -3052,7 +3077,7 @@ static ssize_t new_offset_store(struct md_rdev *rdev,
 		return -EINVAL;
 
 	if (mddev->sync_thread ||
-	    test_bit(MD_RECOVERY_RUNNING,&mddev->recovery))
+	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 	if (new_offset == rdev->data_offset)
 		/* reset is always permitted */
@@ -3390,7 +3415,7 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	rv = mddev ? mddev_lock(mddev): -EBUSY;
+	rv = mddev ? mddev_lock(mddev) : -EBUSY;
 	if (!rv) {
 		if (rdev->mddev == NULL)
 			rv = -EBUSY;
@@ -3404,6 +3429,7 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 static void rdev_free(struct kobject *ko)
 {
 	struct md_rdev *rdev = container_of(ko, struct md_rdev, kobj);
+
 	kfree(rdev);
 }
 static const struct sysfs_ops rdev_sysfs_ops = {
@@ -3479,7 +3505,7 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 	size = i_size_read(rdev->bdev->bd_inode) >> BLOCK_SIZE_BITS;
 	if (!size) {
 		pr_warn("md: %s has zero or unknown size, marking faulty!\n",
-			bdevname(rdev->bdev,b));
+			bdevname(rdev->bdev, b));
 		err = -EINVAL;
 		goto abort_free;
 	}
@@ -3489,13 +3515,13 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
 			pr_warn("md: %s does not have a valid v%d.%d superblock, not importing!\n",
-				bdevname(rdev->bdev,b),
+				bdevname(rdev->bdev, b),
 				super_format, super_minor);
 			goto abort_free;
 		}
 		if (err < 0) {
 			pr_warn("md: could not read %s's sb, not importing!\n",
-				bdevname(rdev->bdev,b));
+				bdevname(rdev->bdev, b));
 			goto abort_free;
 		}
 	}
@@ -3531,7 +3557,7 @@ static void analyze_sbs(struct mddev *mddev)
 			break;
 		default:
 			pr_warn("md: fatal superblock inconsistency in %s -- removing from array\n",
-				bdevname(rdev->bdev,b));
+				bdevname(rdev->bdev, b));
 			md_kick_rdev_from_array(rdev);
 		}
 
@@ -3553,7 +3579,7 @@ static void analyze_sbs(struct mddev *mddev)
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
 				pr_warn("md: kicking non-fresh %s from array!\n",
-					bdevname(rdev->bdev,b));
+					bdevname(rdev->bdev, b));
 				md_kick_rdev_from_array(rdev);
 				continue;
 			}
@@ -3585,11 +3611,13 @@ int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
 {
 	unsigned long result = 0;
 	long decimals = -1;
+
 	while (isdigit(*cp) || (*cp == '.' && decimals < 0)) {
 		if (*cp == '.')
 			decimals = 0;
 		else if (decimals < scale) {
 			unsigned int value;
+
 			value = *cp - '0';
 			result = result * 10 + value;
 			if (decimals >= 0)
@@ -3605,7 +3633,7 @@ int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
 		decimals = 0;
 	while (decimals < scale) {
 		result *= 10;
-		decimals ++;
+		decimals++;
 	}
 	*res = result;
 	return 0;
@@ -3615,6 +3643,7 @@ static ssize_t
 safe_delay_show(struct mddev *mddev, char *page)
 {
 	int msec = (mddev->safemode_delay*1000)/HZ;
+
 	return sprintf(page, "%d.%03d\n", msec/1000, msec%1000);
 }
 static ssize_t
@@ -3644,13 +3673,14 @@ safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
 	return len;
 }
 static struct md_sysfs_entry md_safe_delay =
-__ATTR(safe_mode_delay, S_IRUGO|S_IWUSR,safe_delay_show, safe_delay_store);
+__ATTR(safe_mode_delay, S_IRUGO|S_IWUSR, safe_delay_show, safe_delay_store);
 
 static ssize_t
 level_show(struct mddev *mddev, char *page)
 {
 	struct md_personality *p;
 	int ret;
+
 	spin_lock(&mddev->lock);
 	p = mddev->pers;
 	if (p)
@@ -4104,7 +4134,8 @@ static char *array_states[] = {
 static int match_word(const char *word, char **list)
 {
 	int n;
-	for (n=0; list[n]; n++)
+
+	for (n = 0; list[n]; n++)
 		if (cmd_match(word, list[n]))
 			break;
 	return n;
@@ -4116,7 +4147,7 @@ array_state_show(struct mddev *mddev, char *page)
 	enum array_state st = inactive;
 
 	if (mddev->pers)
-		switch(mddev->ro) {
+		switch (mddev->ro) {
 		case 1:
 			st = readonly;
 			break;
@@ -4181,7 +4212,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 	err = -EINVAL;
-	switch(st) {
+	switch (st) {
 	case bad_word:
 		break;
 	case clear:
@@ -4374,13 +4405,16 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 	/* buf should be <chunk> <chunk> ... or <chunk>-<chunk> ... (range) */
 	while (*buf) {
 		chunk = end_chunk = simple_strtoul(buf, &end, 0);
-		if (buf == end) break;
+		if (buf == end)
+			break;
 		if (*end == '-') { /* range */
 			buf = end + 1;
 			end_chunk = simple_strtoul(buf, &end, 0);
-			if (buf == end) break;
+			if (buf == end)
+				break;
 		}
-		if (*end && !isspace(*end)) break;
+		if (*end && !isspace(*end))
+			break;
 		md_bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
 		buf = skip_spaces(end);
 	}
@@ -4483,6 +4517,7 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
 		size_t namelen = len-9;
+
 		if (namelen >= sizeof(mddev->metadata_type))
 			namelen = sizeof(mddev->metadata_type)-1;
 		strncpy(mddev->metadata_type, buf+9, namelen);
@@ -4497,11 +4532,11 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	major = simple_strtoul(buf, &e, 10);
 	err = -EINVAL;
-	if (e==buf || *e != '.')
+	if (e == buf || *e != '.')
 		goto out_unlock;
 	buf = e+1;
 	minor = simple_strtoul(buf, &e, 10);
-	if (e==buf || (*e && *e != '\n') )
+	if (e == buf || (*e && *e != '\n'))
 		goto out_unlock;
 	err = -ENOENT;
 	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
@@ -4524,6 +4559,7 @@ action_show(struct mddev *mddev, char *page)
 {
 	char *type = "idle";
 	unsigned long recovery = mddev->recovery;
+
 	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
 		type = "frozen";
 	else if (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
@@ -4575,6 +4611,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	} else if (cmd_match(page, "reshape")) {
 		int err;
+
 		if (mddev->pers->start_reshape == NULL)
 			return -EINVAL;
 		err = mddev_lock(mddev);
@@ -4637,7 +4674,7 @@ static ssize_t
 sync_min_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_min(mddev),
-		       mddev->sync_speed_min ? "local": "system");
+		       mddev->sync_speed_min ? "local" : "system");
 }
 
 static ssize_t
@@ -4646,7 +4683,7 @@ sync_min_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned int min;
 	int rv;
 
-	if (strncmp(buf, "system", 6)==0) {
+	if (strncmp(buf, "system", 6) == 0) {
 		min = 0;
 	} else {
 		rv = kstrtouint(buf, 10, &min);
@@ -4666,7 +4703,7 @@ static ssize_t
 sync_max_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_max(mddev),
-		       mddev->sync_speed_max ? "local": "system");
+		       mddev->sync_speed_max ? "local" : "system");
 }
 
 static ssize_t
@@ -4675,7 +4712,7 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned int max;
 	int rv;
 
-	if (strncmp(buf, "system", 6)==0) {
+	if (strncmp(buf, "system", 6) == 0) {
 		max = 0;
 	} else {
 		rv = kstrtouint(buf, 10, &max);
@@ -4732,11 +4769,13 @@ static ssize_t
 sync_speed_show(struct mddev *mddev, char *page)
 {
 	unsigned long resync, dt, db;
+
 	if (mddev->curr_resync == 0)
 		return sprintf(page, "none\n");
 	resync = mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active);
 	dt = (jiffies - mddev->resync_mark) / HZ;
-	if (!dt) dt++;
+	if (!dt)
+		dt++;
 	db = resync - mddev->resync_mark_cnt;
 	return sprintf(page, "%lu\n", db/dt/2); /* K/sec */
 }
@@ -4817,6 +4856,7 @@ static ssize_t
 max_sync_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int err;
+
 	spin_lock(&mddev->lock);
 	if (strncmp(buf, "max", 3) == 0)
 		mddev->resync_max = MaxSector;
@@ -5238,7 +5278,7 @@ static struct kobj_type md_ktype = {
 	.default_attrs	= md_default_attrs,
 };
 
-int mdp_major = 0;
+int mdp_major;
 
 static void mddev_delayed_delete(struct work_struct *ws)
 {
@@ -5303,6 +5343,7 @@ static int md_alloc(dev_t dev, char *name)
 		/* Need to ensure that 'name' is not a duplicate.
 		 */
 		struct mddev *mddev2;
+
 		spin_lock(&all_mddevs_lock);
 
 		list_for_each_entry(mddev2, &all_mddevs, all_mddevs)
@@ -5577,8 +5618,8 @@ int md_run(struct mddev *mddev)
 				    rdev2->bdev->bd_contains) {
 					pr_warn("%s: WARNING: %s appears to be on the same physical disk as %s.\n",
 						mdname(mddev),
-						bdevname(rdev->bdev,b),
-						bdevname(rdev2->bdev,b2));
+						bdevname(rdev->bdev, b),
+						bdevname(rdev2->bdev, b2));
 					warned = 1;
 				}
 			}
@@ -5664,7 +5705,7 @@ int md_run(struct mddev *mddev)
 	if (mddev_is_clustered(mddev))
 		mddev->safemode_delay = 0;
 	else
-		mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
+		mddev->safemode_delay = (200 * HZ)/1000 + 1; /* 200 msec delay */
 	mddev->in_sync = 1;
 	smp_wmb();
 	spin_lock(&mddev->lock);
@@ -5696,7 +5737,7 @@ int md_run(struct mddev *mddev)
 		mempool_destroy(mddev->flush_bio_pool);
 		mddev->flush_bio_pool = NULL;
 	}
-	if (mddev->flush_pool){
+	if (mddev->flush_pool) {
 		mempool_destroy(mddev->flush_pool);
 		mddev->flush_pool = NULL;
 	}
@@ -5891,6 +5932,7 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
+
 	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
@@ -5956,7 +5998,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
 	    mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		pr_warn("md: %s still in use.\n",mdname(mddev));
+		pr_warn("md: %s still in use.\n", mdname(mddev));
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -5969,7 +6011,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 		__md_stop_writes(mddev);
 
 		err  = -ENXIO;
-		if (mddev->ro==1)
+		if (mddev->ro == 1)
 			goto out;
 		mddev->ro = 1;
 		set_disk_ro(mddev->gendisk, 1);
@@ -6018,7 +6060,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	    mddev->sysfs_active ||
 	    mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		pr_warn("md: %s still in use.\n",mdname(mddev));
+		pr_warn("md: %s still in use.\n", mdname(mddev));
 		mutex_unlock(&mddev->open_mutex);
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -6059,6 +6101,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
+
 			spin_lock(&mddev->lock);
 			mddev->bitmap_info.file = NULL;
 			spin_unlock(&mddev->lock);
@@ -6090,7 +6133,8 @@ static void autorun_array(struct mddev *mddev)
 
 	rdev_for_each(rdev, mddev) {
 		char b[BDEVNAME_SIZE];
-		pr_cont("<%s>", bdevname(rdev->bdev,b));
+
+		pr_cont("<%s>", bdevname(rdev->bdev, b));
 	}
 	pr_cont("\n");
 
@@ -6124,15 +6168,16 @@ static void autorun_devices(int part)
 		int unit;
 		dev_t dev;
 		LIST_HEAD(candidates);
+
 		rdev0 = list_entry(pending_raid_disks.next,
 					 struct md_rdev, same_set);
 
-		pr_debug("md: considering %s ...\n", bdevname(rdev0->bdev,b));
+		pr_debug("md: considering %s ...\n", bdevname(rdev0->bdev, b));
 		INIT_LIST_HEAD(&candidates);
 		rdev_for_each_list(rdev, tmp, &pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				pr_debug("md:  adding %s ...\n",
-					 bdevname(rdev->bdev,b));
+					 bdevname(rdev->bdev, b));
 				list_move(&rdev->same_set, &candidates);
 			}
 		/*
@@ -6166,7 +6211,7 @@ static void autorun_devices(int part)
 		else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
 			pr_warn("md: %s already running, cannot run %s\n",
-				mdname(mddev), bdevname(rdev0->bdev,b));
+				mdname(mddev), bdevname(rdev0->bdev, b));
 			mddev_unlock(mddev);
 		} else {
 			pr_debug("md: created %s\n", mdname(mddev));
@@ -6209,7 +6254,7 @@ static int get_version(void __user *arg)
 static int get_array_info(struct mddev *mddev, void __user *arg)
 {
 	mdu_array_info_t info;
-	int nr,working,insync,failed,spare;
+	int nr, working, insync, failed, spare;
 	struct md_rdev *rdev;
 
 	nr = working = insync = failed = spare = 0;
@@ -6242,7 +6287,7 @@ static int get_array_info(struct mddev *mddev, void __user *arg)
 	info.nr_disks      = nr;
 	info.raid_disks    = mddev->raid_disks;
 	info.md_minor      = mddev->md_minor;
-	info.not_persistent= !mddev->persistent;
+	info.not_persistent = !mddev->persistent;
 
 	info.utime         = clamp_t(time64_t, mddev->utime, 0, U32_MAX);
 	info.state         = 0;
@@ -6266,7 +6311,7 @@ static int get_array_info(struct mddev *mddev, void __user *arg)
 	return 0;
 }
 
-static int get_bitmap_file(struct mddev *mddev, void __user * arg)
+static int get_bitmap_file(struct mddev *mddev, void __user *arg)
 {
 	mdu_bitmap_file_t *file = NULL; /* too big for stack allocation */
 	char *ptr;
@@ -6298,7 +6343,7 @@ static int get_bitmap_file(struct mddev *mddev, void __user * arg)
 	return err;
 }
 
-static int get_disk_info(struct mddev *mddev, void __user * arg)
+static int get_disk_info(struct mddev *mddev, void __user *arg)
 {
 	mdu_disk_info_t info;
 	struct md_rdev *rdev;
@@ -6342,7 +6387,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 {
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
-	dev_t dev = MKDEV(info->major,info->minor);
+	dev_t dev = MKDEV(info->major, info->minor);
 
 	if (mddev_is_clustered(mddev) &&
 		!(info->state & ((1 << MD_DISK_CLUSTER_ADD) | (1 << MD_DISK_CANDIDATE)))) {
@@ -6371,8 +6416,8 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 				.load_super(rdev, rdev0, mddev->minor_version);
 			if (err < 0) {
 				pr_warn("md: %s has different UUID to %s\n",
-					bdevname(rdev->bdev,b),
-					bdevname(rdev0->bdev,b2));
+					bdevname(rdev->bdev, b),
+					bdevname(rdev0->bdev, b2));
 				export_rdev(rdev);
 				return -EINVAL;
 			}
@@ -6390,6 +6435,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 	 */
 	if (mddev->pers) {
 		int err;
+
 		if (!mddev->pers->hot_add_disk) {
 			pr_warn("%s: personality does not support diskops!\n",
 				mdname(mddev));
@@ -6507,6 +6553,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 
 	if (!(info->state & (1<<MD_DISK_FAULTY))) {
 		int err;
+
 		rdev = md_import_device(dev, -1, 0);
 		if (IS_ERR(rdev)) {
 			pr_warn("md: error, md_import_device() returned %ld\n",
@@ -6581,7 +6628,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	return 0;
 busy:
 	pr_debug("md: cannot remove active disk %s from %s ...\n",
-		 bdevname(rdev->bdev,b), mdname(mddev));
+		 bdevname(rdev->bdev, b), mdname(mddev));
 	return -EBUSY;
 }
 
@@ -6621,7 +6668,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		pr_warn("md: can not hot-add faulty %s disk to %s!\n",
-			bdevname(rdev->bdev,b), mdname(mddev));
+			bdevname(rdev->bdev, b), mdname(mddev));
 		err = -EINVAL;
 		goto abort_export;
 	}
@@ -6730,6 +6777,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	}
 	if (fd < 0) {
 		struct file *f = mddev->bitmap_info.file;
+
 		if (f) {
 			spin_lock(&mddev->lock);
 			mddev->bitmap_info.file = NULL;
@@ -6793,7 +6841,7 @@ static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		mddev->recovery_cp = MaxSector;
 	else
 		mddev->recovery_cp = 0;
-	mddev->persistent    = ! info->not_persistent;
+	mddev->persistent    = !info->not_persistent;
 	mddev->external	     = 0;
 
 	mddev->layout        = info->layout;
@@ -7229,6 +7277,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 
 	if (cmd == SET_ARRAY_INFO) {
 		mdu_array_info_t info;
+
 		if (!arg)
 			memset(&info, 0, sizeof(info));
 		else if (copy_from_user(&info, argp, sizeof(info))) {
@@ -7301,6 +7350,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		 */
 		if (mddev->pers) {
 			mdu_disk_info_t info;
+
 			if (copy_from_user(&info, argp, sizeof(info)))
 				err = -EFAULT;
 			else if (!(info.state & (1<<MD_DISK_SYNC)))
@@ -7372,6 +7422,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	case ADD_NEW_DISK:
 	{
 		mdu_disk_info_t info;
+
 		if (copy_from_user(&info, argp, sizeof(info)))
 			err = -EFAULT;
 		else
@@ -7409,7 +7460,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		mddev->hold_active = 0;
 	mddev_unlock(mddev);
 out:
-	if(did_set_md_closing)
+	if (did_set_md_closing)
 		clear_bit(MD_CLOSING, &mddev->flags);
 	return err;
 }
@@ -7500,8 +7551,8 @@ static int md_revalidate(struct gendisk *disk)
 	mddev->changed = 0;
 	return 0;
 }
-static const struct block_device_operations md_fops =
-{
+static const struct block_device_operations md_fops = {
+
 	.owner		= THIS_MODULE,
 	.open		= md_open,
 	.release	= md_release,
@@ -7511,7 +7562,7 @@ static const struct block_device_operations md_fops =
 #endif
 	.getgeo		= md_getgeo,
 	.media_changed  = md_media_changed,
-	.revalidate_disk= md_revalidate,
+	.revalidate_disk = md_revalidate,
 };
 
 static int md_thread(void *arg)
@@ -7596,6 +7647,7 @@ EXPORT_SYMBOL(md_register_thread);
 void md_unregister_thread(struct md_thread **threadp)
 {
 	struct md_thread *thread = *threadp;
+
 	if (!thread)
 		return;
 	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
@@ -7618,7 +7670,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (!mddev->pers || !mddev->pers->error_handler)
 		return;
-	mddev->pers->error_handler(mddev,rdev);
+	mddev->pers->error_handler(mddev, rdev);
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
@@ -7638,18 +7690,19 @@ static void status_unused(struct seq_file *seq)
 	int i = 0;
 	struct md_rdev *rdev;
 
-	seq_printf(seq, "unused devices: ");
+	seq_puts(seq, "unused devices: ");
 
 	list_for_each_entry(rdev, &pending_raid_disks, same_set) {
 		char b[BDEVNAME_SIZE];
+
 		i++;
 		seq_printf(seq, "%s ",
-			      bdevname(rdev->bdev,b));
+			      bdevname(rdev->bdev, b));
 	}
 	if (!i)
-		seq_printf(seq, "<none>");
+		seq_puts(seq, "<none>");
 
-	seq_printf(seq, "\n");
+	seq_puts(seq, "\n");
 }
 
 static int status_resync(struct seq_file *seq, struct mddev *mddev)
@@ -7685,23 +7738,23 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 				    !test_bit(Faulty, &rdev->flags) &&
 				    rdev->recovery_offset != MaxSector &&
 				    rdev->recovery_offset) {
-					seq_printf(seq, "\trecover=REMOTE");
+					seq_puts(seq, "\trecover=REMOTE");
 					return 1;
 				}
 			if (mddev->reshape_position != MaxSector)
-				seq_printf(seq, "\treshape=REMOTE");
+				seq_puts(seq, "\treshape=REMOTE");
 			else
-				seq_printf(seq, "\tresync=REMOTE");
+				seq_puts(seq, "\tresync=REMOTE");
 			return 1;
 		}
 		if (mddev->recovery_cp < MaxSector) {
-			seq_printf(seq, "\tresync=PENDING");
+			seq_puts(seq, "\tresync=PENDING");
 			return 1;
 		}
 		return 0;
 	}
 	if (resync < 3) {
-		seq_printf(seq, "\tresync=DELAYED");
+		seq_puts(seq, "\tresync=DELAYED");
 		return 1;
 	}
 
@@ -7713,7 +7766,7 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	 */
 	scale = 10;
 	if (sizeof(sector_t) > sizeof(unsigned long)) {
-		while ( max_sectors/2 > (1ULL<<(scale+32)))
+		while (max_sectors/2 > (1ULL<<(scale+32)))
 			scale++;
 	}
 	res = (resync>>scale)*1000;
@@ -7722,18 +7775,19 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	per_milli = res;
 	{
 		int i, x = per_milli/50, y = 20-x;
-		seq_printf(seq, "[");
+
+		seq_puts(seq, "[");
 		for (i = 0; i < x; i++)
-			seq_printf(seq, "=");
-		seq_printf(seq, ">");
+			seq_puts(seq, "=");
+		seq_puts(seq, ">");
 		for (i = 0; i < y; i++)
-			seq_printf(seq, ".");
-		seq_printf(seq, "] ");
+			seq_puts(seq, ".");
+		seq_puts(seq, "] ");
 	}
 	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
-		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)?
+		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
 		    "reshape" :
-		    (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)?
+		    (test_bit(MD_RECOVERY_CHECK, &mddev->recovery) ?
 		     "check" :
 		     (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
 		      "resync" : "recovery"))),
@@ -7756,7 +7810,8 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	 * The '+1' avoids division by zero if db is very small.
 	 */
 	dt = ((jiffies - mddev->resync_mark) / HZ);
-	if (!dt) dt++;
+	if (!dt)
+		dt++;
 	db = (mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active))
 		- mddev->resync_mark_cnt;
 
@@ -7782,10 +7837,10 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 		return NULL;
 	if (!l--)
 		/* header */
-		return (void*)1;
+		return (void *)1;
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each(tmp,&all_mddevs)
+	list_for_each(tmp, &all_mddevs)
 		if (!l--) {
 			mddev = list_entry(tmp, struct mddev, all_mddevs);
 			mddev_get(mddev);
@@ -7794,7 +7849,7 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 		}
 	spin_unlock(&all_mddevs_lock);
 	if (!l--)
-		return (void*)2;/* tail */
+		return (void *)2;/* tail */
 	return NULL;
 }
 
@@ -7804,23 +7859,23 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct mddev *next_mddev, *mddev = v;
 
 	++*pos;
-	if (v == (void*)2)
+	if (v == (void *)2)
 		return NULL;
 
 	spin_lock(&all_mddevs_lock);
-	if (v == (void*)1)
+	if (v == (void *)1)
 		tmp = all_mddevs.next;
 	else
 		tmp = mddev->all_mddevs.next;
 	if (tmp != &all_mddevs)
-		next_mddev = mddev_get(list_entry(tmp,struct mddev,all_mddevs));
+		next_mddev = mddev_get(list_entry(tmp, struct mddev, all_mddevs));
 	else {
-		next_mddev = (void*)2;
+		next_mddev = (void *)2;
 		*pos = 0x10000;
 	}
 	spin_unlock(&all_mddevs_lock);
 
-	if (v != (void*)1)
+	if (v != (void *)1)
 		mddev_put(mddev);
 	return next_mddev;
 
@@ -7830,7 +7885,7 @@ static void md_seq_stop(struct seq_file *seq, void *v)
 {
 	struct mddev *mddev = v;
 
-	if (mddev && v != (void*)1 && v != (void*)2)
+	if (mddev && v != (void *)1 && v != (void *)2)
 		mddev_put(mddev);
 }
 
@@ -7840,19 +7895,20 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	sector_t sectors;
 	struct md_rdev *rdev;
 
-	if (v == (void*)1) {
+	if (v == (void *)1) {
 		struct md_personality *pers;
-		seq_printf(seq, "Personalities : ");
+
+		seq_puts(seq, "Personalities : ");
 		spin_lock(&pers_lock);
 		list_for_each_entry(pers, &pers_list, list)
 			seq_printf(seq, "[%s] ", pers->name);
 
 		spin_unlock(&pers_lock);
-		seq_printf(seq, "\n");
+		seq_puts(seq, "\n");
 		seq->poll_event = atomic_read(&md_event_count);
 		return 0;
 	}
-	if (v == (void*)2) {
+	if (v == (void *)2) {
 		status_unused(seq);
 		return 0;
 	}
@@ -7862,10 +7918,10 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%s : %sactive", mdname(mddev),
 						mddev->pers ? "" : "in");
 		if (mddev->pers) {
-			if (mddev->ro==1)
-				seq_printf(seq, " (read-only)");
-			if (mddev->ro==2)
-				seq_printf(seq, " (auto-read-only)");
+			if (mddev->ro == 1)
+				seq_puts(seq, " (read-only)");
+			if (mddev->ro == 2)
+				seq_puts(seq, " (auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
@@ -7873,20 +7929,21 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev) {
 			char b[BDEVNAME_SIZE];
+
 			seq_printf(seq, " %s[%d]",
-				bdevname(rdev->bdev,b), rdev->desc_nr);
+				bdevname(rdev->bdev, b), rdev->desc_nr);
 			if (test_bit(WriteMostly, &rdev->flags))
-				seq_printf(seq, "(W)");
+				seq_puts(seq, "(W)");
 			if (test_bit(Journal, &rdev->flags))
-				seq_printf(seq, "(J)");
+				seq_puts(seq, "(J)");
 			if (test_bit(Faulty, &rdev->flags)) {
-				seq_printf(seq, "(F)");
+				seq_puts(seq, "(F)");
 				continue;
 			}
 			if (rdev->raid_disk < 0)
-				seq_printf(seq, "(S)"); /* spare */
+				seq_puts(seq, "(S)"); /* spare */
 			if (test_bit(Replacement, &rdev->flags))
-				seq_printf(seq, "(R)");
+				seq_puts(seq, "(R)");
 			sectors += rdev->sectors;
 		}
 		rcu_read_unlock();
@@ -7903,7 +7960,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		if (mddev->persistent) {
 			if (mddev->major_version != 0 ||
 			    mddev->minor_version != 90) {
-				seq_printf(seq," super %d.%d",
+				seq_printf(seq, " super %d.%d",
 					   mddev->major_version,
 					   mddev->minor_version);
 			}
@@ -7911,21 +7968,21 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, " super external:%s",
 				   mddev->metadata_type);
 		else
-			seq_printf(seq, " super non-persistent");
+			seq_puts(seq, " super non-persistent");
 
 		if (mddev->pers) {
 			mddev->pers->status(seq, mddev);
-			seq_printf(seq, "\n      ");
+			seq_puts(seq, "\n      ");
 			if (mddev->pers->sync_request) {
 				if (status_resync(seq, mddev))
-					seq_printf(seq, "\n      ");
+					seq_puts(seq, "\n      ");
 			}
 		} else
-			seq_printf(seq, "\n       ");
+			seq_puts(seq, "\n       ");
 
 		md_bitmap_status(seq, mddev->bitmap);
 
-		seq_printf(seq, "\n");
+		seq_puts(seq, "\n");
 	}
 	spin_unlock(&mddev->lock);
 
@@ -8005,6 +8062,7 @@ int register_md_cluster_operations(struct md_cluster_operations *ops,
 				   struct module *module)
 {
 	int ret = 0;
+
 	spin_lock(&pers_lock);
 	if (md_cluster_ops != NULL)
 		ret = -EALREADY;
@@ -8060,6 +8118,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
+
 		curr_events = (int)part_stat_read_accum(&disk->part0, sectors) -
 			      atomic_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
@@ -8240,11 +8299,11 @@ void md_do_sync(struct md_thread *thread)
 	struct mddev *mddev2;
 	unsigned int currspeed = 0,
 		 window;
-	sector_t max_sectors,j, io_sectors, recovery_done;
+	sector_t max_sectors, j, io_sectors, recovery_done;
 	unsigned long mark[SYNC_MARKS];
 	unsigned long update_time;
 	sector_t mark_cnt[SYNC_MARKS];
-	int last_mark,m;
+	int last_mark, m;
 	struct list_head *tmp;
 	sector_t last_check;
 	int skipped = 0;
@@ -8310,9 +8369,10 @@ void md_do_sync(struct md_thread *thread)
 
 	do {
 		int mddev2_minor = -1;
+
 		mddev->curr_resync = 2;
 
-	try_again:
+try_again:
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto skip;
 		for_each_mddev(mddev2, tmp) {
@@ -8322,6 +8382,7 @@ void md_do_sync(struct md_thread *thread)
 			&&  mddev2->curr_resync
 			&&  match_mddev_units(mddev, mddev2)) {
 				DEFINE_WAIT(wq);
+
 				if (mddev < mddev2 && mddev->curr_resync == 2) {
 					/* arbitrarily yield */
 					mddev->curr_resync = 1;
@@ -8426,7 +8487,7 @@ void md_do_sync(struct md_thread *thread)
 	atomic_set(&mddev->recovery_active, 0);
 	last_check = 0;
 
-	if (j>2) {
+	if (j > 2) {
 		pr_debug("md: resuming %s of %s from checkpoint.\n",
 			 desc, mdname(mddev));
 		mddev->curr_resync = j;
@@ -8511,8 +8572,8 @@ void md_do_sync(struct md_thread *thread)
 			continue;
 
 		last_check = io_sectors;
-	repeat:
-		if (time_after_eq(jiffies, mark[last_mark] + SYNC_MARK_STEP )) {
+repeat:
+		if (time_after_eq(jiffies, mark[last_mark] + SYNC_MARK_STEP)) {
 			/* step marks */
 			int next = (last_mark+1) % SYNC_MARKS;
 
@@ -8538,7 +8599,7 @@ void md_do_sync(struct md_thread *thread)
 
 		recovery_done = io_sectors - atomic_read(&mddev->recovery_active);
 		currspeed = ((unsigned long)(recovery_done - mddev->resync_mark_cnt))/2
-			/((jiffies-mddev->resync_mark)/HZ +1) +1;
+			/((jiffies-mddev->resync_mark)/HZ + 1) + 1;
 
 		if (currspeed > speed_min(mddev)) {
 			if (currspeed > speed_max(mddev)) {
@@ -8555,7 +8616,7 @@ void md_do_sync(struct md_thread *thread)
 			}
 		}
 	}
-	pr_info("md: %s: %s %s.\n",mdname(mddev), desc,
+	pr_info("md: %s: %s %s.\n", mdname(mddev), desc,
 		test_bit(MD_RECOVERY_INTR, &mddev->recovery)
 		? "interrupted" : "done");
 	/*
@@ -8662,7 +8723,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 		    rdev->raid_disk >= 0 &&
 		    !test_bit(Blocked, &rdev->flags) &&
 		    test_bit(Faulty, &rdev->flags) &&
-		    atomic_read(&rdev->nr_pending)==0) {
+		    atomic_read(&rdev->nr_pending) == 0) {
 			/* Faulty non-Blocked devices with nr_pending == 0
 			 * never get nr_pending incremented,
 			 * never get Faulty cleared, and never get Blocked set.
@@ -8682,7 +8743,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 		    ((test_bit(RemoveSynchronized, &rdev->flags) ||
 		     (!test_bit(In_sync, &rdev->flags) &&
 		      !test_bit(Journal, &rdev->flags))) &&
-		    atomic_read(&rdev->nr_pending)==0)) {
+		    atomic_read(&rdev->nr_pending) == 0)) {
 			if (mddev->pers->hot_remove_disk(
 				    mddev, rdev) == 0) {
 				sysfs_unlink_rdev(mddev, rdev);
@@ -8717,7 +8778,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			continue;
 		if (!test_bit(Journal, &rdev->flags)) {
 			if (mddev->ro &&
-			    ! (rdev->saved_raid_disk >= 0 &&
+			    !(rdev->saved_raid_disk >= 0 &&
 			       !test_bit(Bitmap_sync, &rdev->flags)))
 				continue;
 
@@ -8807,8 +8868,8 @@ void md_check_recovery(struct mddev *mddev)
 
 	if (mddev->ro && !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return;
-	if ( ! (
-		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
+	if ( !(
+		(mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING)) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		(mddev->external == 0 && mddev->safemode == 1) ||
@@ -8825,6 +8886,7 @@ void md_check_recovery(struct mddev *mddev)
 
 		if (mddev->ro) {
 			struct md_rdev *rdev;
+
 			if (!mddev->external && mddev->in_sync)
 				/* 'Blocked' flag not needed as failed devices
 				 * will be recorded if array switched to read/write.
@@ -8937,7 +8999,7 @@ void md_check_recovery(struct mddev *mddev)
 			queue_work(md_misc_wq, &mddev->del_work);
 			goto unlock;
 		}
-	not_running:
+not_running:
 		if (!mddev->sync_thread) {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 			wake_up(&resync_wait);
@@ -8946,7 +9008,7 @@ void md_check_recovery(struct mddev *mddev)
 				if (mddev->sysfs_action)
 					sysfs_notify_dirent_safe(mddev->sysfs_action);
 		}
-	unlock:
+unlock:
 		wake_up(&mddev->sb_wait);
 		mddev_unlock(mddev);
 	} else if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags) && mddev->sb_flags) {
@@ -9046,6 +9108,7 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 {
 	struct mddev *mddev = rdev->mddev;
 	int rv;
+
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
@@ -9070,6 +9133,7 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 			 int is_new)
 {
 	int rv;
+
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
@@ -9135,10 +9199,12 @@ static int __init md_init(void)
 	if (!md_misc_wq)
 		goto err_misc_wq;
 
-	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)
+	ret = register_blkdev(MD_MAJOR, "md");
+	if (ret < 0)
 		goto err_md;
 
-	if ((ret = register_blkdev(0, "mdp")) < 0)
+	ret = register_blkdev(0, "mdp");
+	if (ret < 0)
 		goto err_mdp;
 	mdp_major = ret;
 
@@ -9192,11 +9258,10 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 
 		if (test_bit(Candidate, &rdev2->flags)) {
 			if (role == 0xfffe) {
-				pr_info("md: Removing Candidate device %s because add failed\n", bdevname(rdev2->bdev,b));
+				pr_info("md: Removing Candidate device %s because add failed\n", bdevname(rdev2->bdev, b));
 				md_kick_rdev_from_array(rdev2);
 				continue;
-			}
-			else
+			} else
 				clear_bit(Candidate, &rdev2->flags);
 		}
 
@@ -9206,7 +9271,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 				rdev2->saved_raid_disk = role;
 				ret = remove_and_add_spares(mddev, rdev2);
 				pr_info("Activated spare: %s\n",
-					bdevname(rdev2->bdev,b));
+					bdevname(rdev2->bdev, b));
 				/* wakeup mddev->thread here, so array could
 				 * perform resync with the new activated disk */
 				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -9357,7 +9422,7 @@ static void autostart_arrays(int part)
 		dev = node_detected_dev->dev;
 		kfree(node_detected_dev);
 		mutex_unlock(&detected_devices_mutex);
-		rdev = md_import_device(dev,0, 90);
+		rdev = md_import_device(dev, 0, 90);
 		mutex_lock(&detected_devices_mutex);
 		if (IS_ERR(rdev))
 			continue;
@@ -9384,10 +9449,10 @@ static __exit void md_exit(void)
 	struct list_head *tmp;
 	int delay = 1;
 
-	blk_unregister_region(MKDEV(MD_MAJOR,0), 512);
-	blk_unregister_region(MKDEV(mdp_major,0), 1U << MINORBITS);
+	blk_unregister_region(MKDEV(MD_MAJOR, 0), 512);
+	blk_unregister_region(MKDEV(mdp_major, 0), 1U << MINORBITS);
 
-	unregister_blkdev(MD_MAJOR,"md");
+	unregister_blkdev(MD_MAJOR, "md");
 	unregister_blkdev(mdp_major, "mdp");
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
-- 
2.19.0
