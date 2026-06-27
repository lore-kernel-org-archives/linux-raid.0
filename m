Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0752E091B
	for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 10:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782555944; cv=none; b=WVbpDAT7LlcKPzg+qM9lxrQ9EUpf9btlEkQAVoNKRX07smicLD9AD/RpelwAs6qw7Z99sqbX5fIioRTU2ZnZnSobXaNtINg2sULIQ2u0qXUKDAzX+xuBgg8oJQcehaEY8a3WmSmVhxHNVQGmhOu3xCo5mT/6JsasHQiDhurG/xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782555944; c=relaxed/simple;
	bh=+Zz5LH/Olx733To3eC1S9M792mOiwo/VybA4hs9n8yw=;
	h=Message-Id:Content-Type:Cc:Subject:Mime-Version:To:From:Date; b=PpNbzme4X3LdsoYozPU3QjWh+/sxmixvF/zrVY68BukHK/6HWOL8hoc/xtJphnHKFGLyZSL/P8xgvaN+mxDV4ovkImggi9tRCrBTZQioEIdCkCwi2gke28wbTgSxRgpifzEsQ/E/Yv7L3gEfwlvWRK/46eXyYv/aiDu4MVpxx9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=WulaVZFc; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="WulaVZFc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782555930;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=G/LOohzaeiPuQH8TT9ByWADLq/ZPgCUnYTEqX2uT0Hk=;
 b=WulaVZFchUiLa1bdfvGd+4M49sm43OwPaYg4AdLH2ZxGKAIj2YUkk1vUjbWQAtYXYhfTgY
 peoGCsGdbPebIl9vEm0tKDxXmrQP7+SvXYGAnPKp0k77OkhBHO+b+1EHYNDlFqgWYzdcOu
 JrmLgt/RD1nfI1qxUm8ro+Y45Q/7OghpyzmzLLNf9QrLSHRMH8poRki2x/7KtfbUYV6qWi
 33WQLnB1VKULU5D6vy8hVXKEVA4gjCb3/szWKw5twJrkGfqYMs+RQwRZlgeJge0EPTvG+O
 BsU1QZOD07lpNnesZ952T/h1DPBj26Ufr5V3doaxNrv8B8BqxaaOB6Nmggu1Eg==
Received: from fedora ([27.47.238.101]) by smtp.feishu.cn with ESMTPS; Sat, 27 Jun 2026 18:25:27 +0800
Content-Transfer-Encoding: 7bit
Message-Id: <20260627102519.136940-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
X-Lms-Return-Path: <lba+26a3fa518+3327fe+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] md/raid5: protect lockless recovery_offset accesses during reshape
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Sat, 27 Jun 2026 18:25:19 +0800
X-Original-From: chencheng@fnnas.com

From: Chen Cheng <chencheng@fnnas.com>

During reshape:
- reshape_request() advances rdev->recovery_offset for non-In_sync
  devices locklessly.
- analyse_stripe() reads rdev->recovery_offset locklessly to decide:
    a. use a replacement device to read ?
    b. a device can already be treated as in-sync for the current
       stripe ?

one possible scenario is:

CPU1                            CPU2
reshape_request()
-> mddev->curr_resync_completed = sector_nr
-> if (!mddev->reshape_backwards)
-> rdev->recovery_offset = sector_nr
                                analyse_stripe(sh)
                                -> rdev = conf->disks[i].replacement
                                -> if (rdev->recovery_offset >=
                                      sh->sector + stripe_sectors)
                                   set_bit(R5_ReadRepl)
                                -> or
                                -> if (sh->sector + stripe_sectors <=
                                      rdev->recovery_offset)
                                   set_bit(R5_Insync)

And it could be:

- reading from a replacement before it is recovered far enough; or
- treating a not-yet-recovered device as in-sync for the current stripe.

Fixes: db0505d32066 ("md: be cautious about using ->curr_resync_completed for ->recovery_offset")

