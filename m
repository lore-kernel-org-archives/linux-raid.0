Received: from sg-3-26.ptr.tlmpb.com (sg-3-26.ptr.tlmpb.com [101.45.255.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B42340A4D
	for <linux-raid@vger.kernel.org>; Mon, 15 Jun 2026 11:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781523352; cv=none; b=d4L6b7i7zjKj6UviseeRdYZkNXksmEFwTtpHbaZEvXI8ng9cnxDMCq0OwnZXTKs+FoS7G38hqF+uauWu+tpKwFLRkPCagIz92hO2DRlfFWZceYQnv2xdbEhe/5/gRM4o7JDTicCXtJUFsC1y3gBR4Q4cCjpamEs889vEjx5vd4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781523352; c=relaxed/simple;
	bh=kmVbHxB0aVcYwjMUsWD45NqZ3UsDysh49FDhNV7+AMk=;
	h=Content-Type:Cc:From:Message-Id:To:Date:Mime-Version:Subject; b=ULH4o8+Xs41sLfidqNaR9XQriTVb0suZkmi87H6wMT9GTdJQep5K2zikum5OoZM6Xd78gE5wtY+64udeRFazUZwZPiEf3LEYYcNly3e2BwnRZ0ELXZYM4yA6nJrsE/fIaHYic9M6E+in4Y8KITstk54h7TKH/IV6tlhddaMTf1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=2tdNWpvo; arc=none smtp.client-ip=101.45.255.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="2tdNWpvo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781523302;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=f/68BCYWyd5Dibak/lA9QhfqubPpP7I/WX47YLGfYBk=;
 b=2tdNWpvoZb4LuFuCDkmbh50C8jwbYTmbOGSsjOIf9DgPfR7Z9rQvr5jOC/3gwl9K8ajFBH
 RIDncY+Ruh7OeiE0EYTdaKPFN1tjSLWThQYMkwd+BALA1aeAt8kDLyPBukue9etLY5OJ8f
 tZAJghJgqW1JnhpR1zyGmkt8VXw4voqyYDmR62WiPoumZq/wAX3cCyeJM1eYd2RTrkQpq8
 BPZrj+ZlCRXsg9GSGNZfd6RCfj6ERRdKX2FX6RP+oNmyvIRPnOcYKpsEPlmDUQsWj7iPlU
 oczjTGAEmohChXigR/ueezMpXN6wotgO7su77Slfe1oW7cpnXp18w+CQI5bKvw==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260615113450.2088877-1-chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.169.238]) by smtp.feishu.cn with ESMTPS; Mon, 15 Jun 2026 19:34:59 +0800
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Date: Mon, 15 Jun 2026 19:34:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: chencheng@fnnas.com
Subject: [PATCH v2] md/raid5: fix reshape deadlock while failed devices more than max degraded
X-Mailer: git-send-email 2.54.0
X-Lms-Return-Path: <lba+26a2fe364+6a1e73+vger.kernel.org+chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

reshape stripe lifetime:
- start reshape ==> reshape_request():
	* get destination stripe,
	  - if need to copy source data chunks, set STRIPE_EXPANDING;
	  - or, if new regions past the old end of the array, zero-filled,
	    no need source data, set STRIPE_EXPANDING | STRIPE_READY
	* get source stripe,
	  - set STRIPE_EXPAND_SOURCE

- handle expand stripe ==> handle_stripe():
	reshape use reconstruct-write to construct stripe,
	four stages:
	1. prepare source data chunks for old geometry stripe
		- fill source stripe data by read or compute
	2. move data from old geometry source stripe to new geometry
	   destination stripe
		- source stripe clear STRIPE_EXPAND_SOURCE
		- drain data from source to destination stripe
		- mark stripe chunk as R5_Expanded|R5_UPTODATE when the
		  drain from source chunk to destionation chunk is completed
		- all stripe chunks drain are completed, then mark
		  STRIPE_EXPAND_READY
	3. calculate p/q chunks for destination stripe
		- if destination stripe does't depends on source dstripe,
		  then we can clear STRIPE_EXPANDING
	4. write-out to disks and release
		- set R5_Wantwrite|R5_Locked, writeout to disk
		- if write-out successed, clear STRIPE_EXPAND_READY, and
		  decrement reshape_stripe, call md_done_sync() to report
		  reshape progress.

1. cleanup the following kinds of **destination stripe**
	when failed device more than max degraded:
  - new regions past the old end of the array, zero-filled in place,
    requires no source data.
	(STRIPE_EXPANDING | STRIPE_EXPAND_READY)
  - prepare source data chunks already done, and writeout failed
	(STRIPE_EXPAND_READY)

2. destination stripes that need source data
	(STRIPE_EXPANDING, no STRIPE_HANDLE)
  - these kind of stripes sit idle in the stripe cache and are never seen
    by handle_stripe(). So clean up indirectly when thier source stripe
    (type 3) is processed.

3. source stripes (STRIPE_EXPAND_SOURCE)
  - hit handle_stripe() after thier member disks are markded Faulty.
  - clear STRIPE_EXPAND_SOURCE, finds and cleanup all dependent destination
    stripes that were waiting for data.
  - walks the source's data disks, compute the corresponding destination
    sector, looks up the destination stripe, and do cleanup(clear flags,
    dec counters, call md_done_sync())

