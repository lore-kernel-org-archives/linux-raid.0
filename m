Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EB22C19E
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 07:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716363159; cv=none; b=CCE5Gra/cVTN0eBsvg0Obgo5dS2BMrqHxpwsdAULbevwyKZPlQgmKZSKdxBKI8vEAzmR1S3/QqIqWb7NED/gDKW+jqlJmoGAR3HYGAHsEENl0A+XiQWHXxu/NU7ARS7afwnXxNZQCsg30cAfRuQA+iU23/12j6SpFpmLMCXcguw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716363159; c=relaxed/simple;
	bh=DNH3Qa7OEPlOgRkWZEwNXJDjp6VTntbeGjY/BN5bcZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MIu2Q3jg5DmqzB9wNdNTT5wLPOMcqmgh/GddHhdSRPQ+oUG/8xMle9KkdFhw8YuxDaQYU+n3IvVUPR6/O06RjdIZUDOBGALWaVClhzpWZU3N7ykl1qaXSR/nsYkLMPyZFy0JZzfv6wdVdh5TLeWiqRWFiDxmAt2gwLT1PniEkeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CKXroa/l; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CKXroa/l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716363158; x=1747899158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DNH3Qa7OEPlOgRkWZEwNXJDjp6VTntbeGjY/BN5bcZw=;
  b=CKXroa/ltMDx1egZBb3X/NMF4kQMebKA3amUtrrn/6yi6TwlURoW8ay3
   jBlNZ3DIz4uEshU8lpg5Ur66G/5YRwcS/wp26iqp/kyP3hr9W8Fmz8vnk
   5u69jULsVv2/OEs2CLFcfvKy4YMZnaP4wnwyseFkrUswZw2URu6vrR7cf
   lgHqXWIVi9qHT3/jnagl85L3kY5VQP7TdCw4vPHypnes8o1Rm+YcsAvZb
   3PeYUJ0MIynJCJf4UdHo+yDq55pzcWNAQgsuvuwZs2jAZLWABEbFVeWJM
   WjaOV5B9opzGflZaOmDNCVDQb4nyVHZJcppO8okNtHt+qh07Bbikgce3b
   Q==;
X-CSE-ConnectionGUID: TQ9eObM1QsmmbG+e8Ugejw==
X-CSE-MsgGUID: DI6APEw/QSqJjTScJsEPPg==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="23207576"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="23207576"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 00:32:37 -0700
X-CSE-ConnectionGUID: HWFVPIZ2R9GTzX6KEFsnMA==
X-CSE-MsgGUID: SmZvOuRLQ0eMEMepkkpERA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="64020615"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa002.jf.intel.com with ESMTP; 22 May 2024 00:32:36 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org
Subject: [PATCH v6 1/1] md: generate CHANGE uevents for md device
Date: Wed, 22 May 2024 09:33:10 +0200
Message-Id: <20240522073310.8014-2-kinga.stefaniuk@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240522073310.8014-1-kinga.stefaniuk@intel.com>
References: <20240522073310.8014-1-kinga.stefaniuk@intel.com>
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
MD has md_new_event() functionality to trigger events and with this
patch this function is extended to generate udev CHANGE uevents. It
cannot be done directly for md_error because this function is called on
interrupts context, so appropriate workqueue is used. Uevents are less time
critical, it is safe to use workqueue. It is limited to CHANGE event as
there is no need to generate other uevents for now.
With this change, mdmonitor events are less likely to be missed. Our
internal tests suite confirms that, mdmonitor reliability is (again)
improved.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>

---

v6: use another workqueue and only on md_error, make configurable
    if kobject_uevent is run immediately on event or queued
v5: fix flush_work missing and commit message fixes
v4: add more detailed commit message
v3: fix problems with calling function from interrupt context,
    add work_queue and queue events notification
v2: resolve merge conflicts with applying the patch
Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
---
 drivers/md/md.c     | 47 ++++++++++++++++++++++++++++++---------------
 drivers/md/md.h     |  2 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff697..2ec696e17f3d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -313,6 +313,16 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 
