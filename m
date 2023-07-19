Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED52C001DC
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jul 2023 07:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjGSHKZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjGSHKU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 03:10:20 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A72E1BF0
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:10:13 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id e9e14a558f8ab-345f1e0abf9so28852425ab.3
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1689750613; x=1690355413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PxoHMuRjPvVhNHPoZFIyFjoUjgrNWfrZfj8UVxX1Mo=;
        b=zmWkU5G1tPmeVrozmzHBBV93Io6QrdBU6v/3Geny0Xtq3qecKunlGocnBnJGNVsr20
         EACMVRh2Jtbm2TMebgQy0+Y3F98o5Iw5AxvInvqxL/EFImPgx6cvoXkLRbKpMQJrsJXm
         0K2HJo/oKyG3OAPdJDiW4piR88Yjqm+QdJ6zyR4rmEKydmpNr3fsVW8i3PeiaFRwQJYU
         ddYly5PQLyOoNppU00wCDy7P41YuSTzqrQzvkxGDtor1zzTN4eBM7R1fTQDNJ2Cz8O3e
         qrJfxQhKHCgtnx+Qs/vou1hP5LgU5MvNos/FaCCEvvmqqRQHaVMhmb3F9LWlQl3dzhPr
         UDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689750613; x=1690355413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7PxoHMuRjPvVhNHPoZFIyFjoUjgrNWfrZfj8UVxX1Mo=;
        b=c0QhoCGqu8Mniyd1Xud3EMuTdPqYgX1h8vKGyCvqQRN61YeOFzqJFzn6+ioj6DvFQr
         7VwO2g5H2jTXn5w2xfTBsvkJ4YSY3aP1W4wpgfQ/5dmZ8ZXU262OMbkhaE65+G3maV6n
         3Y3b9FgmADxjcH07AbQH3cSTEe8Sp6hDInTsE3jPcJ5wXW+fzYfKvtfPMgwJiasu0Fi/
         2pMqQPpA3kdPm2WebNossY7fanXPs7E00qY0Lcj4JsNnI5fgwwAU7WNaiOfveC+5YA4l
         RQwMsULx8F4VvfcQwwcpHj/TTNvkyz5+CnpPaK+a1fvN6TU4bChVRN+kNgT9BFYjk2Iy
         /bQw==
X-Gm-Message-State: ABy/qLa5swcfQHQiTvKpZ0Ub3DViukSUS9OexDrge9g6k0zPZYtiASHn
        YNSSoB22PkuTV50kmwSEmIxDRw==
X-Google-Smtp-Source: APBJJlHa+VYyYLNqlJcOAXRaecw2U5+FL4kIjwWod3bni4yQGDzonaQbSEeDsXrW0C+JQySp6Lv18g==
X-Received: by 2002:a92:ca83:0:b0:348:8216:3363 with SMTP id t3-20020a92ca83000000b0034882163363mr1561145ilo.5.1689750612704;
        Wed, 19 Jul 2023 00:10:12 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id 11-20020a17090a194b00b002639c4f81cesm667453pjh.3.2023.07.19.00.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 00:10:12 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, yukuai1@huaweicloud.com,
        Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v3 2/3] md/raid1: don't allow_barrier() before r1bio got freed
Date:   Wed, 19 Jul 2023 15:09:53 +0800
Message-Id: <20230719070954.3084379-3-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719070954.3084379-1-xueshi.hu@smartx.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

allow_barrier() make reshape possible. Raid reshape changes the
r1conf::raid_disks and mempool. Free the r1bio firstly and then call
allow_barrier()

Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5605c9680818..62e86b7d1561 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -313,6 +313,7 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
 	struct r1conf *conf = r1_bio->mddev->private;
+	sector_t sector = r1_bio->sector;
 
 	/* if nobody has done the final endio yet, do it now */
 	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
@@ -323,13 +324,13 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 
 		call_bio_endio(r1_bio);
 	}
+
+	free_r1bio(r1_bio);
 	/*
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.  All I/Os, even write-behind writes, are done.
 	 */
-	allow_barrier(conf, r1_bio->sector);
-
-	free_r1bio(r1_bio);
+	allow_barrier(conf, sector);
 }
 
 /*
@@ -1404,6 +1405,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		return;
 	}
 
+ retry_write:
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
@@ -1419,7 +1421,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
- retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
 	max_sectors = r1_bio->sectors;
@@ -1499,7 +1500,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-		r1_bio->state = 0;
+		free_r1bio(r1_bio);
 		allow_barrier(conf, bio->bi_iter.bi_sector);
 
 		if (bio->bi_opf & REQ_NOWAIT) {
@@ -2529,6 +2530,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	struct mddev *mddev = conf->mddev;
 	struct bio *bio;
 	struct md_rdev *rdev;
+	sector_t sector;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
 	/* we got a read error. Maybe the drive is bad.  Maybe just
@@ -2558,12 +2560,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 
 	rdev_dec_pending(rdev, conf->mddev);
-	allow_barrier(conf, r1_bio->sector);
+	sector = r1_bio->sector;
 	bio = r1_bio->master_bio;
 
 	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
 	r1_bio->state = 0;
 	raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
+	allow_barrier(conf, sector);
 }
 
 static void raid1d(struct md_thread *thread)
-- 
2.40.1

