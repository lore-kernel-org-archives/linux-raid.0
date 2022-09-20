Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4072C6FA82
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 02:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiITC2z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Sep 2022 22:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiITC2w (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Sep 2022 22:28:52 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB22357571
        for <linux-raid@vger.kernel.org>; Mon, 19 Sep 2022 19:28:50 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWllY6gCFzpT23;
        Tue, 20 Sep 2022 10:26:01 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 20 Sep
 2022 10:28:49 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <song@kernel.org>, <linux-raid@vger.kernel.org>
CC:     <yebin10@huawei.com>
Subject: [PATCH -next 3/3] md: introduce md_ro_state to make code easy to understand
Date:   Tue, 20 Sep 2022 10:39:38 +0800
Message-ID: <20220920023938.3273598-4-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220920023938.3273598-1-yebin10@huawei.com>
References: <20220920023938.3273598-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now 'mddev->ro' is use magic number is difficult to understand.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/md/md.c | 152 ++++++++++++++++++++++++++----------------------
 1 file changed, 82 insertions(+), 70 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c981996c298d..0cd1ba459099 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -93,6 +93,18 @@ static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
 
+enum md_ro_state {
+	MD_RDWR,
+	MD_RDONLY,
+	MD_AUTO_READ,
+	MD_MAX_STATE
+};
+
+static bool md_is_rdwr(struct mddev *mddev)
+{
+	return (mddev->ro == MD_RDWR);
+}
+
 /*
  * Default number of read corrections we'll attempt on an rdev
  * before ejecting it from the array. We divide the read error
@@ -444,7 +456,7 @@ static void md_submit_bio(struct bio *bio)
 
 	bio = bio_split_to_limits(bio);
 
-	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
+	if (mddev->ro == MD_RDONLY && unlikely(rw == WRITE)) {
 		if (bio_sectors(bio) != 0)
 			bio->bi_status = BLK_STS_IOERR;
 		bio_endio(bio);
@@ -2639,7 +2651,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	int any_badblocks_changed = 0;
 	int ret = -1;
 
-	if (mddev->ro) {
+	if (!md_is_rdwr(mddev)) {
 		if (force_change)
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		return;
@@ -3901,7 +3913,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		goto out_unlock;
 	}
 	rv = -EROFS;
-	if (mddev->ro)
+	if (!md_is_rdwr(mddev))
 		goto out_unlock;
 
 	/* request to change the personality.  Need to ensure:
@@ -4107,7 +4119,7 @@ layout_store(struct mddev *mddev, const char *buf, size_t len)
 	if (mddev->pers) {
 		if (mddev->pers->check_reshape == NULL)
 			err = -EBUSY;
-		else if (mddev->ro)
+		else if (!md_is_rdwr(mddev))
 			err = -EROFS;
 		else {
 			mddev->new_layout = n;
@@ -4216,7 +4228,7 @@ chunk_size_store(struct mddev *mddev, const char *buf, size_t len)
 	if (mddev->pers) {
 		if (mddev->pers->check_reshape == NULL)
 			err = -EBUSY;
-		else if (mddev->ro)
+		else if (!md_is_rdwr(mddev))
 			err = -EROFS;
 		else {
 			mddev->new_chunk_sectors = n >> 9;
@@ -4339,13 +4351,13 @@ array_state_show(struct mddev *mddev, char *page)
 
 	if (mddev->pers && !test_bit(MD_NOT_READY, &mddev->flags)) {
 		switch(mddev->ro) {
-		case 1:
+		case MD_RDONLY:
 			st = readonly;
 			break;
-		case 2:
+		case MD_AUTO_READ:
 			st = read_auto;
 			break;
-		case 0:
+		case MD_RDWR:
 			spin_lock(&mddev->lock);
 			if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 				st = write_pending;
@@ -4381,7 +4393,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	int err = 0;
 	enum array_state st = match_word(buf, array_states);
 
-	if (mddev->pers && (st == active || st == clean) && mddev->ro != 1) {
+	if (mddev->pers && (st == active || st == clean) &&
+	    mddev->ro != MD_RDONLY) {
 		/* don't take reconfig_mutex when toggling between
 		 * clean and active
 		 */
@@ -4425,23 +4438,23 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		if (mddev->pers)
 			err = md_set_readonly(mddev, NULL);
 		else {
-			mddev->ro = 1;
+			mddev->ro = MD_RDONLY;
 			set_disk_ro(mddev->gendisk, 1);
 			err = do_md_run(mddev);
 		}
 		break;
 	case read_auto:
 		if (mddev->pers) {
-			if (mddev->ro == 0)
+			if (md_is_rdwr(mddev))
 				err = md_set_readonly(mddev, NULL);
-			else if (mddev->ro == 1)
+			else if (mddev->ro == MD_RDONLY)
 				err = restart_array(mddev);
 			if (err == 0) {
-				mddev->ro = 2;
+				mddev->ro = MD_AUTO_READ;
 				set_disk_ro(mddev->gendisk, 0);
 			}
 		} else {
-			mddev->ro = 2;
+			mddev->ro = MD_AUTO_READ;
 			err = do_md_run(mddev);
 		}
 		break;
@@ -4466,7 +4479,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			wake_up(&mddev->sb_wait);
 			err = 0;
 		} else {
-			mddev->ro = 0;
+			mddev->ro = MD_RDWR;
 			set_disk_ro(mddev->gendisk, 0);
 			err = do_md_run(mddev);
 		}
