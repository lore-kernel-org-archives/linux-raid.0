Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC468C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 21 Dec 2021 20:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhLUUGj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 15:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhLUUGj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Dec 2021 15:06:39 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99015C061574
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 12:06:38 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id g28so152361qkk.9
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 12:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fv+GVhTh+gh68aGg97S2nAgHDimFjXCkbqCYMFbylPM=;
        b=YkvTFsD827vo34hxlTPVw58cGXvba06dcVobx26RkFifQDriFizzgmvIRwbCe5D0p7
         LThxNJCP13ernCynKUVbcEdZsis1W5jfbmPW7vNAYJ6ZDKvOysLwl5IPd0vYW9TNTvAr
         oa+FG3n830BrcNBfWKKs2Uo9vp0zsgCENILTw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fv+GVhTh+gh68aGg97S2nAgHDimFjXCkbqCYMFbylPM=;
        b=rdJaPLCUWes8Mq+Eff7CASynCSd6E80G+/msQ35Eivw6yw6XIWVKzYBCSIt8ijM7Dr
         caDvZdZ2rzbqWFkAJaHRItMgmp/5Ci63ZnViv2h7Y0zVBANi9duWDMnOPHXSj6uC/dZR
         wARwAc7titGfHOn02fRne7rIFolh0bqNkwtgYgQolSMLVHvPb6RblTlSdvRPqtNp4lP4
         ri/Q8A9L0rTs9Wn6GFUC1nGwvHZ/ANjzBlp8jc/meYYhdSrOiKThUuRKeUtZyHXJ7ziX
         XkhqOOh5s/xKCzNHYSGpWLS2VKJIIoBOFJhHMabIIVzd4qpmyzckpVPTih5xjqCK5u5y
         ywaQ==
X-Gm-Message-State: AOAM532ggBlXjx3hWuqwJt+6EIN4RrFOSYQ+L2jzgVCrzrfEMl+043uI
        KwN+kybWTvHgXx04XFjzfF6y5NxoqNqgVQ==
X-Google-Smtp-Source: ABdhPJwx03w0lOfYiubC4YlbD8xdkvfKuAlonLnHPN4wFw7I7IPkd6MBnZ8vWLyow5J1xdkymR6y+Q==
X-Received: by 2002:a05:620a:44c6:: with SMTP id y6mr3268679qkp.601.1640117197730;
        Tue, 21 Dec 2021 12:06:37 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id o21sm18518446qta.89.2021.12.21.12.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 12:06:37 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, rgoldwyn@suse.de,
        Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v6 1/4] md: add support for REQ_NOWAIT
Date:   Tue, 21 Dec 2021 20:06:19 +0000
Message-Id: <20211221200622.29795-1-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
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
index 5111ed966947..ccd296aa9641 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -418,6 +418,11 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 	rcu_read_lock();
 	if (is_suspended(mddev, bio)) {
 		DEFINE_WAIT(__wait);
+		/* Bail out if REQ_NOWAIT is set for the bio */
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		for (;;) {
 			prepare_to_wait(&mddev->sb_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
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

