Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F0842DA5B
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689826; cv=none; b=k+4L6KiudO8S+e0DyzJ07xBTMGiP/f6WVBcWgCXsk7+fmbLYupfF/NNErmy/5pE6A9XikGzzUP0BWaAxZ/DzehMz/CoWiPles7eAtOSUr/xx5SXCmCKVZD2KNxsIo4a6RKx0cX8oCyyj3kt9m3bnhXbGs0uNUJ+ecgnSkG8GpzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689826; c=relaxed/simple;
	bh=PgQydgpqIYOao1d3dr5nJfzWz5l6NdWfmXNZPUI/uHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaAJXQv36ftDJjm50XqQzHurckPHgQ0OsUymu8yOFjTvDw2OEZbgXiQn+Ob3Wf4HrJTtQvHzluTK6WhkMBVtEh4YwoglJDI3rkxoqfeXbzASXscmL+YaUsrtoAPNt9h0UOtBfnkurf0xxjyQqrSgBPbMsba/u2rAeZfjugaP2Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rrop7Ldk; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rrop7Ldk"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3817f800c8bso898889a91.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689824; x=1784294624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tAmOOXGE4pd9C+hf2e5u8lpUJtjLza4UtF53Y1pu8iU=;
        b=Rrop7LdkD4L6z+Mx5SfgLAWDa6EJDLfqU21UTk6HwrmM1B+DI7XcyTNgxrfl/KtlL4
         m74wdmmrOuPx5rv9SaPslF+ewveb+KScDFID+8J3cnK7LXobHbHAfIqdBPyNonbjxmHe
         xVTuxzuAvYJJ1udF7btC9r3zCgJsQFwjki+P7WaCJqvuRPPL+tIEjKDrIdg1CKw7sboE
         DWvS5ZoumzTl1CsPuumMxo4HctAMvfj7FmhvX5yJ5Z2OMKlx7Z7cZdZ0MBWEVA+XJciy
         UxBKfuST2lK0lGMTbYwgL1Jo7OM9PSwxj1dlr7BS+N0NOSjui6T9E8YIg3SnrgavWJXC
         oXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689824; x=1784294624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tAmOOXGE4pd9C+hf2e5u8lpUJtjLza4UtF53Y1pu8iU=;
        b=asRWjZ1J7c0IqVRW50Q0rsjh8jVkE2QAN7UDjeaAVDkZ8JLG+8I8ViK1JMLSgXK5f4
         7W1ZCAR8VD5HAhe0xPuSsr+vkZpsXRyfXjkhwY79G31Ov5ISQQkmS3P4l3W3N4yPO6+t
         3QoJNGcfQxoUFo7TcSecY1yJGRMS6KKs8WH6xeqy33gegsjJmTsK9r4UFkIT7ZB0JIbO
         6Lb4kfnMw3SD0BJeUiqm4LcWs826zgqu55GW0/cvI3cRK2UiS7XrsWS9buyno+DOTS11
         lGn1euVgV0JbFSRuOLOHhPPQguP3W5FbJcakazspvJ+1OhYApdpO7fecTbs7i0yIA6Xy
         q1hg==
X-Forwarded-Encrypted: i=1; AHgh+RqgrQ/aK8H0kt8yV7svgjmGtLvfWVcZIEzYpa96sj28jIART462b6hBh7xRpxgCMW/ffZCuLr+l9yYu@vger.kernel.org
X-Gm-Message-State: AOJu0YwVH96VJ8hw1fAVt0D8eszlta7IMWhLlZlKH0/zG3P9WmEeGrx0
	lF/6ubrtAkMgRDEzMr3/nq7aRhdc+fxEMeaUzvUhzDEBlQ/V4zXJLaZb
X-Gm-Gg: AfdE7cmr/HRlS0nr9EDRaHNgZwXZ9DZXTp8VTlQlSQEQibsDgkOsKF5UTO15M2SFDOg
	QNVG2uUSWDOUK/64Ry7+K2gYyM7ifK4AopqVlfD0gHWpZMA40B9438vllkIEKL+h559HKwka7oa
	Lq1O9dhZOcEW/MFD615g4URaDhNAY7dN0uEZvqQKdl57Mn+3NQJiP9OWUDSmEbzEjHV7FhY5TEE
	+Bp6oyOuEN2Ak4yrJDUTQxlRZlY1dJLhKaAQ6ov9wS3bCKdkq77DUcwlRSPqzTvb5h5D/mhZNwn
	imQGSiW5I07ZQg4W1LyzaEgbU6M1CRE5bFic9RgQX2pEBqfVfcfAjOEzgxUij/s6Ki6g6wz4aG8
	br9DTE1UBGP0gvT8NlvHFz+YKgpesXU5Zz3GTJexVfH5uQEHz/L/cw57/1PoW5k0A2dxgksAVbn
	+gKEyMbU/HqGOfUq7nqPekneNwqpKmPHW5M2YN864MtHhyd6VsLKOLdr9+2o/bLzyXY3XBx+AZa
	NBs+TlQffprtZAPNg==
