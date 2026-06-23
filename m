Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBF13D4117
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782218345; cv=none; b=ARcJD/wcu8ZLAzEZ5s4aOglWUkXVwETzRp2y9bK7NMkTEkzRuGRI6EfdbKoXEoWCxGI5VGJIbRClAip4XKBylwGyvod3FAO7LdYYUUZlIqB+qsBwODKgOwGy3KJH/uM3DRXfe2DjmGm1zUKetlsUZCjXrwAYEOBz3BkYihJu2iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782218345; c=relaxed/simple;
	bh=18eTRgYoeHLppWrwYc6eF7a89RpQ353ju7R4vZITpDg=;
	h=Date:Mime-Version:In-Reply-To:References:Cc:Subject:To:Message-Id:
	 Content-Type:From; b=PSEQFwl/qmoxUewqdrujVRi2t0zrkKUAj7YoHvTwYBav5KtZunASTfkRNE1oChC+Y1nxkxWfECVMDBUzIWZIBQkOADuA4D5pIDUFrLQsPPWYWjNqjKXJQCrdbPKF6ViGS4zW+5lrAa4ZJARhnWMTmL09cSFaSIXbWw15s0YSoe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=SLtTz0+0; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="SLtTz0+0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782218339;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=tB1v22PxlpTCOlcV/3Md4yuBMVCnRPIXJoePQzKXC68=;
 b=SLtTz0+0VNUd0qfylZxI2AyyNVNdlB9YkkqP8d6VeV9k7pg+Ln/Y8mTVKTCqcymjNvs04v
 g8qUt482Ay07dIvWm7VMTC4zTsrYbohNBPD0V8JcUj8Z/ithlBZyo7CSFwL2REQNGfoIkm
 q0NCkCvSid7Mkfb33peU78WBS9cY7VaWQfY54aG7Vo4Q2jewlZ3wxhpM88OiAyDcQEqDBo
 FxXlKi7WRD3MDW7m+ZPIQGJCRnI36HlnFdqkG3y0AedapDSar7NK9aNs/ECWjuKPqCFsJ5
 PFOATmHXZzRrAsQpOsqzf9Cd2Dq5ZQ3ZB+Oh9yfTt0cOiD5vNX9ZMKaukvzcsQ==
Date: Tue, 23 Jun 2026 20:38:40 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260623123840.2521340-1-chencheng@fnnas.com>
References: <20260623123840.2521340-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 3/3] md/raid10: free r10bio before ending master_bio in raid_end_bio_io() and raid_end_discard_bio()
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Message-Id: <20260623123840.2521340-4-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Received: from localhost.localdomain ([183.34.169.141]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 20:38:56 +0800
X-Original-From: chencheng@fnnas.com
X-Lms-Return-Path: <lba+26a3a7e61+57b00d+vger.kernel.org+chencheng@fnnas.com>

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

raid_end_discard_bio() is exactly the same.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d740744a9746..e44a9b6e95c7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -330,24 +330,25 @@ static void reschedule_retry(struct r10bio *r10_bio)
  */
 static void raid_end_bio_io(struct r10bio *r10_bio)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct r10conf *conf = r10_bio->mddev->private;
+	unsigned long state = r10_bio->state;
 
-	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
-		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
-			bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
-	}
+	free_r10bio(r10_bio);
 
 	/*
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.
 	 */
 	allow_barrier(conf);
 
-	free_r10bio(r10_bio);
+	if (!test_and_set_bit(R10BIO_Returned, &state)) {
+		if (!test_bit(R10BIO_Uptodate, &state))
+			bio->bi_status = BLK_STS_IOERR;
+		bio_endio(bio);
+	}
 }
 
 /*
  * Update disk head position estimator based on IRQ completion info.
  */
@@ -1580,13 +1581,15 @@ static void raid_end_discard_bio(struct r10bio *r10bio)
 		if (!test_bit(R10BIO_Discard, &r10bio->state)) {
 			first_r10bio = (struct r10bio *)r10bio->master_bio;
 			free_r10bio(r10bio);
 			r10bio = first_r10bio;
 		} else {
+			struct bio *master_bio = r10bio->master_bio;
+
 			md_write_end(r10bio->mddev);
-			bio_endio(r10bio->master_bio);
 			free_r10bio(r10bio);
+			bio_endio(master_bio);
 			break;
 		}
 	}
 }
 
-- 
2.54.0
