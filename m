Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DD51C4EEA
	for <linux-raid@vger.kernel.org>; Tue, 27 Aug 2024 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772948; cv=none; b=CauHYxR/trozePP8yqjlh12ezBnMR4VhSyTTHXIHOhwxg1ZWJ6x1IO5ie8ppBcf7UQrMBTJqazGAOoJth9WjhjE3PUb7U1d5A0UeqyfIgm5zRPaYvOon/s0tIsVI90Mzg/ZO9+iEUcfRRF62WFgKctGe5z7gB58IeEAZRwAU4bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772948; c=relaxed/simple;
	bh=4Ely7P4qH81F1B7yYUtEqgTIo0/dFxqzTxvmAqyoBFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJrra053xxUMmswqDIVlvIR5m3RhK8k99RM3twLgSu5aTODj5+Pk7jbSzk2NwrEerlfkXxN+uzZJTFe9reObA4GIo/3McDi/e9N42rGBBw/pIjqnUxjMFdrZQay8A8sX90LWrdOSGDE1EY/+9oU/kXUmObmaAV3DAwW6YhVdrME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RarYhTRN; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RarYhTRN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724772947; x=1756308947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Ely7P4qH81F1B7yYUtEqgTIo0/dFxqzTxvmAqyoBFA=;
  b=RarYhTRNRGmrWBWb6fGVuAHWqkc+5ZWrGeQxZbCFrPIZsQ+h8TiTXlR4
   BZ5YGjgCo4oCpnsW6RnFqPdLwcbwZatYJAy4cUtbBUnp/r+VZUfhZFzRr
   Y+AXATvvabQWlhJ2w1PmMzRLgRbkBH+9hOcYdV50580+eR3JbgBDyFMID
   YlmjhGFwl/sWaVWw/o8+d+zrW+shLlg8+9Jz/EMlR4t5tp6cJLf7xLWok
   AbzzTcp4/64ymFzBeS6U6B2foPmq+Xwsk+VGeM2R08NYqE6MFTfiEk1YD
   Ni0pPc6k+UOZ8IbhhUcZHQXjV173MJUn2d8MfC/vwkyK58AbnppAp7bO6
   Q==;
