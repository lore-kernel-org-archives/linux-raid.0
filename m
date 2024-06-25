Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BCF16F859
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719325686; cv=none; b=HIsZUE/Z3IvcUPvzLmOdgQy5CWLS2zeQZ5+Tu4WOEMXoxYbZYnBxfhr7KgvRPpPhJC9p/bRlR/O5NLg8vagysqM/5fIvrBrsyYqoNpFZXCGjdedg6kxWI++DLvxC7HTrEto9PSqp4TYgmYi3oRCfzuVJVVCNs4AshkbIhT+IAtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719325686; c=relaxed/simple;
	bh=5xt2oM+1KiMFdbI//ytebLblljA0ds3DAB4poBaFT7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7Upf6R0Afi768dtTHABlOb0VMH4y1DX2a95zWHoLbPbe0zQ58T7T0d28cbKljGksXOPjhqP0DZdQbfvdlXIn2cLMIhwILwpDe70b1+tGRnhPbohWDaaFQ5BDCBvhw4eRCLwL48ij6Q6jZzeQCI4OIf9qbJ7iwvzpSuZTaMbcdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C04XZeoX; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C04XZeoX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719325685; x=1750861685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5xt2oM+1KiMFdbI//ytebLblljA0ds3DAB4poBaFT7M=;
  b=C04XZeoXfl0bXN6A+kTPQe9MhsaQ+AUuNP4sxYW6HTldYtlWMy50fWnN
   N2+S2bOCF4mxc52SMEwuIYi7f5431w4jngBMOcl8QwVwWof5KMq3QZUol
   FVeA9MTmmGHpoVlyjklhO24TzGWyiIsYa9fewuUzaV0kAJ9L6mEOC0M8U
   mfWJ1fxf12dX5d42I1Wed5i/PbFdAn9++D1ZGN/0PWCWeS9sFmeWxO9+m
   XiwELAO4EFAZgB+fePxEBY7ZuxvL7P3vXQ7DI7vaTOl0ExauuoGSFMoie
   FMVBH9SMxUsolWiCP/S/7Mi+crwHRYBIk/c1a/0ZelniKY3gVfBs/PQS3
   Q==;
X-CSE-ConnectionGUID: +9faAXngSI2lmhRxqHLfBA==
X-CSE-MsgGUID: MuGel0TWR4epWy8vIzxO/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16491757"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="16491757"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 07:28:05 -0700
X-CSE-ConnectionGUID: 6ED2l0smQJ6LOWHoRXbKjQ==
X-CSE-MsgGUID: /6jtlY+2Te6UxGjdfb9isA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="44373932"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa008.jf.intel.com with ESMTP; 25 Jun 2024 07:28:03 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH v7] md: generate CHANGE uevents for md device
Date: Tue, 25 Jun 2024 16:29:28 +0200
Message-ID: <20240625142928.28090-2-kinga.stefaniuk@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625142928.28090-1-kinga.stefaniuk@intel.com>
References: <20240625142928.28090-1-kinga.stefaniuk@intel.com>
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

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>

---
v7: add new work struct for these events, use md_misc_wq workqueue,
    fix work cancellation
v6: use another workqueue and only on md_error, make configurable
    if kobject_uevent is run immediately on event or queued
v5: fix flush_work missing and commit message fixes
v4: add more detailed commit message
v3: fix problems with calling function from interrupt context,
    add work_queue and queue events notification
v2: resolve merge conflicts with applying the patch

---
 drivers/md/md.c     | 50 +++++++++++++++++++++++++++++++--------------
 drivers/md/md.h     |  3 ++-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff697..3b976e3bd702 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -313,6 +313,16 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 
+/*
+ * Send every new event to the userspace.
+ */
+static void md_kobject_uevent_fn(struct work_struct *work)
+{
+	struct mddev *mddev = container_of(work, struct mddev, uevent_work);
+
+	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+}
+
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
@@ -325,10 +335,17 @@ static bool create_on_open = true;
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
 static atomic_t md_event_count;
