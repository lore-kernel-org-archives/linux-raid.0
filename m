Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0875313E24
	for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 18:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781375310; cv=none; b=cthWW7Uvcj8Iyn3jvjw1j36Uo9DC2UN1hUt1JzCOC4lDJS2hzinR3IiSPSY3fpcT5wweuTpD+i/zDXtzfKyuCMjykgECzrXnMuNnc24PLT7QdwAfzE1y7u+qB0Q/XkliX5rUW01N5NCcZ0cnbrxW8T4WLSd/lf4894PGS5H6JxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781375310; c=relaxed/simple;
	bh=H6xEHOv2A3X5t6F2c677VKkcIm5PxpOYu/wf+3EP4Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+bXXdB/a9keDA86f+Lj5cYecnonr15wDTVUfFQXP7BSAc0TDyjAIklfB9FfW4k/Stqa1WYmRxJF0tuP9kw4c+6KzujWYoYqHuG8Jf0jXoLW39zSbuTBvc5FrfNRvse6AksbP/FubrNCbbQR20xtXTagOwgKIqn1yGjpMEwzEpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pTNNJ01E; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pTNNJ01E"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45eedcdaeaaso1324158f8f.3
        for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 11:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781375307; x=1781980107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oykH226daU1dmEgW6apfw5s9xG7KAd0jfisG7uN7peU=;
        b=pTNNJ01EDMb+GExOi8dgIPqWFf0zjx2fcliBtUjUj7sXkUqIK6X6WjXlYteSRx6PE8
         Bsegi3uYMakYlMBZlgs0GfNRS02YMN+eaOgZPcmqCQXzR/8lm5PFieJtITLhIVD3lsIy
         Sg17RCU5bZtOomq/ltUVtrPU85hrH+YcMUNN5/K7fpkpatbQeyU7gBQbVpQNDy4pe4re
         DaCHIKcOWCqkgIsgPTgs6KW1A6YReuvC57iDJ739DfU/abJ9Ugb8sBLcFk6IHcEYV4Ue
         fCl6Em8b1+vkdZKAsgYRmmZLIbTVBeVPfKGWivRJG04G2nZQvfbZeGTO4b/yQszkAzb+
         9pHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781375307; x=1781980107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oykH226daU1dmEgW6apfw5s9xG7KAd0jfisG7uN7peU=;
        b=bnUwLYOR9eSEbNAB1GpBOefzpvxmB2F27FucgRc9+t6JbDIEU64TlrCIRICufYIttu
         XurFHCxXBV8lrXhMQO4qQXZbj+C9G6RQPAPgJTWggtpIaB/efCeT7YaS9NTY7EBKn9aH
         8AtZQLtlUGcOr7OWgHKkjO1SyrXCR4u+1t5AD4F7nHusyYB4vbG1MpQJ6GjJ9Z9KJfxo
         eC7AR6jUQJ7qdZAfWchkzFc7JNxnUehR1MhnkA/ebzRbtkf5raOVKDWoGgpnbonwDli7
         HMH/BiyCgF1LQDyCcfnqmjapzbT3Zy9k6kkWcGhHOq8eun/KeYY+fyJF8A4HbGXl8IVo
         hkqw==
X-Gm-Message-State: AOJu0Yyl808vhobCqL4qoKB5yfzbM5mz1tdSgjBbVpWYC+FhFzWXukmr
	6cnfd97oMpIPOUl9gmEwO38GZrJ2S8bBXqX6a613VbdjlUsY7fxCgsSi
