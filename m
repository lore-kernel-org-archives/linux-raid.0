Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1EEC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 21 Dec 2021 20:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhLUUGo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 15:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhLUUGn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Dec 2021 15:06:43 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BDFC061574
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 12:06:43 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id a1so13919952qtx.11
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 12:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3jH/tg/Anrf85/Y0XcyO0fEpawXIgKcwlWa/WiEW19o=;
        b=O2PGHQMq/fp6x9zL159G4ID3p/YOFThASl3JwlHGXci++oW2YAo2dOB3R7t0QuYMxY
         DcKJRp/J5ipFGw8XfbEIHoLLZWBsa8dOeQtErnoHF6x1I7vMLH9bYDUCNQc0edmvWcyC
         co+ZuheX+sbOYlI0dDRjcSm5JpV5yE/2NpiY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3jH/tg/Anrf85/Y0XcyO0fEpawXIgKcwlWa/WiEW19o=;
        b=h/1ChyKd/wjiWyB4hCMfpSPjK2/7QmwvpKXZMScEmIWYzfLjbDLHUIteI7vCWlrC5p
         odwIfD4rRK1ODYAaK4xvLRC8QWb9kg2PdC/DE06vrRZiJh/PHM0HKGIIOWT3t+mL38y/
         YMAE8Ks9vNfMnfzIsMOI7tWx9PzX/OT3VVTuHUavIA3TzHhNJPgVko1Fk2qkPmARzsYs
         Dg98SJrSgJmOajXxZPXnceUJ+WaUYVW0oqenFE5sC8ZLpLL6yd6rIh5lg1nkBtFGGWRn
         zqCA8SuY3YEy8efWQekwzH2ohNkEabw+96j7wBXfRAeVNm00n+C076TD2pdPnyMPPAeq
         zOpA==
X-Gm-Message-State: AOAM532DIqXpl21yv4N5jll4dwsxs6k132/NxcSYOGK67F703r9kDccH
        Hd6fmo3qtrtalY+TeIjP+zHxQQ==
X-Google-Smtp-Source: ABdhPJwTb/jnagBf5wTTlla53p41bAjf/ykXnjMlkGDLZ7xbRjvaw1isEJLXduXYbusRkKypCo0abQ==
X-Received: by 2002:a05:622a:c:: with SMTP id x12mr3745744qtw.502.1640117202698;
        Tue, 21 Dec 2021 12:06:42 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id v12sm18283115qtx.80.2021.12.21.12.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 12:06:42 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, rgoldwyn@suse.de,
        Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v6 2/4] md: raid1 add nowait support
Date:   Tue, 21 Dec 2021 20:06:20 +0000
Message-Id: <20211221200622.29795-2-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221200622.29795-1-vverma@digitalocean.com>
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This adds nowait support to the RAID1 driver. It makes RAID1 driver
return with EAGAIN for situations where it could wait for eg:

  - Waiting for the barrier,
  - Too many pending I/Os to be queued.

wait_barrier() fn is modified to return bool to support error for
wait barriers. It returns true in case of wait or if wait is not
required and returns false if wait was required but not performed
to support nowait.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/raid1.c | 83 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7dc8026cf6ee..e488671bb563 100644
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
@@ -979,18 +980,29 @@ static void _wait_barrier(struct r1conf *conf, int idx)
 	 */
 	wake_up(&conf->wait_barrier);
 	/* Wait for the barrier in same barrier unit bucket to drop. */
-	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->array_frozen &&
-			     !atomic_read(&conf->barrier[idx]),
-			    conf->resync_lock);
-	atomic_inc(&conf->nr_pending[idx]);
+
+	/* Return false when nowait flag is set */
+	if (nowait)
+		ret = false;
+	else {
+		wait_event_lock_irq(conf->wait_barrier,
+				!conf->array_frozen &&
+				!atomic_read(&conf->barrier[idx]),
+				conf->resync_lock);
+	}
+
+	/* Only increment nr_pending when we wait */
+	if (ret)
+		atomic_inc(&conf->nr_pending[idx]);
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
@@ -1002,7 +1014,7 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 	atomic_inc(&conf->nr_pending[idx]);
 
 	if (!READ_ONCE(conf->array_frozen))
-		return;
+		return ret;
 
 	spin_lock_irq(&conf->resync_lock);
 	atomic_inc(&conf->nr_waiting[idx]);
@@ -1013,19 +1025,30 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 	 */
 	wake_up(&conf->wait_barrier);
 	/* Wait for array to be unfrozen */
-	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->array_frozen,
-			    conf->resync_lock);
-	atomic_inc(&conf->nr_pending[idx]);
+
+	/* Return false when nowait flag is set */
+	if (nowait)
+		/* Return false when nowait flag is set */
+		ret = false;
+	else {
+		wait_event_lock_irq(conf->wait_barrier,
+				!conf->array_frozen,
+				conf->resync_lock);
+	}
+
+	/* Only increment nr_pending when we wait */
+	if (ret)
+		atomic_inc(&conf->nr_pending[idx]);
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
@@ -1236,7 +1259,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
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
@@ -1336,6 +1363,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
 
 		DEFINE_WAIT(w);
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_IDLE);
@@ -1353,17 +1384,26 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1458,9 +1498,14 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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
 
@@ -1687,7 +1732,7 @@ static void close_sync(struct r1conf *conf)
 	int idx;
 
 	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
-		_wait_barrier(conf, idx);
+		_wait_barrier(conf, idx, false);
 		_allow_barrier(conf, idx);
 	}
 
-- 
2.17.1