X-CSE-ConnectionGUID: Tu9nkeMzSymUhhfPBSa98Q==
X-CSE-MsgGUID: 9gkRTpDQQQiUmj74LLeF5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="34634184"
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="34634184"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 08:35:47 -0700
X-CSE-ConnectionGUID: pTuT1/4aRdiZNPz8Wfp7vQ==
X-CSE-MsgGUID: 9Shn+JP/QTeqksMuNoO9pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="62628235"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO apaszkie-mobl2.intel.com) ([10.245.244.19])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 08:35:44 -0700
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	paul.e.luse@intel.com
Subject: [PATCH 1/3] md/raid5: use wait_on_bit() for R5_Overlap
Date: Tue, 27 Aug 2024 17:35:34 +0200
Message-ID: <20240827153536.6743-2-artur.paszkiewicz@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
References: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert uses of wait_for_overlap wait queue with R5_Overlap bit to
wait_on_bit() / wake_up_bit().

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-cache.c |  6 +---
 drivers/md/raid5.c       | 60 +++++++++++++++++++---------------------
 2 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 874874fe4fa1..d0698852c570 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2798,7 +2798,6 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 {
 	struct r5l_log *log = READ_ONCE(conf->log);
 	int i;
-	int do_wakeup = 0;
 	sector_t tree_index;
 	void __rcu **pslot;
 	uintptr_t refcount;
@@ -2815,7 +2814,7 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 	for (i = sh->disks; i--; ) {
 		clear_bit(R5_InJournal, &sh->dev[i].flags);
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-			do_wakeup = 1;
+			wake_up_bit(&sh->dev[i].flags, R5_Overlap);
 	}
 
 	/*
@@ -2828,9 +2827,6 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 		if (atomic_dec_and_test(&conf->pending_full_writes))
 			md_wakeup_thread(conf->mddev->thread);
 
-	if (do_wakeup)
-		wake_up(&conf->wait_for_overlap);
-
 	spin_lock_irq(&log->stripe_in_journal_lock);
 	list_del_init(&sh->r5c);
 	spin_unlock_irq(&log->stripe_in_journal_lock);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c14cf2410365..1e7dcb6235c7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2337,7 +2337,7 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
-				wake_up(&sh->raid_conf->wait_for_overlap);
+				wake_up_bit(&dev->flags, R5_Overlap);
 		}
 	}
 	local_unlock(&conf->percpu->lock);
@@ -3473,7 +3473,7 @@ static bool stripe_bio_overlaps(struct stripe_head *sh, struct bio *bi,
 		 * With PPL only writes to consecutive data chunks within a
 		 * stripe are allowed because for a single stripe_head we can
 		 * only have one PPL entry at a time, which describes one data
-		 * range. Not really an overlap, but wait_for_overlap can be
+		 * range. Not really an overlap, but R5_Overlap can be
 		 * used to handle this.
 		 */
 		sector_t sector;
@@ -3652,7 +3652,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		log_stripe_write_finished(sh);
 
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-			wake_up(&conf->wait_for_overlap);
+			wake_up_bit(&sh->dev[i].flags, R5_Overlap);
 
 		while (bi && bi->bi_iter.bi_sector <
 			sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
@@ -3696,7 +3696,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			sh->dev[i].toread = NULL;
 			spin_unlock_irq(&sh->stripe_lock);
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-				wake_up(&conf->wait_for_overlap);
+				wake_up_bit(&sh->dev[i].flags, R5_Overlap);
 			if (bi)
 				s->to_read--;
 			while (bi && bi->bi_iter.bi_sector <
@@ -3734,7 +3734,7 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 	BUG_ON(sh->batch_head);
 	clear_bit(STRIPE_SYNCING, &sh->state);
 	if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
-		wake_up(&conf->wait_for_overlap);
+		wake_up_bit(&sh->dev[sh->pd_idx].flags, R5_Overlap);
 	s->syncing = 0;
 	s->replacing = 0;
 	/* There is nothing more to do for sync/check/repair.
@@ -4875,7 +4875,6 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 {
 	struct stripe_head *sh, *next;
 	int i;
-	int do_wakeup = 0;
 
 	list_for_each_entry_safe(sh, next, &head_sh->batch_list, batch_list) {
 
@@ -4911,7 +4910,7 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 		spin_unlock_irq(&sh->stripe_lock);
 		for (i = 0; i < sh->disks; i++) {
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-				do_wakeup = 1;
+				wake_up_bit(&sh->dev[i].flags, R5_Overlap);
 			sh->dev[i].flags = head_sh->dev[i].flags &
 				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
 		}
@@ -4925,12 +4924,9 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 	spin_unlock_irq(&head_sh->stripe_lock);
 	for (i = 0; i < head_sh->disks; i++)
 		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
-			do_wakeup = 1;
+			wake_up_bit(&head_sh->dev[i].flags, R5_Overlap);
 	if (head_sh->state & handle_flags)
 		set_bit(STRIPE_HANDLE, &head_sh->state);
-
-	if (do_wakeup)
-		wake_up(&head_sh->raid_conf->wait_for_overlap);
 }
 
 static void handle_stripe(struct stripe_head *sh)
@@ -5196,7 +5192,7 @@ static void handle_stripe(struct stripe_head *sh)
 		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf), 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
-			wake_up(&conf->wait_for_overlap);
+			wake_up_bit(&sh->dev[sh->pd_idx].flags, R5_Overlap);
 	}
 
 	/* If the failed drives are just a ReadError, then we might need
@@ -5753,12 +5749,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		int d;
 	again:
 		sh = raid5_get_active_stripe(conf, NULL, logical_sector, 0);
-		prepare_to_wait(&conf->wait_for_overlap, &w,
-				TASK_UNINTERRUPTIBLE);
 		set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
 		if (test_bit(STRIPE_SYNCING, &sh->state)) {
 			raid5_release_stripe(sh);
-			schedule();
+			wait_on_bit(&sh->dev[sh->pd_idx].flags, R5_Overlap,
+				    TASK_UNINTERRUPTIBLE);
 			goto again;
 		}
 		clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
@@ -5770,12 +5765,12 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 				set_bit(R5_Overlap, &sh->dev[d].flags);
 				spin_unlock_irq(&sh->stripe_lock);
 				raid5_release_stripe(sh);
-				schedule();
+				wait_on_bit(&sh->dev[d].flags, R5_Overlap,
+					    TASK_UNINTERRUPTIBLE);
 				goto again;
 			}
 		}
 		set_bit(STRIPE_DISCARD, &sh->state);
-		finish_wait(&conf->wait_for_overlap, &w);
 		sh->overwrite_disks = 0;
 		for (d = 0; d < conf->raid_disks; d++) {
 			if (d == sh->pd_idx || d == sh->qd_idx)
@@ -5855,7 +5850,6 @@ static int add_all_stripe_bios(struct r5conf *conf,
 		struct bio *bi, int forwrite, int previous)
 {
 	int dd_idx;
-	int ret = 1;
 
 	spin_lock_irq(&sh->stripe_lock);
 
@@ -5871,14 +5865,19 @@ static int add_all_stripe_bios(struct r5conf *conf,
 
 		if (stripe_bio_overlaps(sh, bi, dd_idx, forwrite)) {
 			set_bit(R5_Overlap, &dev->flags);
-			ret = 0;
-			continue;
+			spin_unlock_irq(&sh->stripe_lock);
+			raid5_release_stripe(sh);
+			/* release batch_last before wait to avoid risk of deadlock */
+			if (ctx->batch_last) {
+				raid5_release_stripe(ctx->batch_last);
+				ctx->batch_last = NULL;
+			}
+			md_wakeup_thread(conf->mddev->thread);
+			wait_on_bit(&dev->flags, R5_Overlap, TASK_UNINTERRUPTIBLE);
+			return 0;
 		}
 	}
 
-	if (!ret)
-		goto out;
-
 	for (dd_idx = 0; dd_idx < sh->disks; dd_idx++) {
 		struct r5dev *dev = &sh->dev[dd_idx];
 
@@ -5894,9 +5893,8 @@ static int add_all_stripe_bios(struct r5conf *conf,
 			  RAID5_STRIPE_SHIFT(conf), ctx->sectors_to_do);
 	}
 
-out:
 	spin_unlock_irq(&sh->stripe_lock);
-	return ret;
+	return 1;
 }
 
 enum reshape_loc {
@@ -5992,17 +5990,17 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 		goto out_release;
 	}
 
-	if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-	    !add_all_stripe_bios(conf, ctx, sh, bi, rw, previous)) {
-		/*
-		 * Stripe is busy expanding or add failed due to
-		 * overlap. Flush everything and wait a while.
-		 */
+	if (test_bit(STRIPE_EXPANDING, &sh->state)) {
 		md_wakeup_thread(mddev->thread);
 		ret = STRIPE_SCHEDULE_AND_RETRY;
 		goto out_release;
 	}
 
+	if (!add_all_stripe_bios(conf, ctx, sh, bi, rw, previous)) {
+		ret = STRIPE_RETRY;
+		goto out;
+	}
+
 	if (stripe_can_batch(sh)) {
 		stripe_add_to_batch_list(conf, sh, ctx->batch_last);
 		if (ctx->batch_last)
-- 
2.43.0

