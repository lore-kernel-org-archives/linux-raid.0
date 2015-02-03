From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 25/26] md: make reconfig_mutex optional for writes to md
 sysfs files.
Date: Wed, 04 Feb 2015 08:42:30 +1100
Message-ID: <20150203214230.3448.69084.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rather than using mddev_lock() to take the reconfig_mutex
when writing to any md sysfs file, we only take mddev_lock()
in the particular _store() functions that require it.
Admittedly this is most, but it isn't all.

This also allows us to remove special-case handling for new_dev_store
(in md_attr_store).

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |  346 ++++++++++++++++++++++++++++++++++++----------------
 drivers/md/raid5.c |  134 +++++++++++---------
 2 files changed, 316 insertions(+), 164 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6517f4ece44e..4c3ab0639c58 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3256,26 +3256,32 @@ static ssize_t
 level_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	char clevel[16];
-	ssize_t rv = len;
+	ssize_t rv;
+	size_t slen = len;
 	struct md_personality *pers, *oldpers;
 	long level;
 	void *priv, *oldpriv;
 	struct md_rdev *rdev;
 
+	if (slen == 0 || slen >= sizeof(clevel))
+		return -EINVAL;
+
+	rv = mddev_lock(mddev);
+	if (rv)
+		return rv;
+
 	if (mddev->pers == NULL) {
-		if (len == 0)
-			return 0;
-		if (len >= sizeof(mddev->clevel))
-			return -ENOSPC;
-		strncpy(mddev->clevel, buf, len);
-		if (mddev->clevel[len-1] == '\n')
-			len--;
-		mddev->clevel[len] = 0;
+		strncpy(mddev->clevel, buf, slen);
+		if (mddev->clevel[slen-1] == '\n')
+			slen--;
+		mddev->clevel[slen] = 0;
 		mddev->level = LEVEL_NONE;
-		return rv;
+		rv = len;
+		goto out_unlock;
 	}
+	rv = -EROFS;
 	if (mddev->ro)
-		return  -EROFS;
+		goto out_unlock;
 
 	/* request to change the personality.  Need to ensure:
 	 *  - array is not engaged in resync/recovery/reshape
@@ -3283,25 +3289,25 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	 *  - new personality will access other array.
 	 */
 
+	rv = -EBUSY;
 	if (mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 	    mddev->reshape_position != MaxSector ||
 	    mddev->sysfs_active)
-		return -EBUSY;
+		goto out_unlock;
 
+	rv = -EINVAL;
 	if (!mddev->pers->quiesce) {
 		printk(KERN_WARNING "md: %s: %s does not support online personality change\n",
 		       mdname(mddev), mddev->pers->name);
-		return -EINVAL;
+		goto out_unlock;
 	}
 
 	/* Now find the new personality */
-	if (len == 0 || len >= sizeof(clevel))
-		return -EINVAL;
-	strncpy(clevel, buf, len);
-	if (clevel[len-1] == '\n')
-		len--;
-	clevel[len] = 0;
+	strncpy(clevel, buf, slen);
+	if (clevel[slen-1] == '\n')
+		slen--;
+	clevel[slen] = 0;
 	if (kstrtol(clevel, 10, &level))
 		level = LEVEL_NONE;
 
@@ -3312,20 +3318,23 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!pers || !try_module_get(pers->owner)) {
 		spin_unlock(&pers_lock);
 		printk(KERN_WARNING "md: personality %s not loaded\n", clevel);
-		return -EINVAL;
+		rv = -EINVAL;
+		goto out_unlock;
 	}
 	spin_unlock(&pers_lock);
 
 	if (pers == mddev->pers) {
 		/* Nothing to do! */
 		module_put(pers->owner);
-		return rv;
+		rv = len;
+		goto out_unlock;
 	}
 	if (!pers->takeover) {
 		module_put(pers->owner);
 		printk(KERN_WARNING "md: %s: %s does not support personality takeover\n",
 		       mdname(mddev), clevel);
-		return -EINVAL;
+		rv = -EINVAL;
+		goto out_unlock;
 	}
 
 	rdev_for_each(rdev, mddev)