X-Gm-Gg: Acq92OER9BQRvNZDec9jlB7UQh0Dkm5Y3Ezx9E2GJ31CW6ujOefCmxvue+ZHCbQwZym
	O1qHg75bxlOpfw9ufxfnQnF1jFJxeGwrMOiVCwF0GWGC06a0jLj3UYtCsFug+uBDWgZBcF31ca0
	bPyPrsNla7WrygmLOwXwKnVBarxa6D6Hx17I/GgD7gfPqmv3JHg0ulSA1vrJ5/YbyNS8WW++QIQ
	i7VRhU5AC6Oq7GeWpnU48T9kkrQFHZfY2MAOnIXw90+29f4dLRjpUKq0FSyiu9zx/Va3eBnSJi/
	PJLl0JqB6/tbB5mCYfV7nD7Ps+6jxAUEmwDJlk5vsVU4yATv+MoSU6jPdRdNvbILjUCdGIcIavY
	hK22hK/rVy40oi65kPItfQq5xCg7H6E1r3Xh9258jXyBs/RoqSxEz6/Wh+SjOYUp9ytPAFX003y
	0jAoJ+cRgkIQikBo8dv/VAOBrjZHpirufy6NyRJMLThqAJf5spg7uamNLuwwQeqcB05YTM5I5Aa
	svqrkwkveGZZw==
X-Received: by 2002:a05:6000:2dc2:b0:460:30bd:4dca with SMTP id ffacd0b85a97d-4606dba0652mr9981669f8f.30.1781375307241;
        Sat, 13 Jun 2026 11:28:27 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-197-181.176.7.pool.telefonica.de. [176.7.197.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c3782sm15353944f8f.25.2026.06.13.11.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 11:28:26 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	hare@suse.de,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	vverma@digitalocean.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2 4/4] md/raid1: simplify raid1_write_request() error handling
Date: Sat, 13 Jun 2026 18:28:10 +0000
Message-ID: <20260613182810.1317258-5-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260613182810.1317258-1-abd.masalkhi@gmail.com>
References: <20260613182810.1317258-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid1_write_request() increments rdev->nr_pending before checking the
badblocks and then immediately decrements it again when a device is
skipped. Move the increment until after the checks succeed so the
reference accounting is easier to follow.

Consolidate the failure paths so that each error label releases exactly
the resources acquired up to that point. err_dec_pending drops pending
references and frees the r1bio, while err_allow_barrier handles the
barrier release before returning.

When a REQ_ATOMIC write cannot be satisfied due to a badblock range,
complete the bio with BLK_STS_NOTSUPP rather than reporting an I/O
error, since the operation is unsupported rather than having failed
during I/O.

Rename max_write_sectors to max_sectors and remove the redundant local
copy.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - new patch, depends on patch 1.
---
 drivers/md/raid1.c | 59 +++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0e1c7125972..dc0b7b8bc2f8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1502,29 +1502,29 @@ static void raid1_start_write_behind(struct mddev *mddev, struct r1bio *r1_bio,
 }
 
 static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
