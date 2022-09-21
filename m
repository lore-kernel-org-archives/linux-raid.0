Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08610ECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 13:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiIUNu7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 09:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiIUNu5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 09:50:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A551280F73
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 06:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663768256; x=1695304256;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8b9uMydaY9aE2g86T1ClzKEmQKbWWmc+fiHRN260hCM=;
  b=N5DPv15xWzjd9nyXOrXTd2AlnX45XyE3LPPRu3kOqnO/nrzqgerqqUGQ
   t9splQkYFk2fIfg2mAV0ngWSdQY1aX0UbPcAIuHBgM8FSCyVIAYxj6lfM
   iWczhuCAvfHAyNawUO2dQlyVBg4sSlnRsOET0iQx1QZA8ufIurTLD/RsC
   L9WTdzzbcxAyEtYBpCdM5caQ5lbXBD6W86fWjqiwRs7g6R5oHkBtsukOt
   k2p/+DUE9tzoCDgPF6pbfQ67GRnDSEcLAMVOc4f0l9GSBiOM8MZtMoHEA
   F2VHs2PgW9WAJReElY05B5mA6X1CYlYcVXnBzdZWAzElRiwKfuWb9Sos9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="386291037"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="386291037"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 06:50:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="596987223"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.105.50])
  by orsmga006.jf.intel.com with ESMTP; 21 Sep 2022 06:50:43 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org
Subject: [PATCH v2] md: generate CHANGE uevents for md device
Date:   Wed, 21 Sep 2022 15:33:47 +0200
Message-Id: <20220921133347.29270-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Due to changes in mdadm event handling and moving to udev based
approach [1], more CHANGE uevents need to be added.

Generate CHANGE uevents to give a udev based software (e.g. mdmonitor)
chance to see changes in case of any array reconfiguration.
Add emitting a new CHANGE uevent into md_new_event() to keep consistency
with currently used mdstat based approach.

[1] https://lore.kernel.org/linux-raid/20220907125657.12192-1-mateusz.grzonka@intel.com/

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 drivers/md/md.c     | 31 ++++++++++++++++---------------
 drivers/md/md.h     |  2 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9dc0175280b4..47c1cde56783 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -354,10 +354,11 @@ static bool create_on_open = true;
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
 static atomic_t md_event_count;
-void md_new_event(void)
+void md_new_event(struct mddev *mddev)
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
+	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
@@ -2852,7 +2853,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event();
+	md_new_event(mddev);
 	md_wakeup_thread(mddev->thread);
 	return 0;
 }
@@ -2972,7 +2973,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 					md_wakeup_thread(mddev->thread);
 				}
-				md_new_event();
+				md_new_event(mddev);
 			}
 		}
 	} else if (cmd_match(buf, "writemostly")) {
@@ -4070,7 +4071,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	sysfs_notify_dirent_safe(mddev->sysfs_level);
-	md_new_event();
+	md_new_event(mddev);
 	rv = len;
 out_unlock:
 	mddev_unlock(mddev);
@@ -4590,7 +4591,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		export_rdev(rdev);
 	mddev_unlock(mddev);
 	if (!err)
-		md_new_event();
+		md_new_event(mddev);
 	return err ? err : len;
 }
 
@@ -6024,7 +6025,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->sb_flags)
 		md_update_sb(mddev, 0);
 
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 
 bitmap_abort:
@@ -6411,7 +6412,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-	md_new_event();
+	md_new_event(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
 }
@@ -6910,7 +6911,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		md_wakeup_thread(mddev->thread);
 	else
 		md_update_sb(mddev, 1);
-	md_new_event();
+	md_new_event(mddev);
 
 	return 0;
 busy:
@@ -6991,7 +6992,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 
 abort_export:
@@ -7973,7 +7974,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	}
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
-	md_new_event();
+	md_new_event(mddev);
 }
 EXPORT_SYMBOL(md_error);
 
@@ -8893,7 +8894,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync = MD_RESYNC_ACTIVE; /* no longer delayed */
 	mddev->curr_resync_completed = j;
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
-	md_new_event();
+	md_new_event(mddev);
 	update_time = jiffies;
 
 	blk_start_plug(&plug);
@@ -8964,7 +8965,7 @@ void md_do_sync(struct md_thread *thread)
 			/* this is the earliest that rebuild will be
 			 * visible in /proc/mdstat
 			 */
-			md_new_event();
+			md_new_event(mddev);
 
 		if (last_check + window > io_sectors || j == max_sectors)
 			continue;
@@ -9188,7 +9189,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
 				spares++;
-			md_new_event();
+			md_new_event(mddev);
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
@@ -9222,7 +9223,7 @@ static void md_start_sync(struct work_struct *ws)
 	} else
 		md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev);
 }
 
 /*
@@ -9483,7 +9484,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event();
+	md_new_event(mddev);
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b4e2d8b87b61..2a25af01ec72 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -757,7 +757,7 @@ extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
-extern void md_new_event(void);
+extern void md_new_event(struct mddev *mddev);
 extern void md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 58c711912875..5c858e39c162 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4697,7 +4697,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	}
 	conf->reshape_checkpoint = jiffies;
 	md_wakeup_thread(mddev->sync_thread);
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 
 abort:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 734f92e75f85..ad3eb87f60b7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8577,7 +8577,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	}
 	conf->reshape_checkpoint = jiffies;
 	md_wakeup_thread(mddev->sync_thread);
-	md_new_event();
+	md_new_event(mddev);
 	return 0;
 }
 
-- 
2.26.2

