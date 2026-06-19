Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF76632E68D
	for <linux-raid@vger.kernel.org>; Fri, 19 Jun 2026 04:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781842236; cv=none; b=nrdAL2oc2xfIkdTgpsti2l2y21WvuHqd6e5aSMWwpkwwBRwYDLtU8DytZC151lUr0wzZ7Oqmgstk/Jk7OmIrT5Wnsnx5kVuo5HEV8TS/hSz48E5EiODBY9yu6HNM3b5xERQrvLX24M3Qv6ktTY0HG+uWd7RgE+52fZyaclyqipE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781842236; c=relaxed/simple;
	bh=O0+2WigCaFsIa7P4izvrJp4819rT0d4c18Q/RdGLCJ0=;
	h=To:Date:Cc:From:Subject:Message-Id:Mime-Version:Content-Type; b=NX+c6iOFc1kz/Z/kBMCcj1Plw5OfM62lVtTj0fc5X1tfeC06DXZIanqNLS9SfouZ6fntDV0DSwbXSwMBZw+xymSzTvHrpUwSsG4VyNOLhCasUwy02bxlbd6QFanEXmY7WT5mNFbcr/IvZXLYmfXnDPyESKoROiq1YX870hsgzGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=piLs+0KQ; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="piLs+0KQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781842228;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yS+9FcQ3luwGzE43FCzAjT+J3BUoNhJEMrbzs+Nel8I=;
 b=piLs+0KQt0MwNvOgPNorfhwf0HJt/Jxm8KWE6BhwJyj+CMa5R2IbM0WaNN6xsDpr7tTB6e
 siVMf2Udo59HAbAOywQAOy8OsxpumH+BB3+DsNaCTnF4okjnPH228LS+xya8FL6nmut1tQ
 ST2N22vWMB/NN4iK7kp3A42nF7Gk85KUly6aQ8ek5mJ8gs9ho3DIJ90TFuPwiyNe0nCn/N
 qfnGlqmpfWDDuICGWR8YUwdZS2mYqB2WRcfopzCalZag/CVuoNDobanWIMI5i+1aNOhLMo
 bXyo34wsvl+77pPjCPcfAdj/BLUptRWC3xPmjPSpyhynpIwzctPtezPteMCI9w==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Date: Fri, 19 Jun 2026 12:10:13 +0800
X-Original-From: chencheng@fnnas.com
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 7bit
Received: from localhost.localdomain ([183.34.170.142]) by smtp.feishu.cn with ESMTPS; Fri, 19 Jun 2026 12:10:25 +0800
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>, 
	<linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: avoid R5_Overlap races while breaking stripe batches
Message-Id: <20260619041013.1207148-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a34c132+f2c10d+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

KCSAN report a race in break_stripe_batch_list() vs. raid5_make_request()
on sh->dev[i].flags (plain word write vs. atomic bit op)..

and .. one possible scenario is:

CPU1                            CPU2
break_stripe_batch_list(sh1)
-> handle sh2
-> lock(sh2)
-> sh2->batch_head = NULL
-> unlock(sh2)
-> test_and_clear_bit(R5_Overlap, sh2->dev[i].flags)
-> wake_up_bit(sh2->dev[i].flags)
                                raid5_make_request()
                                -> add_all_stripe_bios(sh2)
                                -> lock(sh2)
                                -> stripe_bio_overlaps(sh2) returns true
				   batch_head is NULL, so new bio overlap
				   exist bio on sh2 -> true
                                -> set_bit(R5_Overlap, sh2->dev[i].flags)
                                -> unlock(sh2)
                                -> wait_on_bit(sh2->dev[i].flags)
-> sh2->dev[i].flags = sh1->dev[i].flags & ~R5_Overlap

No wait_up_bit(), CPU2 could be wait_on_bit() forever...

Fix by :
- Expand the protect zone.
- Use batch_head's device flag's snaphot when no held head_sh->stripe_lock.
- Move sh/head_sh->batch_head = NULL to the end of protected zone , and ,
  any concurrent add_all_stripe_bios() grabs sh->stripe_lock now either:
	- see batch_head != null, and , is rejected by stripe_bio_overlaps()
	  under the lock (no R5_Overlap wait ) , or ,
	- sees batch_head == NULL, only after dev[i].flags has already been
	  set and the prior R5_Overlap waiters worken.

KCSAN report:
================================================
  BUG: KCSAN: data-race in break_stripe_batch_list / raid5_make_request

  write (marked) to 0xffff8e89c8117548 of 8 bytes by task 4042 on cpu 0:
    raid5_make_request+0xea0/0x2930
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
    __x64_sys_io_submit+0xf7/0x220
    x64_sys_call+0x1907/0x1c60
    do_syscall_64+0x130/0x570
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

  read to 0xffff8e89c8117548 of 8 bytes by task 4010 on cpu 5:
    break_stripe_batch_list+0x249/0x480
    handle_stripe_clean_event+0x720/0x9b0
    handle_stripe+0x32fb/0x4500
    handle_active_stripes.isra.0+0x6e0/0xa50
    raid5d+0x7e0/0xba0
    md_thread+0x15a/0x2d0
    kthread+0x1e3/0x220
    ret_from_fork+0x37a/0x410
    ret_from_fork_asm+0x1a/0x30

  value changed: 0x0000000000000019 -> 0x0000000000000099 --> R5_Overlap

Fixes: fb642b92c267b

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a376560be92e..5521051a9425 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4939,30 +4939,30 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 			      state & (1 << STRIPE_INSYNC));
 
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
 		spin_lock_irq(&sh->stripe_lock);
-		sh->batch_head = NULL;
-		spin_unlock_irq(&sh->stripe_lock);
 		for (i = 0; i < sh->disks; i++) {
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up_bit(&sh->dev[i].flags, R5_Overlap);
-			sh->dev[i].flags = head_sh->dev[i].flags &
+			sh->dev[i].flags = READ_ONCE(head_sh->dev[i].flags) &
 				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
 		}
+		sh->batch_head = NULL;
+		spin_unlock_irq(&sh->stripe_lock);
 
 		state = READ_ONCE(sh->state);
 		if (handle_flags == 0 || (state & handle_flags))
 			set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
 	}
 	spin_lock_irq(&head_sh->stripe_lock);
-	head_sh->batch_head = NULL;
-	spin_unlock_irq(&head_sh->stripe_lock);
 	for (i = 0; i < head_sh->disks; i++)
 		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
 			wake_up_bit(&head_sh->dev[i].flags, R5_Overlap);
+	head_sh->batch_head = NULL;
+	spin_unlock_irq(&head_sh->stripe_lock);
 
 	state = READ_ONCE(head_sh->state);
 	if (state & handle_flags)
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 }
-- 
2.54.0
