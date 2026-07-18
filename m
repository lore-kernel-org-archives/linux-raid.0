Received: from sg-3-26.ptr.tlmpb.com (sg-3-26.ptr.tlmpb.com [101.45.255.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD613876A9
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 08:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784364199; cv=none; b=iGqVGV7X6V4sZRUgZ0o4DU8G4l3JBsSoGJdCvnI5bMqT432wg860a4il5cNep25u8vVudDRdZu36Pr9F56o0IOK+Dg4kx78pwGaZkn9XTbUuYUSwYszWzNKainKg75aFlYlWIadFAIAUIHw0ltnTXs2a1+0psHnk6z348IjPY4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784364199; c=relaxed/simple;
	bh=TjcdDnBZytiFaOoeOzr56HRWb7S/ia+OtElB/XphwMU=;
	h=Cc:Message-Id:Subject:Mime-Version:To:From:Date:Content-Type; b=rGN0m4WH61lG32lmW5j9waBlZ2q5T/D4dzUYdnnDbjuwzuwmNpTMR5GrD752nZgnM2B18lrw2b//L2r4eFxnLfG0xXyfE/9D792YjbYIFl0pKZy5zhUDOegbpSJHvgtQxxt9SIZ2kUoYohU9FY+utGogPFXWhMcW/wZ8W+/X8+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=nRINJ51e; arc=none smtp.client-ip=101.45.255.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="nRINJ51e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1784364151;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=NJx3oqD+bDLszlusISLrVeq0NfqyNdcaBdVhtXnYGzI=;
 b=nRINJ51ew6IJgrkWheDkjkd/RAo4AjONO5oPgrvjTtxcffLU4i6MY+Gck7WAAYoa39595e
 aZWabxmv/gJdyVIlo7cJGlq35Aq6dB8jXULonSeG9SJaeHLcsIM4LIonWYN4gpbZKiHTEX
 UI9EI5HGbU+7AwRzaVb/If7tD5hYJ8tLON45yicNl+EwILyMgPUoqZbjpRb9ozCzOQmslS
 0zwKZbCYc+BrpdJb8j05Lj8N/dJO5yu2wVTqqsyk3cUpcNH9N4fGO+WxDVLuj3dxXGfZ5M
 MqdbKDrfaTIucGnK62MVw2N8Suj1P4viIcD7qHm6E/bUY+QucKFWW61QllqrwQ==
Cc: <chencheng@fnnas.com>, <chencheng@fygo.io>, 
	<linux-kernel@vger.kernel.org>
X-Lms-Return-Path: <lba+26a5b3c75+b777a9+vger.kernel.org+chencheng@fnnas.com>
Message-Id: <20260718084218.417895-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
X-Original-From: chencheng@fnnas.com
Subject: [PATCH v2] md: scope memalloc_noio to allocation critical sections
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from fedora ([183.34.161.69]) by smtp.feishu.cn with ESMTPS; Sat, 18 Jul 2026 16:42:28 +0800
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Sat, 18 Jul 2026 16:42:18 +0800
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

Save token as mddev-scoped in mddev->noio_flags cause PF_MEMALLOC_NOIO
leak into task A, while task B restores a token that it never saved.

scenario:

task A                          mddev                       task B
======                          =======                     ============
write suspend_lo
mddev_suspend()
                                suspended == 0
                                drain active_io
                                suspended = 1
A: noio_A = memalloc_noio_save()
A returns with PF_MEMALLOC_NOIO set

                                                            write suspend_hi
                                                            mddev_suspend()
                                suspended == 1
                                suspended = 2
                                                            B returns
                                                            (no save)

mddev_resume()
                                suspended = 1
                                not last resume
A returns
A still has PF_MEMALLOC_NOIO   <-- leaked

                                                            mddev_resume()
                                suspended = 0
                                                            memalloc_noio_restore(noio_A)
                                                            (restores A's token in B)

Fixed by:
call flags = memalloc_noio_save() directly in mdraid, where:
	1) after array suspend succeed;
	2) before allocating memory

Validation:
repeatedly updates the array's suspend_lo and suspend_hi sysfs from many
concurrent userspace workers. That makes multiple tasks to call
mddev_suspend()/mddev_resume() concurrently.

Each worker:
  - reads its initial /proc/self/stat flags and verifies that PF_MEMALLOC_NOIO is not already
    set
  - writes 0 to either suspend_lo or suspend_hi
  - immediately reads its own task flags again
  - reports success if flags & PF_MEMALLOC_NOIO is true after the write returns

Link: https://github.com/chencheng-fnnas/reproducer/blob/main/repro-md-noio-token-leak.sh
Fixes: 78f57ef9d50a ("md: use memalloc scope APIs in mddev_suspend()/mddev_resume()")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---

rfc -> v1:
        - dm-raid side just bypass because suspend and resume not in the
          same task context..

v1 -> v2:
        - just call flags = memalloc_noio_save() directly in mdraid
                (suggest by Yu Kuai)
---
 drivers/md/md-bitmap.c |  3 +++
 drivers/md/md.c        | 52 ++++++++++++++++++++++++++++--------------
 drivers/md/md.h        |  1 -
 drivers/md/raid5.c     | 14 ++++++++----
 4 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 3e40cb45d473..6d495cdf3fb2 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2621,14 +2621,16 @@ location_show(struct mddev *mddev, char *page)
 
 static ssize_t
 location_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int rv;
+	unsigned int noio_flags;
 
 	rv = mddev_suspend_and_lock(mddev);
 	if (rv)
 		return rv;
+	noio_flags = memalloc_noio_save();
 
 	if (mddev->pers) {
 		if (mddev->recovery || mddev->sync_thread) {
 			rv = -EBUSY;
 			goto out;
@@ -2711,10 +2713,11 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
 	}
 	rv = 0;
 out:
+	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
 	if (rv)
 		return rv;
 	return len;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..25e06f088dc1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -231,35 +231,35 @@ static int rdev_need_serial(struct md_rdev *rdev)
  * 2. rdev is NULL, means we want to enable serialization for all rdevs.
  */
 void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 {
 	int ret = 0;
+	unsigned int noio_flags;
 
 	if (rdev && !rdev_need_serial(rdev) &&
 	    !test_bit(CollisionCheck, &rdev->flags))
 		return;
 
+	noio_flags = memalloc_noio_save();
 	if (!rdev)
 		ret = rdevs_init_serial(mddev);
 	else
 		ret = rdev_init_serial(rdev);
 	if (ret)
-		return;
+		goto out;
 
 	if (mddev->serial_info_pool == NULL) {
-		/*
-		 * already in memalloc noio context by
-		 * mddev_suspend()
-		 */
 		mddev->serial_info_pool =
 			mempool_create_kmalloc_pool(NR_SERIAL_INFOS,
 						sizeof(struct serial_info));
 		if (!mddev->serial_info_pool) {
 			rdevs_uninit_serial(mddev);
 			pr_err("can't alloc memory pool for serialization\n");
 		}
 	}
+out:
+	memalloc_noio_restore(noio_flags);
 }
 
 /*
  * Free resource from rdev(s), and destroy serial_info_pool under conditions:
  * 1. rdev is the last device flaged with CollisionCheck.
@@ -514,13 +514,10 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 	 * allow new reshape to start while waiting for io to be done to
 	 * prevent deadlock.
 	 */
 	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
 
-	/* restrict memory reclaim I/O during raid array is suspend */
-	mddev->noio_flag = memalloc_noio_save();
-
 	mutex_unlock(&mddev->suspend_mutex);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 
@@ -533,13 +530,10 @@ static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
 	if (mddev->suspended) {
 		mutex_unlock(&mddev->suspend_mutex);
 		return;
 	}
 
-	/* entred the memalloc scope from mddev_suspend() */
-	memalloc_noio_restore(mddev->noio_flag);
-
 	percpu_ref_resurrect(&mddev->active_io);
 	wake_up(&mddev->sb_wait);
 
 	if (recovery_needed)
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -4045,10 +4039,11 @@ static ssize_t
 level_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	char clevel[16];
 	ssize_t rv;
 	size_t slen = len;
+	unsigned int noio_flags;
 	struct md_personality *pers, *oldpers;
 	long level;
 	void *priv, *oldpriv;
 	struct md_rdev *rdev;
 
@@ -4056,10 +4051,11 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EINVAL;
 
 	rv = mddev_suspend_and_lock(mddev);
 	if (rv)
 		return rv;
+	noio_flags = memalloc_noio_save();
 
 	if (mddev->pers == NULL) {
 		memcpy(mddev->clevel, buf, slen);
 		if (mddev->clevel[slen-1] == '\n')
 			slen--;
@@ -4231,10 +4227,11 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		md_update_sb(mddev, 1);
 	sysfs_notify_dirent_safe(mddev->sysfs_level);
 	md_new_event();
 	rv = len;
 out_unlock:
+	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
 	return rv;
 }
 
 static struct md_sysfs_entry md_level =
@@ -4410,19 +4407,21 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks);
 
 static ssize_t
 raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned int n;
+	unsigned int noio_flags;
 	int err;
 
 	err = kstrtouint(buf, 10, &n);
 	if (err < 0)
 		return err;
 
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
+	noio_flags = memalloc_noio_save();
 	if (mddev->pers) {
 		if (n != mddev->raid_disks)
 			err = update_raid_disks(mddev, n);
 	} else if (mddev->reshape_position != MaxSector) {
 		struct md_rdev *rdev;
@@ -4442,10 +4441,11 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->raid_disks = n;
 		mddev->reshape_backwards = (mddev->delta_disks < 0);
 	} else
 		mddev->raid_disks = n;
 out_unlock:
+	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
 	return err ? err : len;
 }
 static struct md_sysfs_entry md_raid_disks =
 __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
