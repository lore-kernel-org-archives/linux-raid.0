Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1971C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 06:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240010AbhLOGJ3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 01:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbhLOGJ1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 01:09:27 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C8BC061574
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 22:09:27 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id de30so19133445qkb.0
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 22:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R6I79aGYe8qy1vb1CqBMZ7hVCiE0GqaRh0eYWWnYTUU=;
        b=NAu3yX+7tCdINq0jkPDdwZ7TSsyf9X+UQ//TP49/BN1E0+Mer+rQlcRQH3PUpuv1j+
         o8MOmh/bTLPpanMqqr9GNQiMNwfrsTJHfyHl5peMOzJIe2aBnaETXelVlPYp0uut1/bV
         VeASC4tUtXJ+rUyb3Q1XSO1CsFimKS4u0mxfU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R6I79aGYe8qy1vb1CqBMZ7hVCiE0GqaRh0eYWWnYTUU=;
        b=P/zf7gthmvGOt1ovCOD0iMSg8gM9lUkNx4FrGJ2Cl/pwo7q3S1EpAO2oTN74nN1Ro1
         9fq+0CZfIf2JWAjicg1yRhz7pbSMv1Tw42YOo6ONCme2iQAHoOXTACWtA45+Cv2Qkt8U
         yWQV4HwShDbZsq0o8OjboEsUVmu4A9f02BefFB6DiOaxxtlXu7V1NZIJlWyq6uyesJ8+
         0kOQEw17KcIqKRZsTvDkFOsPb29U3hiuBAIWDRV6V8ls0H/2+6lNQcKLZEJW3gbPFZfj
         du2gMWSDyWqnwOvJLA6U3OHPiLYCUSM+h82CBtTVgVOZSg9IR3TQ0IHmZpmGVMHGIQuU
         1kog==
X-Gm-Message-State: AOAM533wgG2CLYrz8aaEHzog7fJ8bnDgajDBCWFd+JjqIrymE96+9P2n
        FD8yj6Qa79o1qmLPuTmKNkKFXA==
X-Google-Smtp-Source: ABdhPJz9WIGJ7mZWhzyPW9q4HUdpy76O6ij+9Ro7oufZkumxBeUuVb1xflxWlLVTc0rzbr7/kSb1hg==
X-Received: by 2002:ae9:f511:: with SMTP id o17mr7363790qkg.763.1639548566407;
        Tue, 14 Dec 2021 22:09:26 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id j16sm797254qtx.92.2021.12.14.22.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:09:26 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, rgoldwyn@suse.de,
        Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v5 2/4] md: raid1 add nowait support
Date:   Wed, 15 Dec 2021 06:09:04 +0000
Message-Id: <20211215060906.3230-2-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211215060906.3230-1-vverma@digitalocean.com>
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This adds nowait support to the RAID1 driver. It makes RAID1 driver
return with EAGAIN for situations where it could wait for eg:

- Waiting for the barrier,
- Array got frozen,
- Too many pending I/Os to be queued.

wait_barrier() fn is modified to return bool to support error for
wait barriers. It returns true in case of wait or if wait is not
required and returns false if wait was required but not performed
to support nowait.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/raid1.c | 74 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7dc8026cf6ee..727d31de5694 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -929,8 +929,9 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
 	wake_up(&conf->wait_barrier);
 }
 
-static void _wait_barrier(struct r1conf *conf, int idx)
+static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
 {
+	bool ret = true;
 	/*
 	 * We need to increase conf->nr_pending[idx] very early here,
 	 * then raise_barrier() can be blocked when it waits for
@@ -961,7 +962,7 @@ static void _wait_barrier(struct r1conf *conf, int idx)
 	 */
 	if (!READ_ONCE(conf->array_frozen) &&
 	    !atomic_read(&conf->barrier[idx]))
-		return;
+		return ret;
 
 	/*
 	 * After holding conf->resync_lock, conf->nr_pending[idx]
@@ -979,18 +980,27 @@ static void _wait_barrier(struct r1conf *conf, int idx)
 	 */
 	wake_up(&conf->wait_barrier);
 	/* Wait for the barrier in same barrier unit bucket to drop. */
-	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->array_frozen &&
-			     !atomic_read(&conf->barrier[idx]),
-			    conf->resync_lock);
+	if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
+		/* Return false when nowait flag is set */
+		if (nowait)
+			ret = false;
+		else {
+			wait_event_lock_irq(conf->wait_barrier,
+					!conf->array_frozen &&
+					!atomic_read(&conf->barrier[idx]),
+					conf->resync_lock);
+		}
+	}
 	atomic_inc(&conf->nr_pending[idx]);
 	atomic_dec(&conf->nr_waiting[idx]);
 	spin_unlock_irq(&conf->resync_lock);
+	return ret;
 }
 
-static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
+static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
 {
 	int idx = sector_to_idx(sector_nr);
+	bool ret = true;
 
 	/*
 	 * Very similar to _wait_barrier(). The difference is, for read
@@ -1002,7 +1012,7 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 	atomic_inc(&conf->nr_pending[idx]);
 
 	if (!READ_ONCE(conf->array_frozen))
-		return;
+		return ret;
 
 	spin_lock_irq(&conf->resync_lock);
 	atomic_inc(&conf->nr_waiting[idx]);
@@ -1013,19 +1023,27 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 	 */
 	wake_up(&conf->wait_barrier);
 	/* Wait for array to be unfrozen */
-	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->array_frozen,
-			    conf->resync_lock);
+	if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
+		if (nowait)
+			/* Return false when nowait flag is set */
+			ret = false;
+		else {
+			wait_event_lock_irq(conf->wait_barrier,
+					!conf->array_frozen,
+					conf->resync_lock);
+		}
+	}
 	atomic_inc(&conf->nr_pending[idx]);
 	atomic_dec(&conf->nr_waiting[idx]);
 	spin_unlock_irq(&conf->resync_lock);
+	return ret;
 }
 
-static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
+static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
 {
 	int idx = sector_to_idx(sector_nr);
 
-	_wait_barrier(conf, idx);
+	return _wait_barrier(conf, idx, nowait);
 }
 
 static void _allow_barrier(struct r1conf *conf, int idx)
@@ -1236,7 +1254,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 * Still need barrier for READ in case that whole
 	 * array is frozen.
 	 */
-	wait_read_barrier(conf, bio->bi_iter.bi_sector);
+	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
+				bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return;
+	}
 
 	if (!r1_bio)
 		r1_bio = alloc_r1bio(mddev, bio);
@@ -1336,6 +1358,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
 
 		DEFINE_WAIT(w);
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_IDLE);
@@ -1353,17 +1379,26 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
 	 */
-	wait_barrier(conf, bio->bi_iter.bi_sector);
+	if (!wait_barrier(conf, bio->bi_iter.bi_sector,
+				bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return;
+	}
 
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		raid1_log(mddev, "wait queued");
 		wait_event(conf->wait_barrier,
 			   conf->pending_count < max_queued_requests);
 	}
+
 	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
@@ -1458,9 +1493,14 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
 		r1_bio->state = 0;
 		allow_barrier(conf, bio->bi_iter.bi_sector);
+
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf, bio->bi_iter.bi_sector);
+		wait_barrier(conf, bio->bi_iter.bi_sector, false);
 		goto retry_write;
 	}
 
@@ -1687,7 +1727,7 @@ static void close_sync(struct r1conf *conf)
 	int idx;
 
 	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
-		_wait_barrier(conf, idx);
+		_wait_barrier(conf, idx, false);
 		_allow_barrier(conf, idx);
 	}
 
-- 
2.17.1

