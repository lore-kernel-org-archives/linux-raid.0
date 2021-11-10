Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D1BC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 18:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 756AF6103C
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 18:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhKJSRw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Nov 2021 13:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhKJSRv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Nov 2021 13:17:51 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372D6C061764
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 10:15:04 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id w15so3454464ill.2
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 10:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2nGM7GUO1EluoeMwaTeWBWJwFE/iceh1q41+8bOPAo4=;
        b=L0E+fDIzUTdva+Q1NMduLbpjVnhDnRxDlYu/zYTEnyE7bueFQDBz4IX0nMrOJiI39R
         iOqVyygs6i1HiyKhr6H57WCwSHj3XeZ18H+giSjyOIwNMQmK2SI0xbWZd0YMHT8WBOmV
         WVEphpW6q1fVOelEQUTph0HSljBm7fxM6WfsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2nGM7GUO1EluoeMwaTeWBWJwFE/iceh1q41+8bOPAo4=;
        b=7I9vnaEEMpVjhTnsyOMN45FCyTPhKpGsvsW+PpP+7cvateO9JK1FBXRlxZXWmDbkKP
         gEEMB9xv7SZPfCEZTHOvbievwfH6G0YS2cWs/dAPFdT9UIuAF2icxJ4DJkwT3+I/6bei
         FS6KPaB/inbicnvcRwqPKRdhDqhW/h8TBvy0Boo9lSsXV1mAETZaOP6s2NNjG9ejaiDN
         tQOkhyM1WZolyVCMBwDevXClEa626/W9pLLR7YifmK7ZXjvU7eHrkDZ3/jBdA+sxZAr2
         hILjD9DMMGr753jjV0qIcWBvOYDlT5JjBwQZYplmN45UK9omnQN19oixA6vmV0P64vRc
         lKuQ==
X-Gm-Message-State: AOAM530rfFnNitgCYzSNy0k/7lKmHVHDCoA7MftnzwNsOCJ78xLlL20Q
        43GRgU1VsU4vZHEIBtEu7J4lkw==
X-Google-Smtp-Source: ABdhPJzsDmaF1iIXaWfEYsd0mN8MVil/d+6iXep21B5c7h8nu4b4KhaZsfdxmGV0SI+nb8QRcw6c6g==
X-Received: by 2002:a92:d03:: with SMTP id 3mr661779iln.216.1636568103565;
        Wed, 10 Nov 2021 10:15:03 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id l18sm268385iob.17.2021.11.10.10.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 10:15:03 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk, Vishal Verma <vverma@digitalocean.com>
Subject: [RFC PATCH v4 2/4] md: raid1 add nowait support
Date:   Wed, 10 Nov 2021 18:14:39 +0000
Message-Id: <20211110181441.9263-2-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110181441.9263-1-vverma@digitalocean.com>
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
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