Reproducer:
  - Create a 4-disk RAID5 with mdadm on top of 5 disposable test disks
    wrapped by dm targets.
  - Add the 5th device as a spare and start a 4 -> 5 reshape.
  - Wait until /sys/block/mdX/md/sync_action reports "reshape".
  - Inject failures on two members so reshape exceeds max_degraded.
  - After a few seconds, write "frozen" to /sys/block/mdX/md/sync_action.
    Before this fix, the write blocks indefinitely.

Read-error variant:
  - Use dm-dust on /dev/sd[b-f].
  - Preload bad blocks on two source members, e.g. dust0 and dust1:
      dmsetup message dust0 0 addbadblock <range>
      dmsetup message dust1 0 addbadblock <range>
  - Start reshape:
      mdadm -C /dev/mdX -e 1.2 -l 5 -n 4 -c 64 --assume-clean /dev/mapper/dust{0..3}
      mdadm --manage /dev/mdX --add /dev/mapper/dust4
      mdadm --grow /dev/mdX -n 5 --backup-file=/tmp/grow.backup &
  - Once reshape starts, enable the injected read failures:
      dmsetup message dust0 0 enable
      dmsetup message dust1 0 enable
  - Then:
      echo frozen > /sys/block/mdX/md/sync_action
    hangs forever before the fix.

Write-error variant:
  - Use dm-flakey on /dev/sd[b-f].
  - Start the same 4 -> 5 reshape on flakey0..flakey4.
  - Once reshape starts, switch two members, e.g. flakey3 and flakey4,
    to error_writes.
  - Then:
      echo frozen > /sys/block/mdX/md/sync_action
    hangs forever before the fix.

md_do_sync() exits its main loop on MD_RECOVERY_INTR but then blocks
forever at:

  wait_event(mddev->recovery_wait,
		!atomic_read(&mddev->recovery_active));

After the fix recovery_active drains to zero, md_do_sync() prints

    md/raid:md0: Cannot continue operation (2/5 failed).
    md: md0: reshape interrupted.

changes v1 -> v2:
- handle reshape write deadlock while failed devices more than max degraded

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 65ae7d8930fc..a320b71d7117 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3728,10 +3728,82 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 
 	if (abort)
 		md_sync_error(conf->mddev);
 }
 
+/*
+ * handle_failed_reshape - handl failed stripes when reshape failed and
+ *			   degraded devices >= max_degraded
+ *
+ * handle following kinds of stripe:
+ * 1. cleanup the following kinds of destination stripe:
+ *	- new regions past the old end of the array, zero-filled in place,
+ *	  requires no source data.
+ *		(STRIPE_EXPANDING | STRIPE_EXPAND_READY)
+ *	- prepare source data chunks already done, and writeout failed
+ *		(STRIPE_EXPAND_READY)
+ * 2. dest stripes that need source data (STRIPE_EXPANDING, no STRIPE_HANDLE)
+ *   - these kind of stripes sit idle in the stripe cache and are never seen
+ *     by handle_stripe(). So clean up indirectly when thier source stripe
+ *     (type 3) is processed.
+ * 3. src stripes (STRIPE_EXPAND_SOURCE)
+ *   - hit handle_stripe() after thier member disks are markded Faulty.
+ *   - clear STRIPE_EXPAND_SOURCE, finds and cleanup all dependent destination
+ *     stripes that were waiting for data.
+ *   - walks the source's data disks, compute the corresponding destination
+ *     sector, looks up the destination stripe, and do cleanup(clear flags,
+ *     dec counters, call md_done_sync())
+ */
+static void handle_failed_reshape(struct r5conf *conf, struct stripe_head *sh,
+				  struct stripe_head_state *s)
+{
+	int i;
+	bool was_expanding = test_and_clear_bit(STRIPE_EXPANDING, &sh->state);
+	bool was_ready = test_and_clear_bit(STRIPE_EXPAND_READY, &sh->state);
+
+	if (was_expanding || was_ready) {
+		atomic_dec(&conf->reshape_stripes);
+		wake_up(&conf->wait_for_reshape);
+		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf));
+	}
+
+	s->expanded = 0;
+	s->expanding = 0;
+
+	/* release the destination stripes that are waiting to be filled */
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
+
+			if (test_and_clear_bit(STRIPE_EXPANDING, &sh2->state)) {
+				atomic_dec(&conf->reshape_stripes);
+				wake_up(&conf->wait_for_reshape);
+				md_done_sync(conf->mddev,
+					     RAID5_STRIPE_SECTORS(conf));
+			}
+
+			clear_bit(STRIPE_EXPAND_READY, &sh2->state);
+
+			raid5_release_stripe(sh2);
+		}
+	}
+}
+
 static int want_replace(struct stripe_head *sh, int disk_idx)
 {
 	struct md_rdev *rdev;
 	int rv = 0;
 
@@ -5001,10 +5073,12 @@ static void handle_stripe(struct stripe_head *sh)
 		break_stripe_batch_list(sh, 0);
 		if (s.to_read+s.to_write+s.written)
 			handle_failed_stripe(conf, sh, &s, disks);
 		if (s.syncing + s.replacing)
 			handle_failed_sync(conf, sh, &s);
+		if (s.expanding + s.expanded)
+			handle_failed_reshape(conf, sh, &s);
 	}
 
 	/* Now we check to see if any write operations have recently
 	 * completed
 	 */
-- 
2.54.0