-void md_new_event(void)
+void md_new_event(struct mddev *mddev, bool sync)
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
+
+	if (mddev_is_dm(mddev))
+		return;
+	if (sync)
+		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+	else
+		queue_work(md_misc_wq, &mddev->uevent_work);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
@@ -765,6 +782,7 @@ int mddev_init(struct mddev *mddev)
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
+	INIT_WORK(&mddev->uevent_work, md_kobject_uevent_fn);
 
 	return 0;
 }
@@ -2940,7 +2958,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev, false);
 	return 0;
 }
 
@@ -3057,7 +3075,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 				md_kick_rdev_from_array(rdev);
 				if (mddev->pers)
 					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-				md_new_event();
+				md_new_event(mddev, false);
 			}
 		}
 	} else if (cmd_match(buf, "writemostly")) {
@@ -4173,7 +4191,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	sysfs_notify_dirent_safe(mddev->sysfs_level);
-	md_new_event();
+	md_new_event(mddev, false);
 	rv = len;
 out_unlock:
 	mddev_unlock_and_resume(mddev);
@@ -4700,7 +4718,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		export_rdev(rdev, mddev);
 	mddev_unlock_and_resume(mddev);
 	if (!err)
-		md_new_event();
+		md_new_event(mddev, false);
 	return err ? err : len;
 }
 
@@ -5803,6 +5821,7 @@ static void mddev_delayed_delete(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
 
+	cancel_work_sync(&mddev->uevent_work);
 	kobject_put(&mddev->kobj);
 }
 
@@ -6244,7 +6263,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->sb_flags)
 		md_update_sb(mddev, 0);
 
-	md_new_event();
+	md_new_event(mddev, false);
 	return 0;
 
 bitmap_abort:
@@ -6603,7 +6622,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-	md_new_event();
+	md_new_event(mddev, false);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
 }
@@ -7099,7 +7118,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
-	md_new_event();
+	md_new_event(mddev, false);
 
 	return 0;
 busy:
@@ -7179,7 +7198,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 * array immediately.
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev, false);
 	return 0;
 
 abort_export:
@@ -8159,7 +8178,8 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	}
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
-	md_new_event();
+	if (!test_bit(MD_DELETED, &mddev->flags))
+		md_new_event(mddev, true);
 }
 EXPORT_SYMBOL(md_error);
 
@@ -9049,7 +9069,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
 	mddev->curr_resync_completed = j;
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
-	md_new_event();
+	md_new_event(mddev, false);
 	update_time = jiffies;
 
 	blk_start_plug(&plug);
@@ -9120,7 +9140,7 @@ void md_do_sync(struct md_thread *thread)
 			/* this is the earliest that rebuild will be
 			 * visible in /proc/mdstat
 			 */
-			md_new_event();
+			md_new_event(mddev, false);
 
 		if (last_check + window > io_sectors || j == max_sectors)
 			continue;
@@ -9386,7 +9406,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
 				spares++;
-			md_new_event();
+			md_new_event(mddev, false);
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
@@ -9505,7 +9525,7 @@ static void md_start_sync(struct work_struct *ws)
 		__mddev_resume(mddev, false);
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev, false);
 	return;
 
 not_running:
@@ -9757,7 +9777,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev, false);
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
 	wake_up(&resync_wait);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ca085ecad504..e1fe88c1c0f7 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -528,6 +528,7 @@ struct mddev {
 						*/
 	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
+	struct work_struct uevent_work;
 	mempool_t *serial_info_pool;
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
@@ -803,7 +804,7 @@ extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
-extern void md_new_event(void);
+extern void md_new_event(struct mddev *mddev, bool sync);
 extern void md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a4556d2e46bf..fe743168dd35 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4545,7 +4545,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_new_event();
+	md_new_event(mddev, false);
 	return 0;
 
 abort:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2bd1ce9b3922..6e61cc13b9c2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8503,7 +8503,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_new_event();
+	md_new_event(mddev, false);
 	return 0;
 }
 
-- 
2.43.0