@@ -3345,7 +3354,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		module_put(pers->owner);
 		printk(KERN_WARNING "md: %s: %s would not accept array\n",
 		       mdname(mddev), clevel);
-		return PTR_ERR(priv);
+		rv = PTR_ERR(priv);
+		goto out_unlock;
 	}
 
 	/* Looks like we have a winner */
@@ -3438,6 +3448,9 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		md_update_sb(mddev, 1);
 	sysfs_notify(&mddev->kobj, NULL, "level");
 	md_new_event(mddev);
+	rv = len;
+out_unlock:
+	mddev_unlock(mddev);
 	return rv;
 }
 
@@ -3460,28 +3473,32 @@ layout_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	char *e;
 	unsigned long n = simple_strtoul(buf, &e, 10);
+	int err;
 
 	if (!*buf || (*e && *e != '\n'))
 		return -EINVAL;
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 
 	if (mddev->pers) {
-		int err;
 		if (mddev->pers->check_reshape == NULL)
-			return -EBUSY;
-		if (mddev->ro)
-			return -EROFS;
-		mddev->new_layout = n;
-		err = mddev->pers->check_reshape(mddev);
-		if (err) {
-			mddev->new_layout = mddev->layout;
-			return err;
+			err = -EBUSY;
+		else if (mddev->ro)
+			err = -EROFS;
+		else {
+			mddev->new_layout = n;
+			err = mddev->pers->check_reshape(mddev);
+			if (err)
+				mddev->new_layout = mddev->layout;
 		}
 	} else {
 		mddev->new_layout = n;
 		if (mddev->reshape_position == MaxSector)
 			mddev->layout = n;
 	}
-	return len;
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 static struct md_sysfs_entry md_layout =
 __ATTR(layout, S_IRUGO|S_IWUSR, layout_show, layout_store);
@@ -3504,32 +3521,39 @@ static ssize_t
 raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	char *e;
-	int rv = 0;
+	int err;
 	unsigned long n = simple_strtoul(buf, &e, 10);
 
 	if (!*buf || (*e && *e != '\n'))
 		return -EINVAL;
 
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 	if (mddev->pers)
-		rv = update_raid_disks(mddev, n);
+		err = update_raid_disks(mddev, n);
 	else if (mddev->reshape_position != MaxSector) {
 		struct md_rdev *rdev;
 		int olddisks = mddev->raid_disks - mddev->delta_disks;
 
+		err = -EINVAL;
 		rdev_for_each(rdev, mddev) {
 			if (olddisks < n &&
 			    rdev->data_offset < rdev->new_data_offset)
-				return -EINVAL;
+				goto out_unlock;
 			if (olddisks > n &&
 			    rdev->data_offset > rdev->new_data_offset)
-				return -EINVAL;
+				goto out_unlock;
 		}
+		err = 0;
 		mddev->delta_disks = n - olddisks;
 		mddev->raid_disks = n;
 		mddev->reshape_backwards = (mddev->delta_disks < 0);
 	} else
 		mddev->raid_disks = n;
-	return rv ? rv : len;
+out_unlock:
+	mddev_unlock(mddev);
+	return err ? err : len;
 }
 static struct md_sysfs_entry md_raid_disks =
 __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
