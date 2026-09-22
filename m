Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7BA39099E;
	Tue, 22 Sep 2026 02:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790043377; cv=none; b=SRSeG1SxxWFFG+Z8FHz6pgjq3hIfTIKl2Hsz07xJKWif3O11ppc/q4zWFazM1XCINYtQiLTFLNkekXIfBtDA8SN6TSd0JpEogQVtX/agmoKyN19B15vJsAleNEnz3UombxQ5mdQz/POvREZA4I0wx2qW1zat2X9hBbkT3SiCzWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790043377; c=relaxed/simple;
	bh=7A7y9CAxNoq9ANQOit0lBAmSoUankmPZfVDd0778M4o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J8G7sI6t2jBcq5dmqMd/uH7wiqNb0Rm0lcNd/CJMPdqamZSUr/tbBdiaGTGlzAgxUhysCHfXNP/ygwb9/z9rncc2Cjnjw2VMzujFJtXwUpVrG2cljWqsNfzXdHXXdCy9Qlstl3fX3NTrcEimCLCCRliz2eb6zbtS836HUxIK+z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DObo/d60; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DObo/d60"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=6l
	tR3/ax8Dp7by9nVzJ/G+NVE79FlfaZHmqdftpQC60=; b=DObo/d60hz8+YfE3HT
	vVyFMMb6KESSVcb5Fg0AbA5tRZdobY8weV04HEonH/E04ZU4Xt+avZwoqhhYJf7R
	8rk2cl488xbZi36h8V/MYbxQAdvl4wtDqAjY3H5eK5t4bpj4KORcNHJMnx9Tp31B
	YtI4n75MkOtOCa8yjunO7p5eM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3X3vG5LFqvQwSAA--.11206S2;
	Tue, 22 Sep 2026 10:15:36 +0800 (CST)
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
Subject: [PATCH v2] md: remove legacy async del_gendisk
Date: Tue, 22 Sep 2026 10:15:33 +0800
Message-Id: <20260922021533.2935172-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X3vG5LFqvQwSAA--.11206S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3CrWDuF1DXrykGFyUtF17trb_yoW8Gr4fXo
	Z3W3s3Xw1rtryF9348trs7KFW7Xryqkw4rKw15urs8u3WUX34UXrW7ua93Jry3Jwn3KFy0
	q3s7JryfZFWUGw45n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU7LvtDUUUU
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3QlyIWqx5MlVBwAA3j

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
v2:
- Drop legacy_async_del_gendisk, del_work, mddev_delayed_delete(),
  and the flush in md_alloc().
- del_gendisk is synchronous: mddev_unlock() after dropping reconfig_mutex,
  and the last kobject_put() from mddev_put() after dropping all_mddevs_lock.
- __mddev_put() returns whether the caller must complete_delete after
  dropping all_mddevs_lock. md_seq_show() stashes last-put mddev in
  seq->private and complete_delete after the iterator has moved on.
  md_notify_reboot()/md_exit() walk with list_for_each_entry_safe().
- v1: link: https://lore.kernel.org/linux-raid/20260915083354.1603416-1-dayou5941@163.com/ 

---
 drivers/md/md.c | 175 +++++++++++++++++++++++++-----------------------
 drivers/md/md.h |   2 -
 2 files changed, 91 insertions(+), 86 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..5d9e76f3256b 100644
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
@@ -9041,8 +9042,13 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	}
 
 	mddev = list_entry(v, struct mddev, all_mddevs);
-	if (!mddev_get(mddev))
+	if (!mddev_get(mddev)) {
+		md_seq_flush_delete(seq);
 		return 0;
+	}
+
+	/* Previous node is no longer the iterator; delete it if we last-put it. */
+	md_seq_flush_delete(seq);
 
 	spin_unlock(&all_mddevs_lock);
 
@@ -9130,7 +9136,8 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
 		status_unused(seq);
 
-	mddev_put_locked(mddev);
+	if (mddev_put_locked(mddev))
+		seq->private = mddev;
 	return 0;
 }
 
@@ -10714,10 +10721,11 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
-	struct mddev *mddev;
+	struct mddev *mddev, *tmp;
+	bool complete_delete;
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+	list_for_each_entry_safe(mddev, tmp, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
@@ -10729,7 +10737,12 @@ static int md_notify_reboot(struct notifier_block *this,
 			mddev_unlock(mddev);
 		}
 		spin_lock(&all_mddevs_lock);
-		mddev_put_locked(mddev);
+		complete_delete = mddev_put_locked(mddev);
+		if (complete_delete) {
+			spin_unlock(&all_mddevs_lock);
+			mddev_complete_delete(mddev);
+			spin_lock(&all_mddevs_lock);
+		}
 	}
 	spin_unlock(&all_mddevs_lock);
 
@@ -11054,7 +11067,7 @@ void md_autostart_arrays(int part)
 
 static __exit void md_exit(void)
 {
-	struct mddev *mddev;
+	struct mddev *mddev, *tmp;
 	int delay = 1;
 
 	unregister_blkdev(MD_MAJOR,"md");
@@ -11075,20 +11088,15 @@ static __exit void md_exit(void)
 	remove_proc_entry("mdstat", NULL);
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+	list_for_each_entry_safe(mddev, tmp, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
 		export_array(mddev);
 		mddev->ctime = 0;
 		mddev->hold_active = 0;
-		/*
-		 * As the mddev is now fully clear, mddev_put will schedule
-		 * the mddev for destruction by a workqueue, and the
-		 * destroy_workqueue() below will wait for that to complete.
-		 */
+		mddev_put(mddev);
 		spin_lock(&all_mddevs_lock);
-		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 
@@ -11112,7 +11120,6 @@ module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
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
 
-- 
2.25.1

