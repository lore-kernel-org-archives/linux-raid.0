Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686293F0ABE
	for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781706547; cv=none; b=k4lGlbT1BTp/DBdULEUt9FtyD60C8Z0X94wm9IPYGp4zVysszISnx5PMNTO2pjnBpgJ4GTXBov7opIJkUm9WF5i7oTe1bKGn/f1B/rtPHjG9uoVIOlsALul60XcHNY+jJV+FrIO1VwWQc5A6JftxDErFYZdcHC0Tt1BZoArLj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781706547; c=relaxed/simple;
	bh=ht81X3q/9CsA8o5h5Lob/z5QwFRnn3z3QkcZfo4fdEI=;
	h=Content-Type:Date:Message-Id:Mime-Version:Cc:From:Subject:To; b=Rj4iLobsNHAS0QUG/+DjsSZQ2ofaLSoWVTnFhZmpxqNXrChn7kzfYyEMAkzJW1jEkSdVsVZFNFXHObWHwksNitW9j+tTC4KT6k++E1LqDccEAw5JK5bEWnoNrLSoiP+q4lH9eOPobpRePadkiyVEjFzfz+Kyh/g8ubM+EpmV1S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=xQIA2vg9; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="xQIA2vg9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781706533;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Z+3PWDXKGqocCSQ8RCWhR5ssklu7SGw9QNq4raaguZ4=;
 b=xQIA2vg9tKciQnU8QhCU/JXyqmcPjX7k9mFvhORODdJeH+fsLEGkeWT1VSonFlGQOUJgu6
 0llOpLRIrbjSE0KdACCmQ/CNDaHiE0ZEAtBJmiF36ovX5VBqY1gGnAGGhndA+N2bUvOryu
 RyqiIy9C6gOz9zWQnyFXVpNmUYHOZG9cicXL88PLc7FbpCJqEKSpM46gbEHcO0vQWOjanm
 EHQjxgEW5mnCYLeeYNpRYGIO8310RDw+1BjFPjreejYdCaIkkLoGxqM34pTFKBywGywEiT
 PpZtFRGQlFcE7yPAfXqYVvOkpbOxFrmKqTi8RhjXPZI1LlLwz6QqyCCM9NgUsw==
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 22:28:39 +0800
Message-Id: <20260617142839.882378-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a32af23+4715a9+vger.kernel.org+chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>, 
	<linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Subject: [PATCH v2] md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency
Received: from localhost.localdomain ([183.34.164.112]) by smtp.feishu.cn with ESMTPS; Wed, 17 Jun 2026 22:28:50 +0800
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>

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

v1 -> v2:
- remove WRITE_ONCE(conf->seq_write) in held device_lock path.
- remove READ_ONCE(conf->seq_flush) in held device_lock path.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a320b71d7117..b2c5a1930841 100644
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
@@ -6877,16 +6877,17 @@ static void raid5d(struct md_thread *thread)
 			clear_bit(R5_DID_ALLOC, &conf->cache_state);
 
 		if (
 		    !list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
-			conf->seq_flush++;
+			int seq = conf->seq_flush + 1;
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
