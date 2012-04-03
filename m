From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/10] md: allow a reshape operation to be reversed.
Date: Tue, 03 Apr 2012 15:53:01 +1000
Message-ID: <20120403055301.19495.37242.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently a reshape operation always progresses from the start
of the array to the end unless the number of devices is being
reduced, in which case it progressed in the opposite direction.

To reverse a partial reshape which changes the number of devices
you can stop the array and re-assemble with the raid-disks numbers
reversed and it will undo.

However for a reshape that does not change the number of devices
it is not possible to reverse the reshape in the middle - you have to
wait until it completes.

So add a 'reshape_direction' attribute with is either 'forwards' or
'backwards' and can be explicitly set when delta_disks is zero.

This will become more important when we allow the data_offset to
change in a reshape.  Then the explicit statement of what direction is
being used will be more useful.

This can be enabled in raid5 trivially as it already supports
reverse reshape and just needs to use a different trigger to request it.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c           |   67 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h           |    1 +
 drivers/md/raid5.c        |   23 ++++++++-------
 include/linux/raid/md_p.h |    7 ++++-
 4 files changed, 84 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b572e1e..1ea2e26 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -605,6 +605,7 @@ void mddev_init(struct mddev *mddev)
 	init_waitqueue_head(&mddev->sb_wait);
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
+	mddev->reshape_backwards = 0;
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
@@ -1183,6 +1184,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
+		mddev->reshape_backwards = 0;
 
 		if (mddev->minor_version >= 91) {
 			mddev->reshape_position = sb->reshape_position;
@@ -1190,6 +1192,8 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 			mddev->new_level = sb->new_level;
 			mddev->new_layout = sb->new_layout;
 			mddev->new_chunk_sectors = sb->new_chunk >> 9;
+			if (mddev->delta_disks < 0)
+				mddev->reshape_backwards = 1;
 		} else {
 			mddev->reshape_position = MaxSector;
 			mddev->delta_disks = 0;
@@ -1643,7 +1647,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.default_offset = 1024 >> 9;
-		
+		mddev->reshape_backwards = 0;
+
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
 		memcpy(mddev->uuid, sb->set_uuid, 16);
 
@@ -1660,6 +1665,11 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			mddev->new_level = le32_to_cpu(sb->new_level);
 			mddev->new_layout = le32_to_cpu(sb->new_layout);
 			mddev->new_chunk_sectors = le32_to_cpu(sb->new_chunk);
+			if (mddev->delta_disks < 0 ||
+			    (mddev->delta_disks == 0 &&
+			     (le32_to_cpu(sb->feature_map)
+			      & MD_FEATURE_RESHAPE_BACKWARDS)))
+				mddev->reshape_backwards = 1;
 		} else {
 			mddev->reshape_position = MaxSector;
 			mddev->delta_disks = 0;
@@ -1779,6 +1789,10 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->delta_disks = cpu_to_le32(mddev->delta_disks);
 		sb->new_level = cpu_to_le32(mddev->new_level);
 		sb->new_chunk = cpu_to_le32(mddev->new_chunk_sectors);
+		if (mddev->delta_disks == 0 &&
+		    mddev->reshape_backwards)
+			sb->feature_map
+				|= cpu_to_le32(MD_FEATURE_RESHAPE_BACKWARDS);
 	}
 
 	if (rdev->badblocks.count == 0)
@@ -3417,6 +3431,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->new_chunk_sectors = mddev->chunk_sectors;
 		mddev->raid_disks -= mddev->delta_disks;
 		mddev->delta_disks = 0;
+		mddev->reshape_backwards = 0;
 		module_put(pers->owner);
 		printk(KERN_WARNING "md: %s: %s would not accept array\n",
 		       mdname(mddev), clevel);
@@ -3490,6 +3505,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->layout = mddev->new_layout;
 	mddev->chunk_sectors = mddev->new_chunk_sectors;
 	mddev->delta_disks = 0;
