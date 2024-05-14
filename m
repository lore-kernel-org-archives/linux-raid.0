Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8201812EBF3
	for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 09:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715679290; cv=none; b=KO67SZi6isGtVoD0wwv/CQT0Y4fkqGrGVl4P62cL88NnF03iXPR+cyjPBwUOhznmdn2PQL8sUmGJpPBGAEG5yvbj5Q374VN+xfYLANgzccJxm4zGTypIl5fgs2++2GKjhIukrPOZlABk45EULoziAtKiOxjiX+tj36A/oO2doKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715679290; c=relaxed/simple;
	bh=eXZ1qfgfdL6zFjqI6VKqjOq333gSpQL4KaGz5QsnhYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Db3RRN0J6rAdq6IUS9YKiP3ZZ3iRSUzCCM/ntSnQQL+B9hKUJ/OzdZ8Cl8FVnaN2VrsA1dua7L7eDEghINAvkNPxB8BFuVkQMNRVQNmxupJd1453CGFgsy9y8GguolXjCS5WL0ITwAtSdqQ83jRAwDCx3xXru7At055dU+tzYQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y86vk8lt; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y86vk8lt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715679289; x=1747215289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eXZ1qfgfdL6zFjqI6VKqjOq333gSpQL4KaGz5QsnhYM=;
  b=Y86vk8ltNKf6+drywHoLLoHCds6RkjZmBBJwsOxImmyaSCD6nbRgYvdq
   CE+69ItjdL0d9HHTqskax6dvGBXwfxsZTNW5xS0B/NrQkY6edonIZg8o3
   gYSpJs2CxAZ5CBP2IGUL/H4FfKEbitBKTksc1bfxstOsAP+6duHSlCVVJ
   JwsNskq7vtZHrCNgXJTAmGxUIOWmcaBRU35CnWb9BpxIoOE34HTikLKck
   y4KzZX8QJlZiS16P2fHg3c4m9ggvOI6/0A11nrqfuHIin6c6/GAVOYthS
   voJEie9PO44WrAHkdaTOl5BWXHkGtmIEPzSuaLO2JTwJMijvO1a6MRF7s
   w==;
X-CSE-ConnectionGUID: p4LLusIvQrarN1K9J4di8g==
X-CSE-MsgGUID: tWr00r7pTSyg/jC8NA6E/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="22796869"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="22796869"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 02:34:49 -0700
X-CSE-ConnectionGUID: OhESZOBsTsKaZnHe/tAGtg==
X-CSE-MsgGUID: K+laVzOIQpyT6yD6O4q/fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="61456037"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa002.jf.intel.com with ESMTP; 14 May 2024 02:34:47 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org
Subject: [PATCH v5 1/1] md: generate CHANGE uevents for md device
Date: Tue, 14 May 2024 11:35:01 +0200
Message-Id: <20240514093501.2527-2-kinga.stefaniuk@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240514093501.2527-1-kinga.stefaniuk@intel.com>
References: <20240514093501.2527-1-kinga.stefaniuk@intel.com>
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

v5: fix flush_work missing and commit message fixes
v4: add more detailed commit message
v3: fix problems with calling function from interrupt context,
    add work_queue and queue events notification
v2: resolve merge conflicts with applying the patch
---
 drivers/md/md.c     | 44 +++++++++++++++++++++++++++++---------------
 drivers/md/md.h     |  3 ++-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e575e74aabf5..e2016c0a08c9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -313,6 +313,16 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 
+/*
+ * Send every new event to the userspace.
+ */
+static void trigger_event(struct work_struct *work)
+{
+	struct mddev *mddev = container_of(work, struct mddev, uevent_work);
+
+	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+}
+
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
@@ -325,10 +335,11 @@ static bool create_on_open = true;
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
 static atomic_t md_event_count;
-void md_new_event(void)
+void md_new_event(struct mddev *mddev)
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
+	schedule_work(&mddev->uevent_work);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
@@ -2940,7 +2951,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 }
 
@@ -3057,7 +3068,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 				md_kick_rdev_from_array(rdev);
 				if (mddev->pers)
 					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-				md_new_event();
+				md_new_event(mddev);
 			}
 		}
 	} else if (cmd_match(buf, "writemostly")) {
@@ -4173,7 +4184,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	sysfs_notify_dirent_safe(mddev->sysfs_level);
-	md_new_event();
+	md_new_event(mddev);
 	rv = len;
 out_unlock:
 	mddev_unlock_and_resume(mddev);
@@ -4700,7 +4711,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		export_rdev(rdev, mddev);
 	mddev_unlock_and_resume(mddev);
 	if (!err)
-		md_new_event();
+		md_new_event(mddev);
 	return err ? err : len;
 }
 
@@ -5902,6 +5913,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
+	INIT_WORK(&mddev->uevent_work, trigger_event);
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
@@ -6244,7 +6256,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->sb_flags)
 		md_update_sb(mddev, 0);
 
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 
 bitmap_abort:
@@ -6603,7 +6615,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-	md_new_event();
+	md_new_event(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
 }
@@ -7099,7 +7111,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
-	md_new_event();
+	md_new_event(mddev);
 
 	return 0;
 busy:
@@ -7179,7 +7191,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 * array immediately.
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 
 abort_export:
@@ -8158,7 +8170,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	}
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
-	md_new_event();
+	md_new_event(mddev);
 }
 EXPORT_SYMBOL(md_error);
 
@@ -9044,7 +9056,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
 	mddev->curr_resync_completed = j;
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
-	md_new_event();
+	md_new_event(mddev);
 	update_time = jiffies;
 
 	blk_start_plug(&plug);
@@ -9115,7 +9127,7 @@ void md_do_sync(struct md_thread *thread)
 			/* this is the earliest that rebuild will be
 			 * visible in /proc/mdstat
 			 */
-			md_new_event();
+			md_new_event(mddev);
 
 		if (last_check + window > io_sectors || j == max_sectors)
 			continue;
@@ -9381,7 +9393,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
 				spares++;
-			md_new_event();
+			md_new_event(mddev);
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
@@ -9500,7 +9512,7 @@ static void md_start_sync(struct work_struct *ws)
 		__mddev_resume(mddev, false);
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev);
 	return;
 
 not_running:
@@ -9752,7 +9764,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev);
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
 	wake_up(&resync_wait);
@@ -10194,6 +10206,8 @@ static __exit void md_exit(void)
 	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
+		if (work_pending(&mddev->uevent_work))
+			flush_work(&mddev->uevent_work);
 		spin_unlock(&all_mddevs_lock);
 		export_array(mddev);
 		mddev->ctime = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 097d9dbd69b8..111aa3a0f60c 100644
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
@@ -802,7 +803,7 @@ extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
-extern void md_new_event(void);
+extern void md_new_event(struct mddev *mddev);
 extern void md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a4556d2e46bf..6f459d47e2a5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4545,7 +4545,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 
 abort:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d874abfc1836..f5736fa1b318 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8512,7 +8512,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 }
 
-- 
2.35.3

