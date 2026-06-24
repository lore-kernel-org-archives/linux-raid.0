Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A1C38C2C6
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782287945; cv=none; b=e21u5/WoIgaxBxZBueDNLEj9t7ImwO2aVRFKI9vxr7XxxKTCL7ZCewTruyVBmXEqdyzNTDTpLsLBCgbuVMbyQpQbx9N3SQnMh9wgtwuoCAFehWRFZ87uCSJT0A7CMAqWbj1nBzxWNBG9sDlUe7TPg3pGClq24SSfba7akCEdEYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782287945; c=relaxed/simple;
	bh=0fRR2lpLgyy9SusbTlMA0hImoxHn7xwfMmCgmyf4pqI=;
	h=From:Message-Id:Date:Subject:Content-Type:Cc:Mime-Version:To; b=Gm/9ME/aKkhWfEsJkAXq3wce+8zBQPIVCpoQTAbZysiK9HY0hsqrq+tiBXUy0viRg7Sq+LH6XFNvatI8WALlukGRSYQsyvesz2jut38SU+wAc5bme9pAaPEgtiP6tIZybbV84L32gg+JiyayoOgd48VIqTlg7st2YgGFKwIj3tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=wMdIM/Wl; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="wMdIM/Wl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782287931;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=P29x4NWvJ5cX/qQ/95Jhajfr5zwakMlA/AwQK/KiI0k=;
 b=wMdIM/Wl7W9/873wVi1j3L9tClI1FKEzdH3C6wLs7vElTIfKlpliIcr4d959kZLTC6Sh/P
 hhW1kvSX/alg0U+vcETI2K19JvTajUTEQoDs3wTuYaOOJEl260qs7iVZGJLg1rzlwcAf6K
 PE5cRdTPsEbMcvBJTBO9aE9ZiSfgpfFM3TpeEk69fPkB6RYh8wL2DErPCDC1BEp/ZGCf+k
 peC2LDu0+X9vYbHeCo+XZT0j8owahkLrZb+pn66Zb7+FdUxLVeFKoy0A9AvJVitrn4xTPc
 Pocq0beX7Ig8g2zaT6d3hm+QT9ehJuU1bN5Sa/Ca/MYP7c57kghIrAt2SCCYEw==
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260624075824.2601110-1-chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.163.186]) by smtp.feishu.cn with ESMTPS; Wed, 24 Jun 2026 15:58:49 +0800
X-Original-From: chencheng@fnnas.com
Date: Wed, 24 Jun 2026 15:58:24 +0800
Subject: [PATCH v3] md/raid5: fix reshape deadlock while failed devices more than max degraded
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a3b8e39+d538dc+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>

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

v2 -> v3:
- just kick sashiko-bot to review my patch..

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