+/*
+ * Send every new event to the userspace.
+ */
+static void trigger_kobject_uevent(struct work_struct *work)
+{
+	struct mddev *mddev = container_of(work, struct mddev, event_work);
+
+	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+}
+
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
@@ -325,10 +335,15 @@ static bool create_on_open = true;
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
 static atomic_t md_event_count;
-void md_new_event(void)
+void md_new_event(struct mddev *mddev, bool trigger_event)
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
+
+	if (trigger_event)
+		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+	else
+		schedule_work(&mddev->event_work);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
@@ -863,6 +878,7 @@ static void mddev_free(struct mddev *mddev)
 	list_del(&mddev->all_mddevs);
 	spin_unlock(&all_mddevs_lock);
 
+	cancel_work_sync(&mddev->event_work);
 	mddev_destroy(mddev);
 	kfree(mddev);
 }
@@ -2940,7 +2956,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 }
 
@@ -3057,7 +3073,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 				md_kick_rdev_from_array(rdev);
 				if (mddev->pers)
 					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-				md_new_event();
+				md_new_event(mddev, true);
 			}
 		}
 	} else if (cmd_match(buf, "writemostly")) {
@@ -4173,7 +4189,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	sysfs_notify_dirent_safe(mddev->sysfs_level);
-	md_new_event();
+	md_new_event(mddev, true);
 	rv = len;
 out_unlock:
 	mddev_unlock_and_resume(mddev);
@@ -4700,7 +4716,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		export_rdev(rdev, mddev);
 	mddev_unlock_and_resume(mddev);
 	if (!err)
-		md_new_event();
+		md_new_event(mddev, true);
 	return err ? err : len;
 }
 
@@ -5902,6 +5918,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
+	INIT_WORK(&mddev->event_work, trigger_kobject_uevent);
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
@@ -6244,7 +6261,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->sb_flags)
 		md_update_sb(mddev, 0);
 
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 
 bitmap_abort:
@@ -6603,7 +6620,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-	md_new_event();
+	md_new_event(mddev, true);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
 }
@@ -7099,7 +7116,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
-	md_new_event();
+	md_new_event(mddev, true);
 
 	return 0;
 busy:
@@ -7179,7 +7196,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 * array immediately.
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 
 abort_export:
@@ -8159,7 +8176,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	}
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
-	md_new_event();
+	md_new_event(mddev, false);
 }
 EXPORT_SYMBOL(md_error);
 
@@ -9049,7 +9066,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
 	mddev->curr_resync_completed = j;
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
-	md_new_event();
+	md_new_event(mddev, true);
 	update_time = jiffies;
 
 	blk_start_plug(&plug);
@@ -9120,7 +9137,7 @@ void md_do_sync(struct md_thread *thread)
 			/* this is the earliest that rebuild will be
 			 * visible in /proc/mdstat
 			 */
-			md_new_event();
+			md_new_event(mddev, true);
 
 		if (last_check + window > io_sectors || j == max_sectors)
 			continue;
@@ -9386,7 +9403,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
 				spares++;
-			md_new_event();
+			md_new_event(mddev, true);
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
@@ -9505,7 +9522,7 @@ static void md_start_sync(struct work_struct *ws)
 		__mddev_resume(mddev, false);
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev, true);
 	return;
 
 not_running:
@@ -9757,7 +9774,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev, true);
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
 	wake_up(&resync_wait);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ca085ecad504..6c0a45d4613e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -803,7 +803,7 @@ extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
-extern void md_new_event(void);
+extern void md_new_event(struct mddev *mddev, bool trigger_event);
 extern void md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a4556d2e46bf..4f4adbe5da95 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4545,7 +4545,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 
 abort:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2bd1ce9b3922..085206f1cdcc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8503,7 +8503,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_new_event();
+	md_new_event(mddev, true);
 	return 0;
 }
 
-- 
2.35.3

