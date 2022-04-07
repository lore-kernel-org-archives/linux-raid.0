Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6B4C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  7 Apr 2022 17:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346136AbiDGRYW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Apr 2022 13:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346139AbiDGRYJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Apr 2022 13:24:09 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A38213F42;
        Thu,  7 Apr 2022 10:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=8A2LLz32tCEzRewNnQLykD+6PqGRxl8cxRVvTKPtTeQ=; b=MbTP8kOnFBzPY2nh4TMKjRI/O2
        fxolg8y0bbcKWFS/oE8KzsRTLvDVNWeuZyAsSzuu4l/yEPxMQFY5AAHDOiasLJUJlP8D6evspaHDu
        fIlLlEyJb1Dbq4rwCiPsSG69WF5Gzk5alMcQAvI1r2zFqMXQx6Prvl+qCeYPWDoWKz7mgifxgRhof
        R6Rs5Y2YV8M7y0krVNAnEk2PdE6T+WDxmtPiRFlywuiltEbKTm2+94Q1kJRf7/q5NR/UqMEJgRPRE
        RBfTsviOzYOkzhUGwKaDvegje8pgSi1bQl4A+fiW10sRs+hJu4neqMMcDqfctGCQ4qXNHATEtRjKW
        MxNEW7hg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ncVG1-002CHo-9v; Thu, 07 Apr 2022 10:45:19 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ncVG0-0002Dk-Dr; Thu, 07 Apr 2022 10:45:16 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Shaohua Li <shli@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu,  7 Apr 2022 10:45:07 -0600
Message-Id: <20220407164511.8472-5-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407164511.8472-1-logang@deltatee.com>
References: <20220407164511.8472-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, shli@kernel.org, guoqing.jiang@linux.dev, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v1 4/8] md/raid5: Make common label for schedule/retry in raid5_make_request()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Cleanup the code to make a common label for the schedule,
prepare_to_wait() and retry path. This drops the do_prepare boolean.

This requires moveing the prepare_to_wait() above the
read_seqcount_begin() call on the retry path. However there's no
appearant requirement for ordering between these two calls.

This should hopefully be easier to read rather than following the
extra do_prepare boolean, but it will also be used in a subsequent
patch to add more code common to all schedule() calls.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid5.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index be01c4515f0e..f963ffb35484 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5742,7 +5742,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
 	DEFINE_WAIT(w);
-	bool do_prepare;
 	bool do_flush = false;
 
 	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
@@ -5803,13 +5802,9 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		int previous;
 		int seq;
 
-		do_prepare = false;
 	retry:
 		seq = read_seqcount_begin(&conf->gen_lock);
 		previous = 0;
-		if (do_prepare)
-			prepare_to_wait(&conf->wait_for_overlap, &w,
-				TASK_UNINTERRUPTIBLE);
 		if (unlikely(conf->reshape_progress != MaxSector)) {
 			/* spinlock is needed as reshape_progress may be
 			 * 64bit on a 32bit platform, and so it might be
@@ -5829,9 +5824,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 				    ? logical_sector < conf->reshape_safe
 				    : logical_sector >= conf->reshape_safe) {
 					spin_unlock_irq(&conf->device_lock);
-					schedule();
-					do_prepare = true;
-					goto retry;
+					goto schedule_and_retry;
 				}
 			}
 			spin_unlock_irq(&conf->device_lock);
@@ -5872,9 +5865,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			spin_unlock_irq(&conf->device_lock);
 			if (must_retry) {
 				raid5_release_stripe(sh);
-				schedule();
-				do_prepare = true;
-				goto retry;
+				goto schedule_and_retry;
 			}
 		}
 		if (read_seqcount_retry(&conf->gen_lock, seq)) {
@@ -5891,9 +5882,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			 */
 			md_wakeup_thread(mddev->thread);
 			raid5_release_stripe(sh);
-			schedule();
-			do_prepare = true;
-			goto retry;
+			goto schedule_and_retry;
 		}
 
 		if (stripe_can_batch(sh))
@@ -5913,6 +5902,13 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			atomic_inc(&conf->preread_active_stripes);
 
 		release_stripe_plug(mddev, sh);
+		continue;
+
+schedule_and_retry:
+		schedule();
+		prepare_to_wait(&conf->wait_for_overlap, &w,
+				TASK_UNINTERRUPTIBLE);
+		goto retry;
 	}
 	finish_wait(&conf->wait_for_overlap, &w);
 
-- 
2.30.2

