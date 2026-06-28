Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1F7190462
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656865; cv=none; b=YC09rikuQ8WqaEltxRBVGPFlENGzr3Nnjluz+LpO2dGIsLZ4D4d79AtVhFmd8F7YF/dfwptaoljUkZFvLReUZwfAZsgkfgSWiIpjCRPKhULfH1f05lDOyp6C5RpRZQSm+nDjBMUwL0y4kYTo5D/VEVv7rumZoq360GR1EqS654Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656865; c=relaxed/simple;
	bh=BTb2zYZ0t8I2Cv+LmuDiE37Bm4O39CQYq1rcGvF0Io8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FmeTVd3o/yKVTCnc+QJz7WZj8/FoRxOKSJF+Fc0ifGGtbLvqoD8u1uoFjT7Si/wZ4Jcf55+9iYHcyILttmdkgHYz3X92oG0L8Bsbv8GKrKosUdAaFtX3xiYcIT1LJAk6i2DEcV7D1aXjo/PDlvYziWMJyg/9vRKUqRCaqewnmVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rpSAZ4Sp; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rpSAZ4Sp"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4720f3bf164so398317f8f.1
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656862; x=1783261662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uf9Eezi+IHncXLpl28UKTdGH/GSLiRY48Hyy50eWEYI=;
        b=rpSAZ4SpYTS4BZ701GTVVCeT28WV5+CI0oqKopnUSg7OO88IC2g3lkr0qGDfHNdSmO
         0/VLOsM8IgxdlKvhHFlC2047+RluKcDLxe60Gb8huETAioKPPcvdXFkTVWMoBHyom3YU
         SfvSFiPtUSxSx6K1j7d7MYeHIKDYrrAV3p+6XoD2aUSTBrd2mibOwKW9zBMxCx9USIAF
         gbJ9C5GniFDkM9r32T3wJuMUliV9ST+R8PBIXnYhbcHQBLXErSAJU22DoRA01hgHuD/u
         A7TJbWrbmrYFxMJriPyHg1cigt6e0EBl4kOJ9NlXY1pHryvY4swNnsWzGcvKcS0GTyZe
         ksAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656862; x=1783261662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uf9Eezi+IHncXLpl28UKTdGH/GSLiRY48Hyy50eWEYI=;
        b=WIcs+NpwLspR4DvTEJHIfq8ukn1w1Tkl6sAP047fCDeV2ZLcxKnQ7d2ZgtDrJCirRf
         ylGRUigrN4KsER1K3ECBlMN2av/RxG2jeWqftXs3HmmrJJcGfr8JwUknlCaS3Lv8dAcQ
         eSzSEXyTFQJCNtCPef57us8SyrEyr5ghmsOyXyTheno74hjnQPm2Av78bQ3YgzVtgcFq
         I+qasbI9p/WDsmZfyzyR/ted+/ZT4LpbipqCXGHtGaUNxSHZMkB9BbxGc4ZdkzoleNVY
         ehTuAW4nXeP1h/JgrEfeNm7SuZFJZgezuk6z09F9hrxnlCm5ZJRG2Kkktq/CZMsyh458
         CoTQ==
X-Forwarded-Encrypted: i=1; AHgh+Row2AeMZNgeVy9TVaNppmCYtp01wCE6GG8MgNdr8zk8/kCgc8lp/Z00uSy17QjiyTv7bzSebwzSkwud@vger.kernel.org
X-Gm-Message-State: AOJu0YzvAg6buiv/P1n3I9TgsC5ZeI+E7g1JO19XZ2XWUmIOZGU8Ostk
	7SITqZvig4cU5dxNYOKlN7/WIJd8plWSSsAREj9R0gNioLJXNmCXbtPR
