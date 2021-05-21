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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA46C433B4
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1FAA600CD
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbhEUA57 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 20:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhEUA56 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 20:57:58 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBC3C061763
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b13so9940746pfv.4
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CzyeW0naSWePcPj2uPR8PUqj6py64yU6rVDLUAUWGDs=;
        b=TMg5HXkcpH9Ux4rxbBOj4h/moEcJ5UchLEFGKWKuaiwNkl4UZ5Seyliqp+fdXF+lGb
         rhCcvbpy4k09sxd5bjU4FKgrU3DtvlvpJQn+0NqSaWn5d+av7Bm2yYTThR1vjkcXt4tI
         3Q5eu9CzvMbs9szd3PAJYYRO/Ztq5HxvmNSAR4u/48HbhkUlJ7BQrULRyfukasVvvsdR
         pyAOZZG7CQr1Tq22yT58RxKkCgMwtnFy3Qg4pU3moEqQondWgC9XFBvXRzh0pZgTp1Qq
         rH+CtRluLYGS/Ddv//GE7X08HDDH7caPV4jT/5Rzg6ImdBdBrrXAthmBUkRaZM6C92oL
         6q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CzyeW0naSWePcPj2uPR8PUqj6py64yU6rVDLUAUWGDs=;
        b=Mhk0J9HR1Fge6p8P20isO9CmqkdGAGT252MDh7dewXNIviAJki/kSflJABCKQ1F/Yn
         AUSm7nQrTUxrv8yScUs9g5Ha/8TSKjN6w3cfFv1E6x9FCk17GBzLW4wxRz/puW9wCZYI
         UhPNj0/Kok6SZfS7z545Nty4PMb1jeEXpl2knAvGULEk9gvcXJbObZp3DOV/kpe8bOFU
         ugsU+mcB8XGe6M/oD9Xs2TqzBdMgzV3eO1HCpiYPCwJIHwmULkysBUNxvkN98ggDpHxh
         7Hjvq6B/wDYAo56xOOF5UUxTPCyngnPsHx4v6HR2NQ8Hd9BCoMGkkDq5gB4bWmz49Ak2
         2vnQ==
X-Gm-Message-State: AOAM531RChnRn/7lzgkC199eufjJKpRIdSIo2Uf9N1LHwWrZU2mn3oaa
        6w2p73/lq4mrywNpA+z5XWc=
X-Google-Smtp-Source: ABdhPJw2JhKP8pNwrP1Of/IfbL9wfRKBd5iyKQvwvU+aPtsfSYHQ2Vv+BaN1JxYjhWAiui7J6cUXIw==
X-Received: by 2002:aa7:8202:0:b029:2d8:c24d:841d with SMTP id k2-20020aa782020000b02902d8c24d841dmr7504775pfi.57.1621558595535;
        Thu, 20 May 2021 17:56:35 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id 5sm7405945pjo.17.2021.05.20.17.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:56:35 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
Subject: [PATCH V2 3/7] md: the latest try for improve io stats accounting
Date:   Fri, 21 May 2021 08:55:17 +0800
Message-Id: <20210521005521.713106-4-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
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
 drivers/md/md.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h |  1 +
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7ba00e4c862d..13392fe9379c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -441,6 +441,25 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+struct md_io {
+	struct mddev *mddev;
+	struct bio *orig_bio;
+	unsigned long start_time;
+	struct bio bio_clone;
+};
+
+static void md_end_io(struct bio *bio)
+{
+	struct md_io *md_io = bio->bi_private;
+	struct bio *orig_bio = md_io->orig_bio;
+
+	orig_bio->bi_status = bio->bi_status;
+
+	bio_end_io_acct(orig_bio, md_io->start_time);
+	bio_put(bio);
+	bio_endio(orig_bio);
+}
+
 static blk_qc_t md_submit_bio(struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
@@ -465,6 +484,30 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
+	/*
+	 * clone bio under conditions:
+	 * 1. QUEUE_FLAG_IO_STAT flag is set.
+	 * 2. bio just enters md and it is not split from personality.
+	 */
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue) &&
+	    (bio->bi_pool != &mddev->md_io_bs) &&
+	    (mddev->pers->accounting_bio &&
+	     mddev->pers->accounting_bio(mddev, bio))) {
+		struct md_io *md_io;
+		struct bio *clone;
+
+		clone = bio_clone_fast(bio, GFP_NOIO, &mddev->md_io_bs);
+
+		md_io = container_of(clone, struct md_io, bio_clone);
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
 
@@ -2340,9 +2383,12 @@ int md_integrity_register(struct mddev *mddev)
 			       bdev_get_integrity(reference->bdev));
 
 	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
-	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
+	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
+	    bioset_integrity_create(&mddev->md_io_bs, BIO_POOL_SIZE)) {
 		pr_err("md: failed to create integrity pool for %s\n",
 		       mdname(mddev));
+		bioset_exit(&mddev->bio_set);
+		bioset_exit(&mddev->md_io_bs);
 		return -EINVAL;
 	}
 	return 0;
@@ -5569,6 +5615,7 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 	kfree(mddev);
 }
 
@@ -5864,6 +5911,12 @@ int md_run(struct mddev *mddev)
 		if (err)
 			return err;
 	}
+	if (!bioset_initialized(&mddev->md_io_bs)) {
+		err = bioset_init(&mddev->md_io_bs, BIO_POOL_SIZE,
+				  offsetof(struct md_io, bio_clone), 0);
+		if (err)
+			return err;
+	}
 
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
@@ -6041,6 +6094,7 @@ int md_run(struct mddev *mddev)
 abort:
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6264,6 +6318,7 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5125ccf9df06..d2f476c427a9 100644
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

