Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A525185952
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 08:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725266291; cv=none; b=fioR5+5hkbY2wuL3e5z+2TyqjRPruPe824I/X1l0cbnQdtkr+B+SUF9kzuDEGBzqlyirDY36GkPtzLaHKgYBYpRd9wWAAiJVMONp7mU4sttZrO5beAhTrPnLdHfObDKsLlsI4PWWbbLP6dDa1wLn8zoty33ANDqWETGM8aUuroQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725266291; c=relaxed/simple;
	bh=90FE7u77G7fmnJK/Jdkly8PBM7FV8cZAjR74AmAISoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAuW4+Q7RSkqkRd0A/Vm0sqmyBg2KThn7+mYJMuYfdotQgWY271GSFHCriDRDZ7mYmBpv054IjnmlpmQADkI2Wa2B4hUCpbZoHK4xcVVA12lVGTQ7T2IQVaJWnaaq7ztuBFryKHYL9ZOvd5P2qMJUhshc9we95umHeGIYVwILMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jBHdHvKN; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jBHdHvKN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725266289; x=1756802289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=90FE7u77G7fmnJK/Jdkly8PBM7FV8cZAjR74AmAISoY=;
  b=jBHdHvKNhPKBIcl2PWTPWOcYtScv+NdQRvXhGtIt8iwY89fJf2Dc0xUS
   Xb3DdjLFjIRDpSp97WSxfS5QiHihWbD0pJ/LW96Vxb7GcdAEMUuMqqVu0
   eFyJ0bX8HZp5Vbnhd6A9aQl8s+sTYj/K0DKLUKo5ML0d0FWrwrTKsjVKm
   JqQ4j+5e2CpBoxgLDj8bYv5lnh0MlCdgu4gS1cGc/VD/OmqXuHXS5SElC
   Tqb68eUw/ilzqtiPmbHhkIYLkOBEfMPQDThb4gJfMKLkjGQAmfZc9gej7
   hiy0tKRV5QoCUIa2vmomcF0aH/AYDPUurybvqd5+GzdUdgwekD8k3FfdF
   Q==;