@@ -4822,10 +4822,11 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	char *e;
 	int major = simple_strtoul(buf, &e, 10);
 	int minor;
 	dev_t dev;
 	struct md_rdev *rdev;
+	unsigned int noio_flags;
 	int err;
 
 	if (!*buf || *e != ':' || !e[1] || e[1] == '\n')
 		return -EINVAL;
 	minor = simple_strtoul(e+1, &e, 10);
@@ -4837,10 +4838,11 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EOVERFLOW;
 
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
+	noio_flags = memalloc_noio_save();
 	if (mddev->persistent) {
 		rdev = md_import_device(dev, mddev->major_version,
 					mddev->minor_version);
 		if (!IS_ERR(rdev) && !list_empty(&mddev->disks)) {
 			struct md_rdev *rdev0
@@ -4855,17 +4857,19 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		rdev = md_import_device(dev, -2, -1);
 	else
 		rdev = md_import_device(dev, -1, -1);
 
 	if (IS_ERR(rdev)) {
+		memalloc_noio_restore(noio_flags);
 		mddev_unlock_and_resume(mddev);
 		return PTR_ERR(rdev);
 	}
 	err = bind_rdev_to_array(rdev, mddev);
  out:
 	if (err)
 		export_rdev(rdev);
+	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
 	if (!err)
 		md_new_event();
 	return err ? err : len;
 }
@@ -8322,12 +8326,14 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 
 static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
+	unsigned int noio_flags = 0;
 	void __user *argp = (void __user *)arg;
 	struct mddev *mddev = NULL;
+	bool suspend;
 
 	err = md_ioctl_valid(cmd);
 	if (err)
 		return err;
 
@@ -8373,17 +8379,19 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	}
 
 	if (!md_is_rdwr(mddev))
 		flush_work(&mddev->sync_work);
 
