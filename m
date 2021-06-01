Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3E8C47080
	for <linux-raid@archiver.kernel.org>; Tue,  1 Jun 2021 01:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9E1F61003
	for <linux-raid@archiver.kernel.org>; Tue,  1 Jun 2021 01:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhFABXD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 May 2021 21:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbhFABXB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 May 2021 21:23:01 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6C9C061574
        for <linux-raid@vger.kernel.org>; Mon, 31 May 2021 18:21:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 69so6008046plc.5
        for <linux-raid@vger.kernel.org>; Mon, 31 May 2021 18:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VPac+kzo+dJbQk/cdJxk0VW7vvjtvfDZ4u54YgriTh8=;
        b=agar4Fz9EEUiZ7PltrKCwmXhMZE0/1Q7C7g88tABRmg9GBcC196rTcFdkFFJ7rlGve
         ze7AjOtktK4zbOXFJ6qcW1UzpjCLuPoSJRX1Z5bgVadtfgBhAdpRrORevGFX4Q1/0+HG
         O/awk3G+fI+AxyC/WfhuAhpP066XeEeFZJNKTyy8xmPWaXAZJ9uIQyUXoSQUz4Tfxgl6
         +GMpdFrVIFjIfE6psbFDh2VWqrNqr3RIWAlGFbdvU/o3b7EpLjGrhIhXeKxidwF8YGSL
         5LhuKVNAgMy0ARyZ2sal3tnQokQ+BtEorHLq6/WHU2XplsPMDguRazQtA+loimTG76HB
         VYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VPac+kzo+dJbQk/cdJxk0VW7vvjtvfDZ4u54YgriTh8=;
        b=YjnIPQhJwwmPwZqyLCum4i+OFULluXGmTxO0cXXGPpxxGPQIFdVfRJ3bm/LAue559L
         kTcvEM8Aqc/MXJrVnJ+0CQLQS9MBPYELhTS6jG9GyCJqaFZHtjqAsENJJvzE7nnP09Nx
         DxYllP2u1snj08+FUlYELhaAkjaB0Uw/AeNTCL9J91HDuEeyAtW/O+kOqLe4Trz71cSi
         QrWuYPbwD8SHz5CoibPZSozgRLE1BoB31Bevumly1g+HKXzQ7W7PziMtvxvQcjNntoBV
         ibDjnTEHg6vI4Cjudc3u0vZZ9HOuOJkaCBu21Y318kwmUXWxA/M8Cw6gc7bp95nC6VyJ
         /DFw==
X-Gm-Message-State: AOAM5306v80NVT5itTLDGD47T48YtjO66jtZY6rjq3TnSSPdNex9bf+r
        Qy9HPxIN1DhX1HCCVLVm+X0k4k2lKAWQew==
X-Google-Smtp-Source: ABdhPJxP136AdobMpEJ8dNHFCiGenljoOgfWfPI4D5oQNiguy4ihc7z4zVAmIy3EAVAIppQHWZNRqw==
X-Received: by 2002:a17:90a:55c5:: with SMTP id o5mr21655980pjm.169.1622510479688;
        Mon, 31 May 2021 18:21:19 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id y205sm408009pfb.53.2021.05.31.18.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 18:21:19 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [Update PATCH V3 2/8] md: add io accounting for raid0 and raid5
Date:   Tue,  1 Jun 2021 09:19:46 +0800
Message-Id: <20210601011946.1299847-1-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Guoqing Jiang <jgq516@gmail.com>

We introduce a new bioset (io_acct_set) for raid0 and raid5 since they
don't own clone infrastructure to accounting io. And the bioset is added
to mddev instead of to raid0 and raid5 layer, because with this way, we
can put common functions to md.h and reuse them in raid0 and raid5.

Also struct md_io_acct is added accordingly which includes io start_time,
the origin bio and cloned bio. Then we can call bio_{start,end}_io_acct
to get related io status.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
Signed-off-by: Song Liu <song@kernel.org>
---
Hi Song,

Please consider apply the updated patch which has minor changes based on
Christoph's comment.

1. don't create io_acct_set for raid1 and raid10.
2. update comment for md_account_bio.

Thanks,
Guoqing

 drivers/md/md.c    | 55 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/md.h    |  8 +++++++
 drivers/md/raid0.c |  3 +++
 drivers/md/raid5.c |  9 ++++++++
 4 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7ba00e4c862d..17a4aa8271f7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2340,7 +2340,9 @@ int md_integrity_register(struct mddev *mddev)
 			       bdev_get_integrity(reference->bdev));
 
 	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
-	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
+	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
+	    (mddev->level != 1 && mddev->level != 10 &&
+	     bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE))) {
 		pr_err("md: failed to create integrity pool for %s\n",
 		       mdname(mddev));
 		return -EINVAL;
@@ -5569,6 +5571,7 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->io_acct_set);
 	kfree(mddev);
 }
 
@@ -5862,7 +5865,13 @@ int md_run(struct mddev *mddev)
 	if (!bioset_initialized(&mddev->sync_set)) {
 		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 		if (err)
-			return err;
+			goto exit_bio_set;
+	}
+	if (!bioset_initialized(&mddev->io_acct_set)) {
+		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
+				  offsetof(struct md_io_acct, bio_clone), 0);
+		if (err)
+			goto exit_sync_set;
 	}
 
 	spin_lock(&pers_lock);
