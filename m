Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E17C072A2
	for <linux-raid@archiver.kernel.org>; Sat, 18 Nov 2023 00:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbjKRAkK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Nov 2023 19:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjKRAkJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Nov 2023 19:40:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDD493
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 16:40:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A28DC433C8;
        Sat, 18 Nov 2023 00:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700268006;
        bh=bONo3JWLmmf5t4W5DM3Xs4WIwL5POGRaxigm9Sd0Uqg=;
        h=From:To:Cc:Subject:Date:From;
        b=cHnoRoGpXIOcF6EJGmUP5vWpPCkkvciU3JOQh8tq00aBNAUmwal6kudTqsTpCmqVd
         Ac17IbrjkxG8Ez5xuqmLdaDXzhsMzZr/jCefhbfBigRR8qtItGOBR9KnrL2Ib7VH03
         eoR5DaH8Tqztixp2Nz7LHD0ScCJYorh4ca2dOJtLfa8pDfZDMEH0h07O7pIM3xmpyE
         IhO5CTt7BRO7SSjLR5eQmNHj9H0HvHxbncGrtSR+2ewkguqCqmSxwYlf6xcYuxwdke
         V/ZCzOYZZZMLSD68Tnc9Jy5oJrKIJ4t3PeroSpq80eRXZMtCLzx/HK8UYGXu4U9Qj8
         b8mbtA6MWtwJA==
From:   Song Liu <song@kernel.org>
To:     linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>,
        Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Xiao Ni <xni@redhat.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH] md: fix bi_status reporting in md_end_clone_io
Date:   Fri, 17 Nov 2023 16:39:58 -0800
Message-Id: <20231118003958.2740032-1-song@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

md_end_clone_io() may overwrite error status in orig_bio->bi_status with
BLK_STS_OK. This could happen when orig_bio has BIO_CHAIN (split by
md_submit_bio => bio_split_to_limits, for example). As a result, upper
layer may miss error reported from md (or the device) and consider the
failed IO was successful.

Fix this by only update orig_bio->bi_status when current bio reports
error and orig_bio is BLK_STS_OK. This is the same behavior as
__bio_chain_endio().

Fixes: 10764815ff47 ("md: add io accounting for raid0 and raid5")
Reported-by: Bhanu Victor DiCara <00bvd0+linux@gmail.com>
Closes: https://lore.kernel.org/regressions/5727380.DvuYhMxLoT@bvd0/
Signed-off-by: Song Liu <song@kernel.org>
Tested-by: Xiao Ni <xni@redhat.com>
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ee4593c874a..c94373d64f2c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8666,7 +8666,8 @@ static void md_end_clone_io(struct bio *bio)
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
-	orig_bio->bi_status = bio->bi_status;
+	if (bio->bi_status && !orig_bio->bi_status)
+		orig_bio->bi_status = bio->bi_status;
 
 	if (md_io_clone->start_time)
 		bio_end_io_acct(orig_bio, md_io_clone->start_time);
-- 
2.34.1

