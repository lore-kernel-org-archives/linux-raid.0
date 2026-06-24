Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54433DC4C8
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316514; cv=none; b=LH0yg9lS0N9OyoKsEqcnW7GiiRC7bsvnSSjApMme9e3llJ5E1ZBmWjNXChDncrS0ehDSkQZYCrivsQ4s5lx4YZ75LsjobzhI9E8Fc+eNibYYDgrp1mqV1Su8c8bwCy2WPpzOHRwpVjGm2Qk9SEgQesTUj0SVx7/F0ziJ5L1RBfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316514; c=relaxed/simple;
	bh=/iL01rcTxKYuoOjkr8nBO3nz+X//63wXskIuLVcYLTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe4FVctS5EgOl/r0wcThCuv4u8yGADhzK/bN8Bvx9DtfRedTNfwbrIDxD0HQYHh7GczCaGxI/DmY9EpzNSDR20taXzJrI8gD+6Q51pNBEIsFtJm8aa8Bh7cQNu0wuYpsBSjv+FudZfV+Vx8+TXjUwzCh2hMnE0aLh2nAt83EMfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKi8uwz1; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKi8uwz1"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-845a3c05e40so734471b3a.1
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316512; x=1782921312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBvcMnXR0bUCZ+109muiJPH0MtIFIDW9xLIUeZK+mX0=;
        b=EKi8uwz1jWWaIopxKghDqj51TzVYKK0IgSMQwrQ9r1BoA0v9vO0Jfl6BDmZHgsq6mH
         nV8yx8nsP9XzvjL4UTDL3uK1xuXxF9eJ+eiHx9J/FE86K26gygRAmFS0RnBqikVE23vM
         hyUNsr1P6X2yB7/a2ypcUxnubZzP5DN//fiYrgnMNI937M+5rY2iJrahMdPREI+04AvO
         5iDCfYcNNxKXRPdhzJ3d8PsnzBEzVZYiMzxrdbxWrM6eIr2DAw0UkPA4SqHZkHmT/+DU
         fb2arY26JtBZT+0PilAU8wJUUzgB2HtV6/CYbRBAeHkniIBOKPqf8M9QSZSaqI4Q3C3B
         W/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316512; x=1782921312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rBvcMnXR0bUCZ+109muiJPH0MtIFIDW9xLIUeZK+mX0=;
        b=QMooDrDWoHtG/LQqW8q8SIkssZ/RWewwySILsu+QcojL2BZslvLRW6u3cCD8bA1jtI
         x9WTq3EpbQJLCKceyzurKf/dnRCp51nS9fkg5K+yvtktgimHg0vxnxWWXqZay0afw1vh
         smY1Az+nThyBtoOHS46qaBO+mT/5V3x9W0mhO6OSo/HHJ7UYEk9pgg8rq4JE4KYdwkxc
         4EdorCAG3NH4tvdh92rjnfvaD8rOyZrnUL63P0OBxIlqpCuRYRE1O6DReNWZmP8m4mCX
         NsFfUsAelv67cFDPQNXZ4tKlbA4sSnNTdFkUjDiKRwRj9hZRWZ9j2uwx6oCRbXuFqZQI
         BqKg==
X-Forwarded-Encrypted: i=1; AFNElJ/pZtlRZ0Nbk2EUMvFJXTBPPSQNrd/vlIa2XPawfs8F1tnIFxLX+Ka+L9b0ZCEwcsMAbTUm4EaUicD/@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk3ATkE4Lo4zP+iABp3EuQiiQlThFYRMUkyR+rmvK7mrvx2iTy
	Xon/6RfnaJujeuIz+XvkaYOuGZA99kbV2ZOdgpf9R9i45yKJDZAd69GF
X-Gm-Gg: AfdE7cngJXSUQ0dh8Dk0Z7B9DVNXD0AzlQA9Xoif3U5KO40c/rmSt9l1hCeSzjabUsD
	rHMK2/qVnsFGZMACAyKsXQoc1YNriI1UiWmYFTm7zcTY/N00DCr8d4f1Rkt0mW1uDT+aFNIhcjp
	fk3A1B4LXK+U2Ms6wR6g0us0e/LkHzQLlv6qMI6WleLTYr+hbg0GcVLAl9hJOuS788AKX/POU83
	10Zq2zdz3f86wfNNSMolHtSSNWWSMUts9Kdk4cBQd7nUyUc8dcJBHKUNou+9Zd6B7wbjpH3KqKe
	EzeVfUx+RdsxjAaFSQcXzeYrO+LZyugzzD13LiQoK51zz/FS7HFbipxO04Hvqb/OgIU+uYV8/pV
	SxWDLGgo2N7eXEQk5oj94uHDCWNUL5yCFH2VjX9ciTtxH6Xb+sww9nHrKNRzzDwntRQV8ktzJp2
	taAgb4g6449dd5T46FUxb+YP5tpJxFW3EtZuWabCnQ2NSiTKby9xzAH2sMnBdKiNbhImPuDNbsn
	tSumrI=
X-Received: by 2002:a05:6a00:a883:b0:845:3fea:976 with SMTP id d2e1a72fcca58-845a2c30d3amr5314426b3a.29.1782316511931;
        Wed, 24 Jun 2026 08:55:11 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:11 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 5/8] md/raid5: submit a window of stripes during resync/recovery
Date: Wed, 24 Jun 2026 08:54:49 -0700
Message-ID: <20260624155452.211646-6-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155452.211646-1-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
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

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 47 +++++++++++++++++++++++++++++++++-------------
 drivers/md/raid5.h |  1 +
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9cb4ed3bd85c..8e9edaaca667 100644
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
index 3efab71ebef7..7aeba1fc7f09 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -497,6 +497,7 @@ struct disk_info {
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
 #define MAX_STRIPE_BATCH	8
+#define RAID5_SYNC_WINDOW	32	/* stripes to pre-submit per sync_request call */
 
 /* NR_STRIPE_HASH_LOCKS must be a power of two, since
  * STRIPE_HASH_LOCKS_MASK masks with (NR_STRIPE_HASH_LOCKS - 1).
-- 
2.43.0