+	mddev->reshape_backwards = 0;
 	mddev->degraded = 0;
 	if (mddev->pers->sync_request == NULL) {
 		/* this is now an array without redundancy, so
@@ -3583,6 +3599,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 		int olddisks = mddev->raid_disks - mddev->delta_disks;
 		mddev->delta_disks = n - olddisks;
 		mddev->raid_disks = n;
+		mddev->reshape_backwards = (mddev->delta_disks < 0);
 	} else
 		mddev->raid_disks = n;
 	return rv ? rv : len;
@@ -4434,6 +4451,7 @@ reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EINVAL;
 	mddev->reshape_position = new;
 	mddev->delta_disks = 0;
+	mddev->reshape_backwards = 0;
 	mddev->new_level = mddev->level;
 	mddev->new_layout = mddev->layout;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
@@ -4445,6 +4463,42 @@ __ATTR(reshape_position, S_IRUGO|S_IWUSR, reshape_position_show,
        reshape_position_store);
 
 static ssize_t
+reshape_direction_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%s\n",
+		       mddev->reshape_backwards ? "backwards" : "forwards");
+}
+
+static ssize_t
+reshape_direction_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	int backwards = 0;
+	if (cmd_match(buf, "forwards"))
+		backwards = 0;
+	else if (cmd_match(buf, "backwards"))
+		backwards = 1;
+	else
+		return -EINVAL;
+	if (mddev->reshape_backwards == backwards)
+		return len;
+
+	/* check if we are allowed to change */
+	if (mddev->delta_disks)
+		return -EBUSY;
+
+	if (mddev->persistent &&
+	    mddev->major_version == 0)
+		return -EINVAL;
+
+	mddev->reshape_backwards = backwards;
+	return len;
+}
+
+static struct md_sysfs_entry md_reshape_direction =
+__ATTR(reshape_direction, S_IRUGO|S_IWUSR, reshape_direction_show,
+       reshape_direction_store);
+
+static ssize_t
 array_size_show(struct mddev *mddev, char *page)
 {
 	if (mddev->external_size)
@@ -4499,6 +4553,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_safe_delay.attr,
 	&md_array_state.attr,
 	&md_reshape_position.attr,
+	&md_reshape_direction.attr,
 	&md_array_size.attr,
 	&max_corr_read_errors.attr,
 	NULL,
@@ -5062,6 +5117,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->events = 0;
 	mddev->can_decrease_events = 0;
 	mddev->delta_disks = 0;
+	mddev->reshape_backwards = 0;
 	mddev->new_level = LEVEL_NONE;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = 0;
@@ -5886,6 +5942,7 @@ static int set_array_info(struct mddev * mddev, mdu_array_info_t *info)
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->new_layout = mddev->layout;
 	mddev->delta_disks = 0;
+	mddev->reshape_backwards = 0;
 
 	return 0;
 }
@@ -5951,10 +6008,16 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
 	if (mddev->sync_thread || mddev->reshape_position != MaxSector)
 		return -EBUSY;
 	mddev->delta_disks = raid_disks - mddev->raid_disks;
+	if (mddev->delta_disks < 0)
+		mddev->reshape_backwards = 1;
+	else if (mddev->delta_disks > 0)
+		mddev->reshape_backwards = 0;
 
 	rv = mddev->pers->check_reshape(mddev);