@@ -4765,7 +4778,7 @@ action_show(struct mddev *mddev, char *page)
 	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
 		type = "frozen";
 	else if (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
-	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &recovery))) {
+	    (md_is_rdwr(mddev) && test_bit(MD_RECOVERY_NEEDED, &recovery))) {
 		if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
 			type = "reshape";
 		else if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
@@ -4851,11 +4864,11 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	}
-	if (mddev->ro == 2) {
+	if (mddev->ro == MD_AUTO_READ) {
 		/* A write to sync_action is enough to justify
 		 * canceling read-auto mode
 		 */
-		mddev->ro = 0;
+		mddev->ro = MD_RDWR;
 		md_wakeup_thread(mddev->sync_thread);
 	}
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -5083,8 +5096,7 @@ max_sync_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out_unlock;
 
 		err = -EBUSY;
-		if (max < mddev->resync_max &&
-		    mddev->ro == 0 &&
+		if (max < mddev->resync_max && md_is_rdwr(mddev) &&
 		    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 			goto out_unlock;
 
@@ -5813,8 +5825,8 @@ int md_run(struct mddev *mddev)
 			continue;
 		sync_blockdev(rdev->bdev);
 		invalidate_bdev(rdev->bdev);
-		if (mddev->ro != 1 && rdev_read_only(rdev)) {
-			mddev->ro = 1;
+		if (mddev->ro != MD_RDONLY && rdev_read_only(rdev)) {
+			mddev->ro = MD_RDONLY;
 			if (mddev->gendisk)
 				set_disk_ro(mddev->gendisk, 1);
 		}
@@ -5917,8 +5929,8 @@ int md_run(struct mddev *mddev)
 
 	mddev->ok_start_degraded = start_dirty_degraded;
 
-	if (start_readonly && mddev->ro == 0)
-		mddev->ro = 2; /* read-only, but switch on first write */
+	if (start_readonly && md_is_rdwr(mddev))
+		mddev->ro = MD_AUTO_READ; /* read-only, but switch on first write */
 
 	err = pers->run(mddev);
 	if (err)
@@ -5996,8 +6008,8 @@ int md_run(struct mddev *mddev)
 		mddev->sysfs_action = sysfs_get_dirent_safe(mddev->kobj.sd, "sync_action");
 		mddev->sysfs_completed = sysfs_get_dirent_safe(mddev->kobj.sd, "sync_completed");
 		mddev->sysfs_degraded = sysfs_get_dirent_safe(mddev->kobj.sd, "degraded");
-	} else if (mddev->ro == 2) /* auto-readonly not meaningful */
-		mddev->ro = 0;
+	} else if (mddev->ro == MD_AUTO_READ)
+		mddev->ro = MD_RDWR;
 
 	atomic_set(&mddev->max_corr_read_errors,
 		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
@@ -6015,7 +6027,7 @@ int md_run(struct mddev *mddev)
 		if (rdev->raid_disk >= 0)
 			sysfs_link_rdev(mddev, rdev); /* failure here is OK */
 
-	if (mddev->degraded && !mddev->ro)
+	if (mddev->degraded && md_is_rdwr(mddev))
 		/* This ensures that recovering status is reported immediately
 		 * via sysfs - until a lack of spares is confirmed.
 		 */
@@ -6105,7 +6117,7 @@ static int restart_array(struct mddev *mddev)
 		return -ENXIO;
 	if (!mddev->pers)
 		return -EINVAL;
-	if (!mddev->ro)
+	if (md_is_rdwr(mddev))
 		return -EBUSY;
 
 	rcu_read_lock();
@@ -6124,7 +6136,7 @@ static int restart_array(struct mddev *mddev)
 		return -EROFS;
 
 	mddev->safemode = 0;
-	mddev->ro = 0;
+	mddev->ro = MD_RDWR;
 	set_disk_ro(disk, 0);
 	pr_debug("md: %s switched to read-write mode.\n", mdname(mddev));
 	/* Kick recovery or resync if necessary */
@@ -6151,7 +6163,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->clevel[0] = 0;
 	mddev->flags = 0;
 	mddev->sb_flags = 0;
-	mddev->ro = 0;
+	mddev->ro = MD_RDWR;
 	mddev->metadata_type[0] = 0;
 	mddev->chunk_sectors = 0;
 	mddev->ctime = mddev->utime = 0;
@@ -6203,7 +6215,7 @@ static void __md_stop_writes(struct mddev *mddev)
 	}
 	md_bitmap_flush(mddev);
 
-	if (mddev->ro == 0 &&
+	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
 	     mddev->sb_flags)) {
 		/* mark array as shutdown cleanly */
@@ -6312,9 +6324,9 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 		__md_stop_writes(mddev);
 
 		err  = -ENXIO;
-		if (mddev->ro==1)
+		if (mddev->ro == MD_RDONLY)
 			goto out;
-		mddev->ro = 1;
+		mddev->ro = MD_RDONLY;
 		set_disk_ro(mddev->gendisk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -6371,7 +6383,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		return -EBUSY;
 	}
 	if (mddev->pers) {
-		if (mddev->ro)
+		if (!md_is_rdwr(mddev))
 			set_disk_ro(disk, 0);
 
 		__md_stop_writes(mddev);
@@ -6388,8 +6400,8 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		mutex_unlock(&mddev->open_mutex);
 		mddev->changed = 1;
 
-		if (mddev->ro)
-			mddev->ro = 0;
+		if (!md_is_rdwr(mddev))
+			mddev->ro = MD_RDWR;
 	} else
 		mutex_unlock(&mddev->open_mutex);
 	/*
@@ -7204,7 +7216,7 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 	    mddev->sync_thread)
 		return -EBUSY;
-	if (mddev->ro)
+	if (!md_is_rdwr(mddev))
 		return -EROFS;
 
 	rdev_for_each(rdev, mddev) {
@@ -7234,7 +7246,7 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
 	/* change the number of raid disks */
 	if (mddev->pers->check_reshape == NULL)
 		return -EINVAL;
-	if (mddev->ro)
+	if (!md_is_rdwr(mddev))
 		return -EROFS;
 	if (raid_disks <= 0 ||
 	    (mddev->max_disks && raid_disks >= mddev->max_disks))
@@ -7659,26 +7671,25 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	 * The remaining ioctls are changing the state of the
 	 * superblock, so we do not allow them on read-only arrays.
 	 */
-	if (mddev->ro && mddev->pers) {
-		if (mddev->ro == 2) {
-			mddev->ro = 0;
-			sysfs_notify_dirent_safe(mddev->sysfs_state);
-			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-			/* mddev_unlock will wake thread */
-			/* If a device failed while we were read-only, we
-			 * need to make sure the metadata is updated now.
-			 */
-			if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
-				mddev_unlock(mddev);
-				wait_event(mddev->sb_wait,
-					   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
-					   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
-				mddev_lock_nointr(mddev);
-			}
-		} else {
+	if (!md_is_rdwr(mddev) && mddev->pers) {
+		if (mddev->ro != MD_AUTO_READ) {
 			err = -EROFS;
 			goto unlock;
 		}
+		mddev->ro = MD_RDWR;
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		/* mddev_unlock will wake thread */
+		/* If a device failed while we were read-only, we
+		 * need to make sure the metadata is updated now.
+		 */
+		if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
+			mddev_unlock(mddev);
+			wait_event(mddev->sb_wait,
+				   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
+				   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
+			mddev_lock_nointr(mddev);
+		}
 	}
 
 	switch (cmd) {
@@ -7764,11 +7775,11 @@ static int md_set_read_only(struct block_device *bdev, bool ro)
 	 * Transitioning to read-auto need only happen for arrays that call
 	 * md_write_start and which are not ready for writes yet.
 	 */
-	if (!ro && mddev->ro == 1 && mddev->pers) {
+	if (!ro && mddev->ro == MD_RDONLY && mddev->pers) {
 		err = restart_array(mddev);
 		if (err)
 			goto out_unlock;
-		mddev->ro = 2;
+		mddev->ro = MD_AUTO_READ;
 	}
 
 out_unlock:
@@ -8243,9 +8254,9 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%s : %sactive", mdname(mddev),
 						mddev->pers ? "" : "in");
 		if (mddev->pers) {
-			if (mddev->ro==1)
+			if (mddev->ro == MD_RDONLY)
 				seq_printf(seq, " (read-only)");
-			if (mddev->ro==2)
+			if (mddev->ro == MD_AUTO_READ)
 				seq_printf(seq, " (auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
@@ -8504,10 +8515,10 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
 	if (bio_data_dir(bi) != WRITE)
 		return true;
 
-	BUG_ON(mddev->ro == 1);
-	if (mddev->ro == 2) {
+	BUG_ON(mddev->ro == MD_RDONLY);
+	if (mddev->ro == MD_AUTO_READ) {
 		/* need to switch to read/write */
-		mddev->ro = 0;
+		mddev->ro = MD_RDWR;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		md_wakeup_thread(mddev->sync_thread);
@@ -8558,7 +8569,7 @@ void md_write_inc(struct mddev *mddev, struct bio *bi)
 {
 	if (bio_data_dir(bi) != WRITE)
 		return;
-	WARN_ON_ONCE(mddev->in_sync || mddev->ro);
+	WARN_ON_ONCE(mddev->in_sync || !md_is_rdwr(mddev));
 	percpu_ref_get(&mddev->writes_pending);
 }
 EXPORT_SYMBOL(md_write_inc);
@@ -8663,7 +8674,7 @@ void md_allow_write(struct mddev *mddev)
 {
 	if (!mddev->pers)
 		return;
-	if (mddev->ro)
+	if (!md_is_rdwr(mddev))
 		return;
 	if (!mddev->pers->sync_request)
 		return;
@@ -8711,7 +8722,7 @@ void md_do_sync(struct md_thread *thread)
 	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery))
 		return;
-	if (mddev->ro) {/* never try to sync a read-only array */
+	if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array */
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		return;
 	}
@@ -9180,9 +9191,9 @@ static int remove_and_add_spares(struct mddev *mddev,
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		if (!test_bit(Journal, &rdev->flags)) {
-			if (mddev->ro &&
-			    ! (rdev->saved_raid_disk >= 0 &&
-			       !test_bit(Bitmap_sync, &rdev->flags)))
+			if (!md_is_rdwr(mddev) &&
+			    !(rdev->saved_raid_disk >= 0 &&
+			      !test_bit(Bitmap_sync, &rdev->flags)))
 				continue;
 
 			rdev->recovery_offset = 0;
@@ -9280,7 +9291,8 @@ void md_check_recovery(struct mddev *mddev)
 		flush_signals(current);
 	}
 
-	if (mddev->ro && !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+	if (!md_is_rdwr(mddev) &&
+	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return;
 	if ( ! (
 		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
@@ -9299,7 +9311,7 @@ void md_check_recovery(struct mddev *mddev)
 		if (!mddev->external && mddev->safemode == 1)
 			mddev->safemode = 0;
 
-		if (mddev->ro) {
+		if (!md_is_rdwr(mddev)) {
 			struct md_rdev *rdev;
 			if (!mddev->external && mddev->in_sync)
 				/* 'Blocked' flag not needed as failed devices
-- 
2.31.1

