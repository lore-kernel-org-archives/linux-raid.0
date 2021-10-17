Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7752C433FE
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 13:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAABE61054
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 13:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343778AbhJQNxE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Oct 2021 09:53:04 -0400
Received: from out2.migadu.com ([188.165.223.204]:45980 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343774AbhJQNxB (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 17 Oct 2021 09:53:01 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634478650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=754KybrJUttHLrFqoBToe6FRTDaOh5GFqNzP1TUeO+c=;
        b=PtITK1o8G4mSqINvfuMxnLOaoI7+nQ0Qp3kNVKI6NdGdYz0+oBoRvqGre5k8nHIIN1b9+X
        fpDGXHin1/lISsqlGI9850jf9gqnyOX3Qjts2vhq3ujqAScOSgLr9Kc8yTHJyrTwgdW5Qu
        aT4EhkiK9jxn1NIBeKrkDmsiF73BuH0=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/3] md/raid10: factor out a get_error_dev helper
Date:   Sun, 17 Oct 2021 21:50:19 +0800
Message-Id: <20211017135019.27346-4-guoqing.jiang@linux.dev>
In-Reply-To: <20211017135019.27346-1-guoqing.jiang@linux.dev>
References: <20211017135019.27346-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add a helper to find error_dev in case handle_read_err is true.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/raid10.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 49f3187b2d46..35d842ec377b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1115,6 +1115,27 @@ static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 	}
 }
 
+static void get_error_dev(struct mddev *mddev, struct r10conf *conf, int slot,
+			  struct md_rdev **err_rdev, struct r10bio *r10_bio)
+{
+	/*
+	 * This is an error retry, but we cannot
+	 * safely dereference the rdev in the r10_bio,
+	 * we must use the one in conf.
+	 * If it has already been disconnected (unlikely)
+	 * we lose the device name in error messages.
+	 */
+	int disk;
+
+	rcu_read_lock();
+	disk = r10_bio->devs[slot].devnum;
+	*err_rdev = rcu_dereference(conf->mirrors[disk].rdev);
+	if (!*err_rdev)
+		/* This never gets dereferenced */
+		*err_rdev = r10_bio->devs[slot].rdev;
+	rcu_read_unlock();
+}
+
 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 				struct r10bio *r10_bio, bool handle_read_err)
 {
@@ -1130,37 +1151,18 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	gfp_t gfp = GFP_NOIO;
 
 	if (handle_read_err && slot >= 0 && r10_bio->devs[slot].rdev) {
-		/*
-		 * This is an error retry, but we cannot
-		 * safely dereference the rdev in the r10_bio,
-		 * we must use the one in conf.
-		 * If it has already been disconnected (unlikely)
-		 * we lose the device name in error messages.
-		 */
-		int disk;
 		/*
 		 * As we are blocking raid10, it is a little safer to
 		 * use __GFP_HIGH.
 		 */
 		gfp = GFP_NOIO | __GFP_HIGH;
-
-		rcu_read_lock();
-		disk = r10_bio->devs[slot].devnum;
-		err_rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		if (err_rdev)
-			bdevname(err_rdev->bdev, b);
-		else {
-			strcpy(b, "???");
-			/* This never gets dereferenced */
-			err_rdev = r10_bio->devs[slot].rdev;
-		}
-		rcu_read_unlock();
+		get_error_dev(mddev, conf, slot, &err_rdev, r10_bio);
 	}
-
 	regular_request_wait(mddev, conf, bio, r10_bio->sectors);
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (!rdev) {
 		if (err_rdev) {
+			bdevname(err_rdev->bdev, b);
 			pr_crit_ratelimited("md/raid10:%s: %s: unrecoverable I/O read error for block %llu\n",
 					    mdname(mddev), b,
 					    (unsigned long long)r10_bio->sector);
-- 
2.31.1

