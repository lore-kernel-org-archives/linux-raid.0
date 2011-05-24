From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH 7 of 9] MD:  new sb type
Date: Mon, 23 May 2011 22:07:04 -0500
Message-ID: <201105240307.p4O374rN029659@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-new-sb-type.patch

A new MD superblock that is device-mapper specific.

The new superblock is not read or written from userspace and is not exported.
It contains information to track resync, recovery, and reshaping progress.  It
also maintains information on the health of the devices in the array.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -1731,6 +1731,305 @@ super_1_rdev_size_change(mdk_rdev_t *rde
 	return num_sectors;
 }
 
+/*
+ * This structure is never used by userspace.  It is only ever
+ * used in these particular super block accessing functions.
+ * Therefore, we don't put it in any .h file.
+ *
+ * It makes sense to define a new magic number here.  This way,
+ * no userspace application will confuse the device as a device
+ * that is accessible through MD operations.  Devices with this
+ * superblock should only ever be accessed via device-mapper.
+ */
+#define MD_DM_SB_MAGIC 0x426E6F4A
+struct mdp_superblock_2 {
+	__le32 magic;
+	__le32 flags; /* Used to indicate possible future changes */
+
+	__le64 events;
+
+	/*
+	 * The following offset variables are used to indicate:
+	 *  reshape_offset:  If the RAID level or layout of an array is
+	 *		     being updated, this offset keeps track of the
+	 *		     progress.
+	 *  disk_recovery_offset:  If drives are being repaired/replaced on
+	 *			   an individual basis, this offset tracks
+	 *			   that progress.  This might happen when a
+	 *			   drive fails and is replaced.
+	 *  array_resync_offset:  When the array is constructed for the first
+	 *			  time, all the devices must be made coherent.
+	 *			  This offset tracks that progress.
+	 */
+	__le64 reshape_offset;
+	__le64 disk_recovery_offset;
+	__le64 array_resync_offset;
+
+	/*
+	 * The following variable pairs reflect things
+	 * that can changed during an array reshape.
+	 */
+	__le32 level;
+	__le32 new_level;
+
+	__le32 layout;
+	__le32 new_layout;
+
+	__le32 stripe_sectors;
+	__le32 new_stripe_sectors;
+
+	__le32 num_devices;    /* Number of devs in RAID, Max = 64 */
+	__le32 new_num_devices;
+
+	__le64 failed_devices; /* bitmap of devs, used to indicate a failure */
+	__u8 pad[432];         /* Round out the struct to 512 bytes */
+};
+
+static void super_2_sync(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	mdk_rdev_t *r, *t;
+	uint64_t failed_devices;
+	struct mdp_superblock_2 *sb;
+
+	sb = (struct mdp_superblock_2 *)page_address(rdev->sb_page);
+	failed_devices = le32_to_cpu(sb->failed_devices);
+
+	rdev_for_each(r, t, mddev)
+		if ((r->raid_disk >= 0) && test_bit(Faulty, &r->flags))
+			failed_devices |= (1 << r->raid_disk);
+
+	memset(sb, 0, sizeof(*sb));
+
+	sb->magic  = cpu_to_le32(MD_DM_SB_MAGIC);
+	sb->flags  = cpu_to_le32(0); /* No flags yet */
+
+	sb->events = cpu_to_le64(mddev->events);
+
+	sb->reshape_offset = cpu_to_le64(mddev->reshape_position);
+	sb->disk_recovery_offset = cpu_to_le64(rdev->recovery_offset);
+	sb->array_resync_offset = cpu_to_le64(mddev->recovery_cp);
+
+	sb->level = cpu_to_le32(mddev->level);
+	sb->layout = cpu_to_le32(mddev->layout);
+	sb->stripe_sectors = cpu_to_le32(mddev->chunk_sectors);
+	sb->num_devices = cpu_to_le32(mddev->raid_disks);
+
+	if (mddev->reshape_position != MaxSector) {
+		sb->new_level = cpu_to_le32(mddev->new_level);
+		sb->new_layout = cpu_to_le32(mddev->new_layout);
+		sb->new_stripe_sectors = cpu_to_le32(mddev->new_chunk_sectors);
+		sb->new_num_devices = cpu_to_le32(mddev->delta_disks);
+	} else {
+		sb->new_level = 0;
+		sb->new_layout = 0;
+		sb->new_stripe_sectors = 0;
+		sb->new_num_devices = 0;
+	}
+
+	sb->failed_devices = cpu_to_le32(failed_devices);
+}
+
+/*
+ * super_2_load
+ *
+ * This function creates a superblock if one is not found on the device
+ * and will indicate the more appropriate device whose superblock should
+ * be used, if given two.
+ *
+ * Return: 1 if use rdev, 0 if use refdev, -Exxx otherwise
+ */
+static int super_2_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
+{
+	int r;
+	uint64_t ev1, ev2;
+	struct mdp_superblock_2 *sb;
+	struct mdp_superblock_2 *refsb;
+
+	if (sizeof(*sb) & (sizeof(*sb) - 1)) {
+		printk(KERN_ERR "Programmer error: Bad sized superblock (%lu)\n",
+		       sizeof(*sb));
+		return -EIO;
+	}
+
+	rdev->sb_start = 0;
+	rdev->sb_size  = sizeof(*sb);
+	r = read_disk_sb(rdev, rdev->sb_size);
+	if (r)
+		return r;
+
+	sb = (struct mdp_superblock_2 *)page_address(rdev->sb_page);
+	if (sb->magic != cpu_to_le32(MD_DM_SB_MAGIC)) {
+		super_2_sync(rdev->mddev, rdev);
+
+		set_bit(FirstUse, &rdev->flags);
+
+		/* Force new superblocks to disk */
+		set_bit(MD_CHANGE_DEVS, &rdev->mddev->flags);
+
+		/* Any superblock is better than none, choose that if given */
+		return refdev ? 0 : 1;
+	}
+
+	if (!refdev)
+		return 1;
+
+	ev1 = le64_to_cpu(sb->events);
+	refsb = (struct mdp_superblock_2 *)page_address(refdev->sb_page);
+	ev2 = le64_to_cpu(refsb->events);
+
+	return (ev1 > ev2) ? 1 : 0;
+}
+
+static int super_2_init_validation(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	uint64_t ev1;
+	uint32_t failed_devices;
+	struct mdp_superblock_2 *sb;
+	uint32_t new_devs = 0;
+	uint32_t rebuilds = 0;
+	mdk_rdev_t *r, *t;
+	struct mdp_superblock_2 *sb2;
+
+	sb = (struct mdp_superblock_2 *)page_address(rdev->sb_page);
+	ev1 = le64_to_cpu(sb->events);
+	failed_devices = le32_to_cpu(sb->failed_devices);
+
+	mddev->events = ev1 ? ev1 : 1;
+
+	/* Reshaping is not currently allowed */
+	if ((le32_to_cpu(sb->level) != mddev->level) ||
+	    (le32_to_cpu(sb->layout) != mddev->layout) ||
+	    (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors) ||
+	    (le32_to_cpu(sb->num_devices) != mddev->raid_disks)) {
+		printk(KERN_ERR
+		       "md: %s: Reshaping arrays not yet supported.\n",
+		       mdname(mddev));
+		return -EINVAL;
+	}
+
+	if (!test_and_clear_bit(MD_SYNC_STATE_FORCED, &mddev->flags))
+		mddev->recovery_cp = le64_to_cpu(sb->array_resync_offset);
+
+	/*
+	 * During load, we set FirstUse if a new superblock was written.
+	 * There are two reasons we might not have a superblock:
+	 * 1) The array is brand new - in which case, all of the
+	 *    devices must have their In_sync bit set.  Also,
+	 *    recovery_cp must be 0, unless forced.
+	 * 2) This is a new device being added to an old array
+	 *    and the new device needs to be rebuilt - in which
+	 *    case the In_sync bit will /not/ be set and
+	 *    recovery_cp must be MaxSector.
+	 */
+	rdev_for_each(r, t, mddev) {
+		if (!test_bit(In_sync, &r->flags)) {
+			if (!test_bit(FirstUse, &r->flags))
+				printk(KERN_ERR "md: %s: Superblock area of "
+				       "rebuild device %d should have been "
+				       "cleared.\n", mdname(mddev),
+				       r->raid_disk);
+			set_bit(FirstUse, &r->flags);
+			rebuilds++;
+		} else if (test_bit(FirstUse, &r->flags))
+			new_devs++;
+	}
+
+	if (!rebuilds) {
+		if (new_devs == mddev->raid_disks) {
+			printk(KERN_INFO "md: %s: Superblocks created for new array\n", mdname(mddev));
+		} else if (new_devs) {
+			printk(KERN_ERR "md: %s: New device injected "
+			       "into existing array without 'rebuild' "
+			       "parameter specified\n", mdname(mddev));
+			return -EINVAL;
+		}
+	} else if (new_devs) {
+		printk(KERN_ERR "md: %s: 'rebuild' devices cannot be "
+		       "injected into an array with other "
+		       "first-time devices\n", mdname(mddev));
+		return -EINVAL;
+	} else if (mddev->recovery_cp != MaxSector) {
+		printk(KERN_ERR "md: %s: 'rebuild' specified while "
+		       "array is not in-sync\n",
+		       mdname(mddev));
+		return -EINVAL;
+	}
+
+	/*
+	 * Now we set the Faulty bit for those devices that are
+	 * recorded in the superblock as failed.
+	 */
+	rdev_for_each(r, t, mddev) {
+		if (!r->sb_page)
+			continue;
+		sb2 = (struct mdp_superblock_2 *)
+			page_address(r->sb_page);
+		sb2->failed_devices = 0;
+
+		if ((r->raid_disk >= 0) &&
+		    (failed_devices & (1 << r->raid_disk))) {
+			if (test_bit(FirstUse, &r->flags)) {
+				char b[BDEVNAME_SIZE];
+				printk(KERN_INFO
+				       "md: %s: Starting complete rebuild of "
+				       "previously failed device, %s\n",
+				       mdname(mddev), bdevname(rdev->bdev, b));
+			} else {
+				set_bit(Faulty, &r->flags);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int super_2_validate(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	struct mdp_superblock_2 *sb;
+
+	sb = (struct mdp_superblock_2 *)page_address(rdev->sb_page);
+
+	/*
+	 * mddev->events is set during the first call to super_2_validate,
+	 * so we use that knowledge to kick off some global sanity checks
+	 * on the first call.
+	 */
+	if (!mddev->events && super_2_init_validation(mddev, rdev))
+		return -EINVAL;
+
+	rdev->mddev->bitmap_info.offset = 0; /* disable bitmap creation */
+	rdev->mddev->bitmap_info.default_offset = 4096 >> 9;
+	if (!test_bit(FirstUse, &rdev->flags)) {
+		rdev->recovery_offset = le64_to_cpu(sb->disk_recovery_offset);
+		if (rdev->recovery_offset != MaxSector)
+			clear_bit(In_sync, &rdev->flags);
+	}
+
+	if (test_bit(Faulty, &rdev->flags)) {
+		clear_bit(Faulty, &rdev->flags);
+		clear_bit(In_sync, &rdev->flags);
+		rdev->recovery_offset = 0;
+		printk(KERN_INFO "md: %s: Dev #%d previously marked as failed\n",
+		       mdname(mddev), rdev->raid_disk);
+	}
+
+	clear_bit(FirstUse, &rdev->flags);
+	return 0;
+}
+
+static unsigned long long
+super_2_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
+{
+	/*
+	 * Arrays built through device-mapper must use device-mapper
+	 * tables to change the size.  A call to this function is
+	 * invalid for this array.
+	 */
+	printk(KERN_ERR "md: %s: Invalid device size change request.\n",
+	       mdname(rdev->mddev));
+	return 0;
+}
+
 static struct super_type super_types[] = {
 	[0] = {
 		.name	= "0.90.0",
@@ -1748,6 +2047,14 @@ static struct super_type super_types[] =
 		.sync_super	    = super_1_sync,
 		.rdev_size_change   = super_1_rdev_size_change,
 	},
+	[2] = {
+		.name	= "dm",
+		.owner	= THIS_MODULE,
+		.load_super	    = super_2_load,
+		.validate_super	    = super_2_validate,
+		.sync_super	    = super_2_sync,
+		.rdev_size_change   = super_2_rdev_size_change,
+	},
 };
 
 static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -77,6 +77,8 @@ struct mdk_rdev_s
 #define Blocked		8		/* An error occurred on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
+#define FirstUse        9               /* Used by device-mapper interface when
+					 * initializing first-time devices. */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */
@@ -124,6 +126,7 @@ struct mddev_s
 #define MD_CHANGE_DEVS	0	/* Some device status has changed */
 #define MD_CHANGE_CLEAN 1	/* transition to or from 'clean' */
 #define MD_CHANGE_PENDING 2	/* switch from 'clean' to 'active' in progress */
+#define MD_SYNC_STATE_FORCED 3  /* recovery_cp is set and must be honored */
 
 	int				suspended;
 	atomic_t			active_io;