X-Gm-Gg: AfdE7cmhLf3zOX+L/kx8NtAGee6BqW3ZWcke2LY0Ajrdem4h/MHoCobZ5kHrv9p5Hgj
	YWIAUCVed9/E+23wqi14Raaj8gRGTJZvYRTDa2a65X2ifSa1FdT89H3PPhgtITho8O1HbEmzX/Y
	rALa9tlpMFHwG+8D0FwjlQGWYikjmKoTn6RAQREcGdWcnD/3kgZoI9Sgug4MCakHZKdPpeQ9cE9
	neDQbWPZ50l+ARRnBiTpG1uUNgupV4CSkGUUww9ReISkVVa0U8a9ouRERcjbjaU8NasCW+VkVU3
	bBld/zdhQ/jK/GD+eu7WYSYwpa/DpC3UIwzA1LgeCoJaS6R9yet5qEBFkgDR2ojQVeaYgCdkvwj
	EsrQJngaknw6CIrZcXiQVdgRHXG/L4Ff3tfvjXbThSyUS6g69aPV2fAjLmaOBiJY4YvBv0gGeE6
	yC+77xGfp+mwCMTh9WTAs06MxuCik8iqBhvqFadsp9XVNCIYhU+Y3COM3U/EQzfxIxFw5VGeRft
	HH4npA=
X-Received: by 2002:a05:6000:27c3:b0:46b:70db:2113 with SMTP id ffacd0b85a97d-46b70ea637fmr19421536f8f.0.1782656861996;
        Sun, 28 Jun 2026 07:27:41 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4707ed8ee0bsm15548707f8f.27.2026.06.28.07.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:27:41 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	vverma@digitalocean.com,
	axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] md: remove REQ_NOWAIT support
Date: Sun, 28 Jun 2026 14:27:37 +0000
Message-ID: <20260628142737.1051059-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

REQ_NOWAIT support in md is fundamentally incomplete. While reads can
avoid some blocking paths, write requests can still encounter cases
where one mirror succeeds while another returns -EAGAIN. At that point
md cannot distinguish queue pressure from a real device failure, so it
can neither record a bad block nor safely retry the write without
REQ_NOWAIT, leaving mirrors with divergent data.

Rather than continue advertising REQ_NOWAIT support that cannot be
implemented correctly, remove it from md and its raid personalities.
This simplifies the waiting paths and avoids exposing incorrect
non-blocking semantics.

Fixes: bf2c411bb1cf ("md: raid456 add nowait support")
Fixes: c9aa889b035f ("md: raid10 add nowait support")
Fixes: 5aa705039c4f ("md: raid1 add nowait support")
Fixes: f51d46d0e7cb ("md: add support for REQ_NOWAIT")
Suggested-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md-bitmap.c   |  9 +---
 drivers/md/md-bitmap.h   |  2 +-
 drivers/md/md-llbitmap.c | 10 +----
 drivers/md/md.c          | 15 ++-----
 drivers/md/raid1-10.c    |  8 ++--
 drivers/md/raid1.c       | 91 +++++++++-------------------------------
 drivers/md/raid10.c      | 80 +++++++++--------------------------
 drivers/md/raid5.c       | 13 ------
 8 files changed, 51 insertions(+), 177 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0f02e2956398..7d778fe1c47c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2064,23 +2064,18 @@ static void bitmap_end_behind_write(struct mddev *mddev)
 		 bitmap->mddev->bitmap_info.max_write_behind);
 }
 
-static bool bitmap_wait_behind_writes(struct mddev *mddev, bool nowait)
+static void bitmap_wait_behind_writes(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
 	/* wait for behind writes to complete */
 	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
-		if (nowait)
-			return false;
-
 		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
 			 mdname(mddev));
 		/* need to kick something here to make sure I/O goes? */
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
-
-	return true;
 }
 
 static void bitmap_destroy(struct mddev *mddev)