X-CSE-ConnectionGUID: gykPlzN6TG6Ei67Vju3Jdw==
X-CSE-MsgGUID: HlO9z+4VRx6fcBKqU+dJDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23643796"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="23643796"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 01:38:09 -0700
X-CSE-ConnectionGUID: eIIeTqv5QjW/NxsZ+Kgyzg==
X-CSE-MsgGUID: xJttBTIeTUCOakYz3frHWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="64513417"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa009.jf.intel.com with ESMTP; 02 Sep 2024 01:38:07 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH md-6.12 v14 1/1] md: generate CHANGE uevents for md device
Date: Mon,  2 Sep 2024 10:38:16 +0200
Message-ID: <20240902083816.26099-2-kinga.stefaniuk@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240902083816.26099-1-kinga.stefaniuk@intel.com>
References: <20240902083816.26099-1-kinga.stefaniuk@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In mdadm commit 49b69533e8 ("mdmonitor: check if udev has finished
events processing") mdmonitor has been learnt to wait for udev to finish
processing, and later in commit 9935cf0f64f3 ("Mdmonitor: Improve udev
event handling") pooling for MD events on /proc/mdstat file has been
deprecated because relying on udev events is more reliable and less bug
prone (we are not competing with udev).

After those changes we are still observing missing mdmonitor events in
some scenarios, especially SpareEvent is likely to be missed. With this
patch MD will be able to generate more change uevents and wakeup
mdmonitor more frequently to give it possibility to notice events.
MD has md_new_events() functionality to trigger events and with this
patch this function is extended to generate udev CHANGE uevents. It
cannot be done directly because this function is called on interrupts
context, so appropriate workqueue is created. Uevents are less time
critical, it is safe to use workqueue. It is limited to CHANGE event as
there is no need to generate other uevents for now.
With this change, mdmonitor events are less likely to be missed. Our
internal tests suite confirms that, mdmonitor reliability is (again)
improved.
Start using irq methods on all_mddevs_lock, because it can be reached
by interrupt context.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>

---
v14: rebase and fix merge conflicts
v13: fix irqsave methods in md_new_event() and mddev_put()
v12: change lock spin_lock/unlock methods on all_mddevs_lock
v11: use irq methods to lock/unlock all_mddevs_lock
v10: move mddev_get into md_new_event
v9: add using md_wq and fix if (sync) condition
v8: fix possible conflict with del_work by adding spin_lock,
    change default sync value to true, now false only on md_error
v7: add new work struct for these events, use md_misc_wq workqueue,
    fix work cancellation
v6: use another workqueue and only on md_error, make configurable
    if kobject_uevent is run immediately on event or queued
v5: fix flush_work missing and commit message fixes
v4: add more detailed commit message
v3: fix problems with calling function from interrupt context,
    add work_queue and queue events notification
v2: resolve merge conflicts with applying the patch

Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
---
 drivers/md/md.c     | 148 +++++++++++++++++++++++++++-----------------
 drivers/md/md.h     |   3 +-
 drivers/md/raid10.c |   2 +-
 drivers/md/raid5.c  |   2 +-
 4 files changed, 94 insertions(+), 61 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 414146111425..177cb78b25b2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -107,6 +107,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
 static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
+static inline struct mddev *mddev_get(struct mddev *mddev);
 
 /*
  * Default number of read corrections we'll attempt on an rdev
@@ -323,6 +324,24 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 
+/*
+ * Enables to iterate over all existing md arrays
+ * all_mddevs_lock protects this list.
+ */
+static LIST_HEAD(all_mddevs);
+static DEFINE_SPINLOCK(all_mddevs_lock);
+
+/*
+ * Send every new event to the userspace.
+ */
+static void md_kobject_uevent_fn(struct work_struct *work)
+{
+	struct mddev *mddev = container_of(work, struct mddev, uevent_work);
+
+	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+	mddev_put(mddev);
+}
+
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
@@ -335,20 +354,30 @@ static bool create_on_open = true;
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
 static atomic_t md_event_count;
-void md_new_event(void)
+
+void md_new_event(struct mddev *mddev, bool sync)
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
+
+	if (mddev_is_dm(mddev))
+		return;
+
+	if (!sync) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&all_mddevs_lock, flags);
+		mddev = mddev_get(mddev);
+		spin_unlock_irqrestore(&all_mddevs_lock, flags);
+		if (mddev == NULL)
+			return;
+		queue_work(md_wq, &mddev->uevent_work);
+		return;
+	}
+	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
-/*
- * Enables to iterate over all existing md arrays
- * all_mddevs_lock protects this list.
- */
-static LIST_HEAD(all_mddevs);
-static DEFINE_SPINLOCK(all_mddevs_lock);
-
 static bool is_md_suspended(struct mddev *mddev)
 {
 	return percpu_ref_is_dying(&mddev->active_io);
@@ -609,11 +638,13 @@ static void __mddev_put(struct mddev *mddev)
 
 void mddev_put(struct mddev *mddev)
 {
-	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
+	unsigned long flags;
+
+	if (!atomic_dec_and_lock_irqsave(&mddev->active, &all_mddevs_lock, flags))
 		return;
 
 	__mddev_put(mddev);
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irqrestore(&all_mddevs_lock, flags);
 }
 
 static void md_safemode_timeout(struct timer_list *t);
@@ -666,6 +697,7 @@ int mddev_init(struct mddev *mddev)
 	mddev->level = LEVEL_NONE;
 	mddev_set_bitmap_ops(mddev);
 
+	INIT_WORK(&mddev->uevent_work, md_kobject_uevent_fn);
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 
@@ -728,7 +760,7 @@ static struct mddev *mddev_alloc(dev_t unit)
 	if (error)
 		goto out_free_new;
 
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 	if (unit) {
 		error = -EEXIST;
 		if (mddev_find_locked(unit))
@@ -749,11 +781,11 @@ static struct mddev *mddev_alloc(dev_t unit)
 	}
 
 	list_add(&new->all_mddevs, &all_mddevs);
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 	return new;
 
 out_destroy_new:
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 	mddev_destroy(new);
 out_free_new:
 	kfree(new);
@@ -762,9 +794,9 @@ static struct mddev *mddev_alloc(dev_t unit)
 
 static void mddev_free(struct mddev *mddev)
 {
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 	list_del(&mddev->all_mddevs);
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 
 	mddev_destroy(mddev);
 	kfree(mddev);
@@ -2809,7 +2841,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 }
 
@@ -2926,7 +2958,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 				md_kick_rdev_from_array(rdev);
 				if (mddev->pers)
 					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-				md_new_event();
+				md_new_event(mddev, true);
 			}
 		}
 	} else if (cmd_match(buf, "writemostly")) {
@@ -3277,19 +3309,19 @@ static bool md_rdev_overlaps(struct md_rdev *rdev)
 	struct mddev *mddev;
 	struct md_rdev *rdev2;
 
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (test_bit(MD_DELETED, &mddev->flags))
 			continue;
 		rdev_for_each(rdev2, mddev) {
 			if (rdev != rdev2 && rdev->bdev == rdev2->bdev &&
 			    md_rdevs_overlap(rdev, rdev2)) {
-				spin_unlock(&all_mddevs_lock);
+				spin_unlock_irq(&all_mddevs_lock);
 				return true;
 			}
 		}
 	}
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 	return false;
 }
 