-				int max_write_sectors)
+				int max_sectors)
 {
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
 	int i, disks, k;
 	unsigned long flags;
 	int first_clone;
-	int max_sectors;
 	bool write_behind = false;
-	bool is_discard = (bio_op(bio) == REQ_OP_DISCARD);
+	bool nowait = bio->bi_opf & REQ_NOWAIT;
+	bool is_discard = op_is_discard(bio->bi_opf);
 	sector_t sector = bio->bi_iter.bi_sector;
 
 	if (mddev_is_clustered(mddev) &&
-	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
-		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
+	    mddev->cluster_ops->area_resyncing(mddev, WRITE, sector,
+					       bio_end_sector(bio))) {
 
-		if (bio->bi_opf & REQ_NOWAIT) {
+		if (nowait) {
 			bio_wouldblock_error(bio);
 			return false;
 		}
 		wait_event_idle(conf->wait_barrier,
 				!mddev->cluster_ops->area_resyncing(mddev, WRITE,
-								    bio->bi_iter.bi_sector,
+								    sector,
 								    bio_end_sector(bio)));
 	}
 
@@ -1533,20 +1533,18 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
 	 */
-	if (!wait_barrier(conf, bio->bi_iter.bi_sector,
-				bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_barrier(conf, sector, nowait)) {
 		bio_wouldblock_error(bio);
 		return false;
 	}
 
 	if (!wait_blocked_rdev(mddev, bio)) {
 		bio_wouldblock_error(bio);
-		allow_barrier(conf, sector);
-		return false;
+		goto err_allow_barrier;
 	}
 
 	r1_bio = alloc_r1bio(mddev, bio);
-	r1_bio->sectors = max_write_sectors;
+	r1_bio->sectors = max_sectors;
 
 	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
@@ -1560,7 +1558,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
-	max_sectors = r1_bio->sectors;
 	for (i = 0;  i < disks; i++) {
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
 
@@ -1576,23 +1573,21 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		if (!rdev || test_bit(Faulty, &rdev->flags))
 			continue;
 
-		atomic_inc(&rdev->nr_pending);
 		if (test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			sector_t bad_sectors;
 			int is_bad;
 
-			is_bad = is_badblock(rdev, r1_bio->sector, max_sectors,
+			is_bad = is_badblock(rdev, sector, max_sectors,
 					     &first_bad, &bad_sectors);
-			if (is_bad && first_bad <= r1_bio->sector) {
+			if (is_bad && first_bad <= sector) {
 				/* Cannot write here at all */
-				bad_sectors -= (r1_bio->sector - first_bad);
+				bad_sectors -= (sector - first_bad);
 				if (bad_sectors < max_sectors)
 					/* mustn't write more than bad_sectors
 					 * to other devices yet
 					 */
 					max_sectors = bad_sectors;
-				rdev_dec_pending(rdev, mddev);
 				continue;
 			}
 			if (is_bad) {
@@ -1606,15 +1601,18 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 				 * the benefit.
 				 */
 				if (bio->bi_opf & REQ_ATOMIC) {
-					rdev_dec_pending(rdev, mddev);
-					goto err_handle;
+					bio->bi_status = BLK_STS_NOTSUPP;
+					bio_endio(bio);
+					goto err_dec_pending;
 				}
 
-				good_sectors = first_bad - r1_bio->sector;
+				good_sectors = first_bad - sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
 		}
+
+		atomic_inc(&rdev->nr_pending);
 		r1_bio->bios[i] = bio;
 	}
 
@@ -1630,10 +1628,8 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		bio = bio_submit_split_bioset(bio, max_sectors,
 					      &conf->bio_split);
-		if (!bio) {
-			set_bit(R1BIO_Returned, &r1_bio->state);
-			goto err_handle;
-		}
+		if (!bio)
+			goto err_dec_pending;
 
 		r1_bio->master_bio = bio;
 		r1_bio->sectors = max_sectors;
@@ -1677,7 +1673,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		mbio->bi_opf &= ~REQ_NOWAIT;
 		r1_bio->bios[i] = mbio;
 
-		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
+		mbio->bi_iter.bi_sector	= sector + rdev->data_offset;
 		mbio->bi_end_io	= raid1_end_write_request;
 		if (test_bit(FailFast, &rdev->flags) &&
 		    !test_bit(WriteMostly, &rdev->flags) &&
@@ -1686,7 +1682,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
-		mddev_trace_remap(mddev, mbio, r1_bio->sector);
+		mddev_trace_remap(mddev, mbio, sector);
 		/* flush_pending_writes() needs access to the rdev so...*/
 		mbio->bi_bdev = (void *)rdev;
 		if (!raid1_add_bio_to_plug(mddev, mbio, raid1_unplug, disks)) {
@@ -1701,9 +1697,10 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
+
 	return true;
 
-err_handle:
+err_dec_pending:
 	for (k = 0; k < i; k++) {
 		if (r1_bio->bios[k]) {
 			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
@@ -1711,7 +1708,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		}
 	}
 
-	raid_end_bio_io(r1_bio);
+	free_r1bio(r1_bio);
+
+err_allow_barrier:
+	allow_barrier(conf, sector);
+
 	return false;
 }
 
-- 
2.43.0

