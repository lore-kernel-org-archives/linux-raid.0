Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF780C25B07
	for <linux-raid@archiver.kernel.org>; Wed, 10 Aug 2022 18:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiHJSUW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Aug 2022 14:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJSUU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Aug 2022 14:20:20 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA941DA7B
        for <linux-raid@vger.kernel.org>; Wed, 10 Aug 2022 11:20:19 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id f192so14414543pfa.9
        for <linux-raid@vger.kernel.org>; Wed, 10 Aug 2022 11:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ixdjr3sgpBqBSfaiOC77P7qdemAmqfMtgfCUrhKJuAY=;
        b=MdCFlxieZSBWdft3R0arXMj+A3OjJNvwTcbQ06DV+wMIqNJjoiyGnk9tELReRoNmVq
         CmuIPlXjSBd/cO1oMWuXSDXAMKCIHhtL1msXwlLMC8YDWjav18HzBwffGCUKB1nVdyQ6
         BA9u5Aw0mDHj/yCqGlObvyPl48EHLIiQ1CJ9Zwd5NDMgkSF+Ju2oHIr/omLArBUdJPfJ
         FLOaW3Kc18tiPb+5FgCzsAxkf47JVkI8PmDVBzUx5jOWA8C0E63O+53gOFtLdy8e81XY
         Ik6GAScshCkOWUco3cRht/ZQqUinq+I8yctASTqLNsxHSW0s5dYvKKXUI2gmgTV4SXxw
         Ubkw==
X-Gm-Message-State: ACgBeo2L121ozPpsJ2QgTmckGqmR0qxkjYZNRX0oFPFN8vPwAavz/Rak
        OclF5y9M1MNuugTYPEXPKQ4=
X-Google-Smtp-Source: AA6agR7ciNBD7gMHw7bAWHOVM78DtyQFe3Q/beWCJLlmm1gQW5wE/6suiQB3w7InJ8uS6SBaIEww+A==
X-Received: by 2002:a63:f412:0:b0:41b:cbd:bcd7 with SMTP id g18-20020a63f412000000b0041b0cbdbcd7mr24510790pgi.30.1660155618804;
        Wed, 10 Aug 2022 11:20:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:85c9:163f:8564:e41f])
        by smtp.gmail.com with ESMTPSA id u23-20020a1709026e1700b0016dafeda062sm13221696plk.232.2022.08.10.11.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 11:20:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Rong A Chen <rong.a.chen@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2] md/raid10: Fix the data type of an r10_sync_page_io() argument
Date:   Wed, 10 Aug 2022 11:20:12 -0700
Message-Id: <20220810182012.755167-1-bvanassche@acm.org>
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
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Fixes: 4ce4c73f662b ("md/core: Combine two sync_page_io() arguments")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: made the patch subject more specific.

 drivers/md/raid10.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9117fcdee1be..64d6e4cd8a3a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2639,18 +2639,18 @@ static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 }
 
 static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			    int sectors, struct page *page, int rw)
+			    int sectors, struct page *page, enum req_op op)
 {
 	sector_t first_bad;
 	int bad_sectors;
 
 	if (is_badblock(rdev, sector, sectors, &first_bad, &bad_sectors)
-	    && (rw == READ || test_bit(WriteErrorSeen, &rdev->flags)))
+	    && (op == REQ_OP_READ || test_bit(WriteErrorSeen, &rdev->flags)))
 		return -1;
-	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
+	if (sync_page_io(rdev, sector, sectors << 9, page, op, false))
 		/* success */
 		return 1;
-	if (rw == WRITE) {
+	if (op == REQ_OP_WRITE) {
 		set_bit(WriteErrorSeen, &rdev->flags);
 		if (!test_and_set_bit(WantReplacement, &rdev->flags))
 			set_bit(MD_RECOVERY_NEEDED,
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
