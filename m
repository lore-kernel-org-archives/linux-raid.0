Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6F5C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 14:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BC7C61052
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 14:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhKBOnJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBOnI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 10:43:08 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0168BC061714
        for <linux-raid@vger.kernel.org>; Tue,  2 Nov 2021 07:40:34 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q127so24802164iod.12
        for <linux-raid@vger.kernel.org>; Tue, 02 Nov 2021 07:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qp5/3yQx7/A4xmESr3uPX7HvuOi+2KW5kOW/diDs1fc=;
        b=MO8BR2y9f6uRZtUObRq/KT3aQPEF9glOThmmW1gEEwdTWtz4xJu/gflS9i280xTQBC
         0RKKD/HMpPiuf2i07PxUreOmMp2508wIThx2nSiUw8OG0A9SM+9o3zzWf3VL/CugjkJb
         t8mbfIF+oPkIZnnRN3v4tJpPVoNnYqADjBY6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qp5/3yQx7/A4xmESr3uPX7HvuOi+2KW5kOW/diDs1fc=;
        b=qXVsSCp25jKKmwgX9jCLbofIhmdfpwSmDNCJyXHpJUU+20ydLsxATpqwOkn8FuDxVq
         12DDrb4VQrT35UUXH3o9lrspae805aZJVD/n8X023NH48UZ+C9ASRiNy2G/O1SjpAxeR
         mRUQotL3voo6iK/WwAth5fJyPAvUxxgIpp4pLIs2mT7QvqhIV+m3fKCH4lOrf6b3xVJf
         xsPjlwWI8xr354cbEx1IqGUUvngM7yCB+NHPP2vwDhQE3xHXr0feTeWQGPPI7HmtR0mN
         41gFwnMGl1LDDMkD6FnDSYOioDo8mbmjL/0v4U3NAcAc/6eLQJnVxcHHVUgrg5jDXB2G
         R/4g==
X-Gm-Message-State: AOAM531JA1hkxMZRm6TewfUuPdw40UvHm9fRslE6AfHaQkURed1Uet0o
        AQQNUcB8wecHtfxMMp7bsCKePRXzUSh4lw==
X-Google-Smtp-Source: ABdhPJxPy3CQXvk28904nDZVE6JTMW1iCjN3XVzn6cezUZSV4Mn6I3l2/2X3NV6ZpTSVcyvSwC5f4w==
X-Received: by 2002:a5e:890e:: with SMTP id k14mr24944800ioj.187.1635864033378;
        Tue, 02 Nov 2021 07:40:33 -0700 (PDT)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id g13sm9872746ile.73.2021.11.02.07.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 07:40:32 -0700 (PDT)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     axboe@kernel.dk, Vishal Verma <vverma@digitalocean.com>
Subject: [PATCH v2] md: add support for REQ_NOWAIT
Date:   Tue,  2 Nov 2021 14:40:04 +0000
Message-Id: <20211102144004.25344-1-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAPhsuW5FpeS9AfPYpNgHGCp8dP151g-t8whSiGyuxEfp2O92tg@mail.gmail.com>
References: <CAPhsuW5FpeS9AfPYpNgHGCp8dP151g-t8whSiGyuxEfp2O92tg@mail.gmail.com>
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

I also successfully tested this patch on various other
raid personalities (1, 6 and 10).

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/md.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5111ed966947..11174d32bfd7 100644
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
+		nowait = blk_queue_nowait(bdev_get_queue(rdev->bdev));
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