@@ -2090,7 +2085,7 @@ static void bitmap_destroy(struct mddev *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	bitmap_wait_behind_writes(mddev, false);
+	bitmap_wait_behind_writes(mddev);
 	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		mddev_destroy_serial_pool(mddev, NULL);
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index f46674bdfeb9..214f623c7e79 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -98,7 +98,7 @@ struct bitmap_operations {
 
 	void (*start_behind_write)(struct mddev *mddev);
 	void (*end_behind_write)(struct mddev *mddev);
-	bool (*wait_behind_writes)(struct mddev *mddev, bool nowait);
+	void (*wait_behind_writes)(struct mddev *mddev);
 
 	md_bitmap_fn *start_write;
 	md_bitmap_fn *end_write;
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 5a4e2abaa757..2a2b38c663c3 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1574,19 +1574,13 @@ static void llbitmap_end_behind_write(struct mddev *mddev)
 		wake_up(&llbitmap->behind_wait);
 }
 
-static bool llbitmap_wait_behind_writes(struct mddev *mddev, bool nowait)
+static void llbitmap_wait_behind_writes(struct mddev *mddev)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
 
-	if (llbitmap && atomic_read(&llbitmap->behind_writes) > 0) {
-		if (nowait)
-			return false;
-
+	if (llbitmap && atomic_read(&llbitmap->behind_writes) > 0)
 		wait_event(llbitmap->behind_wait,
 			   atomic_read(&llbitmap->behind_writes) == 0);
-	}
-
-	return true;
 }
 
 static ssize_t bits_show(struct mddev *mddev, char *page)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..66a41d482e59 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -402,14 +402,9 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 		 */
 		percpu_ref_get(&mddev->active_io);
 	} else {
-		if (is_suspended(mddev, bio)) {
-			/* Bail out if REQ_NOWAIT is set for the bio */
-			if (bio->bi_opf & REQ_NOWAIT) {
-				bio_wouldblock_error(bio);
-				return true;
-			}
+		if (is_suspended(mddev, bio))
 			wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
-		}
+
 		if (!percpu_ref_tryget_live(&mddev->active_io))
 			goto check_suspended;
 	}
@@ -6283,7 +6278,7 @@ void md_init_stacking_limits(struct queue_limits *lim)
 {
 	blk_set_stacking_limits(lim);
 	lim->features = BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
-			BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
+			BLK_FEAT_IO_STAT;
 }
 EXPORT_SYMBOL_GPL(md_init_stacking_limits);
 
@@ -6631,7 +6626,6 @@ int md_run(struct mddev *mddev)
 	int err;
 	struct md_rdev *rdev;
 	struct md_personality *pers;
-	bool nowait = true;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -6702,7 +6696,6 @@ int md_run(struct mddev *mddev)
 			}
 		}
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
-		nowait = nowait && bdev_nowait(rdev->bdev);
 	}
 
 	pers = get_pers(mddev->level, mddev->clevel);
@@ -7050,7 +7043,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 static void mddev_detach(struct mddev *mddev)
 {
 	if (md_bitmap_enabled(mddev, false))
-		mddev->bitmap_ops->wait_behind_writes(mddev, false);
+		mddev->bitmap_ops->wait_behind_writes(mddev);
 	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 56a56a4da4f8..3b0e230692ba 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -290,9 +290,8 @@ static inline bool raid1_should_read_first(struct mddev *mddev,
 }
 
 /*
- * bio with REQ_RAHEAD or REQ_NOWAIT can fail at anytime, before such IO is
- * submitted to the underlying disks, hence don't record badblocks or retry
- * in this case.
+ * bio with REQ_RAHEAD can fail at anytime, before such IO is submitted to the
+ * underlying disks, hence don't record badblocks or retry in this case.
  *
  * BLK_STS_INVAL means the bio was not valid for the underlying device. This
  * is a user error, not a device failure, so retrying or recording bad blocks
@@ -300,6 +299,5 @@ static inline bool raid1_should_read_first(struct mddev *mddev,
  */
 static inline bool raid1_should_handle_error(struct bio *bio)
 {
-	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT)) &&
-		bio->bi_status != BLK_STS_INVAL;
+	return !(bio->bi_opf & REQ_RAHEAD) && bio->bi_status != BLK_STS_INVAL;
 }
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f322048ab3c2..a217c9e2d504 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1051,10 +1051,8 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
 	wake_up(&conf->wait_barrier);
 }
 
