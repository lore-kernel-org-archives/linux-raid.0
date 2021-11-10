Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C348DC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 18:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5FB61106
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 18:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhKJSR4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Nov 2021 13:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhKJSRy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Nov 2021 13:17:54 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE38C061764
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 10:15:06 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id w15so3454566ill.2
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 10:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YcEtW47xHjsz2FV/Su5MVVGPcxQ8j3/Nm2C50UdoOXs=;
        b=IFqQZ2AJgTencBKLeJFjnfd4bxZtTaTtYD2pSckkQeD6vSiiZZZPix/B8W4ugdS/TC
         4lO9SNt/m+12/9AbOjSYTsPdWOVQhKHK03mHtJt5KQeELc9fvdk9j9J7W0LGHxggGt0L
         ThPN7sfewHPaODz42/ri9Jg8lVCc9weSHo3yI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YcEtW47xHjsz2FV/Su5MVVGPcxQ8j3/Nm2C50UdoOXs=;
        b=pLOqlKeGP0ZzMSwvH3ec3xPbmJe+Ho3YZH0jTrLAgI1KjAAYH3eJSR4VS9Dnkg1CZ8
         IyfLiBh1yC+v06IZoAb4QLDLDT+A9dA63m01+OZmU8gLqpP58Q4XSsGA3hftD4Ddy/TG
         +1tK2gkeiFFC7ufGrM4JgirzlappqO1lvmkkQR+WNBwbhMY0i4MjpP1089NllC75Fmja
         2hRWUEj1aln5wbtaEA/J5c5aVtORKylNijd90wdjY5sVJjBAhwTOz7g58PtSihnRqfaW
         i3pA1y+VOHjTDSbC1YEUtdM4FSw487jiuEL9XQrGZCAgEQCdfjHivIjTB+wDKvfalZjC
         KefQ==
X-Gm-Message-State: AOAM5328ylIBVCr5c5IJnVRzU+GUPD1y3aQ8l8RXFbhZtvnINSm5tk+z
        TzC9h2ZQLcFyDe15aKEIJ/ev9A==
X-Google-Smtp-Source: ABdhPJxkZtMptYRWAK3nAcM+WE2nWShFzEs56XfLEt5t74JahE9ilTEW984VjVDGWSM3iLDMrFX+IA==
X-Received: by 2002:a92:d081:: with SMTP id h1mr633269ilh.7.1636568105854;
        Wed, 10 Nov 2021 10:15:05 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id c22sm277090ioz.15.2021.11.10.10.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 10:15:05 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk, Vishal Verma <vverma@digitalocean.com>
Subject: [RFC PATCH v4 3/4] md: raid10 add nowait support
Date:   Wed, 10 Nov 2021 18:14:40 +0000
Message-Id: <20211110181441.9263-3-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110181441.9263-1-vverma@digitalocean.com>
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
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

wait_barrier() fn is modified to return bool to support error for
wait barriers. It returns true in case of wait or if wait is not
required and returns false if wait was required but not performed
to support nowait.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/raid10.c | 87 +++++++++++++++++++++++++++++++--------------
 1 file changed, 60 insertions(+), 27 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dde98f65bd04..03983146d31a 100644
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
@@ -1101,17 +1109,25 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 				 struct bio *bio, sector_t sectors)
 {
-	wait_barrier(conf);
+	/* Bail out if REQ_NOWAIT is set for the bio */
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return;
+	}
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
 	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
 		raid10_log(conf->mddev, "wait reshape");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		allow_barrier(conf);
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
 			   sectors);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 }
 
@@ -1179,7 +1195,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		bio = split;
 		r10_bio->master_bio = bio;
 		r10_bio->sectors = max_sectors;
@@ -1338,7 +1354,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 		raid10_log(conf->mddev, "%s wait rdev %d blocked",
 				__func__, blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		goto retry_wait;
 	}
 }
@@ -1357,6 +1373,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 					    bio_end_sector(bio)))) {
 		DEFINE_WAIT(w);
 		for (;;) {
+			/* Bail out if REQ_NOWAIT is set for the bio */
+			if (bio->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bio);
+				return;
+			}
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_IDLE);
 			if (!md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1381,6 +1402,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
 		raid10_log(conf->mddev, "wait reshape metadata");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
@@ -1390,6 +1415,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1482,7 +1511,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		bio = split;
 		r10_bio->master_bio = bio;
 	}
@@ -1607,7 +1636,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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
@@ -1649,7 +1682,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		allow_barrier(conf);
 		/* Resend the fist split part */
 		submit_bio_noacct(split);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 	div_u64_rem(bio_end, stripe_size, &remainder);
 	if (remainder) {
@@ -1660,7 +1693,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		/* Resend the second split part */
 		submit_bio_noacct(bio);
 		bio = split;
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 
 	bio_start = bio->bi_iter.bi_sector;
@@ -1816,7 +1849,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		end_disk_offset += geo->stride;
 		atomic_inc(&first_r10bio->remaining);
 		raid_end_discard_bio(r10_bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		goto retry_discard;
 	}
 
@@ -2011,7 +2044,7 @@ static void print_conf(struct r10conf *conf)
 
 static void close_sync(struct r10conf *conf)
 {
-	wait_barrier(conf);
+	wait_barrier(conf, false);
 	allow_barrier(conf);
 
 	mempool_exit(&conf->r10buf_pool);
@@ -4819,7 +4852,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
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