@@ -5990,6 +5999,7 @@ int md_run(struct mddev *mddev)
 			blk_queue_flag_set(QUEUE_FLAG_NONROT, mddev->queue);
 		else
 			blk_queue_flag_clear(QUEUE_FLAG_NONROT, mddev->queue);
+		blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue);
 	}
 	if (pers->sync_request) {
 		if (mddev->kobj.sd &&
@@ -6039,8 +6049,11 @@ int md_run(struct mddev *mddev)
 	module_put(pers->owner);
 	md_bitmap_destroy(mddev);
 abort:
-	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->io_acct_set);
+exit_sync_set:
 	bioset_exit(&mddev->sync_set);
+exit_bio_set:
+	bioset_exit(&mddev->bio_set);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6264,6 +6277,7 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->io_acct_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
@@ -8568,6 +8582,41 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
+static void md_end_io_acct(struct bio *bio)
+{
+	struct md_io_acct *md_io_acct = bio->bi_private;
+	struct bio *orig_bio = md_io_acct->orig_bio;
+
+	orig_bio->bi_status = bio->bi_status;
+
+	bio_end_io_acct(orig_bio, md_io_acct->start_time);
+	bio_put(bio);
+	bio_endio(orig_bio);
+}
+
+/*
+ * Used by personalities that don't already clone the bio and thus can't
+ * easily add the timestamp to their extended bio structure.
+ */
+void md_account_bio(struct mddev *mddev, struct bio **bio)
+{
+	struct md_io_acct *md_io_acct;
+	struct bio *clone;
+
+	if (!blk_queue_io_stat((*bio)->bi_bdev->bd_disk->queue))
+		return;
+
+	clone = bio_clone_fast(*bio, GFP_NOIO, &mddev->io_acct_set);
+	md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
+	md_io_acct->orig_bio = *bio;
+	md_io_acct->start_time = bio_start_io_acct(*bio);
+
+	clone->bi_end_io = md_end_io_acct;
+	clone->bi_private = md_io_acct;
+	*bio = clone;
+}
+EXPORT_SYMBOL_GPL(md_account_bio);
+
 /* md_allow_write(mddev)
  * Calling this ensures that the array is marked 'active' so that writes
  * may proceed without blocking.  It is important to call this before
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4da240ffe2c5..4191f22acce4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -487,6 +487,7 @@ struct mddev {
 	struct bio_set			sync_set; /* for sync operations like
 						   * metadata and bitmap writes
 						   */
+	struct bio_set			io_acct_set; /* for raid0 and raid5 io accounting */
 
 	/* Generic flush handling.
 	 * The last to finish preflush schedules a worker to submit
@@ -683,6 +684,12 @@ struct md_thread {
 	void			*private;
 };
 
+struct md_io_acct {
+	struct bio *orig_bio;
+	unsigned long start_time;
+	struct bio bio_clone;
+};
+
 #define THREAD_WAKEUP  0
 
 static inline void safe_put_page(struct page *p)
@@ -714,6 +721,7 @@ extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
+void md_account_bio(struct mddev *mddev, struct bio **bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e5d7411cba9b..62c8b6adac70 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -546,6 +546,9 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		bio = split;
 	}
 
+	if (bio->bi_pool != &mddev->bio_set)
+		md_account_bio(mddev, &bio);
+
 	orig_sector = sector;
 	zone = find_zone(mddev->private, &sector);
 	switch (conf->layout) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 841e1c1aa5e6..58e9dbc0f683 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5468,6 +5468,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 	sector_t sector = raid_bio->bi_iter.bi_sector;
 	unsigned chunk_sects = mddev->chunk_sectors;
 	unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
+	struct r5conf *conf = mddev->private;
 
 	if (sectors < bio_sectors(raid_bio)) {
 		struct r5conf *conf = mddev->private;
@@ -5477,6 +5478,9 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 		raid_bio = split;
 	}
 
+	if (raid_bio->bi_pool != &conf->bio_split)
+		md_account_bio(mddev, &raid_bio);
+
 	if (!raid5_read_one_chunk(mddev, raid_bio))
 		return raid_bio;
 
@@ -5756,6 +5760,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	DEFINE_WAIT(w);
 	bool do_prepare;
 	bool do_flush = false;
+	bool do_clone = false;
 
 	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
 		int ret = log_handle_flush_request(conf, bi);
@@ -5784,6 +5789,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	if (rw == READ && mddev->degraded == 0 &&
 	    mddev->reshape_position == MaxSector) {
 		bi = chunk_aligned_read(mddev, bi);
+		do_clone = true;
 		if (!bi)
 			return true;
 	}
@@ -5798,6 +5804,9 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 
+	if (!do_clone)
+		md_account_bio(mddev, &bi);
+
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (; logical_sector < last_sector; logical_sector += RAID5_STRIPE_SECTORS(conf)) {
 		int previous;
-- 
2.25.1