-static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
+static void _wait_barrier(struct r1conf *conf, int idx)
 {
-	bool ret = true;
-
 	/*
 	 * We need to increase conf->nr_pending[idx] very early here,
 	 * then raise_barrier() can be blocked when it waits for
@@ -1085,7 +1083,7 @@ static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
 	 */
 	if (!READ_ONCE(conf->array_frozen) &&
 	    !atomic_read(&conf->barrier[idx]))
-		return ret;
+		return;
 
 	/*
 	 * After holding conf->resync_lock, conf->nr_pending[idx]
@@ -1104,26 +1102,18 @@ static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
 	wake_up_barrier(conf);
 	/* Wait for the barrier in same barrier unit bucket to drop. */
 
-	/* Return false when nowait flag is set */
-	if (nowait) {
-		ret = false;
-	} else {
-		wait_event_lock_irq(conf->wait_barrier,
-				!conf->array_frozen &&
-				!atomic_read(&conf->barrier[idx]),
-				conf->resync_lock);
-		atomic_inc(&conf->nr_pending[idx]);
-	}
+	wait_event_lock_irq(conf->wait_barrier, !conf->array_frozen &&
+			    !atomic_read(&conf->barrier[idx]),
+			    conf->resync_lock);
 
+	atomic_inc(&conf->nr_pending[idx]);
 	atomic_dec(&conf->nr_waiting[idx]);
 	spin_unlock_irq(&conf->resync_lock);
-	return ret;
 }
 
-static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
+static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 {
 	int idx = sector_to_idx(sector_nr);
-	bool ret = true;
 
 	/*
 	 * Very similar to _wait_barrier(). The difference is, for read
@@ -1135,7 +1125,7 @@ static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowa
 	atomic_inc(&conf->nr_pending[idx]);
 
 	if (!READ_ONCE(conf->array_frozen))
-		return ret;
+		return;
 
 	spin_lock_irq(&conf->resync_lock);
 	atomic_inc(&conf->nr_waiting[idx]);
@@ -1147,27 +1137,19 @@ static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowa
 	wake_up_barrier(conf);
 	/* Wait for array to be unfrozen */
 
-	/* Return false when nowait flag is set */
-	if (nowait) {
-		/* Return false when nowait flag is set */
-		ret = false;
-	} else {
-		wait_event_lock_irq(conf->wait_barrier,
-				!conf->array_frozen,
-				conf->resync_lock);
-		atomic_inc(&conf->nr_pending[idx]);
-	}
+	wait_event_lock_irq(conf->wait_barrier, !conf->array_frozen,
+			    conf->resync_lock);
 
+	atomic_inc(&conf->nr_pending[idx]);
 	atomic_dec(&conf->nr_waiting[idx]);
 	spin_unlock_irq(&conf->resync_lock);
-	return ret;
 }
 
-static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
+static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
 {
 	int idx = sector_to_idx(sector_nr);
 
-	return _wait_barrier(conf, idx, nowait);
+	_wait_barrier(conf, idx);
 }
 
 static void _allow_barrier(struct r1conf *conf, int idx)
@@ -1342,7 +1324,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	int rdisk;
 	bool r1bio_existed = !!r1_bio;
-	bool nowait = bio->bi_opf & REQ_NOWAIT;
 
 	/*
 	 * An md cloned bio indicates we are in the error path.
@@ -1362,16 +1343,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 * Still need barrier for READ in case that whole
 	 * array is frozen.
 	 */
-	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
-		bio_wouldblock_error(bio);
-
-		if (r1bio_existed) {
-			set_bit(R1BIO_Returned, &r1_bio->state);
-			raid_end_bio_io(r1_bio);
-		}
-
-		return;
-	}
+	wait_read_barrier(conf, bio->bi_iter.bi_sector);
 
 	if (!r1_bio)
 		r1_bio = alloc_r1bio(mddev, bio);
