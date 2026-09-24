Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043FC34A797;
	Thu, 24 Sep 2026 08:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790237797; cv=none; b=K+uaSzdSlco8F+em5BnIHZvzsvolWHUDx6xxbhZqYOPh7MzgypIgjU1v+O+DNKIX6sAWoO6poXHIyZEG1zuR5XLBzk1OxaR/F3p57T6277arxwvCBDe7xMwBEVhMGenR9zwPLTqSKu+aSzlIRF6rlPhHtkSUH1Pzmi/T0IjjP90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790237797; c=relaxed/simple;
	bh=eNxEOjlgOWJ3769Z/LOMZW9ud26xh6c8fE/ouMmofqo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Olxx9FkQjS4bPA5QOzl3SKITa6vUFHJR/zLAC+5LPGOatv7svGTLOl3p4Q1Ndjuk3Hey0NtGi7AOM2+/5Tk31lKVNv1UTauS0AI+XBaCcG5qCkZ2P8IRjAZyjjsveuWEwTsHNCmUOsuRk435RUSJB2hD++T7z1+Dfs8Dq3Y4PH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=hjV06rtc; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hjV06rtc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2J
	vBVtz3JRcuXQE64E5vwT0TpTexauVjj/HUdBcrFDA=; b=hjV06rtcCRyamW+ShZ
	3cesrvOY3zTwdkU6NyvJg0UZD//GLFg983gH8VTF6QP6DvlFNnvRaFOdqGgRffhb
	o0gizhEEq49CHxCA/4W/VkPmEuTZ73TOC/Fc4ilqfoNrLKMNWqCVy9ODPajVDkaS
	1FHja9EdjQymXp5YTi1IWjBTA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDX33g53LRq_q8NAg--.54925S2;
	Thu, 24 Sep 2026 16:15:54 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>,
	syzbot+68e1f51046d68329940f@syzkaller.appspotmail.com,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v3] md: remove legacy async del_gendisk
Date: Thu, 24 Sep 2026 16:15:52 +0800
Message-Id: <20260924081552.2564214-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX33g53LRq_q8NAg--.54925S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3CrWDuF1DXrykGFyUtF17trb_yoW8GFyDKo
	Z3W34fXw1rtryFv348Jws7KFW7Xryqkw4rKw1Y9rs8u3WUXryUJrW7Wa95Wry3Jwn3KFyj
	qwn7JryfZF4UGw45n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU766wDUUUU
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+RsNu2q03DsyoAAA3-

From: Li Youhong <liyouhong@kylinos.cn>

md_alloc() is called from md_probe() while blk_probe_dev() still holds
major_names_lock. It flushes md_misc_wq only to wait for the previous
mddev_delayed_delete() to finish.

md_misc_wq also runs sync_work (md_start_sync), which takes
reconfig_mutex. On the other path, md_ioctl() already holds
reconfig_mutex when md_import_device() opens a bdev and takes
major_names_lock.

Flushing md_misc_wq under major_names_lock therefore creates a lockdep
cycle:

  major_names_lock -> md_misc_wq -> reconfig_mutex -> major_names_lock

legacy_async_del_gendisk has been in tree long enough that the async
path can be removed. del_gendisk is done synchronously from
mddev_unlock() after dropping reconfig_mutex, and the last kobject_put()
runs from mddev_put() after dropping all_mddevs_lock. del_work and the
flush in md_alloc() are then unnecessary.

mdadm 4.5+ is required.

Reported-by: syzbot+68e1f51046d68329940f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=68e1f51046d68329940f
Fixes: e804ac780e2f ("md: fix and update workqueue usage")
Suggested-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
v3:
- md_seq_show() returns without flushing when mddev_get() fails. v is
  still the iterator, and dropping all_mddevs_lock there lets a
  concurrent last put free it before seq_next().
- md_notify_reboot() and md_exit() defer complete_delete until the
  iterator has moved on. list_for_each_entry_safe() caches the next
  mddev before the unlock, and a concurrent last put can free it.
- v2: link: https://lore.kernel.org/linux-raid/20260922021533.2935172-1-dayou5941@163.com/

v2:
- Drop legacy_async_del_gendisk, del_work, mddev_delayed_delete(),
  and the flush in md_alloc().
