Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A865CC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 21 Dec 2021 20:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhLUUGr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 15:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhLUUGq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Dec 2021 15:06:46 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2702EC061574
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 12:06:46 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id m25so13924562qtq.13
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 12:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ctJXq/+hwS9p/rFlUAxH7p/mCuxCcylcLsZlq7isL1s=;
        b=AG6zirS8xnSR2FTZ2p4vDXONKL8vSx3IYcV5JItVgagh47v4+J29sCs1Cz/0QR6zwG
         /4cZ9qCsYjy8k7KeXsrt3nyLELxG3rg2Qwn4SwMTFKij812VAqSkYfvsMi73ywR1S6ti
         NLj+G4xB7wM7rYvGRvr/pCOIc0r0mcN42N6R8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ctJXq/+hwS9p/rFlUAxH7p/mCuxCcylcLsZlq7isL1s=;
        b=tAvv9kaAAPBzO6hKo/BatF5O+MUwP2JEhRb1xIVK8Td3jqOOZM9juu9VhT36W6esrj
         MgSNhBWTO4aFziADkScKbftzdKJPtFgq5Juxzp5LKMqK1SVZSWKf9MqVXD/fPHKGnkA7
         DQpFj9vk+YqVQnSeZt5VAugssqtRnM3rHODCeN9bEOmwJMTtzSX0kQ4zIcUGMVJ4uJ26
         wIb3x4cLUcpPbozug6VA3dckDf14/758uFEC5MDgvWsygjD9ERQUXK16vWOvlHu9QOmT
         RWjbRYlATc4VieetKbF9t7PA+csBn+53lQbhocvai/1+oe/Wi6ANEhW49I/N4xzmOo5t
         eLZA==
X-Gm-Message-State: AOAM533wj1QNSF5WkPKY9FGI7FYY2L33VU+znEjjUXeqRmsK6x+YM/ji
        w5+j3c9kyBVGOobtgShQle262g==
X-Google-Smtp-Source: ABdhPJx9gZ1RE7QUAz7TUbzBZ8nHw1fArafn+TukFCMtf73dIMNFrof6VjpYe/S8KJJzE2etdZ1Lbg==
X-Received: by 2002:ac8:6985:: with SMTP id o5mr3649971qtq.346.1640117205204;
        Tue, 21 Dec 2021 12:06:45 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id o17sm17938018qtv.30.2021.12.21.12.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 12:06:44 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, rgoldwyn@suse.de,
        Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v6 3/4] md: raid10 add nowait support
Date:   Tue, 21 Dec 2021 20:06:21 +0000
Message-Id: <20211221200622.29795-3-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221200622.29795-1-vverma@digitalocean.com>
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This adds nowait support to the RAID10 driver. Very similar to
raid1 driver changes. It makes RAID10 driver return with EAGAIN
for situations where it could wait for eg:

  - Waiting for the barrier,
  - Too many pending I/Os to be queued,
  - Reshape operation,
  - Discard operation.

wait_barrier() and regular_request_wait() fn are modified to return bool
to support error for wait barriers. They returns true in case of wait
or if wait is not required and returns false if wait was required
but not performed to support nowait.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/raid10.c | 90 +++++++++++++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 28 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dde98f65bd04..7ceae00e863e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -952,8 +952,9 @@ static void lower_barrier(struct r10conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void wait_barrier(struct r10conf *conf)
+static bool wait_barrier(struct r10conf *conf, bool nowait)
 {
+	bool ret = true;
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		struct bio_list *bio_list = current->bio_list;
@@ -968,26 +969,33 @@ static void wait_barrier(struct r10conf *conf)
 		 * count down.
 		 */
 		raid10_log(conf->mddev, "wait barrier");
-		wait_event_lock_irq(conf->wait_barrier,
-				    !conf->barrier ||
-				    (atomic_read(&conf->nr_pending) &&
-				     bio_list &&
-				     (!bio_list_empty(&bio_list[0]) ||
-				      !bio_list_empty(&bio_list[1]))) ||
-				     /* move on if recovery thread is
-				      * blocked by us
-				      */
-				     (conf->mddev->thread->tsk == current &&
-				      test_bit(MD_RECOVERY_RUNNING,
-					       &conf->mddev->recovery) &&
-				      conf->nr_queued > 0),
-				    conf->resync_lock);
+		/* Return false when nowait flag is set */
+		if (nowait)
+			ret = false;
+		else
+			wait_event_lock_irq(conf->wait_barrier,
+					    !conf->barrier ||
+					    (atomic_read(&conf->nr_pending) &&
+					     bio_list &&
+					     (!bio_list_empty(&bio_list[0]) ||
+					      !bio_list_empty(&bio_list[1]))) ||
+					     /* move on if recovery thread is
+					      * blocked by us
+					      */
+					     (conf->mddev->thread->tsk == current &&
+					      test_bit(MD_RECOVERY_RUNNING,
+						       &conf->mddev->recovery) &&
+					      conf->nr_queued > 0),
+					    conf->resync_lock);
 		conf->nr_waiting--;
 		if (!conf->nr_waiting)
 			wake_up(&conf->wait_barrier);
 	}
-	atomic_inc(&conf->nr_pending);
+	/* Only increment nr_pending when we wait */
+	if (ret)
+		atomic_inc(&conf->nr_pending);
 	spin_unlock_irq(&conf->resync_lock);
+	return ret;
 }
 
 static void allow_barrier(struct r10conf *conf)
