Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF6FC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71F0C60F9E
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbhJDPmW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:42:22 -0400
Received: from out10.migadu.com ([46.105.121.227]:59806 "EHLO out10.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235770AbhJDPmQ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 4 Oct 2021 11:42:16 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633361707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4b738/Ui8VtpTfUQ8ou1TkRy4qqVVnGx69r+4I35A5U=;
        b=EXUZHyqlIZt6E/L2z/ZOO/rrW4z8x3kGsL/QWfW9qBpW1HcgxvSbp3oN8gaLYjiAfuhYvH
        aSKBM1+5cT7iQEayiTwyP5bZAEDR0Wtzq7RA9TyfheKK4AWkQdL7Mj4abj8he/PRps1CvU
        e4OBLQKPHlNS6Zd11vlMzLxMOfOmUz0=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 6/6] md: remove unused argument from md_new_event
Date:   Mon,  4 Oct 2021 23:34:53 +0800
Message-Id: <20211004153453.14051-7-guoqing.jiang@linux.dev>
In-Reply-To: <20211004153453.14051-1-guoqing.jiang@linux.dev>
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Actually, mddev is not used by md_new_event.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/md.c     | 30 +++++++++++++++---------------
 drivers/md/md.h     |  2 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c322841d4edc..90c624bec695 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -352,7 +352,7 @@ static bool create_on_open = true;
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
 static atomic_t md_event_count;
-void md_new_event(struct mddev *mddev)
+void md_new_event(void)
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
@@ -2886,7 +2886,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event(mddev);
+	md_new_event();
 	md_wakeup_thread(mddev->thread);
 	return 0;
 }
@@ -3002,7 +3002,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 					md_wakeup_thread(mddev->thread);
 				}
-				md_new_event(mddev);
+				md_new_event();
 			}
 		}
 	} else if (cmd_match(buf, "writemostly")) {
@@ -4099,7 +4099,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	sysfs_notify_dirent_safe(mddev->sysfs_level);
-	md_new_event(mddev);
+	md_new_event();
 	rv = len;
 out_unlock:
 	mddev_unlock(mddev);
@@ -4620,7 +4620,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		export_rdev(rdev);
 	mddev_unlock(mddev);
 	if (!err)
-		md_new_event(mddev);
+		md_new_event();
 	return err ? err : len;
 }
 
@@ -6041,7 +6041,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->sb_flags)
 		md_update_sb(mddev, 0);
 
-	md_new_event(mddev);
+	md_new_event();
 	return 0;
 
 bitmap_abort:
@@ -6431,7 +6431,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-	md_new_event(mddev);
+	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
 }
@@ -6935,7 +6935,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		md_wakeup_thread(mddev->thread);
 	else
 		md_update_sb(mddev, 1);
-	md_new_event(mddev);
+	md_new_event();
 
 	return 0;
 busy:
@@ -7008,7 +7008,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-	md_new_event(mddev);
+	md_new_event();
 	return 0;
 
 abort_export:
@@ -7982,7 +7982,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	md_wakeup_thread(mddev->thread);
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
-	md_new_event(mddev);
+	md_new_event();
 }
 EXPORT_SYMBOL(md_error);
 
@@ -8866,7 +8866,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync = 3; /* no longer delayed */
 	mddev->curr_resync_completed = j;
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
-	md_new_event(mddev);
+	md_new_event();
 	update_time = jiffies;
 
 	blk_start_plug(&plug);
@@ -8937,7 +8937,7 @@ void md_do_sync(struct md_thread *thread)
 			/* this is the earliest that rebuild will be
 			 * visible in /proc/mdstat
 			 */
-			md_new_event(mddev);
+			md_new_event();
 
 		if (last_check + window > io_sectors || j == max_sectors)
 			continue;
@@ -9161,7 +9161,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
 				spares++;
-			md_new_event(mddev);
+			md_new_event();
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
@@ -9195,7 +9195,7 @@ static void md_start_sync(struct work_struct *ws)
 	} else
 		md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event(mddev);
+	md_new_event();
 }
 
 /*
@@ -9454,7 +9454,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	/* flag recovery needed just to double check */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event(mddev);
+	md_new_event();
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4c96c36bd01a..53ea7a6961de 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -731,7 +731,7 @@ extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 			struct page *page, int op, int op_flags,
 			bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
-extern void md_new_event(struct mddev *mddev);
+extern void md_new_event(void);
 extern void md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 29eb538db953..0aee0675f18e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4647,7 +4647,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	}
 	conf->reshape_checkpoint = jiffies;
 	md_wakeup_thread(mddev->sync_thread);
-	md_new_event(mddev);
+	md_new_event();
 	return 0;
 
 abort:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4ea9e7b647b0..9c1a5877cf9f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8279,7 +8279,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	}
 	conf->reshape_checkpoint = jiffies;
 	md_wakeup_thread(mddev->sync_thread);
-	md_new_event(mddev);
+	md_new_event();
 	return 0;
 }
 
-- 
2.31.1

