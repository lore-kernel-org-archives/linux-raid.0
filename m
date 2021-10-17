Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F2DC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 13:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98A6161027
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 13:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343776AbhJQNxD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Oct 2021 09:53:03 -0400
Received: from out2.migadu.com ([188.165.223.204]:45959 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhJQNxA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 17 Oct 2021 09:53:00 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634478649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lkuakjOFJBiXbbc3xG0NBKOY44kMZHe84MNCfBQ6Op4=;
        b=M6Q7Pv8icGebhkK7AbqOWTcl+bsr8BnGAw8FexCJbyQzTs3BXeWFwiBEFViPlTv6VFkgyv
        l0gKxUaz0BzYlwKnLuN/7deDc4u+8UIBpN3D+CfXLNnvm9jcnFbGyAon3kcAxXHHJDobuk
        d9hWaYfWd8MyyvsJSSqgiHXnLZJdi3o=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/3] md/raid10: add 'read_err' to raid10_read_request
Date:   Sun, 17 Oct 2021 21:50:18 +0800
Message-Id: <20211017135019.27346-3-guoqing.jiang@linux.dev>
In-Reply-To: <20211017135019.27346-1-guoqing.jiang@linux.dev>
References: <20211017135019.27346-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add the paramenter since the err retry logic is only meaningful when
the caller is handle_read_error.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/raid10.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dde98f65bd04..49f3187b2d46 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1116,7 +1116,7 @@ static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 }
 
 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
-				struct r10bio *r10_bio)
+				struct r10bio *r10_bio, bool handle_read_err)
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
@@ -1129,7 +1129,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
 
-	if (slot >= 0 && r10_bio->devs[slot].rdev) {
+	if (handle_read_err && slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
 		 * safely dereference the rdev in the r10_bio,
@@ -1519,7 +1519,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 			conf->geo.raid_disks);
 
 	if (bio_data_dir(bio) == READ)
-		raid10_read_request(mddev, bio, r10_bio);
+		raid10_read_request(mddev, bio, r10_bio, false);
 	else
 		raid10_write_request(mddev, bio, r10_bio);
 }
@@ -2918,7 +2918,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	rdev_dec_pending(rdev, mddev);
 	allow_barrier(conf);
 	r10_bio->state = 0;
-	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
+	raid10_read_request(mddev, r10_bio->master_bio, r10_bio, true);
 }
 
 static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
-- 
2.31.1

