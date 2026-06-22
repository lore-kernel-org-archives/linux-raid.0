Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D0D37883C
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 12:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782132432; cv=none; b=Cy//fGqSnFZCZyQUn2GFxiOnIgLIr6bYDFlA41gffRX2LtFESrSKsQSLR6j0KBNZo1F9e7cGBnoxnWxzFcVmjMzj5fXfbBCrOALZ6iX+nTC1Avlp/NF7UsvEDxl72JMTzgae6/4xAM7EytredZay7e9LewlR8qJr//NGu/lJuFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782132432; c=relaxed/simple;
	bh=kim5z6+tPQPk62o0CMTALAXJ3S0bJMoTL52fJZWd2c0=;
	h=Message-Id:Mime-Version:Content-Type:Cc:Date:To:From:Subject; b=RphvahmNH+3KZdAD5cEYYH+/cYLxyF8c/Yt8QW7zLZkYBqUvaEhHt+0yz1g5BwFIN1fYpDa0QyJisCPoNsrjrx+fCdnMQkLIuStx+hZWUCISpY6WjeSByIZdrlMz8jTZleZBBtnEVHRbHqubGDhRm2Ei/fIdbG1EftGsw2RzmDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=P0zWdfGY; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="P0zWdfGY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782132424;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=i5Q4eyDMSSfZC2qKrz8mZC1GnXoxUoOjLnvnJxTh9qA=;
 b=P0zWdfGYu4gQhkWNz+/26/IHGd/1QqFgv6ZzpzOABrcJvnKy59+AS5P8Rl2n/uhBd3jvK2
 RuijwWDrhrMockYUFo24EecAf6McHBUABRQ7lacSBiNbUi9BIrAryjl8dIKkKwufoFKzPS
 6gaROdRllHzktp56wlyLyD+zZDoSr3mxaHedsdT9ekIKWm/MZgJ3oTJBZuJEAzytqcgxpv
 K1aAsF1aDevcnCEdBjH3vlD4RdQOVXeJGj1R7E+vwLH48Mmn/H1uTa9EjLvuEAvOn7DPVE
 QRqaOtJ49GsevcEZBTX1+HK3v8XbBwAOBdTH5FPeDxJdMDkobr/wHgm5ZbIeHQ==
Message-Id: <20260622124649.1780233-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jun 2026 20:46:49 +0800
X-Lms-Return-Path: <lba+26a392ec6+cd2356+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 20:47:02 +0800

From: Chen Cheng <chencheng@fnnas.com>

kcsan detect race :
- raid5d() closes the current bitmap batch by updating
	conf->seq_flush under conf->device_lock.
- __add_stripe_bio() read conf->seq_flush without that
	lock when assigning sh->bm_seq.

so, protect seq_flush/seq_write consistency for multiple CPUs by
READ_ONCE()/WRITE_ONCE() under the path without held device_lock.

re-explain the stripe batch sequence number update flow:
1. sh->bm_seq declare which batch number the stripe belongs to
   when perform bitmap-related write.
	==> bm_seq = seq_flush+1

2. stripe be handled,
	* if sh->bm_seq - conf->seq_write > 0, means the
	  batch stripes **newer than** the last written
	  batch, it cannot proceed yet, queued on bitmap_list.
	* otherwise , has already proceed.

3. raid5d() `++seq_flush` to closes the current batch, means
	* no more stripes join that old batch
	* just-closed batch ready to write-out to disk

4. raid5d() calls bitmap hooks unplug() or writeout, then,
   `++seq_write` to the same as bm_seq.

- seq_flush - for producer, to close batches.
- seq_write - for consumer, the checkpoint number.

the report:
====================================
BUG: KCSAN: data-race in __add_stripe_bio / raid5d

write to 0xffff88ba5625d470 of 4 bytes by task 82401 on cpu 0:
 raid5d+0x1d9/0xba0
 [.....]

read to 0xffff88ba5625d470 of 4 bytes by task 82421 on cpu 8:
 __add_stripe_bio+0x332/0x400
 raid5_make_request+0x6ac/0x2930
 md_handle_request+0x4a2/0xa40
 md_submit_bio+0x109/0x1a0
 __submit_bio+0x2ec/0x390
 [.....]

Fixes: 7c13edc87510f ("md: incorporate new plugging into raid5.")

v1 -> v2:
- remove WRITE_ONCE(conf->seq_write) in held device_lock path.
- remove READ_ONCE(conf->seq_flush) in held device_lock path.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a320b71d7117..de62ce4c3a21 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3536,11 +3536,11 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d, logical %llu\n",
 		 (*bip)->bi_iter.bi_sector, sh->sector, dd_idx,
 		 sh->dev[dd_idx].sector);
 
 	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
-		sh->bm_seq = conf->seq_flush+1;
+		sh->bm_seq = READ_ONCE(conf->seq_flush) + 1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
 }
 
 /*
@@ -5827,11 +5827,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 			md_write_inc(mddev, bi);
 			sh->overwrite_disks++;
 		}
 		spin_unlock_irq(&sh->stripe_lock);
 		if (conf->mddev->bitmap) {
-			sh->bm_seq = conf->seq_flush + 1;
+			sh->bm_seq = READ_ONCE(conf->seq_flush) + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}
 
 		set_bit(STRIPE_HANDLE, &sh->state);
 		clear_bit(STRIPE_DELAYED, &sh->state);
@@ -6877,16 +6877,18 @@ static void raid5d(struct md_thread *thread)
 			clear_bit(R5_DID_ALLOC, &conf->cache_state);
 
 		if (
 		    !list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
-			conf->seq_flush++;
+			int seq = conf->seq_flush + 1;
+
+			WRITE_ONCE(conf->seq_flush, seq);
 			spin_unlock_irq(&conf->device_lock);
 			if (md_bitmap_enabled(mddev, true))
 				mddev->bitmap_ops->unplug(mddev, true);
 			spin_lock_irq(&conf->device_lock);
-			conf->seq_write = conf->seq_flush;
+			conf->seq_write = seq;
 			activate_bit_delay(conf, conf->temp_inactive_list);
 		}
 		raid5_activate_delayed(conf);
 
 		while ((bio = remove_bio_from_retry(conf, &offset))) {
-- 
2.54.0
