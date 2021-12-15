Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37459C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 06:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbhLOGJY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 01:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbhLOGJX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 01:09:23 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380C3C061574
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 22:09:23 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id i13so19432743qvm.1
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 22:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lv6Ugz9LmRrSqlZAtDLIwfDClSlEtb1nIadfMCyGSfc=;
        b=eDvFRrhrA108tBg+0qJgDAz1TgM6Zp1xdtoCXzxgjO0PBS4+hdOavwyj/RX33JFdvp
         D2xZ/K1kxuBs/yZbQbhzWDXRT81O0okb8Fz3gE5zpNr0e351dxr7j043PAmHHHyqucbW
         Yz3eWUGPiGKaRLZYbfJCEOTLOZG779961Z6+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lv6Ugz9LmRrSqlZAtDLIwfDClSlEtb1nIadfMCyGSfc=;
        b=RXXUkpzbEeuOmXmat5IqxHvn+mKsEr1jyOJPjImpSAKoWVzhRkHchgqCeEwTt8sciP
         OEJ8F5Zyk8TyZbMZQEDTwxyu7VSLmjdBRcTU3RQU7o6GFDiRBc5HNzUuW9yfBQ+xTera
         HCR7Npk+KRNV3n/NoMQmeAjkQtRG1I1c8pThXqPIc58caFjQKpsIPXPgHgVHhZwWqKal
         wuwNujx4lkh9Zzrjmf4l7XVnFiXeenGizu92rr/ImTrki7PGM12BZkGPkprO2Jubyr1u
         7aVqjstk0TBs7DJLQUqw/iG1TMCeL3RKXafSiCnBdZH1KLy8bcWBTJ4zVKJI3huKWT4t
         uzKA==
X-Gm-Message-State: AOAM531vaOriaMusz9attaBQMxUTZUUnceErHxlm1yyFCfaZFb31PmE0
        gWf26seVC70OKKjX9NNr/XtdSw==
X-Google-Smtp-Source: ABdhPJyCuixs5NnvS9FOa1lz0zxaZiGZ0CkEZ7CwKqAW9RMXXhYmIWHtbUfV7ks524HFK7pVzxVIUQ==
X-Received: by 2002:a05:6214:e41:: with SMTP id o1mr38147qvc.63.1639548562342;
        Tue, 14 Dec 2021 22:09:22 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id 22sm801808qtw.12.2021.12.14.22.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:09:22 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, rgoldwyn@suse.de,
        Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v5 1/4] md: add support for REQ_NOWAIT
Date:   Wed, 15 Dec 2021 06:09:03 +0000
Message-Id: <20211215060906.3230-1-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
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
 drivers/md/md.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7fbf6f0ac01b..5b4c28e0e1db 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -419,6 +419,12 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 	if (is_suspended(mddev, bio)) {
 		DEFINE_WAIT(__wait);
 		for (;;) {
+			/* Bail out if REQ_NOWAIT is set for the bio */
+			if (bio->bi_opf & REQ_NOWAIT) {
+				rcu_read_unlock();
+				bio_wouldblock_error(bio);
+				return;
+			}
 			prepare_to_wait(&mddev->sb_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
 			if (!is_suspended(mddev, bio))
@@ -5787,6 +5793,7 @@ int md_run(struct mddev *mddev)
 	int err;
 	struct md_rdev *rdev;
 	struct md_personality *pers;
+	bool nowait = true;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -5857,8 +5864,13 @@ int md_run(struct mddev *mddev)
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
@@ -7002,6 +7014,15 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
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