The race report:
==================================================================
BUG: KCSAN: data-race in ops_run_io / reshape_request

write to 0xffff8bdee168b270 of 8 bytes by task 1704 on cpu 10:
 reshape_request+0x1292/0x17b0
 raid5_sync_request+0x815/0xa00
 md_do_sync.cold+0xf8d/0x1516
 [......]

read to 0xffff8bdee168b270 of 8 bytes by task 1696 on cpu 9:
 ops_run_io+0xc25/0x1960
 handle_stripe+0x2273/0x4570
 handle_active_stripes.isra.0+0x6e0/0xa50
 raid5d+0x7d5/0xb90
 [......]

value changed: 0x0000000000091a00 -> 0x0000000000091b00
==================================================================

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cacdf4211628..eaee7f206ab8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3808,11 +3808,11 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
 
 	rdev = sh->raid_conf->disks[disk_idx].replacement;
 	if (rdev
 	    && !test_bit(Faulty, &rdev->flags)
 	    && !test_bit(In_sync, &rdev->flags)
-	    && (rdev->recovery_offset <= sh->sector
+	    && (READ_ONCE(rdev->recovery_offset) <= sh->sector
 		|| rdev->mddev->resync_offset <= sh->sector))
 		rv = 1;
 	return rv;
 }
 
@@ -4726,11 +4726,11 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		/* Prefer to use the replacement for reads, but only
 		 * if it is recovered enough and has no bad blocks.
 		 */
 		rdev = conf->disks[i].replacement;
 		if (rdev && !test_bit(Faulty, &rdev->flags) &&
-		    rdev->recovery_offset >= sh->sector + RAID5_STRIPE_SECTORS(conf) &&
+		    READ_ONCE(rdev->recovery_offset) >= sh->sector + RAID5_STRIPE_SECTORS(conf) &&
 		    !rdev_has_badblock(rdev, sh->sector,
 				       RAID5_STRIPE_SECTORS(conf)))
 			set_bit(R5_ReadRepl, &dev->flags);
 		else {
 			if (rdev && !test_bit(Faulty, &rdev->flags))
@@ -4768,11 +4768,11 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 				set_bit(R5_ReadError, &dev->flags);
 			}
 		} else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
 		else if (sh->sector + RAID5_STRIPE_SECTORS(conf) <=
-			 rdev->recovery_offset) {
+			 READ_ONCE(rdev->recovery_offset)) {
 			/*
 			 * in sync if:
 			 *  - normal IO, or
 			 *  - resync IO that is not lazy recovery
 			 *
@@ -5514,17 +5514,17 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	if (r5c_big_stripe_cached(conf, sector))
 		return 0;
 
 	rdev = conf->disks[dd_idx].replacement;
 	if (!rdev || test_bit(Faulty, &rdev->flags) ||
-	    rdev->recovery_offset < end_sector) {
+	    READ_ONCE(rdev->recovery_offset) < end_sector) {
 		rdev = conf->disks[dd_idx].rdev;
 		if (!rdev)
 			return 0;
 		if (test_bit(Faulty, &rdev->flags) ||
 		    !(test_bit(In_sync, &rdev->flags) ||
-		      rdev->recovery_offset >= end_sector))
+		      READ_ONCE(rdev->recovery_offset) >= end_sector))
 			return 0;
 	}
 
 	atomic_inc(&rdev->nr_pending);
 
@@ -6463,12 +6463,12 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			/* Can update recovery_offset */
 			rdev_for_each(rdev, mddev)
 				if (rdev->raid_disk >= 0 &&
 				    !test_bit(Journal, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags) &&
-				    rdev->recovery_offset < sector_nr)
-					rdev->recovery_offset = sector_nr;
+				    READ_ONCE(rdev->recovery_offset) < sector_nr)
+					WRITE_ONCE(rdev->recovery_offset, sector_nr);
 
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait, READ_ONCE(mddev->sb_flags) == 0 ||
@@ -6572,12 +6572,12 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			/* Can update recovery_offset */
 			rdev_for_each(rdev, mddev)
 				if (rdev->raid_disk >= 0 &&
 				    !test_bit(Journal, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags) &&
-				    rdev->recovery_offset < sector_nr)
-					rdev->recovery_offset = sector_nr;
+				    READ_ONCE(rdev->recovery_offset) < sector_nr)
+					WRITE_ONCE(rdev->recovery_offset, sector_nr);
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)
@@ -8106,13 +8106,13 @@ static int raid5_run(struct mddev *mddev)
 		 * to worry about reshape going forwards.
 		 */
 		/* Hack because v0.91 doesn't store recovery_offset properly. */
 		if (mddev->major_version == 0 &&
 		    mddev->minor_version > 90)
