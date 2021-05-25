Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB13C47084
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4406100B
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhEYJsj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 05:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbhEYJsg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 05:48:36 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60E6C061574
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cu11-20020a17090afa8bb029015d5d5d2175so12900461pjb.3
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p587mV7/AAq9YmpUV9Hsdc95M4rsuqjwQr1q0hoVAnw=;
        b=RuIyz3oE1wPU71Fyyyp8BVc0d9PQ8/gdD/7pYfW7XxCbp9SsdcXSk1ISGj1QLLPuDJ
         IDAM1Bshii49ubeaMLZyPEn1a8YXfCB8eboifgEeOmC55N3lBeGcmZc92BhFbH+oLkif
         WeVe8QvZicCZr5Gktc3y3ujIilivVHnKai1ByohpXt81GqNOEvSTPxytUNWS6mi7GR3F
         jxApSvSqcFoWcK9fgywHStGQLfYDSscafFUbBQc89VvWtLr17lcImfuD/4QEKLkXAjp/
         yJy9cEhOc9iblGQWvOmapcFKabq0lKk9/CeSZqp7vCb68rw72LkYSOc2UqXlC29RPb24
         0mbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p587mV7/AAq9YmpUV9Hsdc95M4rsuqjwQr1q0hoVAnw=;
        b=N3JogYms4sNiSui4RY+zej3/2P/mUusalJYhfa004wZLxl9uncvqZpm7GkKFUYQibd
         GaIzXpzt217OqmPWQfTTEtOLjdO0rmWZvbgac+ZYCp/E9AfJRwccJvlRbldAYi6G0VG3
         /Sc9dCqz8ZsbQ0FvS1XIwA3knLSDWVXIqpw8f9V8dkBuqpUlo1TTDCOakwbg9yH3ptqi
         rcz2h4scn01U56B8JoPmJhCNAFNq4mYtxAahM1uNfkqd/B2Q04PsIKVOk3WQvqpokleZ
         blnStL1qj1TQ2Bba6EIZ25wUwnchizq273DWhg9yQUf15jpwaJTImJ2v97xr0DWZ84Gq
         tnDQ==
X-Gm-Message-State: AOAM530r9PciMDFhdZVzD7x62edRYDm0MJiV3pH4C0rqlWOmU3EZsW6i
        BCvMJE4MxYf7hCXfhpa0V9k=
X-Google-Smtp-Source: ABdhPJysOM8bm57h3ZT96LOPCVFpx7vigdtGfvmMWVEcu++QIT40vTkLqPziS3a+pHW9GFhn8BRBhA==
X-Received: by 2002:a17:90a:1588:: with SMTP id m8mr4000906pja.226.1621936025155;
        Tue, 25 May 2021 02:47:05 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id r10sm13114437pfl.159.2021.05.25.02.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 02:47:04 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        hch@infradead.org
Subject: [PATCH V3 4/8] md/raid5: avoid redundant bio clone in raid5_read_one_chunk
Date:   Tue, 25 May 2021 17:46:19 +0800
Message-Id: <20210525094623.763195-5-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After enable io accounting, chunk read bio could be cloned twice which
is not good. To avoid such inefficiency, let's clone align_bio from
io_acct_set too, then we need only call md_account_bio in make_request
unconditionally.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/raid5.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5a05277f4be7..f83623ac8c34 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5364,11 +5364,13 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf,
  */
 static void raid5_align_endio(struct bio *bi)
 {
-	struct bio* raid_bi  = bi->bi_private;
+	struct md_io_acct *md_io_acct = bi->bi_private;
+	struct bio *raid_bi = md_io_acct->orig_bio;
 	struct mddev *mddev;
 	struct r5conf *conf;
 	struct md_rdev *rdev;
 	blk_status_t error = bi->bi_status;
+	unsigned long start_time = md_io_acct->start_time;
 
 	bio_put(bi);
 
@@ -5380,6 +5382,8 @@ static void raid5_align_endio(struct bio *bi)
 	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error) {
+		if (blk_queue_io_stat(raid_bi->bi_bdev->bd_disk->queue))
+			bio_end_io_acct(raid_bi, start_time);
 		bio_endio(raid_bi);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_quiescent);
@@ -5398,6 +5402,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	struct md_rdev *rdev;
 	sector_t sector, end_sector, first_bad;
 	int bad_sectors, dd_idx;
+	struct md_io_acct *md_io_acct;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
 		pr_debug("%s: non aligned\n", __func__);
@@ -5434,14 +5439,18 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 		return 0;
 	}
 
-	align_bio = bio_clone_fast(raid_bio, GFP_NOIO, &mddev->bio_set);
+	align_bio = bio_clone_fast(raid_bio, GFP_NOIO, &mddev->io_acct_set);
+	md_io_acct = container_of(align_bio, struct md_io_acct, bio_clone);
+	raid_bio->bi_next = (void *)rdev;
+	if (blk_queue_io_stat(raid_bio->bi_bdev->bd_disk->queue))
+		md_io_acct->start_time = bio_start_io_acct(raid_bio);
+	md_io_acct->orig_bio = raid_bio;
+
 	bio_set_dev(align_bio, rdev->bdev);
 	align_bio->bi_end_io = raid5_align_endio;
-	align_bio->bi_private = raid_bio;
+	align_bio->bi_private = md_io_acct;
 	align_bio->bi_iter.bi_sector = sector;
 
-	raid_bio->bi_next = (void *)rdev;
-
 	/* No reshape active, so we can trust rdev->data_offset */
 	align_bio->bi_iter.bi_sector += rdev->data_offset;
 
@@ -5468,7 +5477,6 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 	sector_t sector = raid_bio->bi_iter.bi_sector;
 	unsigned chunk_sects = mddev->chunk_sectors;
 	unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
-	struct r5conf *conf = mddev->private;
 
 	if (sectors < bio_sectors(raid_bio)) {
 		struct r5conf *conf = mddev->private;
@@ -5478,9 +5486,6 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 		raid_bio = split;
 	}
 
-	if (raid_bio->bi_pool != &conf->bio_split)
-		md_account_bio(mddev, &raid_bio);
-
 	if (!raid5_read_one_chunk(mddev, raid_bio))
 		return raid_bio;
 
@@ -5760,7 +5765,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	DEFINE_WAIT(w);
 	bool do_prepare;
 	bool do_flush = false;
-	bool do_clone = false;
 
 	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
 		int ret = log_handle_flush_request(conf, bi);
@@ -5789,7 +5793,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	if (rw == READ && mddev->degraded == 0 &&
 	    mddev->reshape_position == MaxSector) {
 		bi = chunk_aligned_read(mddev, bi);
-		do_clone = true;
 		if (!bi)
 			return true;
 	}
@@ -5804,9 +5807,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 
-	if (!do_clone)
-		md_account_bio(mddev, &bi);
-
+	md_account_bio(mddev, &bi);
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (; logical_sector < last_sector; logical_sector += RAID5_STRIPE_SECTORS(conf)) {
 		int previous;
-- 
2.25.1