@@ -4042,7 +4074,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	sysfs_notify_dirent_safe(mddev->sysfs_level);
-	md_new_event();
+	md_new_event(mddev, true);
 	rv = len;
 out_unlock:
 	mddev_unlock_and_resume(mddev);
@@ -4569,7 +4601,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		export_rdev(rdev, mddev);
 	mddev_unlock_and_resume(mddev);
 	if (!err)
-		md_new_event();
+		md_new_event(mddev, true);
 	return err ? err : len;
 }
 
@@ -5644,12 +5676,12 @@ md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 
 	if (!entry->show)
 		return -EIO;
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 	if (!mddev_get(mddev)) {
-		spin_unlock(&all_mddevs_lock);
+		spin_unlock_irq(&all_mddevs_lock);
 		return -EBUSY;
 	}
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 
 	rv = entry->show(mddev, page);
 	mddev_put(mddev);
@@ -5668,12 +5700,12 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 	if (!mddev_get(mddev)) {
-		spin_unlock(&all_mddevs_lock);
+		spin_unlock_irq(&all_mddevs_lock);
 		return -EBUSY;
 	}
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 	rv = entry->store(mddev, page, length);
 	mddev_put(mddev);
 	return rv;
@@ -5818,16 +5850,16 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		/* Need to ensure that 'name' is not a duplicate.
 		 */
 		struct mddev *mddev2;
-		spin_lock(&all_mddevs_lock);
+		spin_lock_irq(&all_mddevs_lock);
 
 		list_for_each_entry(mddev2, &all_mddevs, all_mddevs)
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
-				spin_unlock(&all_mddevs_lock);
+				spin_unlock_irq(&all_mddevs_lock);
 				error = -EEXIST;
 				goto out_free_mddev;
 			}
-		spin_unlock(&all_mddevs_lock);
+		spin_unlock_irq(&all_mddevs_lock);
 	}
 	if (name && dev)
 		/*
@@ -6187,7 +6219,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->sb_flags)
 		md_update_sb(mddev, 0);
 
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 
 bitmap_abort:
@@ -6549,7 +6581,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-	md_new_event();
+	md_new_event(mddev, true);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
 }
@@ -7045,7 +7077,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
-	md_new_event();
+	md_new_event(mddev, true);
 
 	return 0;
 busy:
@@ -7116,7 +7148,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 * array immediately.
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 
 abort_export:
@@ -7881,9 +7913,9 @@ static int md_open(struct gendisk *disk, blk_mode_t mode)
 	struct mddev *mddev;
 	int err;
 
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 	mddev = mddev_get(disk->private_data);
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 	if (!mddev)
 		return -ENODEV;
 
@@ -8086,7 +8118,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	}
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
-	md_new_event();
+	md_new_event(mddev, false);
 }
 EXPORT_SYMBOL(md_error);
 
@@ -8264,7 +8296,7 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(&all_mddevs_lock)
 {
 	seq->poll_event = atomic_read(&md_event_count);
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 
 	return seq_list_start_head(&all_mddevs, *pos);
 }
@@ -8277,7 +8309,7 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static void md_seq_stop(struct seq_file *seq, void *v)
 	__releases(&all_mddevs_lock)
 {
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 }
 
 static void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
@@ -8324,7 +8356,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	if (!mddev_get(mddev))
 		return 0;
 
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 	spin_lock(&mddev->lock);
 	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
 		seq_printf(seq, "%s : %sactive", mdname(mddev),
@@ -8395,7 +8427,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\n");
 	}
 	spin_unlock(&mddev->lock);
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 
 	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
 		status_unused(seq);
@@ -8923,7 +8955,7 @@ void md_do_sync(struct md_thread *thread)
 	try_again:
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto skip;
-		spin_lock(&all_mddevs_lock);
+		spin_lock_irq(&all_mddevs_lock);
 		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
 			if (test_bit(MD_DELETED, &mddev2->flags))
 				continue;
@@ -8958,7 +8990,7 @@ void md_do_sync(struct md_thread *thread)
 							desc, mdname(mddev),
 							mdname(mddev2));
 					}
-					spin_unlock(&all_mddevs_lock);
+					spin_unlock_irq(&all_mddevs_lock);
 
 					if (signal_pending(current))
 						flush_signals(current);
@@ -8969,7 +9001,7 @@ void md_do_sync(struct md_thread *thread)
 				finish_wait(&resync_wait, &wq);
 			}
 		}
-		spin_unlock(&all_mddevs_lock);
+		spin_unlock_irq(&all_mddevs_lock);
 	} while (mddev->curr_resync < MD_RESYNC_DELAYED);
 
 	max_sectors = md_sync_max_sectors(mddev, action);
@@ -9009,7 +9041,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
 	mddev->curr_resync_completed = j;
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
-	md_new_event();
+	md_new_event(mddev, true);
 	update_time = jiffies;
 
 	blk_start_plug(&plug);
@@ -9081,7 +9113,7 @@ void md_do_sync(struct md_thread *thread)
 			/* this is the earliest that rebuild will be
 			 * visible in /proc/mdstat
 			 */
