Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0939C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 06:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbhLOGJb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 01:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbhLOGJa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 01:09:30 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4BCC061574
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 22:09:30 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 132so19060234qkj.11
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 22:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T2g+ppyIRgyLKxPTN3VkjmewZw/KNWoZtXVWPiOw0IU=;
        b=fZPCLU/MXEB+v+OE6Gs0RYOn7UeQlVE+it+341Jec6cz8/NixPBR7VBHykwTQrdT5l
         AIIZEAOIiGyxjzuDDslDFgu8DbcM61WRbmfnYg9Ilmu3DhlWkF39o8+KHCnwQT+BEHxZ
         T0NmKPeB8DrFhlu4xtvGUutiZhkdyB161Xggw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T2g+ppyIRgyLKxPTN3VkjmewZw/KNWoZtXVWPiOw0IU=;
        b=lfzsQPnq2xQMgAHr8ueltd0n8Ti8DvCL3BNEUejmFVCmCDPDEPHIuO9CEnanp/xfj5
         TdWn6YnhUw+A70xn59mQnSrJ/Jwy9tr0FSYlS1hhYA7xZIyFaP0l6w1QTGgmuPFfS4eS
         UV8rV+pFDHxsbjvE+oXLLJjy1iEX8MtBa6ewiTjVYqyBvvln4aNcw82/GGeIohrn3Lf5
         McrCn47IfTkLG6YBoO7ZLnFMJbFlEFytNrxJjZE5heAQbdFAXCVU8uCqpkGPhTZBn4AI
         QZxBWK0PW8eYScc94tL7w/5Ief2Aw0ptcapiGtczXig5Al8aiZp5a4wVUKB3cd+QJF8c
         sZpw==
X-Gm-Message-State: AOAM5337PXEfBCJSffSNnpC93Ym/JJiq6/uZhsKcRSRuryoJwIL46bQS
        YPlPWiym6Iqpo4OrIzKmgassRw==
X-Google-Smtp-Source: ABdhPJyE10FnJSt3g5X+IvH0nZA+CAFxThyYXsDqaADqUFj9SUJLd+ovyBbffSbSItVIrRWJaZxBhA==
X-Received: by 2002:a05:620a:752:: with SMTP id i18mr7590966qki.453.1639548569557;
        Tue, 14 Dec 2021 22:09:29 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id o126sm579664qke.11.2021.12.14.22.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:09:29 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, rgoldwyn@suse.de,
        Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v5 3/4] md: raid10 add nowait support
Date:   Wed, 15 Dec 2021 06:09:05 +0000
Message-Id: <20211215060906.3230-3-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211215060906.3230-1-vverma@digitalocean.com>
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com>
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
 drivers/md/raid10.c | 57 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dde98f65bd04..f6c73987e9ac 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -952,11 +952,18 @@ static void lower_barrier(struct r10conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void wait_barrier(struct r10conf *conf)
+static bool wait_barrier(struct r10conf *conf, bool nowait)
 {
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		struct bio_list *bio_list = current->bio_list;
+
+		/* Return false when nowait flag is set */
+		if (nowait) {
+			spin_unlock_irq(&conf->resync_lock);
+			return false;
+		}
+
 		conf->nr_waiting++;
 		/* Wait for the barrier to drop.
 		 * However if there are already pending
@@ -988,6 +995,7 @@ static void wait_barrier(struct r10conf *conf)
 	}
 	atomic_inc(&conf->nr_pending);
 	spin_unlock_irq(&conf->resync_lock);
+	return true;
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

