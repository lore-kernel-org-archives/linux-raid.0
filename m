Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224C5280CFB
	for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 13:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790491; cv=none; b=FQ5pIWnG6c2mxRgGnu1rUyEd7qI3TlODpYiLMvItp5krsRLVZD4Sy1tijsjlqjrIh5fZDWFO5SZF3KAxjIfkiyLAn+wHmUQlgidaduLrQBadAXWQajJrbB6pEa4zTs9eWX0bH7tasLXu1AF0QTwMsWqjDhiyuK2ObwhTIkMF124=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790491; c=relaxed/simple;
	bh=LC2HlJXUPjtZiNjVzSMi95EcZub3bKtG+Eret7AqxwQ=;
	h=From:Subject:Mime-Version:To:Date:Message-Id:Cc:Content-Type; b=rwMppYdm7bWbJWcws3tqJ7lsrMjm7qN/KGktPKPYtX5Nf1nATNS/zXkofq/qcp7g8+5N4tNOAZ5ZO24r0/7Dfl5VnmTsImlYE/FRleHRmBqdSnutK69pYpWILLhOcGCBkCo0/UQegF8kjTgfR+wIp7qwjLJTkH34kG3DIRsuhJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=LPVUV5em; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="LPVUV5em"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781790483;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rLfSpPNuEGSKw8Ptq4C/ZFhlN9JufsT1g6Ir66lmBU8=;
 b=LPVUV5emFYGukQuaEgED63QLTIdXeSSc32ztLOKJ1yXcnfT0i9IAPIctRdPRX1AaTPyaCy
 2ui0OM/k8rieGIa6zDRP9fgeRZTFHnxoZkBIf6T9zqvhi36ttX1UBEwCwHKX8Iixyugwwz
 batHcs7cLre9o4XwtRMZuBo+1dncHx6tElg23VbcXZ5DZ7uCTNvm3ILWRmoRRWiGeUdN91
 hi0YmNeL9GERjC4xFqy7Bu4CZT9wzLihDKURHsGvE7T9yKqcfKbuRSswkVZ6hv+2CB4uf1
 fqZcKBLALwKamS8t1Q9X97B+SzbKCxyqSIT075mJQX8rUpcRKogd3IcY9JIcIQ==
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([183.34.170.8]) by smtp.feishu.cn with ESMTPS; Thu, 18 Jun 2026 21:48:00 +0800
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: use stripe state snapshot in break_stripe_batch_list()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26a33f711+fca7a3+vger.kernel.org+chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Date: Thu, 18 Jun 2026 21:47:48 +0800
Message-Id: <20260618134748.1168360-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

The patch just suppress KCSAN noise. No functional change.

RAID-5 can group multi full-stripe-write aka stripe_head into a
batch aka batch_list, with one head_sh leading them. Call
break_stripe_batch_list() when the batch is finished, or,
a stripe has to be dropped out of the batch.

break_stripe_batch_list() reads stripe state several times while
request paths can update thost state words concurrently with
lockless bitops, which reported by KCSAN.

Use a snapshot to guarantees that the value used for
warning, copying, and handle checks is internally consistent
at current read moment.

KCSAN report:
==============================================
BUG: KCSAN: data-race in __add_stripe_bio / break_stripe_batch_list

write (marked) to 0xffff8e89d4f0b988 of 8 bytes by task 4323 on cpu 3:
  __add_stripe_bio+0x35e/0x400
  raid5_make_request+0x6ac/0x2930
  md_handle_request+0x4a2/0xa40
  md_submit_bio+0x109/0x1a0
  __submit_bio+0x2ec/0x390
  submit_bio_noacct_nocheck+0x457/0x710
  submit_bio_noacct+0x2a7/0xc20
  submit_bio+0x56/0x250
  blkdev_direct_IO+0x54c/0xda0
  blkdev_write_iter+0x38f/0x570
  aio_write+0x22b/0x490
  io_submit_one+0xa51/0xf70

