Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868FDC19F2D
	for <linux-raid@archiver.kernel.org>; Tue,  9 Aug 2022 18:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbiHISjo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Aug 2022 14:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245514AbiHISjP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 Aug 2022 14:39:15 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D146422FA
        for <linux-raid@vger.kernel.org>; Tue,  9 Aug 2022 11:14:24 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso18421437pjq.4
        for <linux-raid@vger.kernel.org>; Tue, 09 Aug 2022 11:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ro4+0D9hhUrJBnAFXXDC9F59JayiGrcor5eZD/LhVh0=;
        b=hToONKCVAHOo1l9tbqAqWzQHVqU/41AJvph9GB7FzEbxx8wBEvvegVKYoPVyrhlD4v
         A4ioRz7nROCUM1OLujU/2UQJxXmzgTg46poJrKECZv6ft1rB3a2+TBZxMXBumdDhbkgM
         XpV59uH18oy2QX7a97HlTyZ170hQyIBcCuORStcW5ajxnJ8o00stSaKjmTKl+X5KqXNU
         yLts+rMxG73s+fVuBelmf9ul2U65d1EwvynLoYSFggCouO332gX4gl5jtbRTxUCE9sIo
         DMkURi9xsGwgJPFv7e4X0U9vowxrJN7WyI4M5uLHqwUTtI5qHMB3/VFpj3oB28pcNvNV
         uKOA==
X-Gm-Message-State: ACgBeo2QWOPZLs4TGpLlUKVJmhy4bir+DbLgdJuLiM7sk3rkKhOQlz6j
        /AfzlZWM08FOutlxyy45HaUTpetnFO8=
X-Google-Smtp-Source: AA6agR40VEObnWA0/LSBVVi6LfCNHAzSfg0GXkrv0QlS3eyAGw8jRL8fvC74vGI1/5MxFop9tzuseQ==
X-Received: by 2002:a17:90a:e611:b0:1f4:f03b:affd with SMTP id j17-20020a17090ae61100b001f4f03baffdmr26459876pjy.85.1660068847266;
        Tue, 09 Aug 2022 11:14:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:61e9:2f41:c2d4:73d])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902e54700b0016c16648213sm11440388plf.20.2022.08.09.11.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 11:14:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Rong A Chen <rong.a.chen@intel.com>,
        Jens Axboe <axboe@kernel.dk>, kernel test robot <lkp@intel.com>
Subject: [PATCH] md/raid10: Fix a recently introduced sparse warning
Date:   Tue,  9 Aug 2022 11:13:58 -0700
Message-Id: <20220809181358.3111654-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Fix the following sparse warning:

drivers/md/raid10.c:2647:60: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected restricted blk_opf_t [usertype] opf @@     got int rw @@

This patch does not change any functionality since REQ_OP_READ = READ = 0
and since REQ_OP_WRITE = WRITE = 1.

Cc: Rong A Chen <rong.a.chen@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 4ce4c73f662b ("md/core: Combine two sync_page_io() arguments")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/raid10.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9117fcdee1be..c4dcaff1fb1d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2639,7 +2639,7 @@ static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 }
 
 static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			    int sectors, struct page *page, int rw)
+			    int sectors, struct page *page, enum req_op op)
 {
 	sector_t first_bad;
 	int bad_sectors;
@@ -2647,7 +2647,7 @@ static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
 	if (is_badblock(rdev, sector, sectors, &first_bad, &bad_sectors)
 	    && (rw == READ || test_bit(WriteErrorSeen, &rdev->flags)))
 		return -1;
-	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
+	if (sync_page_io(rdev, sector, sectors << 9, page, op, false))
 		/* success */
 		return 1;
 	if (rw == WRITE) {
@@ -2780,7 +2780,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			if (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s, conf->tmppage, WRITE)
+					     s, conf->tmppage, REQ_OP_WRITE)
 			    == 0) {
 				/* Well, this device is dead */
 				pr_notice("md/raid10:%s: read correction write failed (%d sectors at %llu on %pg)\n",
@@ -2814,8 +2814,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			switch (r10_sync_page_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s, conf->tmppage,
-						 READ)) {
+					     s, conf->tmppage, REQ_OP_READ)) {
 			case 0:
 				/* Well, this device is dead */
 				pr_notice("md/raid10:%s: unable to read back corrected sectors (%d sectors at %llu on %pg)\n",