-			rdev->recovery_offset = reshape_offset;
+			WRITE_ONCE(rdev->recovery_offset, reshape_offset);
 
-		if (rdev->recovery_offset < reshape_offset) {
+		if (READ_ONCE(rdev->recovery_offset) < reshape_offset) {
 			/* We need to check old and new layout */
 			if (!only_parity(rdev->raid_disk,
 					 conf->algorithm,
 					 conf->raid_disks,
 					 conf->max_degraded))
@@ -8264,11 +8264,11 @@ static int raid5_spare_active(struct mddev *mddev)
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		rdev = conf->disks[i].rdev;
 		replacement = conf->disks[i].replacement;
 		if (replacement
-		    && replacement->recovery_offset == MaxSector
+		    && READ_ONCE(replacement->recovery_offset) == MaxSector
 		    && !test_bit(Faulty, &replacement->flags)
 		    && !test_and_set_bit(In_sync, &replacement->flags)) {
 			/* Replacement has just become active. */
 			if (!rdev
 			    || !test_and_clear_bit(In_sync, &rdev->flags))
@@ -8282,13 +8282,13 @@ static int raid5_spare_active(struct mddev *mddev)
 				sysfs_notify_dirent_safe(
 					rdev->sysfs_state);
 			}
 			sysfs_notify_dirent_safe(replacement->sysfs_state);
 		} else if (rdev
-		    && rdev->recovery_offset == MaxSector
-		    && !test_bit(Faulty, &rdev->flags)
-		    && !test_and_set_bit(In_sync, &rdev->flags)) {
+			   && READ_ONCE(rdev->recovery_offset) == MaxSector
+			   && !test_bit(Faulty, &rdev->flags)
+			   && !test_and_set_bit(In_sync, &rdev->flags)) {
 			count++;
 			sysfs_notify_dirent_safe(rdev->sysfs_state);
 		}
 	}
 	spin_lock_irqsave(&conf->device_lock, flags);
@@ -8653,11 +8653,11 @@ static int raid5_start_reshape(struct mddev *mddev)
 				if (raid5_add_disk(mddev, rdev) == 0) {
 					if (rdev->raid_disk
 					    >= conf->previous_raid_disks)
 						set_bit(In_sync, &rdev->flags);
 					else
-						rdev->recovery_offset = 0;
+						WRITE_ONCE(rdev->recovery_offset, 0);
 
 					/* Failure here is OK */
 					sysfs_link_rdev(mddev, rdev);
 				}
 			} else if (rdev->raid_disk >= conf->previous_raid_disks
@@ -8705,11 +8705,11 @@ static void end_reshape(struct r5conf *conf)
 		conf->mddev->reshape_position = MaxSector;
 		rdev_for_each(rdev, conf->mddev)
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(Journal, &rdev->flags) &&
 			    !test_bit(In_sync, &rdev->flags))
-				rdev->recovery_offset = MaxSector;
+				WRITE_ONCE(rdev->recovery_offset, MaxSector);
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_reshape);
 
 		mddev_update_io_opt(conf->mddev,
 			conf->raid_disks - conf->max_degraded);
-- 
2.54.0