read to 0xffff8e89d4f0b988 of 8 bytes by task 4290 on cpu 4:
  break_stripe_batch_list+0x3ce/0x480
  handle_stripe_clean_event+0x720/0x9b0
  handle_stripe+0x32fb/0x4500
  handle_active_stripes.isra.0+0x6e0/0xa50
  raid5d+0x7e0/0xba0

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 26c24986e01c..a376560be92e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4906,35 +4906,39 @@ static int clear_batch_ready(struct stripe_head *sh)
 static void break_stripe_batch_list(struct stripe_head *head_sh,
 				    unsigned long handle_flags)
 {
 	struct stripe_head *sh, *next;
 	int i;
+	unsigned long state;
 
 	list_for_each_entry_safe(sh, next, &head_sh->batch_list, batch_list) {
 
 		list_del_init(&sh->batch_list);
 
-		WARN_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
-					  (1 << STRIPE_SYNCING) |
-					  (1 << STRIPE_REPLACED) |
-					  (1 << STRIPE_DELAYED) |
-					  (1 << STRIPE_BIT_DELAY) |
-					  (1 << STRIPE_FULL_WRITE) |
-					  (1 << STRIPE_BIOFILL_RUN) |
-					  (1 << STRIPE_COMPUTE_RUN)  |
-					  (1 << STRIPE_DISCARD) |
-					  (1 << STRIPE_BATCH_READY) |
-					  (1 << STRIPE_BATCH_ERR)),
-			"stripe state: %lx\n", sh->state);
-		WARN_ONCE(head_sh->state & ((1 << STRIPE_DISCARD) |
-					      (1 << STRIPE_REPLACED)),
-			"head stripe state: %lx\n", head_sh->state);
+		state = READ_ONCE(sh->state);
+		WARN_ONCE(state & ((1 << STRIPE_ACTIVE) |
+				   (1 << STRIPE_SYNCING) |
+				   (1 << STRIPE_REPLACED) |
+				   (1 << STRIPE_DELAYED) |
+				   (1 << STRIPE_BIT_DELAY) |
+				   (1 << STRIPE_FULL_WRITE) |
+				   (1 << STRIPE_BIOFILL_RUN) |
+				   (1 << STRIPE_COMPUTE_RUN)  |
+				   (1 << STRIPE_DISCARD) |
+				   (1 << STRIPE_BATCH_READY) |
+				   (1 << STRIPE_BATCH_ERR)),
+			"stripe state: %lx\n", state);
+
+		state = READ_ONCE(head_sh->state);
+		WARN_ONCE(state & ((1 << STRIPE_DISCARD) |
+				   (1 << STRIPE_REPLACED)),
+			"head stripe state: %lx\n", state);
 
 		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
 					    (1 << STRIPE_PREREAD_ACTIVE) |
 					    (1 << STRIPE_ON_UNPLUG_LIST)),
-			      head_sh->state & (1 << STRIPE_INSYNC));
+			      state & (1 << STRIPE_INSYNC));
 
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
 		spin_lock_irq(&sh->stripe_lock);
 		sh->batch_head = NULL;
@@ -4943,22 +4947,25 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up_bit(&sh->dev[i].flags, R5_Overlap);
 			sh->dev[i].flags = head_sh->dev[i].flags &
 				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
 		}
-		if (handle_flags == 0 ||
-		    sh->state & handle_flags)
+
+		state = READ_ONCE(sh->state);
+		if (handle_flags == 0 || (state & handle_flags))
 			set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
 	}
 	spin_lock_irq(&head_sh->stripe_lock);
 	head_sh->batch_head = NULL;
 	spin_unlock_irq(&head_sh->stripe_lock);
 	for (i = 0; i < head_sh->disks; i++)
 		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
 			wake_up_bit(&head_sh->dev[i].flags, R5_Overlap);
-	if (head_sh->state & handle_flags)
+
+	state = READ_ONCE(head_sh->state);
+	if (state & handle_flags)
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 }
 
 /*
  * handle_stripe - do things to a stripe.
-- 
2.54.0
