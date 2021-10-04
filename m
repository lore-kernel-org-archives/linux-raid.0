Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C4EC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9DC860F9E
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbhJDPmP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:42:15 -0400
Received: from out10.migadu.com ([46.105.121.227]:62830 "EHLO out10.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235756AbhJDPmP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 4 Oct 2021 11:42:15 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2021 11:42:14 EDT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633361703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8URm4hBnke6FWUPu50hM5apVA1rLx1yDHJUU9NaG8go=;
        b=P3LVwY6TD1JEneYQ7Fsf2/pdzJmXqL0mudB0WeVHxBXP+/etw302gUqiCnK6eYcbpj6Un1
        P0xh0keu9pjKFK+jpY2GwsKStrkkEoAclUBZA7+U8JyYeHyQbd3cWBG+T2sLQJLR3Um83R
        MrVUsriwnjd0bLI2e7/zPIviNqlbTp8=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/6] md/raid1: use rdev in raid1_write_request directly
Date:   Mon,  4 Oct 2021 23:34:50 +0800
Message-Id: <20211004153453.14051-4-guoqing.jiang@linux.dev>
In-Reply-To: <20211004153453.14051-1-guoqing.jiang@linux.dev>
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We already get rdev from conf->mirrors[i].rdev at the beginning of the
loop, so just use it.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/raid1.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6ba12f0f0f03..7dc8026cf6ee 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1529,13 +1529,12 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		r1_bio->bios[i] = mbio;
 
-		mbio->bi_iter.bi_sector	= (r1_bio->sector +
-				   conf->mirrors[i].rdev->data_offset);
-		bio_set_dev(mbio, conf->mirrors[i].rdev->bdev);
+		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
+		bio_set_dev(mbio, rdev->bdev);
 		mbio->bi_end_io	= raid1_end_write_request;
 		mbio->bi_opf = bio_op(bio) | (bio->bi_opf & (REQ_SYNC | REQ_FUA));
-		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags) &&
-		    !test_bit(WriteMostly, &conf->mirrors[i].rdev->flags) &&
+		if (test_bit(FailFast, &rdev->flags) &&
+		    !test_bit(WriteMostly, &rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
 			mbio->bi_opf |= MD_FAILFAST;
 		mbio->bi_private = r1_bio;
@@ -1546,7 +1545,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			trace_block_bio_remap(mbio, disk_devt(mddev->gendisk),
 					      r1_bio->sector);
 		/* flush_pending_writes() needs access to the rdev so...*/
-		mbio->bi_bdev = (void *)conf->mirrors[i].rdev;
+		mbio->bi_bdev = (void *)rdev;
 
 		cb = blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
 		if (cb)
-- 
2.31.1

