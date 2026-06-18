Received: from sg-3-27.ptr.tlmpb.com (sg-3-27.ptr.tlmpb.com [101.45.255.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CFF2F8EB8
	for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 06:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781765811; cv=none; b=DK5BBbeiaekElIvSzXR88lqn4RDuwrhept/ahGsO8KvANrPB/hb1/fhizeBQoVnUzaJwftc7Ukj7/MO/YSRe4ecVfRJF++9OHb9aD2pFbRPwiPvDjJINE4ZrfpYor2hMwJcW9nhn9ijIYLYMCQOV0tS6sexrBFM7m5sKABmlDKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781765811; c=relaxed/simple;
	bh=E0RywlzfSgWRcw7edFJoj3Iywo8TrCjC6t0FMaDwlwY=;
	h=Message-Id:Content-Type:Subject:To:Cc:From:Mime-Version:Date; b=Bi2noEI74TzkALGLa5RJd+0pynHEhi1KOMdIlT9bzso57ZWGupENpW36cJyfF3OU0jfcuXdqgU3O4YphbY1SUiKE94KQoR5MkRG1E9Pi3t8fB/XA0Iv1PNOrLsAKZ0Ccwgh/0qY8HFIqyLBGwOqj/9qJ9aW0SECsRYwb0ROtc5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=IM7AlX1M; arc=none smtp.client-ip=101.45.255.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="IM7AlX1M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781765757;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=l9P5x4yQbmNVbLXBdeBBxhloVa3Tf80a45TdoFScqq0=;
 b=IM7AlX1MnY2qfbrDA+dROeKLqb5tPLQSaH2FjzW5cqRh+NepXf0VxXKcWcsZJEmZBpgMO6
 iisYyA9+Mn63tASPCRXS3TOHDUMolb8EbVidCRbgr4CU53TmRauou73z3+0DMkcRBgYnug
 c5AqWnLNuds4B6VabxhlKxM/KnttMyLgPJD6VqG1+1x/ky1DE0B8iHO+f7wTLtkRFGe1tZ
 O1KXzgJ2rqtUGfjpw9MqXop+AV6sZnFvxmd7pOHQU0WvOQGswzsvzsOwQwW9GFcJGHnH9J
 nOu6NIjACKB8fiw1P68QQ83sB2ZddeRJD9NEhcKY9fNUNDgjqPMO4Egd9pvycg==
Message-Id: <20260618065544.954309-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH] md/raid5: protect batch_head->bm_seq updates
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 7bit
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>, 
	<linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a33967b+58f44b+vger.kernel.org+chencheng@fnnas.com>
Date: Thu, 18 Jun 2026 14:55:44 +0800
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([183.34.170.8]) by smtp.feishu.cn with ESMTPS; Thu, 18 Jun 2026 14:55:55 +0800

From: Chen Cheng <chencheng@fnnas.com>

bm_seq means "stripe delay to flush until bm_seq <= seq_write".

do_release_stripe() keeps STRIPE_BIT_DELAY stripes on bitmap_list
when bm_seq >= seq_write.

after raid5d() flushes bitmap update and ++seq_write, and
active_bit_delay() retry to release delayed stripes.

the stripe batch head must carry the newest bm_seq among all
member stripes, because the whole batch later released according
to the batch head state and bm_seq.

race scenario:
===================
1. cpu0 - sh0->bm_seq=101; cpu1 - sh1->bm_seq=102;
2. both cpu0 and cpu1 read batch_head->bm_seq = 100;
3. cpu1 write 102, and cpu0 overwrite with 101;

the point is, if the head has a lower bm_seq than one of its
members, the whole batch could be released before that
member's bitmap is flushed.
and the on-disk bitmap not record sh1's changes.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a08230aac711..ee145a7bf9e8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -980,32 +980,31 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 		/*
 		 * at this point, head's BATCH_READY could be cleared, but we
 		 * can still add the stripe to batch list
 		 */
 		list_add(&sh->batch_list, &head->batch_list);
-		spin_unlock(&head->batch_head->batch_lock);
 	} else {
 		head->batch_head = head;
 		sh->batch_head = head->batch_head;
 		spin_lock(&head->batch_lock);
 		list_add_tail(&sh->batch_list, &head->batch_list);
-		spin_unlock(&head->batch_lock);
 	}
 
-	if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-		if (atomic_dec_return(&conf->preread_active_stripes)
-		    < IO_THRESHOLD)
-			md_wakeup_thread(conf->mddev->thread);
-
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
 		    sh->batch_head->bm_seq - seq > 0)
 			seq = sh->batch_head->bm_seq;
 		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
 		sh->batch_head->bm_seq = seq;
 	}
+	spin_unlock(&head->batch_head->batch_lock);
+
+	if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		if (atomic_dec_return(&conf->preread_active_stripes)
+		    < IO_THRESHOLD)
+			md_wakeup_thread(conf->mddev->thread);
 
 	atomic_inc(&sh->count);
 unlock_out:
 	unlock_two_stripes(head, sh);
 out:
-- 
2.54.0