@@ -3548,30 +3572,34 @@ chunk_size_show(struct mddev *mddev, char *page)
 static ssize_t
 chunk_size_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	int err;
 	char *e;
 	unsigned long n = simple_strtoul(buf, &e, 10);
 
 	if (!*buf || (*e && *e != '\n'))
 		return -EINVAL;
 
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 	if (mddev->pers) {
-		int err;
 		if (mddev->pers->check_reshape == NULL)
-			return -EBUSY;
-		if (mddev->ro)
-			return -EROFS;
-		mddev->new_chunk_sectors = n >> 9;
-		err = mddev->pers->check_reshape(mddev);
-		if (err) {
-			mddev->new_chunk_sectors = mddev->chunk_sectors;
-			return err;
+			err = -EBUSY;
+		else if (mddev->ro)
+			err = -EROFS;
+		else {
+			mddev->new_chunk_sectors = n >> 9;
+			err = mddev->pers->check_reshape(mddev);
+			if (err)
+				mddev->new_chunk_sectors = mddev->chunk_sectors;
 		}
 	} else {
 		mddev->new_chunk_sectors = n >> 9;
 		if (mddev->reshape_position == MaxSector)
 			mddev->chunk_sectors = n >> 9;
 	}
-	return len;
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 static struct md_sysfs_entry md_chunk_size =
 __ATTR(chunk_size, S_IRUGO|S_IWUSR, chunk_size_show, chunk_size_store);
@@ -3587,20 +3615,27 @@ resync_start_show(struct mddev *mddev, char *page)
 static ssize_t
 resync_start_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	int err;
 	char *e;
 	unsigned long long n = simple_strtoull(buf, &e, 10);
 
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 	if (mddev->pers && !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
-		return -EBUSY;
-	if (cmd_match(buf, "none"))
+		err = -EBUSY;
+	else if (cmd_match(buf, "none"))
 		n = MaxSector;
 	else if (!*buf || (*e && *e != '\n'))
-		return -EINVAL;
+		err = -EINVAL;
 
-	mddev->recovery_cp = n;
-	if (mddev->pers)
-		set_bit(MD_CHANGE_CLEAN, &mddev->flags);
-	return len;
+	if (!err) {
+		mddev->recovery_cp = n;
+		if (mddev->pers)
+			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+	}
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 static struct md_sysfs_entry md_resync_start =
 __ATTR(resync_start, S_IRUGO|S_IWUSR, resync_start_show, resync_start_store);
@@ -3698,8 +3733,39 @@ static int restart_array(struct mddev *mddev);
 static ssize_t
 array_state_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	int err = -EINVAL;
+	int err;
 	enum array_state st = match_word(buf, array_states);
+
+	if (mddev->pers && (st == active || st == clean) && mddev->ro != 1) {
+		/* don't take reconfig_mutex when toggling between
+		 * clean and active
+		 */
+		spin_lock(&mddev->lock);
+		if (st == active) {
+			restart_array(mddev);
+			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+			wake_up(&mddev->sb_wait);
+			err = 0;
+		} else /* st == clean */ {
+			restart_array(mddev);
+			if (atomic_read(&mddev->writes_pending) == 0) {
+				if (mddev->in_sync == 0) {
+					mddev->in_sync = 1;
+					if (mddev->safemode == 1)
+						mddev->safemode = 0;
+					set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+				}
+				err = 0;
+			} else
+				err = -EBUSY;
+		}
+		spin_unlock(&mddev->lock);
+		return err;
+	}
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	err = -EINVAL;
 	switch(st) {
 	case bad_word:
 		break;
@@ -3775,14 +3841,14 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		/* these cannot be set */
 		break;
 	}
-	if (err)
-		return err;
-	else {
+
+	if (!err) {
 		if (mddev->hold_active == UNTIL_IOCTL)
 			mddev->hold_active = 0;
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
-		return len;
 	}
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 static struct md_sysfs_entry md_array_state =
 __ATTR(array_state, S_IRUGO|S_IWUSR, array_state_show, array_state_store);
@@ -3843,6 +3909,11 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	    minor != MINOR(dev))
 		return -EOVERFLOW;
 
+	flush_workqueue(md_misc_wq);
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 	if (mddev->persistent) {
 		rdev = md_import_device(dev, mddev->major_version,
 					mddev->minor_version);
@@ -3866,6 +3937,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
  out:
 	if (err)
 		export_rdev(rdev);
+	mddev_unlock(mddev);
 	return err ? err : len;
 }
 
@@ -3877,7 +3949,11 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	char *end;
 	unsigned long chunk, end_chunk;
+	int err;
 
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 	if (!mddev->bitmap)
 		goto out;
 	/* buf should be <chunk> <chunk> ... or <chunk>-<chunk> ... (range) */
@@ -3895,6 +3971,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
 out:
+	mddev_unlock(mddev);
 	return len;
 }
 
@@ -3922,6 +3999,9 @@ size_store(struct mddev *mddev, const char *buf, size_t len)
 
 	if (err < 0)
 		return err;
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 	if (mddev->pers) {
 		err = update_size(mddev, sectors);
 		md_update_sb(mddev, 1);
@@ -3932,6 +4012,7 @@ size_store(struct mddev *mddev, const char *buf, size_t len)
 		else
 			err = -ENOSPC;
 	}
+	mddev_unlock(mddev);
 	return err ? err : len;
 }
 