@@ -1409,11 +1381,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		 * over-take any writes that are 'behind'
 		 */
 		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
-		if (!mddev->bitmap_ops->wait_behind_writes(mddev, nowait)) {
-			bio_wouldblock_error(bio);
-			set_bit(R1BIO_Returned, &r1_bio->state);
-			goto err_handle;
-		}
+		mddev->bitmap_ops->wait_behind_writes(mddev);
 	}
 
 	if (max_sectors < bio_sectors(bio)) {
@@ -1435,7 +1403,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	read_bio = bio_alloc_clone(mirror->rdev->bdev, bio, gfp,
 				   &mddev->bio_set);
-	read_bio->bi_opf &= ~REQ_NOWAIT;
 	r1_bio->bios[rdisk] = read_bio;
 
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
@@ -1454,7 +1421,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	raid_end_bio_io(r1_bio);
 }
 
-static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
+static void wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
 {
 	struct r1conf *conf = mddev->private;
 	int disks = conf->raid_disks * 2;
@@ -1474,9 +1441,6 @@ static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
 			set_bit(BlockedBadBlocks, &rdev->flags);
 
 		if (rdev_blocked(rdev)) {
-			if (bio->bi_opf & REQ_NOWAIT)
-				return false;
-
 			mddev_add_trace_msg(rdev->mddev, "raid1 wait rdev %d blocked",
 					    rdev->raid_disk);
 			atomic_inc(&rdev->nr_pending);
@@ -1484,8 +1448,6 @@ static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
 			goto retry;
 		}
 	}
-
-	return true;
 }
 
 static void raid1_start_write_behind(struct mddev *mddev, struct r1bio *r1_bio,
@@ -1521,7 +1483,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	unsigned long flags;
 	int first_clone;
 	bool write_behind = false;
-	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	bool atomic = bio->bi_opf & REQ_ATOMIC;
 	bool is_discard = op_is_discard(bio->bi_opf);
 	sector_t sector = bio->bi_iter.bi_sector;
@@ -1529,11 +1490,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (mddev_is_clustered(mddev) &&
 	    mddev->cluster_ops->area_resyncing(mddev, WRITE, sector,
 					       bio_end_sector(bio))) {
-
-		if (nowait) {
-			bio_wouldblock_error(bio);
-			return false;
-		}
 		wait_event_idle(conf->wait_barrier,
 				!mddev->cluster_ops->area_resyncing(mddev, WRITE,
 								    sector,
@@ -1545,15 +1501,9 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
 	 */
-	if (!wait_barrier(conf, sector, nowait)) {
-		bio_wouldblock_error(bio);
-		return false;
-	}
+	wait_barrier(conf, sector);
 
-	if (!wait_blocked_rdev(mddev, bio)) {
-		bio_wouldblock_error(bio);
-		goto err_allow_barrier;
-	}
+	wait_blocked_rdev(mddev, bio);
 
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_sectors;
@@ -1682,7 +1632,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 				wait_for_serialization(rdev, r1_bio);
 		}
 
-		mbio->bi_opf &= ~REQ_NOWAIT;
 		r1_bio->bios[i] = mbio;
 
 		mbio->bi_iter.bi_sector	= sector + rdev->data_offset;
@@ -1721,8 +1670,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	free_r1bio(r1_bio);
-
-err_allow_barrier:
 	allow_barrier(conf, sector);
 
 	return false;
@@ -1851,7 +1798,7 @@ static void close_sync(struct r1conf *conf)
 	int idx;
 
 	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
-		_wait_barrier(conf, idx, false);
+		_wait_barrier(conf, idx);
 		_allow_barrier(conf, idx);
 	}
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 01162c483644..c26507a79fbc 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1002,32 +1002,22 @@ static bool wait_barrier_nolock(struct r10conf *conf)
 	return false;
 }
 
-static bool wait_barrier(struct r10conf *conf, bool nowait)
+static void wait_barrier(struct r10conf *conf)
 {
-	bool ret = true;
-
 	if (wait_barrier_nolock(conf))
-		return true;
+		return;
 
 	write_seqlock_irq(&conf->resync_lock);
 	if (conf->barrier) {
-		/* Return false when nowait flag is set */
-		if (nowait) {
-			ret = false;
-		} else {
-			conf->nr_waiting++;
-			mddev_add_trace_msg(conf->mddev, "raid10 wait barrier");
-			wait_event_barrier(conf, stop_waiting_barrier(conf));
-			conf->nr_waiting--;
-		}
+		conf->nr_waiting++;
+		mddev_add_trace_msg(conf->mddev, "raid10 wait barrier");
+		wait_event_barrier(conf, stop_waiting_barrier(conf));
+		conf->nr_waiting--;
 		if (!conf->nr_waiting)
 			wake_up(&conf->wait_barrier);
 	}
-	/* Only increment nr_pending when we wait */
-	if (ret)
-		atomic_inc(&conf->nr_pending);
+	atomic_inc(&conf->nr_pending);
 	write_sequnlock_irq(&conf->resync_lock);
-	return ret;
 }
 
 static void allow_barrier(struct r10conf *conf)
@@ -1119,28 +1109,22 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
  * currently.
  * 2. If IO spans the reshape position.  Need to wait for reshape to pass.
  */
-static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
+static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 				 struct bio *bio, sector_t sectors)
 {
-	/* Bail out if REQ_NOWAIT is set for the bio */
-	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT))
-		return false;
+	wait_barrier(conf);
 
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
 	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
 		allow_barrier(conf);