-			md_new_event();
+			md_new_event(mddev, true);
 
 		if (last_check + window > io_sectors || j == max_sectors)
 			continue;
@@ -9347,7 +9379,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
 				spares++;
-			md_new_event();
+			md_new_event(mddev, true);
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
@@ -9466,7 +9498,7 @@ static void md_start_sync(struct work_struct *ws)
 		__mddev_resume(mddev, false);
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev, true);
 	return;
 
 not_running:
@@ -9718,7 +9750,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev, true);
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
 	wake_up(&resync_wait);
@@ -9799,11 +9831,11 @@ static int md_notify_reboot(struct notifier_block *this,
 	struct mddev *mddev, *n;
 	int need_delay = 0;
 
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
-		spin_unlock(&all_mddevs_lock);
+		spin_unlock_irq(&all_mddevs_lock);
 		if (mddev_trylock(mddev)) {
 			if (mddev->pers)
 				__md_stop_writes(mddev);
@@ -9813,9 +9845,9 @@ static int md_notify_reboot(struct notifier_block *this,
 		}
 		need_delay = 1;
 		mddev_put(mddev);
-		spin_lock(&all_mddevs_lock);
+		spin_lock_irq(&all_mddevs_lock);
 	}
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 
 	/*
 	 * certain more exotic SCSI devices are known to be
@@ -10166,11 +10198,11 @@ static __exit void md_exit(void)
 	}
 	remove_proc_entry("mdstat", NULL);
 
-	spin_lock(&all_mddevs_lock);
+	spin_lock_irq(&all_mddevs_lock);
 	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
-		spin_unlock(&all_mddevs_lock);
+		spin_unlock_irq(&all_mddevs_lock);
 		export_array(mddev);
 		mddev->ctime = 0;
 		mddev->hold_active = 0;
@@ -10180,9 +10212,9 @@ static __exit void md_exit(void)
 		 * destroy_workqueue() below will wait for that to complete.
 		 */
 		mddev_put(mddev);
-		spin_lock(&all_mddevs_lock);
+		spin_lock_irq(&all_mddevs_lock);
 	}
-	spin_unlock(&all_mddevs_lock);
+	spin_unlock_irq(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_bitmap_wq);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5d2e6bd58e4d..ffa0cdadba8d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -573,6 +573,7 @@ struct mddev {
 	struct bio_set			io_clone_set;
 
 	struct work_struct event_work;	/* used by dm to report failure event */
+	struct work_struct uevent_work;
 	mempool_t *serial_info_pool;
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
@@ -874,7 +875,7 @@ extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
-extern void md_new_event(void);
+extern void md_new_event(struct mddev *mddev, bool sync);
 extern void md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f3bf1116794a..14912f0f7b1b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4549,7 +4549,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 
 abort:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc2ea636d173..902e02e952e2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8532,7 +8532,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 }
 
-- 
2.43.0

