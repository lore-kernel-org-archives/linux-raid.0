Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E14C64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjCFVa5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCFV3p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6F77587E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZT+zYrd42w2hEwUhNDan9G+eS6tQUPAGwnE6lNZF9vk=;
        b=fGp5k791Ze3DQRrv5CcmGHtnRk1kS63KUDwOKGabPA9AdEwTFVn4dVKsLyjL1IAtwndN2d
        TYSU//lu1d/p/i6mVRRA7W33sBHQ87eZjJR/g3zCgREgoeH5vqu+gDc1CYGB5bUK977GqO
        KpKEBSna3nm3606b1zCXbkG+CvYM8vs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-V34XgpbrMOKcR4QJNSmErQ-1; Mon, 06 Mar 2023 16:28:32 -0500
X-MC-Unique: V34XgpbrMOKcR4QJNSmErQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79224885625
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:32 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4FFC40CF8F0;
        Mon,  6 Mar 2023 21:28:31 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 33/34] md: avoid splitting quoted strings [WARNING]
Date:   Mon,  6 Mar 2023 22:27:56 +0100
Message-Id: <b170c3033fa0e150e86d8cf8ec67fe02e1d0b75c.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-bitmap.c  |  3 +--
 drivers/md/md-cluster.c |  4 ++--
 drivers/md/raid0.c      |  6 ++----
 drivers/md/raid1.c      |  3 +--
 drivers/md/raid10.c     |  3 +--
 drivers/md/raid5.c      | 17 +++++++----------
 6 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index dd752f04e3af..0ae7ab8244d7 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2041,8 +2041,7 @@ void md_bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 	counts = &bitmap->counts;
 
 	chunk_kb = bitmap->mddev->bitmap_info.chunksize >> 10;
-	seq_printf(seq, "bitmap: %lu/%lu pages [%luKB], "
-		   "%lu%s chunk",
+	seq_printf(seq, "bitmap: %lu/%lu pages [%luKB], %lu%s chunk",
 		   counts->pages - counts->missing_pages,
 		   counts->pages,
 		   (counts->pages - counts->missing_pages)
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index ac3a8afc28ee..c2d568194fb4 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -171,8 +171,8 @@ static int dlm_lock_sync_interruptible(struct dlm_lock_resource *res, int mode,
 			&res->lksb, res);
 		res->sync_locking_done = false;
 		if (unlikely(ret != 0))
-			pr_info("failed to cancel previous lock request "
-				 "%s return %d\n", res->name, ret);
+			pr_info("failed to cancel previous lock request %s return %d\n",
+				res->name, ret);
 		return -EPERM;
 	}
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index cedb91f84b69..f8897ab4baeb 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -90,8 +90,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 				      rdev1->bdev->bd_disk->queue));
 
 		rdev_for_each(rdev2, mddev) {
-			pr_debug("md/raid0:%s:   comparing %pg(%llu)"
-				 " with %pg(%llu)\n",
+			pr_debug("md/raid0:%s:   comparing %pg(%llu) with %pg(%llu)\n",
 				 mdname(mddev),
 				 rdev1->bdev,
 				 (unsigned long long)rdev1->sectors,
@@ -227,8 +226,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 					 rdev->bdev);
 				continue;
 			}
-			pr_debug("md/raid0:%s: checking %pg ..."
-				 " contained as device %d\n",
+			pr_debug("md/raid0:%s: checking %pg ... contained as device %d\n",
 				 mdname(mddev),
 				 rdev->bdev, c);
 			dev[c] = rdev;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8097e01cd63b..2f8fba6e9756 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -544,8 +544,7 @@ static void raid1_end_write_request(struct bio *bio)
 			if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
 				struct bio *mbio = r1_bio->master_bio;
 
-				pr_debug("raid1: behind end write sectors"
-					 " %llu-%llu\n",
+				pr_debug("raid1: behind end write sectors %llu-%llu\n",
 					 (unsigned long long) mbio->bi_iter.bi_sector,
 					 (unsigned long long) bio_end_sector(mbio) - 1);
 				call_bio_endio(r1_bio);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a95609d5e79c..60d7b1af229e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4168,8 +4168,7 @@ static int raid10_run(struct mddev *mddev)
 		fc = (mddev->layout >> 8) & 255;
 		fo = mddev->layout & (1<<16);
 		if (fc > 1 || fo > 0) {
-			pr_err("only near layout is supported by clustered"
-				" raid10\n");
+			pr_err("only near layout is supported by clustered raid10\n");
 			goto out_free_conf;
 		}
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fb6e0cf727a6..6b87481a9657 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1323,8 +1323,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			rbi->bi_end_io = raid5_end_write_request;
 			rbi->bi_private = sh;
 
-			pr_debug("%s: for %llu schedule op %d on "
-				 "replacement disc %d\n",
+			pr_debug("%s: for %llu schedule op %d on replacement disc %d\n",
 				__func__, (unsigned long long)sh->sector,
 				rbi->bi_opf, i);
 			atomic_inc(&sh->count);
@@ -4335,8 +4334,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 				if (test_bit(R5_Insync, &dev->flags) &&
 				    test_bit(STRIPE_PREREAD_ACTIVE,
 					     &sh->state)) {
-					pr_debug("Read_old block "
-						"%d for Reconstruct\n", i);
+					pr_debug("Read_old block %d for Reconstruct\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
@@ -4438,8 +4436,8 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
-				pr_warn_ratelimited("%s: mismatch sector in range "
-						    "%llu-%llu\n", mdname(conf->mddev),
+				pr_warn_ratelimited("%s: mismatch sector in range %llu-%llu\n",
+						    mdname(conf->mddev),
 						    (unsigned long long) sh->sector,
 						    (unsigned long long) sh->sector +
 						    RAID5_STRIPE_SECTORS(conf));
@@ -4603,8 +4601,8 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
-				pr_warn_ratelimited("%s: mismatch sector in range "
-						    "%llu-%llu\n", mdname(conf->mddev),
+				pr_warn_ratelimited("%s: mismatch sector in range %llu-%llu\n",
+						    mdname(conf->mddev),
 						    (unsigned long long) sh->sector,
 						    (unsigned long long) sh->sector +
 						    RAID5_STRIPE_SECTORS(conf));
@@ -5094,8 +5092,7 @@ static void handle_stripe(struct stripe_head *sh)
 		set_bit(STRIPE_BIOFILL_RUN, &sh->state);
 	}
 
-	pr_debug("locked=%d uptodate=%d to_read=%d"
-	       " to_write=%d failed=%d failed_num=%d,%d\n",
+	pr_debug("locked=%d uptodate=%d to_read=%d to_write=%d failed=%d failed_num=%d,%d\n",
 	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
 	       s.failed_num[0], s.failed_num[1]);
 	/*
-- 
2.39.2