-		if (bio->bi_opf & REQ_NOWAIT)
-			return false;
-
 		mddev_add_trace_msg(conf->mddev, "raid10 wait reshape");
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
 			   sectors);
-		wait_barrier(conf, false);
+		wait_barrier(conf);
 	}
-	return true;
 }
 
 static bool raid10_read_request(struct mddev *mddev, struct bio *bio,
@@ -1189,10 +1173,7 @@ static bool raid10_read_request(struct mddev *mddev, struct bio *bio,
 		}
 	}
 
-	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
-		bio_wouldblock_error(bio);
-		return false;
-	}
+	regular_request_wait(mddev, conf, bio, r10_bio->sectors);
 
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (!rdev) {
@@ -1213,7 +1194,7 @@ static bool raid10_read_request(struct mddev *mddev, struct bio *bio,
 		allow_barrier(conf);
 		bio = bio_submit_split_bioset(bio, max_sectors,
 					      &conf->bio_split);
-		wait_barrier(conf, false);
+		wait_barrier(conf);
 		if (!bio)
 			goto err_dec_pending;
 
@@ -1227,8 +1208,6 @@ static bool raid10_read_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->master_bio = bio;
 	}
 	read_bio = bio_alloc_clone(rdev->bdev, bio, gfp, &mddev->bio_set);
-	read_bio->bi_opf &= ~REQ_NOWAIT;
-
 	r10_bio->devs[slot].bio = read_bio;
 	r10_bio->devs[slot].rdev = rdev;
 
@@ -1267,7 +1246,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 			     conf->mirrors[devnum].rdev;
 
 	mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->bio_set);
-	mbio->bi_opf &= ~REQ_NOWAIT;
 	if (replacement)
 		r10_bio->devs[n_copy].repl_bio = mbio;
 	else
@@ -1346,7 +1324,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 			"raid10 %s wait rdev %d blocked",
 			__func__, blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf, false);
+		wait_barrier(conf);
 		goto retry_wait;
 	}
 }
@@ -1357,29 +1335,19 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	struct r10conf *conf = mddev->private;
 	int i, k;
 	int max_sectors = r10_bio->sectors;