X-Received: by 2002:a17:90b:50:b0:36a:fcf5:64d2 with SMTP id 98e67ed59e1d1-389407321b5mr11150549a91.16.1783689824094;
        Fri, 10 Jul 2026 06:23:44 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38d2fbc64b5sm549778a91.2.2026.07.10.06.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:43 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 1/2] md/raid5: submit a window of stripes during resync/recovery
Date: Fri, 10 Jul 2026 06:23:38 -0700
Message-ID: <20260710132339.7284-2-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710132339.7284-1-nishidafmly@gmail.com>
References: <20260710132339.7284-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid5_sync_request() dispatches one stripe per call: it fetches a single
stripe head, marks it for sync, and returns one stripe's worth of
sectors.  When the stripe cache is full the NOBLOCK fetch fails and it
re-enters a one-jiffy throttle sleep (schedule_timeout_uninterruptible(1))
before retrying.  Because that sleep is taken per stripe, sustained cache
pressure bounds sync progress to roughly HZ stripes/second regardless of
how fast the member devices are.

Dispatch up to RAID5_SYNC_WINDOW (32) stripes per call instead.  Only the
first stripe of the window keeps the original behaviour (block, then the
one-jiffy throttle if the cache was full); the remaining stripes are
requested with R5_GAS_NOBLOCK and the loop stops as soon as the cache is
full.  So at most one throttle sleep is taken per window rather than per
stripe, and when the cache has free slots a single call can queue a batch
instead of one stripe at a time.

With a warm cache the window stays near full: counting raid5_sync_request()
invocations across a rebuild showed it averaging ~30 of the 32 stripes per
call, i.e. roughly 30x fewer calls into the sync path for the same resync.

The return value reports the number of stripes actually submitted, so
md_do_sync()'s recovery_active accounting stays balanced, and the window
is bounded by both the end of the sync region (max_sector) and
mddev->resync_max, so a user- or cluster-imposed sync ceiling is not
overshot.

This does not change which data is read or written during resync or
recovery.

Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 47 +++++++++++++++++++++++++++++++++-------------
 drivers/md/raid5.h |  1 +
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c5c9fb0606e..574880e4f23f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6563,7 +6563,8 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	struct stripe_head *sh;
 	sector_t sync_blocks;
 	bool still_degraded = false;
-	int i;
+	int i, submitted;
+	sector_t win_sector;
 
 	if (sector_nr >= max_sector) {
 		/* just being told to finish up .. nothing much to do */
@@ -6620,16 +6621,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	if (md_bitmap_enabled(mddev, false))
 		mddev->bitmap_ops->cond_end_sync(mddev, sector_nr, false);
 
-	sh = raid5_get_active_stripe(conf, NULL, sector_nr,
-				     R5_GAS_NOBLOCK);
-	if (sh == NULL) {
-		sh = raid5_get_active_stripe(conf, NULL, sector_nr, 0);
-		/* make sure we don't swamp the stripe cache if someone else
-		 * is trying to get access
-		 */
-		schedule_timeout_uninterruptible(1);
-	}
-	/* Need to check if array will still be degraded after recovery/resync
+	/* Check once whether array will still be degraded after recovery/resync.
 	 * Note in case of > 1 drive failures it's possible we're rebuilding
 	 * one drive while leaving another faulty drive in array.
 	 */
@@ -6640,13 +6632,42 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 			still_degraded = true;
 	}
 
+	/* First stripe: block if stripe cache is full, then throttle. */
+	sh = raid5_get_active_stripe(conf, NULL, sector_nr, R5_GAS_NOBLOCK);
+	if (sh == NULL) {
+		sh = raid5_get_active_stripe(conf, NULL, sector_nr, 0);
+		/* make sure we don't swamp the stripe cache if someone else
+		 * is trying to get access
+		 */
+		schedule_timeout_uninterruptible(1);
+	}
 	md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, still_degraded);
 	set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
 	set_bit(STRIPE_HANDLE, &sh->state);
-
 	raid5_release_stripe(sh);
 
-	return RAID5_STRIPE_SECTORS(conf);
+	/* Submit remaining stripes in the window non-blocking.  Stop early
+	 * if the stripe cache is full: the disk queue is already saturated.
+	 * Bound by resync_max so a user- or cluster-imposed sync ceiling is
+	 * not overshot.
+	 */
+	win_sector = sector_nr + RAID5_STRIPE_SECTORS(conf);
+	for (submitted = 1;
+	     submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
+	     win_sector < mddev->resync_max;
+	     submitted++, win_sector += RAID5_STRIPE_SECTORS(conf)) {
+		sh = raid5_get_active_stripe(conf, NULL, win_sector,
+					     R5_GAS_NOBLOCK);
+		if (!sh)
+			break;
+		md_bitmap_start_sync(mddev, win_sector, &sync_blocks,
+				     still_degraded);
+		set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		raid5_release_stripe(sh);
+	}
+
+	return submitted * RAID5_STRIPE_SECTORS(conf);
 }
 
 static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio,
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index cb5feae04db2..63b630118782 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -491,6 +491,7 @@ struct disk_info {
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
 #define MAX_STRIPE_BATCH	8
+#define RAID5_SYNC_WINDOW	32	/* stripes to pre-submit per sync_request call */
 
 /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
  * This is because we sometimes take all the spinlocks
-- 
2.43.0

