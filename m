Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC3240DFC2
	for <linux-raid@vger.kernel.org>; Mon, 18 May 2026 12:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107718; cv=none; b=OSX88WvPBxR4Irk2pZZOhPi3j9KQmDwQsR+epq+mpwnRRFhHo6SYYCMztN4eJ71EylYeqzRwl3AievQWHi1sdOxTPyfrDRhhY/ocbTGWoj3r15TDwU+UfcHXSvxjpTL00A3cNpGhpKBEXj2VoiedSUoYgm/nYQ2uQ0V5hnc0NWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107718; c=relaxed/simple;
	bh=lynFoJ+/ZLbDXGB4eiwgXl7enLvKwtO1pbn24ZFIUqA=;
	h=Message-Id:Content-Type:To:Cc:Mime-Version:From:Subject:Date; b=epOOxURMcq9HgnoIVRPqzEwdxCJgJUOGnhBXpX/fjqcL57ijvqdoO0fuJHTFlHKe0yFQhwHO0Q9PQAVnKg31LYUJOgeA3VhWkaDXhaCS8XSuZ2scb88CbrkGvZi92U6fHUA7Opukj8tOXMewNjhOVTTooKYx5nu/a5ppuBtoaxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=RPGZzr7s; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="RPGZzr7s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779107703;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TB5CVr9Q+j8gBFtee1Atbjc80cuhGP/LRPH7Zu0w5bw=;
 b=RPGZzr7sQxxm/EpVWJfQm8Ma3AemPbuIGdhKVCv4DnguUi7PC9q7Zky7ohyeDXXucBoDnr
 wM7acVkwsxdmSEzTz4SuOkH8yvfC2LmIeDUXJOziD0cX/LwykWletwK4M2r8J8eQNfD9cO
 7kgWTCOuWlX0BchHAgp03HCJ/QHeilSQK6OA0TUlxqDMvVbUu4u77U4RH5ULd/wIl3RP/C
 hjUJ1HuanKytfjJoavWoALxYhOohXhn+tHAAVRADlJuWK2fQFvu26KGI64N73yAhmDeIA8
 ZnmuS8f4zmWtPqJIxjAJ0+kU4k/gjgvQVyeUvqx//M92E9CGzUiy7zqNTP7jCg==
Message-Id: <20260518123449.534287-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Yu Kuai" <yukuai@fnnas.com>, <linux-raid@vger.kernel.org>
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([113.111.0.25]) by smtp.feishu.cn with ESMTPS; Mon, 18 May 2026 20:35:00 +0800
X-Mailer: git-send-email 2.54.0
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: cleanup reshape stripes when too many devices fail
Date: Mon, 18 May 2026 20:34:49 +0800
X-Lms-Return-Path: <lba+26a0b0775+4dc8ed+vger.kernel.org+chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

When a raid5/6 reshape is in progress and the array loses more than
max_degraded devices, raid5_error() sets MD_BROKEN and MD_RECOVERY_INTR,
but the reshape stripes reshape_request() handed out are never released.
The "s.failed > conf->max_degraded" branch of handle_stripe() calls
handle_failed_stripe() / handle_failed_sync() for user IO and resync,
but has no equivalent for the expand case, so three kinds of stripes
leak conf->reshape_stripes and mddev->recovery_active:

  1. Destination stripes with skipped_disk == 0: STRIPE_EXPANDING +
     STRIPE_EXPAND_READY set, but on a broken array the normal
     completion at "s.expanded && !reconstruct_state && s.locked == 0"
     may never fire.

  2. Destination stripes with skipped_disk == 1: only STRIPE_EXPANDING
     set, no STRIPE_HANDLE.  They sit idle in the cache waiting for
     source data that can no longer be read; handle_stripe() is never
     called on them directly.

  3. Source stripes (STRIPE_EXPAND_SOURCE) hit the failure branch but
     the bit is never cleared and the destinations they feed are never
     released.

md_do_sync() exits its main loop on MD_RECOVERY_INTR but then blocks
forever at

    wait_event(mddev->recovery_wait,
               !atomic_read(&mddev->recovery_active));