@@ -3961,21 +4042,28 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int major, minor;
 	char *e;
+	int err;
 	/* Changing the details of 'external' metadata is
 	 * always permitted.  Otherwise there must be
 	 * no devices attached to the array.
 	 */
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	err = -EBUSY;
 	if (mddev->external && strncmp(buf, "external:", 9) == 0)
 		;
 	else if (!list_empty(&mddev->disks))
-		return -EBUSY;
+		goto out_unlock;
 
+	err = 0;
 	if (cmd_match(buf, "none")) {
 		mddev->persistent = 0;
 		mddev->external = 0;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
-		return len;
+		goto out_unlock;
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
 		size_t namelen = len-9;
@@ -3989,22 +4077,27 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->external = 1;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
-		return len;
+		goto out_unlock;
 	}
 	major = simple_strtoul(buf, &e, 10);
+	err = -EINVAL;
 	if (e==buf || *e != '.')
-		return -EINVAL;
+		goto out_unlock;
 	buf = e+1;
 	minor = simple_strtoul(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n') )
-		return -EINVAL;
+		goto out_unlock;
+	err = -ENOENT;
 	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
-		return -ENOENT;
+		goto out_unlock;
 	mddev->major_version = major;
 	mddev->minor_version = minor;
 	mddev->persistent = 1;
 	mddev->external = 0;
-	return len;
+	err = 0;
+out_unlock:
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry md_metadata =
@@ -4049,7 +4142,10 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		flush_workqueue(md_misc_wq);
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
+			if (mddev_lock(mddev) == 0) {
+				md_reap_sync_thread(mddev);
+				mddev_unlock(mddev);
+			}
 		}
 	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
@@ -4063,7 +4159,11 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		int err;
 		if (mddev->pers->start_reshape == NULL)
 			return -EINVAL;
-		err = mddev->pers->start_reshape(mddev);
+		err = mddev_lock(mddev);
+		if (!err) {
+			err = mddev->pers->start_reshape(mddev);
+			mddev_unlock(mddev);
+		}
 		if (err)
 			return err;
 		sysfs_notify(&mddev->kobj, NULL, "degraded");
@@ -4346,14 +4446,20 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
-	unsigned long long old = mddev->suspend_lo;
+	unsigned long long old;
+	int err;
 
-	if (mddev->pers == NULL ||
-	    mddev->pers->quiesce == NULL)
-		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
 
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	err = -EINVAL;
+	if (mddev->pers == NULL ||
+	    mddev->pers->quiesce == NULL)
+		goto unlock;
+	old = mddev->suspend_lo;
 	mddev->suspend_lo = new;
 	if (new >= old)
 		/* Shrinking suspended region */
@@ -4363,7 +4469,10 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
 	}
-	return len;
+	err = 0;
+unlock:
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 static struct md_sysfs_entry md_suspend_lo =
 __ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show, suspend_lo_store);
@@ -4379,14 +4488,20 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
-	unsigned long long old = mddev->suspend_hi;
+	unsigned long long old;
+	int err;
 
-	if (mddev->pers == NULL ||
-	    mddev->pers->quiesce == NULL)
-		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
 
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	err = -EINVAL;
+	if (mddev->pers == NULL ||
+	    mddev->pers->quiesce == NULL)
+		goto unlock;
+	old = mddev->suspend_hi;
 	mddev->suspend_hi = new;
 	if (new <= old)
 		/* Shrinking suspended region */
@@ -4396,7 +4511,10 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
 	}
-	return len;
+	err = 0;
+unlock:
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 static struct md_sysfs_entry md_suspend_hi =
 __ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);