@@ -1098,21 +1106,30 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
  * currently.
  * 2. If IO spans the reshape position.  Need to wait for reshape to pass.
  */
-static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
+static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 				 struct bio *bio, sector_t sectors)
 {
-	wait_barrier(conf);
+	/* Bail out if REQ_NOWAIT is set for the bio */
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return false;
+	}
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
 	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
 		raid10_log(conf->mddev, "wait reshape");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return false;
+		}
 		allow_barrier(conf);
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
 			   sectors);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
+	return true;
 }
 
 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
@@ -1179,7 +1196,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		bio = split;
 		r10_bio->master_bio = bio;
 		r10_bio->sectors = max_sectors;
@@ -1338,7 +1355,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 		raid10_log(conf->mddev, "%s wait rdev %d blocked",
 				__func__, blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		goto retry_wait;
 	}
 }
@@ -1356,6 +1373,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 					    bio->bi_iter.bi_sector,
 					    bio_end_sector(bio)))) {
 		DEFINE_WAIT(w);
+		/* Bail out if REQ_NOWAIT is set for the bio */
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_IDLE);
@@ -1381,6 +1403,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
 		raid10_log(conf->mddev, "wait reshape metadata");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
@@ -1390,6 +1416,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
 		raid10_log(mddev, "wait queued");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		wait_event(conf->wait_barrier,
 			   conf->pending_count < max_queued_requests);
 	}
@@ -1482,7 +1512,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		bio = split;
 		r10_bio->master_bio = bio;
 	}
@@ -1607,7 +1637,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	wait_barrier(conf);
+	if (bio->bi_opf & REQ_NOWAIT) {
+		bio_wouldblock_error(bio);
+		return 0;
+	}
+	wait_barrier(conf, false);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking
@@ -1649,7 +1683,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		allow_barrier(conf);
 		/* Resend the fist split part */
 		submit_bio_noacct(split);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 	div_u64_rem(bio_end, stripe_size, &remainder);
 	if (remainder) {
@@ -1660,7 +1694,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		/* Resend the second split part */
 		submit_bio_noacct(bio);
 		bio = split;
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 
 	bio_start = bio->bi_iter.bi_sector;
@@ -1816,7 +1850,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		end_disk_offset += geo->stride;
 		atomic_inc(&first_r10bio->remaining);
 		raid_end_discard_bio(r10_bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		goto retry_discard;
 	}
 
@@ -2011,7 +2045,7 @@ static void print_conf(struct r10conf *conf)
 
 static void close_sync(struct r10conf *conf)
 {
-	wait_barrier(conf);
+	wait_barrier(conf, false);
 	allow_barrier(conf);
 
 	mempool_exit(&conf->r10buf_pool);
@@ -4819,7 +4853,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	if (need_flush ||
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Need to update reshape_position in metadata */
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		mddev->reshape_position = conf->reshape_progress;
 		if (mddev->reshape_backwards)
 			mddev->curr_resync_completed = raid10_size(mddev, 0, 0)
-- 
2.17.1