A concurrent "echo frozen > sync_action" then blocks in
stop_sync_thread() waiting for MD_RECOVERY_RUNNING to clear, and the
array becomes unstoppable without a reboot.

Reproducer:

    DEVS=(/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf)
    for i in 0 1 2 3 4; do
        s=$(blockdev --getsz ${DEVS[$i]})
        dmsetup create dust$i --table "0 $s dust ${DEVS[$i]} 0 4096"
        dmsetup message dust$i 0 quiet
    done
    mdadm -C /dev/md0 -e 1.2 -l 5 -n 4 -c 64 --assume-clean \
        /dev/mapper/dust{0..3}
    for b in $(seq 0 8191); do
        dmsetup message dust0 0 addbadblock $b
        dmsetup message dust1 0 addbadblock $b
    done
    mdadm --manage /dev/md0 --add /dev/mapper/dust4
    mdadm --grow /dev/md0 -n 5 --backup-file=/tmp/grow.backup &
    while [[ $(cat /sys/block/md0/md/sync_action) != reshape ]]; do
        sleep 0.1
    done
    dmsetup message dust0 0 enable
    dmsetup message dust1 0 enable
    sleep 5
    echo frozen > /sys/block/md0/md/sync_action     # hangs forever

Before the fix, the two tasks deadlock against each other:

    task:md0_reshape  state:D
      schedule
      md_do_sync.cold+0x818/0xc25       # wait_event(recovery_wait,
      md_thread                         #            !recovery_active)
      kthread

    task:bash         state:D
      schedule
      stop_sync_thread+0x1a3/0x350      # wait_event(resync_wait,
      action_store                      #            !MD_RECOVERY_RUNNING)
      md_attr_store
      kernfs_fop_write_iter
      vfs_write
      ksys_write

After the fix handle_stripe() releases the leaked reshape stripes via
the new handle_failed_reshape(), recovery_active drains to zero,
md_do_sync() prints

    md/raid:md0: Cannot continue operation (2/5 failed).
    md: md0: reshape interrupted.

clears MD_RECOVERY_RUNNING and returns; the "echo frozen" write
returns in <1s; "mdadm --stop /dev/md0" completes normally and no
task is left in D state.

Fix it by adding handle_failed_reshape(), called from handle_stripe()
when the failure branch fires on a reshape stripe.  If sh is a
destination, the helper drops STRIPE_EXPANDING / STRIPE_EXPAND_READY,
decrements conf->reshape_stripes, wakes wait_for_reshape and calls
md_done_sync() to return the sectors reshape_request() accounted on
recovery_active.  If sh is a source, the helper drops
STRIPE_EXPAND_SOURCE and walks sh's non-parity data disks using the
same raid5_compute_blocknr() / raid5_compute_sector() mapping
handle_stripe_expansion() uses to forward data, looks up each matching
destination with R5_GAS_NOBLOCK | R5_GAS_NOQUIESCE and applies the
destination cleanup to it.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d76e82f4506..f7d159b46a01 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4594,10 +4594,96 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 		}
 	/* done submitting copies, wait for them to complete */
 	async_tx_quiesce(&tx);
 }
 
