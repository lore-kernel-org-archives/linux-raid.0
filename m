From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/23] md: tidy up rdev_for_each usage.
Date: Wed, 14 Mar 2012 15:40:40 +1100
Message-ID: <20120314044040.7978.26714.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

md.h has an 'rdev_for_each()' macro for iterating the rdevs in an
mddev.  However it uses the 'safe' version of list_for_each_entry,
and so requires the extra variable, but doesn't include 'safe' in the
name, which is useful documentation.

Consequently some places use this safe version without needing it, and
many use an explicity list_for_each entry.

So:
 - rename rdev_for_each to rdev_for_each_safe
 - create a new rdev_for_each which uses the plain
   list_for_each_entry,
 - use the 'safe' version only where needed, and convert all other
   list_for_each_entry calls to use rdev_for_each.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c    |    2 +
 drivers/md/dm-raid.c   |   16 +++++-----
 drivers/md/faulty.c    |    2 +
 drivers/md/linear.c    |    2 +
 drivers/md/md.c        |   74 ++++++++++++++++++++++++------------------------
 drivers/md/md.h        |    5 +++
 drivers/md/multipath.c |    2 +
 drivers/md/raid0.c     |   10 +++---
 drivers/md/raid1.c     |    4 +--
 drivers/md/raid10.c    |    4 +--
 drivers/md/raid5.c     |    8 +++--
 11 files changed, 66 insertions(+), 63 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 239af9a..2c5dbc6 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -171,7 +171,7 @@ static struct page *read_sb_page(struct mddev *mddev, loff_t offset,
 		did_alloc = 1;
 	}
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (! test_bit(In_sync, &rdev->flags)
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 787022c..c5a875d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -615,14 +615,14 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 
 static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 {
-	struct md_rdev *r, *t;
+	struct md_rdev *r;
 	uint64_t failed_devices;
 	struct dm_raid_superblock *sb;
 
 	sb = page_address(rdev->sb_page);
 	failed_devices = le64_to_cpu(sb->failed_devices);
 
-	rdev_for_each(r, t, mddev)
+	rdev_for_each(r, mddev)
 		if ((r->raid_disk >= 0) && test_bit(Faulty, &r->flags))
 			failed_devices |= (1ULL << r->raid_disk);
 
@@ -707,7 +707,7 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 	struct dm_raid_superblock *sb;
 	uint32_t new_devs = 0;
 	uint32_t rebuilds = 0;
-	struct md_rdev *r, *t;
+	struct md_rdev *r;
 	struct dm_raid_superblock *sb2;
 
 	sb = page_address(rdev->sb_page);
@@ -750,7 +750,7 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 	 *    case the In_sync bit will /not/ be set and
 	 *    recovery_cp must be MaxSector.
 	 */
-	rdev_for_each(r, t, mddev) {
+	rdev_for_each(r, mddev) {
 		if (!test_bit(In_sync, &r->flags)) {
 			DMINFO("Device %d specified for rebuild: "
 			       "Clearing superblock", r->raid_disk);
@@ -782,7 +782,7 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 	 * Now we set the Faulty bit for those devices that are
 	 * recorded in the superblock as failed.
 	 */
-	rdev_for_each(r, t, mddev) {
+	rdev_for_each(r, mddev) {
 		if (!r->sb_page)
 			continue;
 		sb2 = page_address(r->sb_page);
@@ -855,11 +855,11 @@ static int super_validate(struct mddev *mddev, struct md_rdev *rdev)
 static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 {
 	int ret;
-	struct md_rdev *rdev, *freshest, *tmp;
+	struct md_rdev *rdev, *freshest;
 	struct mddev *mddev = &rs->md;
 
 	freshest = NULL;
-	rdev_for_each(rdev, tmp, mddev) {
+	rdev_for_each(rdev, mddev) {
 		if (!rdev->meta_bdev)
 			continue;
 
@@ -888,7 +888,7 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 	if (super_validate(mddev, freshest))
 		return -EINVAL;
 
-	rdev_for_each(rdev, tmp, mddev)
+	rdev_for_each(rdev, mddev)
 		if ((rdev != freshest) && super_validate(mddev, rdev))
 			return -EINVAL;
 
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index feb2c3c..45135f6 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -315,7 +315,7 @@ static int run(struct mddev *mddev)
 	}
 	conf->nfaults = 0;
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		conf->rdev = rdev;
 
 	md_set_array_sectors(mddev, faulty_size(mddev, 0, 0));
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 6274565..6794074 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -138,7 +138,7 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 	cnt = 0;
 	conf->array_sectors = 0;
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		int j = rdev->raid_disk;
 		struct dev_info *disk = conf->disks + j;
 		sector_t sectors;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f494e79..84796a5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -439,7 +439,7 @@ static void submit_flushes(struct work_struct *ws)
 	INIT_WORK(&mddev->flush_work, md_submit_flush_data);
 	atomic_set(&mddev->flush_pending, 1);
 	rcu_read_lock();
-	list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
+	rdev_for_each_rcu(rdev, mddev)
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(Faulty, &rdev->flags)) {
 			/* Take two references, one is dropped
@@ -749,7 +749,7 @@ static struct md_rdev * find_rdev_nr(struct mddev *mddev, int nr)
 {
 	struct md_rdev *rdev;
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		if (rdev->desc_nr == nr)
 			return rdev;
 
@@ -760,7 +760,7 @@ static struct md_rdev * find_rdev(struct mddev * mddev, dev_t dev)
 {
 	struct md_rdev *rdev;
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		if (rdev->bdev->bd_dev == dev)
 			return rdev;
 
@@ -1342,7 +1342,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
 
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
-	list_for_each_entry(rdev2, &mddev->disks, same_set) {
+	rdev_for_each(rdev2, mddev) {
 		mdp_disk_t *d;
 		int desc_nr;
 		int is_active = test_bit(In_sync, &rdev2->flags);
@@ -1816,7 +1816,7 @@ retry:
 	}
 
 	max_dev = 0;
-	list_for_each_entry(rdev2, &mddev->disks, same_set)
+	rdev_for_each(rdev2, mddev)
 		if (rdev2->desc_nr+1 > max_dev)
 			max_dev = rdev2->desc_nr+1;
 
@@ -1833,7 +1833,7 @@ retry:
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	
-	list_for_each_entry(rdev2, &mddev->disks, same_set) {
+	rdev_for_each(rdev2, mddev) {
 		i = rdev2->desc_nr;
 		if (test_bit(Faulty, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
@@ -1948,7 +1948,7 @@ int md_integrity_register(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (!mddev->gendisk || blk_get_integrity(mddev->gendisk))
 		return 0; /* shouldn't register, or already is */
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		/* skip spares and non-functional disks */
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
@@ -2175,7 +2175,7 @@ static void export_array(struct mddev *mddev)
 {
 	struct md_rdev *rdev, *tmp;
 
-	rdev_for_each(rdev, tmp, mddev) {
+	rdev_for_each_safe(rdev, tmp, mddev) {
 		if (!rdev->mddev) {
 			MD_BUG();
 			continue;
@@ -2307,11 +2307,11 @@ static void md_print_devices(void)
 			bitmap_print_sb(mddev->bitmap);
 		else
 			printk("%s: ", mdname(mddev));
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+		rdev_for_each(rdev, mddev)
 			printk("<%s>", bdevname(rdev->bdev,b));
 		printk("\n");
 
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+		rdev_for_each(rdev, mddev)
 			print_rdev(rdev, mddev->major_version);
 	}
 	printk("md:	**********************************\n");
@@ -2328,7 +2328,7 @@ static void sync_sbs(struct mddev * mddev, int nospares)
 	 * with the rest of the array)
 	 */
 	struct md_rdev *rdev;
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (rdev->sb_events == mddev->events ||
 		    (nospares &&
 		     rdev->raid_disk < 0 &&
@@ -2351,7 +2351,7 @@ static void md_update_sb(struct mddev * mddev, int force_change)
 
 repeat:
 	/* First make sure individual recovery_offsets are correct */
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk >= 0 &&
 		    mddev->delta_disks >= 0 &&
 		    !test_bit(In_sync, &rdev->flags) &&
@@ -2364,7 +2364,7 @@ repeat:
 		clear_bit(MD_CHANGE_DEVS, &mddev->flags);
 		if (!mddev->external) {
 			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
-			list_for_each_entry(rdev, &mddev->disks, same_set) {
+			rdev_for_each(rdev, mddev) {
 				if (rdev->badblocks.changed) {
 					md_ack_all_badblocks(&rdev->badblocks);
 					md_error(mddev, rdev, 0);
@@ -2430,7 +2430,7 @@ repeat:
 		mddev->events --;
 	}
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (rdev->badblocks.changed)
 			any_badblocks_changed++;
 		if (test_bit(Faulty, &rdev->flags))
@@ -2444,7 +2444,7 @@ repeat:
 		 mdname(mddev), mddev->in_sync);
 
 	bitmap_update_sb(mddev->bitmap);
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		char b[BDEVNAME_SIZE];
 
 		if (rdev->sb_loaded != 1)
@@ -2493,7 +2493,7 @@ repeat:
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (test_and_clear_bit(FaultRecorded, &rdev->flags))
 			clear_bit(Blocked, &rdev->flags);
 
@@ -2896,7 +2896,7 @@ rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 			struct md_rdev *rdev2;
 
 			mddev_lock(mddev);
-			list_for_each_entry(rdev2, &mddev->disks, same_set)
+			rdev_for_each(rdev2, mddev)
 				if (rdev->bdev == rdev2->bdev &&
 				    rdev != rdev2 &&
 				    overlaps(rdev->data_offset, rdev->sectors,
@@ -3193,7 +3193,7 @@ static void analyze_sbs(struct mddev * mddev)
 	char b[BDEVNAME_SIZE];
 
 	freshest = NULL;
-	rdev_for_each(rdev, tmp, mddev)
+	rdev_for_each_safe(rdev, tmp, mddev)
 		switch (super_types[mddev->major_version].
 			load_super(rdev, freshest, mddev->minor_version)) {
 		case 1:
@@ -3214,7 +3214,7 @@ static void analyze_sbs(struct mddev * mddev)
 		validate_super(mddev, freshest);
 
 	i = 0;
-	rdev_for_each(rdev, tmp, mddev) {
+	rdev_for_each_safe(rdev, tmp, mddev) {
 		if (mddev->max_disks &&
 		    (rdev->desc_nr >= mddev->max_disks ||
 		     i > mddev->max_disks)) {
@@ -3403,7 +3403,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EINVAL;
 	}
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		rdev->new_raid_disk = rdev->raid_disk;
 
 	/* ->takeover must set new_* and/or delta_disks
@@ -3456,7 +3456,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->safemode = 0;
 	}
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk < 0)
 			continue;
 		if (rdev->new_raid_disk >= mddev->raid_disks)
@@ -3465,7 +3465,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 			continue;
 		sysfs_unlink_rdev(mddev, rdev);
 	}
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk < 0)
 			continue;
 		if (rdev->new_raid_disk == rdev->raid_disk)
@@ -4796,7 +4796,7 @@ int md_run(struct mddev *mddev)
 	 * the only valid external interface is through the md
 	 * device.
 	 */
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		sync_blockdev(rdev->bdev);
@@ -4867,8 +4867,8 @@ int md_run(struct mddev *mddev)
 		struct md_rdev *rdev2;
 		int warned = 0;
 
-		list_for_each_entry(rdev, &mddev->disks, same_set)
-			list_for_each_entry(rdev2, &mddev->disks, same_set) {
+		rdev_for_each(rdev, mddev)
+			rdev_for_each(rdev2, mddev) {
 				if (rdev < rdev2 &&
 				    rdev->bdev->bd_contains ==
 				    rdev2->bdev->bd_contains) {
@@ -4945,7 +4945,7 @@ int md_run(struct mddev *mddev)
 	mddev->in_sync = 1;
 	smp_wmb();
 	mddev->ready = 1;
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		if (rdev->raid_disk >= 0)
 			if (sysfs_link_rdev(mddev, rdev))
 				/* failure here is OK */;
@@ -5175,7 +5175,7 @@ static int do_md_stop(struct mddev * mddev, int mode, int is_open)
 		/* tell userspace to handle 'inactive' */
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+		rdev_for_each(rdev, mddev)
 			if (rdev->raid_disk >= 0)
 				sysfs_unlink_rdev(mddev, rdev);
 
@@ -5226,7 +5226,7 @@ static void autorun_array(struct mddev *mddev)
 
 	printk(KERN_INFO "md: running: ");
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		char b[BDEVNAME_SIZE];
 		printk("<%s>", bdevname(rdev->bdev,b));
 	}
@@ -5356,7 +5356,7 @@ static int get_array_info(struct mddev * mddev, void __user * arg)
 	struct md_rdev *rdev;
 
 	nr=working=insync=failed=spare=0;
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		nr++;
 		if (test_bit(Faulty, &rdev->flags))
 			failed++;
@@ -5923,7 +5923,7 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 		 * grow, and re-add.
 		 */
 		return -EBUSY;
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		sector_t avail = rdev->sectors;
 
 		if (fit && (num_sectors == 0 || num_sectors > avail))
@@ -6758,7 +6758,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		}
 
 		sectors = 0;
-		list_for_each_entry(rdev, &mddev->disks, same_set) {
+		rdev_for_each(rdev, mddev) {
 			char b[BDEVNAME_SIZE];
 			seq_printf(seq, " %s[%d]",
 				bdevname(rdev->bdev,b), rdev->desc_nr);
@@ -7170,7 +7170,7 @@ void md_do_sync(struct mddev *mddev)
 		max_sectors = mddev->dev_sectors;
 		j = MaxSector;
 		rcu_read_lock();
-		list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
+		rdev_for_each_rcu(rdev, mddev)
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(In_sync, &rdev->flags) &&
@@ -7342,7 +7342,7 @@ void md_do_sync(struct mddev *mddev)
 			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 				mddev->curr_resync = MaxSector;
 			rcu_read_lock();
-			list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
+			rdev_for_each_rcu(rdev, mddev)
 				if (rdev->raid_disk >= 0 &&
 				    mddev->delta_disks >= 0 &&
 				    !test_bit(Faulty, &rdev->flags) &&
@@ -7388,7 +7388,7 @@ static int remove_and_add_spares(struct mddev *mddev)
 
 	mddev->curr_resync_completed = 0;
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(Blocked, &rdev->flags) &&
 		    (test_bit(Faulty, &rdev->flags) ||
@@ -7406,7 +7406,7 @@ static int remove_and_add_spares(struct mddev *mddev)
 			     "degraded");
 
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(In_sync, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags))
@@ -7451,7 +7451,7 @@ static void reap_sync_thread(struct mddev *mddev)
 	 * do the superblock for an incrementally recovered device
 	 * written out.
 	 */
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		if (!mddev->degraded ||
 		    test_bit(In_sync, &rdev->flags))
 			rdev->saved_raid_disk = -1;
@@ -7529,7 +7529,7 @@ void md_check_recovery(struct mddev *mddev)
 			 * failed devices.
 			 */
 			struct md_rdev *rdev;
-			list_for_each_entry(rdev, &mddev->disks, same_set)
+			rdev_for_each(rdev, mddev)
 				if (rdev->raid_disk >= 0 &&
 				    !test_bit(Blocked, &rdev->flags) &&
 				    test_bit(Faulty, &rdev->flags) &&
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 457885a..a8d91fe 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -519,7 +519,10 @@ static inline void sysfs_unlink_rdev(struct mddev *mddev, struct md_rdev *rdev)
 /*
  * iterates through the 'same array disks' ringlist
  */
-#define rdev_for_each(rdev, tmp, mddev)				\
+#define rdev_for_each(rdev, mddev)				\
+	list_for_each_entry(rdev, &((mddev)->disks), same_set)
+
+#define rdev_for_each_safe(rdev, tmp, mddev)				\
 	list_for_each_entry_safe(rdev, tmp, &((mddev)->disks), same_set)
 
 #define rdev_for_each_rcu(rdev, mddev)				\
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index e626567..e7852c1 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -428,7 +428,7 @@ static int multipath_run (struct mddev *mddev)
 	}
 
 	working_disks = 0;
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx < 0 ||
 		    disk_idx >= mddev->raid_disks)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 7294bd1..7ef5cbf 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -91,7 +91,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 
 	if (!conf)
 		return -ENOMEM;
-	list_for_each_entry(rdev1, &mddev->disks, same_set) {
+	rdev_for_each(rdev1, mddev) {
 		pr_debug("md/raid0:%s: looking at %s\n",
 			 mdname(mddev),
 			 bdevname(rdev1->bdev, b));
@@ -102,7 +102,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		sector_div(sectors, mddev->chunk_sectors);
 		rdev1->sectors = sectors * mddev->chunk_sectors;
 
-		list_for_each_entry(rdev2, &mddev->disks, same_set) {
+		rdev_for_each(rdev2, mddev) {
 			pr_debug("md/raid0:%s:   comparing %s(%llu)"
 				 " with %s(%llu)\n",
 				 mdname(mddev),
@@ -157,7 +157,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	smallest = NULL;
 	dev = conf->devlist;
 	err = -EINVAL;
-	list_for_each_entry(rdev1, &mddev->disks, same_set) {
+	rdev_for_each(rdev1, mddev) {
 		int j = rdev1->raid_disk;
 
 		if (mddev->level == 10) {
@@ -329,7 +329,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 	WARN_ONCE(sectors || raid_disks,
 		  "%s does not support generic reshape\n", __func__);
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		array_sectors += rdev->sectors;
 
 	return array_sectors;
@@ -543,7 +543,7 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		/* check slot number for a disk */
 		if (rdev->raid_disk == mddev->raid_disks-1) {
 			printk(KERN_ERR "md/raid0:%s: raid5 must have missing parity disk!\n",
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3309de7..c0d3ffb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2505,7 +2505,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
 	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		int disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)
@@ -2623,7 +2623,7 @@ static int run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e0c5a88..9838f08 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3254,7 +3254,7 @@ static int run(struct mddev *mddev)
 		blk_queue_io_opt(mddev->queue, chunk_size *
 				 (conf->raid_disks / conf->near_copies));
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= conf->raid_disks
@@ -3420,7 +3420,7 @@ static void *raid10_takeover_raid0(struct mddev *mddev)
 
 	conf = setup_conf(mddev);
 	if (!IS_ERR(conf)) {
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+		rdev_for_each(rdev, mddev)
 			if (rdev->raid_disk >= 0)
 				rdev->new_raid_disk = rdev->raid_disk * 2;
 		conf->barrier = 1;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 34f3b5c..dc9ab8a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4842,7 +4842,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	pr_debug("raid456: run(%s) called.\n", mdname(mddev));
 
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
+	rdev_for_each(rdev, mddev) {
 		raid_disk = rdev->raid_disk;
 		if (raid_disk >= max_disks
 		    || raid_disk < 0)
@@ -5177,7 +5177,7 @@ static int run(struct mddev *mddev)
 		blk_queue_io_opt(mddev->queue, chunk_size *
 				 (conf->raid_disks - conf->max_degraded));
 
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+		rdev_for_each(rdev, mddev)
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 	}
@@ -5500,7 +5500,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
+	rdev_for_each(rdev, mddev)
 		if (!test_bit(In_sync, &rdev->flags)
 		    && !test_bit(Faulty, &rdev->flags))
 			spares++;
@@ -5546,7 +5546,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	 * such devices during the reshape and confusion could result.
 	 */
 	if (mddev->delta_disks >= 0) {
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+		rdev_for_each(rdev, mddev)
 			if (rdev->raid_disk < 0 &&
 			    !test_bit(Faulty, &rdev->flags)) {
 				if (raid5_add_disk(mddev, rdev) == 0) {


