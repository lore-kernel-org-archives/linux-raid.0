Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46B71A6810
	for <linux-raid@vger.kernel.org>; Tue,  3 Mar 2026 03:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772508351; cv=none; b=PbbZmF8lxqghTHl2SCa5W5J+kEbELKzCCKXY3ZD/Jwyat9ioxiHgwJe0mLUdi36l2zh88Ehh8xdfHQfiTu5RPNuNHRWWlrkQoDLwAS1F2ugXxnEG18QUSmhUWl7iRgQUELkzvHq5KwdaTOoi3oAvgbqH2pGYDMvEWAk2v6KLdKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772508351; c=relaxed/simple;
	bh=GoT8pE2k4gKM4Cbd4JZfuSBFcuSaPbbnka0AFhZoZCU=;
	h=Subject:From:Message-Id:Mime-Version:Content-Type:To:Cc:Date; b=u27kZ2JSVpMDHSOKlwPVd1t0yA1tij49V/4WpMRVOjwfHR5bOl3KTLi9gg+N/YChU3gwsc0UoegmBfz6XeWuXqeV45dS0WVTu1CV8lhF5YOl0rGC76aNSqnWl80+K6uX88AwzIbIwuPowgkbbkcTtY4vr2BgxceW41Eft5/qTXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=3S7S7Lng; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="3S7S7Lng"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772508256;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gkqHojEMda2c3nm3qF3rYJHxqPJWecnOjS8NHbFXp8E=;
 b=3S7S7LngJkDCnEWwrnIwx/9leTCpfsD26hxOZ84EOUmODYI05t6tScxw9i1n7lFsgPADef
 xPQ0aZQh3zlcLkaUHcxgajZb/jAzDafakx23wdf/enucoUNxZYc/q1lCtNeJNGBgHLQPW1
 lTju/pKLIMt2x1MHv8hNX35C6+Rr9v3aDfLu5pisbDTNlSGmSdUtY1S8C5f6RTemY3jifF
 Gy3JPNIFgtaMNGqTHCssTzOZNuqLAVxUHvkGB82NVX/eajHwH5Fu2eRu6bZw82FFXe3ARK
 D7Z7MNBXWhtkE+09tCaLX/o9HJaTwMQ3U6ynyUQgUlu40BEDzb1tfaC+1TxobA==
Subject: [PATCH] md/raid5: clean up stale declaration and misplaced comment
Received: from c ([113.111.140.155]) by smtp.feishu.cn with ESMTPS; Tue, 03 Mar 2026 11:24:13 +0800
Content-Transfer-Encoding: 7bit
From: "Chen Cheng" <chencheng@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Message-Id: <20260303111608.7259-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269a6545e+e665d8+vger.kernel.org+chencheng@fnnas.com>
X-Mailer: git-send-email 2.51.0
Content-Type: text/plain; charset=UTF-8
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fnas.com>
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>
Date: Tue,  3 Mar 2026 19:16:08 +0800

Remove the unused md_raid5_kick_device() declaration from raid5.h -
no definition exists for this function.

Move the handle_stripe() documentation comment from above
analyse_stripe() to directly above handle_stripe() where it belongs.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 26 ++++++++++++--------------
 drivers/md/raid5.h |  1 -
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8e8d431071b..48504b0e496b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4594,20 +4594,6 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 	async_tx_quiesce(&tx);
 }
 
-/*
- * handle_stripe - do things to a stripe.
- *
- * We lock the stripe by setting STRIPE_ACTIVE and then examine the
- * state of various bits to see what needs to be done.
- * Possible results:
- *    return some read requests which now have data
- *    return some write requests which are safely on storage
- *    schedule a read on some buffers
- *    schedule a write of some buffers
- *    return confirmation of parity correctness
- *
- */
-
 static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	struct r5conf *conf = sh->raid_conf;
@@ -4901,6 +4887,18 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 }
 
+/*
+ * handle_stripe - do things to a stripe.
+ *
+ * We lock the stripe by setting STRIPE_ACTIVE and then examine the
+ * state of various bits to see what needs to be done.
+ * Possible results:
+ *    return some read requests which now have data
+ *    return some write requests which are safely on storage
+ *    schedule a read on some buffers
+ *    schedule a write of some buffers
+ *    return confirmation of parity correctness
+ */
 static void handle_stripe(struct stripe_head *sh)
 {
 	struct stripe_head_state s;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 110b1c2d0a86..1c7b710fc9c1 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -801,7 +801,6 @@ raid5_get_dev_page(struct stripe_head *sh, int disk_idx)
 }
 #endif
 
-void md_raid5_kick_device(struct r5conf *conf);
 int raid5_set_cache_size(struct mddev *mddev, int size);
 sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
 void raid5_release_stripe(struct stripe_head *sh);
-- 
2.51.0
