Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8F2C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 18:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527546103C
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 18:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhKJSRu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Nov 2021 13:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhKJSRt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Nov 2021 13:17:49 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD302C061764
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 10:15:01 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id m9so3946974iop.0
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 10:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hvxf5DUgc71LXKMopNQobFUCU0Ql//3TaxPXBTbYtZo=;
        b=AYzor849il9mj7XDzqcqNxtKQUHPLUG5PFc46kOUyyyEBdtkEa7sfVVv3cO0sF2/9h
         zzyTsWkT60WW84Lm8robOMd8ci7SZFmM+6bOy3pPghaVLpU49v1USbLj6GDKA3FULbmS
         nKjCEnnSKWwXuUzOY2v6SYkvnOlziVTS46OCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hvxf5DUgc71LXKMopNQobFUCU0Ql//3TaxPXBTbYtZo=;
        b=hLmLOOHLgiIlRXCZ2XgFO7xyOslEmZzHbD973s2XOq/Y2k8nvLzZeVu/5VPn7SRG5R
         SvVwjVbgjTGsLLmhqKlNBbvn3u2q3Swt5MBz9MsPIefdjy0g68EuyK1qoDyCuYVDMobi
         rWXVLTNfvVBIZ2IiMpxVz7jGrhmvYvuBKNd5SOS465nc7I8QBROQcNv/cg6OeBJOyH2N
         8TvVTby1bm0CxiRWsp+lpqMV282BtB2E2KPQovKtx9WE13Sgl4AJzNa+8u4VHcmQYbJ7
         fbKHG6fRU/R9EvA1NjehuhcHhUiksOkbLbnOHLhdqJRFCMwsZeoRbOjO1fInJNBKRmPA
         nwHQ==
X-Gm-Message-State: AOAM530XN59EhZvzqcGrhaMAsaUBmVakQwAl4euWH+7baHVpuQQJuga+
        lqNrjNmE2P3Uxb8XSiHWZiMTWw==
X-Google-Smtp-Source: ABdhPJwRhOolGq8co0hx7OSO3Mvd33H+BrrqsN2CgFTxP1sZGCm6P3G3LZtDIFoP/vmfTd60afndQg==
X-Received: by 2002:a5d:9593:: with SMTP id a19mr696555ioo.201.1636568101221;
        Wed, 10 Nov 2021 10:15:01 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id r3sm339289ila.42.2021.11.10.10.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 10:15:00 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk, Vishal Verma <vverma@digitalocean.com>
Subject: [RFC PATCH v4 1/4] md: add support for REQ_NOWAIT
Date:   Wed, 10 Nov 2021 18:14:38 +0000
Message-Id: <20211110181441.9263-1-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
for checking whether a given bdev supports handling of REQ_NOWAIT or not.
Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
it for linear target") added support for REQ_NOWAIT for dm. This uses
a similar approach to incorporate REQ_NOWAIT for md based bios.

This patch was tested using t/io_uring tool within FIO. A nvme drive
was partitioned into 2 partitions and a simple raid 0 configuration
/dev/md0 was created.

md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
      937423872 blocks super 1.2 512k chunks

Before patch:

$ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100

Running top while the above runs:

$ ps -eL | grep $(pidof io_uring)

  38396   38396 pts/2    00:00:00 io_uring
  38396   38397 pts/2    00:00:15 io_uring
  38396   38398 pts/2    00:00:13 iou-wrk-38397

We can see iou-wrk-38397 io worker thread created which gets created
when io_uring sees that the underlying device (/dev/md0 in this case)
doesn't support nowait.

After patch:

$ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100

Running top while the above runs:

$ ps -eL | grep $(pidof io_uring)

  38341   38341 pts/2    00:10:22 io_uring
  38341   38342 pts/2    00:10:37 io_uring

After running this patch, we don't see any io worker thread
being created which indicated that io_uring saw that the
underlying device does support nowait. This is the exact behaviour
noticed on a dm device which also supports nowait.

For all the other raid personalities except raid0, we would need
to train pieces which involves make_request fn in order for them
to correctly handle REQ_NOWAIT.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/md.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5111ed966947..a30c78afcab6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -419,6 +419,11 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 	if (is_suspended(mddev, bio)) {
 		DEFINE_WAIT(__wait);
 		for (;;) {
+			/* Bail out if REQ_NOWAIT is set for the bio */
+			if (bio->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bio);
+				return;
+			}
 			prepare_to_wait(&mddev->sb_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
 			if (!is_suspended(mddev, bio))
@@ -5792,6 +5797,7 @@ int md_run(struct mddev *mddev)
 	int err;
 	struct md_rdev *rdev;
 	struct md_personality *pers;
+	bool nowait = true;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -5862,8 +5868,13 @@ int md_run(struct mddev *mddev)
 			}
 		}
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
+		nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));
 	}
 
+	/* Set the NOWAIT flags if all underlying devices support it */
+	if (nowait)
+		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
+
 	if (!bioset_initialized(&mddev->bio_set)) {
 		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 		if (err)
@@ -7007,6 +7018,15 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
+	/*
+	 * If the new disk does not support REQ_NOWAIT,
+	 * disable on the whole MD.
+	 */
+	if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
+		pr_info("%s: Disabling nowait because %s does not support nowait\n",
+			mdname(mddev), bdevname(rdev->bdev, b));
+		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
+	}
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
 	 * array immediately.
-- 
2.17.1