-	err = md_ioctl_need_suspend(cmd) ? mddev_suspend_and_lock(mddev) :
-					   mddev_lock(mddev);
+	suspend = md_ioctl_need_suspend(cmd);
+	err = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
 	if (err) {
 		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
 			 err, cmd);
 		goto out;
 	}
+	if (suspend)
+		noio_flags = memalloc_noio_save();
 
 	if (cmd == SET_ARRAY_INFO) {
 		err = __md_set_array_info(mddev, argp);
 		goto unlock;
 	}
@@ -8504,12 +8512,16 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 unlock:
 	if (mddev->hold_active == UNTIL_IOCTL &&
 	    err != -EINVAL)
 		mddev->hold_active = 0;
 
-	md_ioctl_need_suspend(cmd) ? mddev_unlock_and_resume(mddev) :
-				     mddev_unlock(mddev);
+	if (suspend) {
+		memalloc_noio_restore(noio_flags);
+		mddev_unlock_and_resume(mddev);
+	} else {
+		mddev_unlock(mddev);
+	}
 
 out:
 	if (cmd == STOP_ARRAY_RO || (err && cmd == STOP_ARRAY))
 		clear_bit(MD_CLOSING, &mddev->flags);
 	return err;
@@ -10173,20 +10185,22 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 static void md_start_sync(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
 	int spares = 0;
 	bool suspend = false;
+	unsigned int noio_flags = 0;
 	char *name;
 
 	/*
 	 * If reshape is still in progress, spares won't be added or removed
 	 * from conf until reshape is done.
 	 */
 	if (mddev->reshape_position == MaxSector &&
 	    md_spares_need_change(mddev)) {
 		suspend = true;
 		mddev_suspend(mddev, false);
+		noio_flags = memalloc_noio_save();
 	}
 
 	mddev_lock_nointr(mddev);
 	if (!md_is_rdwr(mddev)) {
 		/*
@@ -10229,12 +10243,14 @@ static void md_start_sync(struct work_struct *ws)
 	 * md_start_sync was triggered by MD_RECOVERY_NEEDED, so we should
 	 * not set it again. Otherwise, we may cause issue like this one:
 	 *     https://bugzilla.kernel.org/show_bug.cgi?id=218200
 	 * Therefore, use __mddev_resume(mddev, false).
 	 */
-	if (suspend)
+	if (suspend) {
+		memalloc_noio_restore(noio_flags);
 		__mddev_resume(mddev, false);
+	}
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event();
 	return;
 
@@ -10249,12 +10265,14 @@ static void md_start_sync(struct work_struct *ws)
 	 * md_start_sync was triggered by MD_RECOVERY_NEEDED, so we should
 	 * not set it again. Otherwise, we may cause issue like this one:
 	 *     https://bugzilla.kernel.org/show_bug.cgi?id=218200
 	 * Therefore, use __mddev_resume(mddev, false).
 	 */
-	if (suspend)
+	if (suspend) {
+		memalloc_noio_restore(noio_flags);
 		__mddev_resume(mddev, false);
+	}
 
 	wake_up(&resync_wait);
 	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
 	    mddev->sysfs_action)
 		sysfs_notify_dirent_safe(mddev->sysfs_action);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8daf0f75cbb..76488cd9e81e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -619,11 +619,10 @@ struct mddev {
 	mempool_t *serial_info_pool;
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
 	struct md_cluster_operations *cluster_ops;
 	unsigned int			good_device_nr;	/* good device num within cluster raid */
-	unsigned int			noio_flag; /* for memalloc scope API */
 
 	/*
 	 * Temporarily store rdev that will be finally removed when
 	 * reconfig_mutex is unlocked, protected by reconfig_mutex.
 	 */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 65ae7d8930fc..863dcb396d8b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2454,15 +2454,10 @@ static int scribble_alloc(struct raid5_percpu *percpu,
 		sizeof(struct page *) * (num + 2) +
 		sizeof(addr_conv_t) * (num + 2) +
 		sizeof(unsigned int) * (num + 2);
 	void *scribble;
 
-	/*
-	 * If here is in raid array suspend context, it is in memalloc noio
-	 * context as well, there is no potential recursive memory reclaim
-	 * I/Os with the GFP_KERNEL flag.
-	 */
 	scribble = kvmalloc_array(cnt, obj_size, GFP_KERNEL);
 	if (!scribble)
 		return -ENOMEM;
 
 	kvfree(percpu->scribble);
@@ -2473,18 +2468,20 @@ static int scribble_alloc(struct raid5_percpu *percpu,
 }
 
 static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 {
 	unsigned long cpu;
+	unsigned int noio_flags;
 	int err = 0;
 
 	/* Never shrink. */
 	if (conf->scribble_disks >= new_disks &&
 	    conf->scribble_sectors >= new_sectors)
 		return 0;
 
 	raid5_quiesce(conf->mddev, true);
+	noio_flags = memalloc_noio_save();
 	cpus_read_lock();
 
 	for_each_present_cpu(cpu) {
 		struct raid5_percpu *percpu;
 
@@ -2494,10 +2491,11 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 		if (err)
 			break;
 	}
 
 	cpus_read_unlock();
+	memalloc_noio_restore(noio_flags);
 	raid5_quiesce(conf->mddev, false);
 
 	if (!err) {
 		conf->scribble_disks = new_disks;
 		conf->scribble_sectors = new_sectors;
@@ -6993,10 +6991,11 @@ raid5_show_stripe_size(struct mddev  *mddev, char *page)
 static ssize_t
 raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 {
 	struct r5conf *conf;
 	unsigned long new;
+	unsigned int noio_flags = 0;
 	int err;
 	int size;
 
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
@@ -7033,10 +7032,11 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 	    mddev->reshape_position != MaxSector || mddev->sysfs_active) {
 		err = -EBUSY;
 		goto out_unlock;
 	}
 
+	noio_flags = memalloc_noio_save();
 	mutex_lock(&conf->cache_size_mutex);
 	size = conf->max_nr_stripes;
 
 	shrink_stripes(conf);
 
@@ -7049,10 +7049,11 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 		err = -ENOMEM;
 	}
 	mutex_unlock(&conf->cache_size_mutex);
 
 out_unlock:
+	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
 	return err ?: len;
 }
 
 static struct md_sysfs_entry
@@ -8940,10 +8941,11 @@ static void *raid6_takeover(struct mddev *mddev)
 }
 
 static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 {
 	struct r5conf *conf;
+	unsigned int noio_flags;
 	int err;
 
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
@@ -8951,10 +8953,11 @@ static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 	if (!conf) {
 		mddev_unlock_and_resume(mddev);
 		return -ENODEV;
 	}
 
+	noio_flags = memalloc_noio_save();
 	if (strncmp(buf, "ppl", 3) == 0) {
 		/* ppl only works with RAID 5 */
 		if (!raid5_has_ppl(conf) && conf->level == 5) {
 			err = log_init(conf, NULL, true);
 			if (!err) {
@@ -8990,10 +8993,11 @@ static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 	}
 
 	if (!err)
 		md_update_sb(mddev, 1);
 
+	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
 
 	return err;
 }
 
-- 
2.54.0
