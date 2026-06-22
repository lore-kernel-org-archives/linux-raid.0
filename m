Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535C739AD34
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782130417; cv=none; b=DPLRioXXGSiT8zjPPmggb3tWdqqnqe/XO14wJcg6qZL07O+PMDfftBZP49Si59OwIyF/Skrw+0TRrAgsU0bUb6Vfwv78tc62RfwvwTllNN5FUjtvqboEz+OcVHPFTk7vcD+podeP+R6jVBmPPHJgNErL0HElD+H/hqSyJam7Abc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782130417; c=relaxed/simple;
	bh=V3Q3vSYclRVNS28hu/L2fbLAG3qoGNDKJMXnv+X+E54=;
	h=Message-Id:Cc:From:Subject:Date:Mime-Version:Content-Type:To:
	 References:In-Reply-To; b=h0tJpZJfiGI+Td/mHF05avuy6Vv1KDLDwO1TbYapm3KY8ZbldsseF7E/zwFArT9Bn0H3C3nWtipQBqiPylIZuxcTF7B0QYYJWJd5PryqEfydzAvXgEO5Qys5UXhnB4kCZSuCznZZGombe7OCmFOhp/+Q6NhcsKb743aiLeiUkm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ECy9QFff; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ECy9QFff"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782130412;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4kd63vzAcSW+og/wDqa8HYtJ+wn5X36ZnMn/DN5X1IA=;
 b=ECy9QFffmlMTMzT6LYjYEQb3/khUh5F29kUAJ0MLII8xX0/SOcsA+7nciHmW09p1od7n69
 tmTpbl82C771sh/zEhxMLa/Xm1R4fR/L7QoCCKh2HcT7LO+7wboICiY/38fbGhtXf3hTp3
 shHFaobXPFJclCwW3RWN1Tck2ix6pCx9F50jWwX6RGqafiCymXWl3XT91hJSejXXm2vlQ/
 VMvSefPtw0tqqEA2h1CV6+7KIYPorN7VPTL/dIauJiElsFfpwr6r8VlIro2BFtBqxVgr+5
 IsBsF/AAybtnRtKPt8iwTJXPuODnYdb97j5rI/j/RizaPZOZDWfjNLEfbd7Cog==
Message-Id: <20260622121312.1775322-4-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH v5 3/3] md/raid10: free r10bio before ending master_bio in raid_end_bio_io()
Date: Mon, 22 Jun 2026 20:13:12 +0800
Received: from localhost.localdomain ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 20:13:29 +0800
X-Original-From: chencheng@fnnas.com
X-Lms-Return-Path: <lba+26a3926ea+76c663+vger.kernel.org+chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
References: <20260622121312.1775322-1-chencheng@fnnas.com>
In-Reply-To: <20260622121312.1775322-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0

From: Chen Cheng <chencheng@fnnas.com>

origin flow:

      bio_endio(master_bio);   /* may drop active_io to zero */
      allow_barrier(conf);
      free_r10bio(r10_bio);    /* reads conf->geo, returns to pool */

one scenario is:

  CPU A (softirq, raid_end_bio_io)         CPU B (action_store) --> reshape
  ================================         ===============================
  bio_endio(master_bio)
    md_end_clone_io
      percpu_ref_put -> 0
                                           wait_event wakeup, and,
                                           	mddev_suspend return
                                           raid10_start_reshape:
                                             setup_geo(&conf->geo, new)
                                             ...
                                             mempool_destroy(old_pool)
                                             conf->r10bio_pool = new_pool
  allow_barrier(conf)
  free_r10bio(r10_bio)
    put_all_bios:
      for (i=0; i<conf->geo.raid_disks; i++)
          ==> old obj, new geo, OOB
    mempool_free(r10_bio, conf->r10bio_pool)
          ==> old-geometry obj freed into new pool

so .. fix by reorder the flow:

	free_r10bio(r10_bio)
	allow_barrier(conf)
	bio_endio(master_io)

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d740744a9746..a4642c903b20 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -330,24 +330,27 @@ static void reschedule_retry(struct r10bio *r10_bio)
  */
 static void raid_end_bio_io(struct r10bio *r10_bio)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct r10conf *conf = r10_bio->mddev->private;
+	bool returned = test_and_set_bit(R10BIO_Returned, &r10_bio->state);
+	blk_status_t status = test_bit(R10BIO_Uptodate, &r10_bio->state)
+				? BLK_STS_OK : BLK_STS_IOERR;
 
-	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
-		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
-			bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
-	}
+	put_all_bios(conf, r10_bio);
+	mempool_free(r10_bio, conf->r10bio_pool);
 
 	/*
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.
 	 */
 	allow_barrier(conf);
 
-	free_r10bio(r10_bio);
+	if (!returned) {
+		bio->bi_status = status;
+		bio_endio(bio);
+	}
 }
 
 /*
  * Update disk head position estimator based on IRQ completion info.
  */
-- 
2.54.0