-	if (rv < 0)
+	if (rv < 0) {
 		mddev->delta_disks = 0;
+		mddev->reshape_backwards = 0;
+	}
 	return rv;
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1c2063c..d51c0ca 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -262,6 +262,7 @@ struct mddev {
 	sector_t			reshape_position;
 	int				delta_disks, new_level, new_layout;
 	int				new_chunk_sectors;
+	int				reshape_backwards;
 
 	atomic_t			plug_cnt;	/* If device is expecting
 							 * more bios soon.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f351422..0abbd34 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3970,13 +3970,13 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 			 * to check again.
 			 */
 			spin_lock_irq(&conf->device_lock);
-			if (mddev->delta_disks < 0
+			if (mddev->reshape_backwards
 			    ? logical_sector < conf->reshape_progress
 			    : logical_sector >= conf->reshape_progress) {
 				disks = conf->previous_raid_disks;
 				previous = 1;
 			} else {
-				if (mddev->delta_disks < 0
+				if (mddev->reshape_backwards
 				    ? logical_sector < conf->reshape_safe
 				    : logical_sector >= conf->reshape_safe) {
 					spin_unlock_irq(&conf->device_lock);
@@ -4009,7 +4009,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 				 */
 				int must_retry = 0;
 				spin_lock_irq(&conf->device_lock);
-				if (mddev->delta_disks < 0
+				if (mddev->reshape_backwards
 				    ? logical_sector >= conf->reshape_progress
 				    : logical_sector < conf->reshape_progress)
 					/* mismatch, need to try again */
@@ -4108,11 +4108,11 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
-		if (mddev->delta_disks < 0 &&
+		if (mddev->reshape_backwards &&
 		    conf->reshape_progress < raid5_size(mddev, 0, 0)) {
 			sector_nr = raid5_size(mddev, 0, 0)
 				- conf->reshape_progress;
-		} else if (mddev->delta_disks >= 0 &&
+		} else if (!mddev->reshape_backwards &&
 			   conf->reshape_progress > 0)
 			sector_nr = conf->reshape_progress;
 		sector_div(sector_nr, new_data_disks);
@@ -4147,7 +4147,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	sector_div(readpos, data_disks);
 	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
-	if (mddev->delta_disks < 0) {
+	if (mddev->reshape_backwards) {
 		writepos -= min_t(sector_t, reshape_sectors, writepos);
 		readpos += reshape_sectors;
 		safepos += reshape_sectors;
@@ -4174,7 +4174,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	 * Maybe that number should be configurable, but I'm not sure it is
 	 * worth it.... maybe it could be a multiple of safemode_delay???
 	 */
-	if ((mddev->delta_disks < 0
+	if ((mddev->reshape_backwards
 	     ? (safepos > writepos && readpos < writepos)
 	     : (safepos < writepos && readpos > writepos)) ||
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
@@ -4195,7 +4195,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
 
-	if (mddev->delta_disks < 0) {
+	if (mddev->reshape_backwards) {
 		BUG_ON(conf->reshape_progress == 0);
 		stripe_addr = writepos;
 		BUG_ON((mddev->dev_sectors &
@@ -4239,7 +4239,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		list_add(&sh->lru, &stripes);
 	}
 	spin_lock_irq(&conf->device_lock);
-	if (mddev->delta_disks < 0)
+	if (mddev->reshape_backwards)
 		conf->reshape_progress -= reshape_sectors * new_data_disks;
 	else
 		conf->reshape_progress += reshape_sectors * new_data_disks;
@@ -5008,7 +5008,7 @@ static int run(struct mddev *mddev)
 				       mdname(mddev));
 				return -EINVAL;
 			}
-		} else if (mddev->delta_disks < 0
+		} else if (mddev->reshape_backwards
 		    ? (here_new * mddev->new_chunk_sectors <=
 		       here_old * mddev->chunk_sectors)
 		    : (here_new * mddev->new_chunk_sectors >=
@@ -5535,7 +5535,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	conf->chunk_sectors = mddev->new_chunk_sectors;
 	conf->prev_algo = conf->algorithm;
 	conf->algorithm = mddev->new_layout;
-	if (mddev->delta_disks < 0)
+	if (mddev->reshape_backwards)
 		conf->reshape_progress = raid5_size(mddev, 0, 0);
 	else
 		conf->reshape_progress = 0;
@@ -5663,6 +5663,7 @@ static void raid5_finish_reshape(struct mddev *mddev)
 		mddev->chunk_sectors = conf->chunk_sectors;
 		mddev->reshape_position = MaxSector;
 		mddev->delta_disks = 0;
+		mddev->reshape_backwards = 0;
 	}
 }
 
diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 8c0a3ad..07e05f9 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -281,10 +281,15 @@ struct mdp_superblock_1 {
 					    * active device with same 'role'.
 					    * 'recovery_offset' is also set.
 					    */
+#define	MD_FEATURE_RESHAPE_BACKWARDS	32 /* Reshape doesn't change number
+					    * of devices, but is going
+					    * backwards anyway.
+					    */
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
 					|MD_FEATURE_BAD_BLOCKS		\
-					|MD_FEATURE_REPLACEMENT)
+					|MD_FEATURE_REPLACEMENT		\
+					|MD_FEATURE_RESHAPE_BACKWARDS)
 
 #endif 