+/*
+ * handle_failed_reshape - drop reshape state when too many devices have failed
+ *
+ * Called from handle_stripe() in the "s.failed > conf->max_degraded" branch
+ * when sh is participating in a reshape. raid5_error() has set MD_BROKEN
+ * and MD_RECOVERY_INTR); The reshape stripes that reshape_request() handed out
+ * must be released, otherwise they leak conf->reshape_stripes and
+ * mddev->recovery_active, and md_do_sync() hangs forever at
+ * wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active)).
+ *
+ * Three kinds of stripes can reach this path:
+ *
+ *  1. Destination stripes with skipped_disk = 0 in reshape_request()
+ *     - the new stripe maps entirely past the old array end, so its
+ *     blocks are zero-filled in place without any source read.
+ *     STRIPE_EXPANDING, STRIPE_EXPAND_READY and STRIPE_HANDLE are all set, 
+ *     handle_stripe() sees them with s.expanded == 1.
+ *
+ *  2. Destination stripes with skipped_disk = 1 - the new stripe
+ *     overlaps existing data and still needs source blocks copied in by
+ *     handle_stripe_expansion().  Only STRIPE_EXPANDING is set, *not*
+ *     STRIPE_HANDLE, so they sit idle in the stripe cache until a successful
+ *     source expand re-handles them.  In the failure path no one ever does,
+ *     so handle_stripe() will never see them on its own; they are cleaned up
+ *     from the source side in step (b) below.
+ *
+ *  3. Source stripes (STRIPE_EXPAND_SOURCE) - reach handle_stripe() via the
+ *     read-error path once the source members start returning EIO and
+ *     raid5_error() marks them Faulty.
+ *
+ * Handling:
+ *
+ *  (a) If STRIPE_EXPANDING is set on sh, clear it together with
+ *      STRIPE_EXPAND_READY, atomic_dec conf->reshape_stripes, wake
+ *      wait_for_reshape and md_done_sync(RAID5_STRIPE_SECTORS) to return
+ *      the sectors reshape_request() accounted on recovery_active.
+ *
+ *  (b) If STRIPE_EXPAND_SOURCE is set on sh, clear it and walk sh's
+ *      non-parity disks the same way handle_stripe_expansion() does
+ *      (raid5_compute_blocknr previous=1 -> raid5_compute_sector previous=0)
+ *      to find each destination, look it up with
+ *      R5_GAS_NOBLOCK | R5_GAS_NOQUIESCE and apply step (a) to it.
+ *      A NULL lookup means the destination never contributed to
+ *      reshape_stripes - nothing to release.
+ */
+static void handle_failed_reshape(struct r5conf *conf, struct stripe_head *sh)
+{
+	int i;
+
+	if (test_and_clear_bit(STRIPE_EXPANDING, &sh->state)) {
+		atomic_dec(&conf->reshape_stripes);
+		wake_up(&conf->wait_for_reshape);
+		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf));
+	}
+
+	clear_bit(STRIPE_EXPAND_READY, &sh->state);
+
+	if (test_and_clear_bit(STRIPE_EXPAND_SOURCE, &sh->state)) {
+		for (i = 0; i < sh->disks; i++) {
+			int dd_idx;
+			struct stripe_head *sh2;
+			sector_t bn, sec;
+
+			if (i == sh->pd_idx)
+				continue;
+			if (conf->level == 6 && i == sh->qd_idx)
+				continue;
+
+			bn = raid5_compute_blocknr(sh, i, 1);
+			sec = raid5_compute_sector(conf, bn, 0, &dd_idx, NULL);
+			sh2 = raid5_get_active_stripe(conf, NULL, sec,
+					R5_GAS_NOBLOCK | R5_GAS_NOQUIESCE);
+			if (!sh2)
+				continue;
+			if (test_and_clear_bit(STRIPE_EXPANDING, &sh2->state)) {
+				atomic_dec(&conf->reshape_stripes);
+				wake_up(&conf->wait_for_reshape);
+				md_done_sync(conf->mddev,
+					     RAID5_STRIPE_SECTORS(conf));
+			}
+			clear_bit(STRIPE_EXPAND_READY, &sh2->state);
+			raid5_release_stripe(sh2);
+		}
+	}
+}
+
 static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks;
 	struct r5dev *dev;
@@ -5001,10 +5087,15 @@ static void handle_stripe(struct stripe_head *sh)
 		break_stripe_batch_list(sh, 0);
 		if (s.to_read+s.to_write+s.written)
 			handle_failed_stripe(conf, sh, &s, disks);
 		if (s.syncing + s.replacing)
 			handle_failed_sync(conf, sh, &s);
+		if (s.expanding || s.expanded) {
+			handle_failed_reshape(conf, sh);
+			s.expanding = 0;
+			s.expanded = 0;
+		}
 	}
 
 	/* Now we check to see if any write operations have recently
 	 * completed
 	 */
-- 
2.54.0
