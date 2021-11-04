Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C17C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 04:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC82E610E7
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 04:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhKDEyt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Nov 2021 00:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhKDEys (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Nov 2021 00:54:48 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ACEC061714
        for <linux-raid@vger.kernel.org>; Wed,  3 Nov 2021 21:52:11 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id b203so2091839iof.10
        for <linux-raid@vger.kernel.org>; Wed, 03 Nov 2021 21:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LPLb65AiQfayZTAYIrIy++vzphcMV7MYC3VC6XAEIIw=;
        b=RT0jAB1w0EtaJlzmeuTle93TqiCzHBR4ga0cFb0bRxLaVRqUaTGTRHVB9W3Ug355PK
         mXFOjJixse4qy1v/t7mS4RexGPn1/9wTRZ84Vlqxc6TTqUVs091PN9NGxnvbATHyZ8EC
         ICkQDpj4UmeBIy40bCI1/KytNLFRae/sJGqGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LPLb65AiQfayZTAYIrIy++vzphcMV7MYC3VC6XAEIIw=;
        b=VEDAYvtNhBjjiti8ELv3vBmC0n3Z+eyWb39RRhWPbPG/1++CphfN6rQhDd6D7avv9C
         KAXsegjtj0kasI0gKAGQaWckBThBR4H3SG9Nk2WWGDADCY8rI9g8/OeBLDZl4+eahPJG
         mDXDE0ikehReMMtkzJO2mElqnNkfuph6wLWEtuiVhhdohUwTJy3kLrqMBQvW1MRGjtZ1
         Ds71ZrUwOds38Gnu1qFnk4c/jkxdoWgiEzzkWJ1nqJA2eJ0C3FVW2S27USp46qlH5+hV
         m57dX9BdzF3qfGS48M1WfQ97ehkhz6PqDKfFUoDYhYivslAPdDnmgLSplcaJRHRcV9nE
         +IaQ==
X-Gm-Message-State: AOAM530jb4zF7E7ZMlzhAPvRIkq+w3Q3vY8wcfnFZG73V5jox19Zztcy
        xia3Gp+Ob5lg9uNEVk592ftZoA==
X-Google-Smtp-Source: ABdhPJx+Rf9LsP2/tNN/3yN5UzecOmi6zDW/TufmC/n9m51x7yckZsKe5RBwsYaOKtWE+TUbKeEqIA==
X-Received: by 2002:a05:6602:15d3:: with SMTP id f19mr23651887iow.14.1636001530859;
        Wed, 03 Nov 2021 21:52:10 -0700 (PDT)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id 11sm2721171ilx.55.2021.11.03.21.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 21:52:10 -0700 (PDT)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk, Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v3 1/2] md: add support for REQ_NOWAIT
Date:   Thu,  4 Nov 2021 04:51:49 +0000
Message-Id: <20211104045149.9599-2-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211104045149.9599-1-vverma@digitalocean.com>
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
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
 drivers/md/md.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5111ed966947..73089776475f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5792,6 +5792,7 @@ int md_run(struct mddev *mddev)
 	int err;
 	struct md_rdev *rdev;
 	struct md_personality *pers;
+	bool nowait = true;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -5862,8 +5863,13 @@ int md_run(struct mddev *mddev)
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
@@ -7007,6 +7013,14 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
+	/* If the new disk does not support REQ_NOWAIT,
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