- del_gendisk is synchronous: mddev_unlock() after dropping reconfig_mutex,
  and the last kobject_put() from mddev_put() after dropping all_mddevs_lock.
- __mddev_put() returns whether the caller must complete_delete after
  dropping all_mddevs_lock. md_seq_show() stashes last-put mddev in
  seq->private and complete_delete after the iterator has moved on.
  md_notify_reboot() does the same with a local pending pointer.
  md_exit() does the same with a local pending pointer.
- v1: link: https://lore.kernel.org/linux-raid/20260915083354.1603416-1-dayou5941@163.com/

---
 drivers/md/md.c | 180 +++++++++++++++++++++++++++++++-------------------------
 drivers/md/md.h |   2 -
 2 files changed, 99 insertions(+), 83 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..fbe302418be9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -87,7 +87,7 @@ static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 
 /*
  * This workqueue is used for sync_work to register new sync_thread, and for
- * del_work to remove rdev, and for event_work that is only set by dm-raid.
+ * event_work that is only set by dm-raid.
  *
  * Noted that sync_work will grab reconfig_mutex, hence never flush this
  * workqueue whith reconfig_mutex grabbed.
@@ -338,7 +338,6 @@ static int start_readonly;
  * so all the races disappear.
  */
 static bool create_on_open = true;
-static bool legacy_async_del_gendisk = true;
 static bool check_new_feature = true;
 
 /*
@@ -633,40 +632,62 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
 	return mddev;
 }
 
-static void mddev_delayed_delete(struct work_struct *ws);
+static void mddev_delete_gendisk(struct mddev *mddev)
+{
+	/*
+	 * Call del_gendisk after releasing reconfig_mutex to avoid
+	 * deadlock (e.g. del_gendisk under the lock while a sysfs
+	 * access waits for the lock).
+	 * MD_DELETED is only used for md raid, set in do_md_stop().
+	 * dm-raid uses md_stop and does not need MD_DELETED.
+	 */
+	if (!test_bit(MD_DELETED, &mddev->flags) ||
+	    test_and_set_bit(MD_DO_DELETE, &mddev->flags))
+		return;
 
-static void __mddev_put(struct mddev *mddev)
+	kobject_del(&mddev->kobj);
+	del_gendisk(mddev->gendisk);
+}
+
+static void mddev_complete_delete(struct mddev *mddev)
+{
+	mddev_delete_gendisk(mddev);
+	kobject_put(&mddev->kobj);
+}
+
+static bool __mddev_put(struct mddev *mddev)
 {
 	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
 	    mddev->ctime || mddev->hold_active)
-		return;
+		return false;
 
 	/*
 	 * If array is freed by stopping array, MD_DELETED is set by
-	 * do_md_stop(), MD_DELETED is still set here in case mddev is freed
+	 * do_md_stop(). Still set it here in case mddev is freed
 	 * directly by closing a mddev that is created by create_on_open.
 	 */
 	set_bit(MD_DELETED, &mddev->flags);
-	/*
-	 * Call queue_work inside the spinlock so that flush_workqueue() after
-	 * mddev_find will succeed in waiting for the work to be done.
-	 */
-	queue_work(md_misc_wq, &mddev->del_work);
+	return true;
 }
 
-static void mddev_put_locked(struct mddev *mddev)
+static bool mddev_put_locked(struct mddev *mddev)
 {
 	if (atomic_dec_and_test(&mddev->active))
-		__mddev_put(mddev);
+		return __mddev_put(mddev);
+	return false;
 }
 
 void mddev_put(struct mddev *mddev)
 {
+	bool complete_delete;
+
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 
-	__mddev_put(mddev);
+	complete_delete = __mddev_put(mddev);
 	spin_unlock(&all_mddevs_lock);
+	if (complete_delete)
+		mddev_complete_delete(mddev);
 }
 
 static void md_safemode_timeout(struct timer_list *t);
@@ -794,7 +815,6 @@ int mddev_init(struct mddev *mddev)
 	mddev->level = LEVEL_NONE;
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
-	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 
 	return 0;
 
@@ -969,21 +989,7 @@ void mddev_unlock(struct mddev *mddev)
 		export_rdev(rdev);
 	}
 
