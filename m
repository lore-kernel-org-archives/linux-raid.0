Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0579CC04A6A
	for <linux-raid@archiver.kernel.org>; Tue,  8 Aug 2023 15:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjHHPiO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Aug 2023 11:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjHHPhO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Aug 2023 11:37:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A838212C
        for <linux-raid@vger.kernel.org>; Mon,  7 Aug 2023 20:32:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1bc3d94d40fso45587205ad.3
        for <linux-raid@vger.kernel.org>; Mon, 07 Aug 2023 20:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1691465547; x=1692070347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hmAKC7MUaEQY2uXPcmLs0knjPOeTmjxcMa0iPmgWtmE=;
        b=Hy2ozxA0ZfJCSOPYh/WLSNUSNmXJKfKCJ4gIkzBMQ6Tvwh+Cz+SDEuyUqwaZytxpYI
         nIOhKMbp8WpYThAGq5Y89QDFMKAk174QaS+uG80h3MPkB/Wjz5RXQAKRlYVfc8r/eHl4
         ztq2CDMraMoGHV2jpEeV9UeO5724gfZnZa/1Ry3rCrOg4XV49ROhPvp7x5zIqXOjPCCv
         FYZbPED/iy/7KmoWiTRDSqeJCj6Jmohvd8hvg4yuGsn8QCALzXf3xEeOgOkiF/A1nh40
         /drD40/IufnVQ1ZuZKsIhl32MG8WHVCyQu0jJop4C7T52f5zjz3gQB6sqKqBbniIQ/c2
         eFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691465547; x=1692070347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hmAKC7MUaEQY2uXPcmLs0knjPOeTmjxcMa0iPmgWtmE=;
        b=DZOSAgqZQntfBNmyLPnVFIgHyD2BJe40dNjm9EF69kSupqi6EFmb8Kgp61XzwGCvcj
         FNHBfxPre91Bupl2M3wegh/UDETCmotNQ1ymqoMcpksPtSlFeIx03Oz9WD6sHEc0L1Bc
         t6ZpNz7iJcvAxdjUxWw7oKHFGsoVnkJww0SnLq80dopQ3n9ACLT/D6QTxaLZmb8crQwG
         kVL6NYyfBaBXgYsNNAKQjChniSRjmUZEHO7GEmWUoTeJ8nSvaCQhT0CwKyVjZd5wlazw
         /nCHuTVqIsYYkAc69N7Fbng5muPC8F5YSgB4FTAvMv5SufPxhuleQh7971S5RjOUsio1
         fXpg==
X-Gm-Message-State: AOJu0Yxvm2on+c6YlXP6/jz8vJ4n+GOxt22zE1EAa6i4cm3uraPVg3OR
        WaIz8j3uWy6Gzvu2cSQBJqh43A==
X-Google-Smtp-Source: AGHT+IFT2SrJ27yWt/omnEuK95KJUNBVK2fzA9dTM+ADujnvSoSA4KFJhwGLZhYbUsI21Lan1v1vIQ==
X-Received: by 2002:a17:902:f801:b0:1b9:d335:2216 with SMTP id ix1-20020a170902f80100b001b9d3352216mr10215217plb.20.1691465547576;
        Mon, 07 Aug 2023 20:32:27 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id p7-20020a170902bd0700b001b3bf8001a9sm7676272pls.48.2023.08.07.20.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 20:32:27 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org, djeffery@redhat.com, dan.j.williams@intel.com,
        neilb@suse.de, akpm@linux-foundation.org, shli@fb.com,
        neilb@suse.com
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>,
        Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v4] md/raid1: don't allow_barrier() before r1bio got freed
Date:   Tue,  8 Aug 2023 11:32:11 +0800
Message-Id: <20230808033211.197383-1-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Because raid reshape changes the r1conf::raid_disks and the mempool, it
orders that there's no in-flight r1bio when reshaping. However, the
current caller of allow_barrier() allows the reshape
operation to proceed even if the old r1bio requests have not been freed.

Free the r1bio firstly before allow_barrier()

Fixes: c91114c2b89d ("md/raid1: release pending accounting for an I/O only after write-behind is also finished")
Fixes: 6bfe0b499082 ("md: support blocking writes to an array on device failure")
Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
-> v2:
	- fix the problem one by one instead of calling
	blk_mq_freeze_queue() as suggested by Yu Kuai
-> v3:
	- add freeze_array_totally() to replace freeze_array() instead
	  of gave up in raid1_reshape()
	- add a missed fix in raid_end_bio_io()
	- add a small check at the start of raid1_reshape()
-> v4:
	- add fix tag and revise the commit message
	- drop patch 1 as there is an ongoing systematic fix for the bug
	- drop patch 3 as it's unrelated which will be sent in
	another patch

 drivers/md/raid1.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dd25832eb045..5a5eb5f1a224 100644
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
@@ -1373,6 +1374,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		return;
 	}
 
+ retry_write:
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
@@ -1388,7 +1390,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
- retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
 	max_sectors = r1_bio->sectors;
@@ -1468,7 +1469,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-		r1_bio->state = 0;
+		free_r1bio(r1_bio);
 		allow_barrier(conf, bio->bi_iter.bi_sector);
 
 		if (bio->bi_opf & REQ_NOWAIT) {
@@ -2498,6 +2499,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	struct mddev *mddev = conf->mddev;
 	struct bio *bio;
 	struct md_rdev *rdev;
+	sector_t sector;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
 	/* we got a read error. Maybe the drive is bad.  Maybe just
@@ -2527,12 +2529,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
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