-	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	bool atomic = bio->bi_opf & REQ_ATOMIC;
 
 	if ((mddev_is_clustered(mddev) &&
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
 						bio->bi_iter.bi_sector,
 						bio_end_sector(bio)))) {
-		/* Bail out if REQ_NOWAIT is set for the bio */
-		if (nowait) {
-			bio_wouldblock_error(bio);
-			return false;
-		}
-
 		wait_event_idle(conf->wait_barrier,
 				!mddev->cluster_ops->area_resyncing(mddev, WRITE,
 								    bio->bi_iter.bi_sector,
 								    bio_end_sector(bio)));
 	}
 
-	if (!regular_request_wait(mddev, conf, bio, max_sectors)) {
-		bio_wouldblock_error(bio);
-		return false;
-	}
+	regular_request_wait(mddev, conf, bio, max_sectors);
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    (mddev->reshape_backwards
@@ -1392,10 +1360,6 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		set_mask_bits(&mddev->sb_flags, 0,
 			      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
-		if (nowait) {
-			bio_wouldblock_error(bio);
-			goto err_allow_barrier;
-		}
 		mddev_add_trace_msg(conf->mddev,
 			"raid10 wait reshape metadata");
 		wait_event(mddev->sb_wait,
@@ -1626,11 +1590,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
-		bio_wouldblock_error(bio);
-		md_write_end(mddev);
-		return 0;
-	}
+	wait_barrier(conf);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking
@@ -1681,7 +1641,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		allow_barrier(conf);
 		/* Resend the fist split part */
 		submit_bio_noacct(split);
-		wait_barrier(conf, false);
+		wait_barrier(conf);
 	}
 	div_u64_rem(bio_end, stripe_size, &remainder);
 	if (remainder) {
@@ -1701,7 +1661,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		/* Resend the second split part */
 		submit_bio_noacct(bio);
 		bio = split;
-		wait_barrier(conf, false);
+		wait_barrier(conf);
 	}
 
 	bio_start = bio->bi_iter.bi_sector;
@@ -1859,7 +1819,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		end_disk_offset += geo->stride;
 		atomic_inc(&first_r10bio->remaining);
 		raid_end_discard_bio(r10_bio);
-		wait_barrier(conf, false);
+		wait_barrier(conf);
 		goto retry_discard;
 	}
 
@@ -2059,7 +2019,7 @@ static void print_conf(struct r10conf *conf)
 
 static void close_sync(struct r10conf *conf)
 {
-	wait_barrier(conf, false);
+	wait_barrier(conf);
 	allow_barrier(conf);
 
 	mempool_exit(&conf->r10buf_pool);
@@ -4694,7 +4654,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	if (need_flush ||
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Need to update reshape_position in metadata */
-		wait_barrier(conf, false);
+		wait_barrier(conf);
 		mddev->reshape_position = conf->reshape_progress;
 		if (mddev->reshape_backwards)
 			mddev->curr_resync_completed = raid10_size(mddev, 0, 0)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c5c9fb0606e..5171e221696a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5718,10 +5718,6 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	struct bio *orig_bi = bi;
 	int stripe_sectors;
 
-	/* We need to handle this when io_uring supports discard/trim */
-	if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
-		return;
-
 	if (mddev->reshape_position != MaxSector)
 		/* Skip discard while reshape is happening */
 		return;
@@ -6191,15 +6187,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	pr_debug("raid456: %s, logical %llu to %llu\n", __func__,
 		 bi->bi_iter.bi_sector, ctx->last_sector);
 
-	/* Bail out if conflicts with reshape and REQ_NOWAIT is set */
-	if ((bi->bi_opf & REQ_NOWAIT) &&
-	    get_reshape_loc(mddev, conf, logical_sector) == LOC_INSIDE_RESHAPE) {
-		bio_wouldblock_error(bi);
-		if (rw == WRITE)
-			md_write_end(mddev);
-		mempool_free(ctx, conf->ctx_pool);
-		return true;
-	}
 	md_account_bio(mddev, &bi);
 
 	/*
-- 
2.43.0