-	if (!legacy_async_del_gendisk) {
-		/*
-		 * Call del_gendisk after release reconfig_mutex to avoid
-		 * deadlock (e.g. call del_gendisk under the lock and an
-		 * access to sysfs files waits the lock)
-		 * And MD_DELETED is only used for md raid which is set in
-		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
-		 * doesn't need to check MD_DELETED when getting reconfig lock
-		 */
-		if (test_bit(MD_DELETED, &mddev->flags) &&
-		    !test_and_set_bit(MD_DO_DELETE, &mddev->flags)) {
-			kobject_del(&mddev->kobj);
-			del_gendisk(mddev->gendisk);
-		}
-	}
+	mddev_delete_gendisk(mddev);
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
 
@@ -6174,13 +6180,10 @@ static void md_kobj_release(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
 
-	if (legacy_async_del_gendisk) {
-		if (mddev->sysfs_state)
-			sysfs_put(mddev->sysfs_state);
-		if (mddev->sysfs_level)
-			sysfs_put(mddev->sysfs_level);
-		del_gendisk(mddev->gendisk);
-	}
+	if (mddev->sysfs_state)
+		sysfs_put(mddev->sysfs_state);
+	if (mddev->sysfs_level)
+		sysfs_put(mddev->sysfs_level);
 	put_disk(mddev->gendisk);
 }
 
@@ -6293,13 +6296,6 @@ void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes)
 }
 EXPORT_SYMBOL_GPL(mddev_update_io_opt);
 