@@ -4416,11 +4534,17 @@ reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	struct md_rdev *rdev;
 	char *e;
+	int err;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
-	if (mddev->pers)
-		return -EBUSY;
+
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	err = -EBUSY;
+	if (mddev->pers)
+		goto unlock;
 	mddev->reshape_position = new;
 	mddev->delta_disks = 0;
 	mddev->reshape_backwards = 0;
@@ -4429,7 +4553,10 @@ reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	rdev_for_each(rdev, mddev)
 		rdev->new_data_offset = rdev->data_offset;
-	return len;
+	err = 0;
+unlock:
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry md_reshape_position =
@@ -4447,6 +4574,8 @@ static ssize_t
 reshape_direction_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int backwards = 0;
+	int err;
+
 	if (cmd_match(buf, "forwards"))
 		backwards = 0;
 	else if (cmd_match(buf, "backwards"))
@@ -4456,16 +4585,19 @@ reshape_direction_store(struct mddev *mddev, const char *buf, size_t len)
 	if (mddev->reshape_backwards == backwards)
 		return len;
 
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 	/* check if we are allowed to change */
 	if (mddev->delta_disks)
-		return -EBUSY;
-
-	if (mddev->persistent &&
+		err = -EBUSY;
+	else if (mddev->persistent &&
 	    mddev->major_version == 0)
-		return -EINVAL;
-
-	mddev->reshape_backwards = backwards;
-	return len;
+		err =  -EINVAL;
+	else
+		mddev->reshape_backwards = backwards;
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry md_reshape_direction =
@@ -4486,6 +4618,11 @@ static ssize_t
 array_size_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	sector_t sectors;
+	int err;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
 
 	if (strncmp(buf, "default", 7) == 0) {
 		if (mddev->pers)
@@ -4496,19 +4633,22 @@ array_size_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->external_size = 0;
 	} else {
 		if (strict_blocks_to_sectors(buf, &sectors) < 0)
-			return -EINVAL;
-		if (mddev->pers && mddev->pers->size(mddev, 0, 0) < sectors)
-			return -E2BIG;
-
-		mddev->external_size = 1;
+			err = -EINVAL;
+		else if (mddev->pers && mddev->pers->size(mddev, 0, 0) < sectors)
+			err = -E2BIG;
+		else
+			mddev->external_size = 1;
 	}
 
-	mddev->array_sectors = sectors;
-	if (mddev->pers) {
-		set_capacity(mddev->gendisk, mddev->array_sectors);
-		revalidate_disk(mddev->gendisk);
+	if (!err) {
+		mddev->array_sectors = sectors;
+		if (mddev->pers) {
+			set_capacity(mddev->gendisk, mddev->array_sectors);
+			revalidate_disk(mddev->gendisk);
+		}
 	}
-	return len;
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry md_array_size =
@@ -4596,13 +4736,7 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	}
 	mddev_get(mddev);
 	spin_unlock(&all_mddevs_lock);
-	if (entry->store == new_dev_store)
-		flush_workqueue(md_misc_wq);
-	rv = mddev_lock(mddev);
-	if (!rv) {
-		rv = entry->store(mddev, page, length);
-		mddev_unlock(mddev);
-	}
+	rv = entry->store(mddev, page, length);
 	mddev_put(mddev);
 	return rv;
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d5b80174b3b3..aa76865b804b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5400,21 +5400,25 @@ EXPORT_SYMBOL(raid5_set_cache_size);
 static ssize_t
 raid5_store_stripe_cache_size(struct mddev *mddev, const char *page, size_t len)
 {
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf;
 	unsigned long new;
 	int err;
 
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
-	if (!conf)
-		return -ENODEV;
-
 	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
-	err = raid5_set_cache_size(mddev, new);
+	err = mddev_lock(mddev);
 	if (err)
 		return err;
-	return len;
+	conf = mddev->private;
+	if (!conf)
+		err = -ENODEV;
+	else
+		err = raid5_set_cache_size(mddev, new);
+	mddev_unlock(mddev);
+
+	return err ?: len;
 }
 
 static struct md_sysfs_entry
@@ -5438,19 +5442,27 @@ raid5_show_preread_threshold(struct mddev *mddev, char *page)
 static ssize_t
 raid5_store_preread_threshold(struct mddev *mddev, const char *page, size_t len)
 {
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf;
 	unsigned long new;
+	int err;
+
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
-	if (!conf)
-		return -ENODEV;
-
 	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
-	if (new > conf->max_nr_stripes)
-		return -EINVAL;
-	conf->bypass_threshold = new;
-	return len;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	conf = mddev->private;
+	if (!conf)
+		err = -ENODEV;
+	else if (new > conf->max_nr_stripes)
+		err = -EINVAL;
+	else
+		conf->bypass_threshold = new;
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry
@@ -5475,29 +5487,35 @@ raid5_show_skip_copy(struct mddev *mddev, char *page)
 static ssize_t
 raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 {
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf;
 	unsigned long new;
+	int err;
+
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
-	if (!conf)
-		return -ENODEV;
-
 	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
 	new = !!new;
-	if (new == conf->skip_copy)
-		return len;
 
-	mddev_suspend(mddev);
-	conf->skip_copy = new;
-	if (new)
-		mddev->queue->backing_dev_info.capabilities |=
-						BDI_CAP_STABLE_WRITES;
-	else
-		mddev->queue->backing_dev_info.capabilities &=
-						~BDI_CAP_STABLE_WRITES;
-	mddev_resume(mddev);
-	return len;
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	conf = mddev->private;
+	if (!conf)
+		err = -ENODEV;
+	else if (new != conf->skip_copy) {
+		mddev_suspend(mddev);
+		conf->skip_copy = new;
+		if (new)
+			mddev->queue->backing_dev_info.capabilities |=
+				BDI_CAP_STABLE_WRITES;
+		else
+			mddev->queue->backing_dev_info.capabilities &=
+				~BDI_CAP_STABLE_WRITES;
+		mddev_resume(mddev);
+	}
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry
@@ -5538,7 +5556,7 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt,
 static ssize_t
 raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 {
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf;
 	unsigned long new;
 	int err;
 	struct r5worker_group *new_groups, *old_groups;
@@ -5546,41 +5564,41 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
-	if (!conf)
-		return -ENODEV;
-
 	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
 
-	if (new == conf->worker_cnt_per_group)
-		return len;
-
-	mddev_suspend(mddev);
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	conf = mddev->private;
+	if (!conf)
+		err = -ENODEV;
+	else if (new != conf->worker_cnt_per_group) {
+		mddev_suspend(mddev);
 
-	old_groups = conf->worker_groups;
-	if (old_groups)
-		flush_workqueue(raid5_wq);
+		old_groups = conf->worker_groups;
+		if (old_groups)
+			flush_workqueue(raid5_wq);
 
-	err = alloc_thread_groups(conf, new,
-				  &group_cnt, &worker_cnt_per_group,
-				  &new_groups);
-	if (!err) {
-		spin_lock_irq(&conf->device_lock);
-		conf->group_cnt = group_cnt;
-		conf->worker_cnt_per_group = worker_cnt_per_group;
-		conf->worker_groups = new_groups;
-		spin_unlock_irq(&conf->device_lock);
+		err = alloc_thread_groups(conf, new,
+					  &group_cnt, &worker_cnt_per_group,
+					  &new_groups);
+		if (!err) {
+			spin_lock_irq(&conf->device_lock);
+			conf->group_cnt = group_cnt;
+			conf->worker_cnt_per_group = worker_cnt_per_group;
+			conf->worker_groups = new_groups;
+			spin_unlock_irq(&conf->device_lock);
 
-		if (old_groups)
-			kfree(old_groups[0].workers);
-		kfree(old_groups);
+			if (old_groups)
+				kfree(old_groups[0].workers);
+			kfree(old_groups);
+		}
+		mddev_resume(mddev);
 	}
+	mddev_unlock(mddev);
 
-	mddev_resume(mddev);
-
-	if (err)
-		return err;
-	return len;
+	return err ?: len;
 }
 
 static struct md_sysfs_entry


