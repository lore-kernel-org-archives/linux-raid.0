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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D326C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58D2460FDB
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240991AbhERFe0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 01:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhERFeZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 01:34:25 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18B2C061573
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:07 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id e19so6586353pfv.3
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IalRtbCUge/qvHzcqpXuERUVL+HUBdmo9QbtJeieVL8=;
        b=Admxo8U581EOH+PxHdawzIX8+zilgdZCDJ+STz+T0sB+PwIsN4PB1THpJfVHDyierg
         GpmRge37JQ29t4nuykiFt220TdG6dPPOG8p8NMDVVSocIy8nhriwWmIruvqGf/rJGUKr
         NM+KxLUHiv78/XJMnZ6sLZuKN+7rdc0VVm8TSNzy/uyvjx1peymhy1lLGMdS6A+y5ExG
         HyTBOLYdw+p1KmIXhQYVrwWyQjxMwcAfCvwoi0cJXFj53FhZe23EwOxFN6D7ogqJvl7d
         22i5iH80D1huI1pUnt3ZZvMYW3Cu6q7FsJSe6sngLgFpe7JFIi+QdGmKxsO3rD/WACTJ
         5sCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IalRtbCUge/qvHzcqpXuERUVL+HUBdmo9QbtJeieVL8=;
        b=eRuQXQ8dl+a9+ZGdz/pXFP3pt7Cy/ZoP+73n3l5cllJ/ry3f5cIlMHFX+/jLy2jEBT
         MBC52h8Nnxg1VJ/Hco6pE2Zw4eEQSeu0RJTSIuHeuJo2Kgkt4FQW+ZoPeAmZv3Z6eMX2
         kcyu0Y75QcH5uiE0haS6bZlFDc7v/bQ6SdW3H19ch7s+/tc1G23FRaGJhEBuJEiRXqDt
         EA2UkmYpxG6NUFarm4WmMhP5xWlG+Sd7BHRvv8zJ0Gmx7U20NaL1g6E62umMD9mYS02A
         9vDQ8WXbLDpJfcCrIn2wrFsCxWsbQXImIJvMp+OIUjAuiZ3kRj/SNLABzgknErP7s7Xi
         XJrw==
X-Gm-Message-State: AOAM533viTHCEvPiXnc97pNSdPG3el/E9FHExWwD2AL+AXXYPhSSzy5j
        8z1s9abm0PEw/Hbh35iDtYU=
X-Google-Smtp-Source: ABdhPJzvR1K2hPJLgD4foXeAmHFESNWdZVHUXqP3isijH3u04h5HcAZYMS2XowhS4wcqDdyqtzcngw==
X-Received: by 2002:a65:53c8:: with SMTP id z8mr3328774pgr.192.1621315987240;
        Mon, 17 May 2021 22:33:07 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id z20sm11756726pjq.47.2021.05.17.22.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:33:06 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: [PATCH 2/5] md: the latest try for improve io stats accounting
Date:   Tue, 18 May 2021 13:32:22 +0800
Message-Id: <20210518053225.641506-3-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Use generic io accounting functions to manage io stats. There was an
attempt to do this earlier in commit 18c0b223cf990172 ("md: use generic
io stats accounting functions to simplify io stat accounting"), but it
did not include a call to generic_end_io_acct() and caused issues with
tracking in-flight IOs, so it was later removed in commit 74672d069b29
("md: fix md io stats accounting broken").

This patch attempts to fix this by using both generic_start_io_acct()
and generic_end_io_acct(). To make it possible, in md_make_request() a
bio is cloned with additional data - struct md_io, which includes the io
start_time. A new bioset is introduced for this purpose. We call
generic_start_io_acct() and pass the clone instead of the original to
md_handle_request(). When it completes, we call generic_end_io_acct()
and complete the original bio.

This adds correct statistics about in-flight IOs and IO processing time,
interpreted e.g. in iostat as await, svctm, aqu-sz and %util.

It also fixes a situation where too many IOs where reported if a bio was
re-submitted to the mddev, because io accounting is now performed only
on newly arriving bios.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
[Guoqing: rebase and make generic accounting applies to personalities 
	  which don't have clone infrastructure]
Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/md.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h |  1 +
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7ba00e4c862d..35355c187377 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -441,6 +441,25 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+struct md_io {
+	struct mddev *mddev;
+	struct bio *orig_bio;
+	unsigned long start_time;
+	struct bio orig_bio_clone;
+};
+
+static void md_end_io(struct bio *bio)
+{
+	struct md_io *md_io = bio->bi_private;
+	struct bio *orig_bio = md_io->orig_bio;
+
+	orig_bio->bi_status = bio->bi_status;
+
+	bio_end_io_acct_remapped(orig_bio, md_io->start_time, orig_bio->bi_bdev);
+	bio_put(bio);
+	bio_endio(orig_bio);
+}
+
 static blk_qc_t md_submit_bio(struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
@@ -465,6 +484,29 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
+	/*
+	 * We don't clone bio for multipath, raid1 and raid10 since we can reuse
+	 * their clone infrastructure.
+	 */
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue) &&
+	    (bio->bi_pool != &mddev->md_io_bs) &&
+	    (mddev->level != 1) && (mddev->level != 10) &&
+	    (mddev->level != LEVEL_MULTIPATH)) {
+		struct md_io *md_io;
+		struct bio *clone;
+
+		clone = bio_clone_fast(bio, GFP_NOIO, &mddev->md_io_bs);
+
+		md_io = container_of(clone, struct md_io, orig_bio_clone);
+		md_io->mddev = mddev;
+		md_io->orig_bio = bio;
+		md_io->start_time = bio_start_io_acct(bio);
+
+		clone->bi_end_io = md_end_io;
+		clone->bi_private = md_io;
+		bio = clone;
+	}
+
 	/* bio could be mergeable after passing to underlayer */
 	bio->bi_opf &= ~REQ_NOMERGE;
 
@@ -2340,7 +2382,8 @@ int md_integrity_register(struct mddev *mddev)
 			       bdev_get_integrity(reference->bdev));
 
 	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
-	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
+	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
+	    bioset_integrity_create(&mddev->md_io_bs, BIO_POOL_SIZE)) {
 		pr_err("md: failed to create integrity pool for %s\n",
 		       mdname(mddev));
 		return -EINVAL;
@@ -5569,6 +5612,7 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 	kfree(mddev);
 }
 
@@ -5864,6 +5908,12 @@ int md_run(struct mddev *mddev)
 		if (err)
 			return err;
 	}
+	if (!bioset_initialized(&mddev->md_io_bs)) {
+		err = bioset_init(&mddev->md_io_bs, BIO_POOL_SIZE,
+				  offsetof(struct md_io, orig_bio_clone), 0);
+		if (err)
+			return err;
+	}
 
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
@@ -6041,6 +6091,7 @@ int md_run(struct mddev *mddev)
 abort:
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6264,6 +6315,7 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4da240ffe2c5..1dece6b73c9e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -487,6 +487,7 @@ struct mddev {
 	struct bio_set			sync_set; /* for sync operations like
 						   * metadata and bitmap writes
 						   */
+	struct bio_set			md_io_bs; /* for io accounting */
 
 	/* Generic flush handling.
 	 * The last to finish preflush schedules a worker to submit
-- 
2.25.1