-static void mddev_delayed_delete(struct work_struct *ws)
-{
-	struct mddev *mddev = container_of(ws, struct mddev, del_work);
-
-	kobject_put(&mddev->kobj);
-}
-
 void md_init_stacking_limits(struct queue_limits *lim)
 {
 	blk_set_stacking_limits(lim);
@@ -6327,12 +6323,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	int unit;
 	int error;
 
-	/*
-	 * Wait for any previous instance of this device to be completely
-	 * removed (mddev_delayed_delete).
-	 */
-	flush_workqueue(md_misc_wq);
-
 	mutex_lock(&disks_mutex);
 	mddev = mddev_alloc(dev);
 	if (IS_ERR(mddev)) {
@@ -6422,9 +6412,6 @@ static int md_alloc_and_put(dev_t dev, char *name)
 {
 	struct mddev *mddev = md_alloc(dev, name);
 
-	if (legacy_async_del_gendisk)
-		pr_warn("md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+\n");
-
 	if (IS_ERR(mddev))
 		return PTR_ERR(mddev);
 	mddev_put(mddev);
@@ -6979,21 +6966,10 @@ static void md_clean(struct mddev *mddev)
 	mddev->level = LEVEL_NONE;
 	mddev->clevel[0] = 0;
 
-	/*
-	 * For legacy_async_del_gendisk mode, it can stop the array in the
-	 * middle of assembling it, then it still can access the array. So
-	 * it needs to clear MD_CLOSING. If not legacy_async_del_gendisk,
-	 * it can't open the array again after stopping it. So it doesn't
-	 * clear MD_CLOSING.
-	 */
-	if (legacy_async_del_gendisk && mddev->hold_active) {
-		clear_bit(MD_CLOSING, &mddev->flags);
-	} else {
-		/* if UNTIL_STOP is set, it's cleared here */
-		mddev->hold_active = 0;
-		/* Don't clear MD_CLOSING, or mddev can be opened again. */
-		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
-	}
+	/* if UNTIL_STOP is set, it's cleared here */
+	mddev->hold_active = 0;
+	/* Don't clear MD_CLOSING, or mddev can be opened again. */
+	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
 	mddev->sb_flags = 0;
 	mddev->ro = MD_RDWR;
 	mddev->metadata_type[0] = 0;
@@ -7222,8 +7198,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 
 		export_array(mddev);
 		md_clean(mddev);
-		if (!legacy_async_del_gendisk)
-			set_bit(MD_DELETED, &mddev->flags);
+		set_bit(MD_DELETED, &mddev->flags);
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -8977,10 +8952,31 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	return 1;
 }
 
+/*
+ * seq_file walks all_mddevs with the lock held across next().  Last put
+ * cannot complete_delete in show() or the current list node is freed
+ * before next().  Stash it in seq->private and delete after the iterator
+ * has moved on: the next show() pins the new current first, stop()
+ * handles the last one.
+ */
+static void md_seq_flush_delete(struct seq_file *seq)
+{
+	struct mddev *mddev = seq->private;
+
+	if (!mddev)
+		return;
+
+	seq->private = NULL;
+	spin_unlock(&all_mddevs_lock);
+	mddev_complete_delete(mddev);
+	spin_lock(&all_mddevs_lock);
+}
+
 static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(&all_mddevs_lock)
 {
 	seq->poll_event = atomic_read(&md_event_count);
+	seq->private = NULL;
 	spin_lock(&all_mddevs_lock);
 
 	return seq_list_start_head(&all_mddevs, *pos);
@@ -8994,7 +8990,12 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static void md_seq_stop(struct seq_file *seq, void *v)
 	__releases(&all_mddevs_lock)
 {
+	struct mddev *mddev = seq->private;
+
+	seq->private = NULL;
 	spin_unlock(&all_mddevs_lock);
+	if (mddev)
+		mddev_complete_delete(mddev);
 }
 
 static void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
@@ -9044,6 +9045,9 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	if (!mddev_get(mddev))
 		return 0;
 
+	/* Previous node is no longer the iterator; delete it if we last-put it. */
+	md_seq_flush_delete(seq);
+
 	spin_unlock(&all_mddevs_lock);
 
 	/* prevent bitmap to be freed after checking */
@@ -9130,7 +9134,8 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
 		status_unused(seq);
 
-	mddev_put_locked(mddev);
+	if (mddev_put_locked(mddev))
+		seq->private = mddev;
 	return 0;
 }
 
@@ -10714,13 +10719,19 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
-	struct mddev *mddev;
+	struct mddev *mddev, *pending = NULL;
+	bool complete_delete;
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
+
 		spin_unlock(&all_mddevs_lock);
+		if (pending) {
+			mddev_complete_delete(pending);
+			pending = NULL;
+		}
 		if (mddev_trylock(mddev)) {
 			if (mddev->pers)
 				__md_stop_writes(mddev);
@@ -10729,9 +10740,13 @@ static int md_notify_reboot(struct notifier_block *this,
 			mddev_unlock(mddev);
 		}
 		spin_lock(&all_mddevs_lock);
-		mddev_put_locked(mddev);
+		complete_delete = mddev_put_locked(mddev);
+		if (complete_delete)
+			pending = mddev;
 	}
 	spin_unlock(&all_mddevs_lock);
+	if (pending)
+		mddev_complete_delete(pending);
 
 	return NOTIFY_DONE;
 }
@@ -11054,7 +11069,8 @@ void md_autostart_arrays(int part)
 
 static __exit void md_exit(void)
 {
-	struct mddev *mddev;
+	struct mddev *mddev, *pending = NULL;
+	bool complete_delete;
 	int delay = 1;
 
 	unregister_blkdev(MD_MAJOR,"md");
@@ -11079,18 +11095,21 @@ static __exit void md_exit(void)
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
+		if (pending) {
+			mddev_complete_delete(pending);
+			pending = NULL;
+		}
 		export_array(mddev);
 		mddev->ctime = 0;
 		mddev->hold_active = 0;
-		/*
-		 * As the mddev is now fully clear, mddev_put will schedule
-		 * the mddev for destruction by a workqueue, and the
-		 * destroy_workqueue() below will wait for that to complete.
-		 */
 		spin_lock(&all_mddevs_lock);
-		mddev_put_locked(mddev);
+		complete_delete = mddev_put_locked(mddev);
+		if (complete_delete)
+			pending = mddev;
 	}
 	spin_unlock(&all_mddevs_lock);
+	if (pending)
+		mddev_complete_delete(pending);
 
 	destroy_workqueue(md_misc_wq);
 	md_bitmap_exit();
@@ -11112,7 +11131,6 @@ module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
 module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
 module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
 module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
-module_param(legacy_async_del_gendisk, bool, 0600);
 module_param(check_new_feature, bool, 0600);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b6d2e8929a0f..16a236bd37ce 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -549,8 +549,6 @@ struct mddev {
 	struct kernfs_node		*sysfs_degraded;	/*handle for 'degraded' */
 	struct kernfs_node		*sysfs_level;		/*handle for 'level' */
 
-	/* used for delayed sysfs removal */
-	struct work_struct del_work;
 	/* used for register new sync thread */
 	struct work_struct sync_work;
 

