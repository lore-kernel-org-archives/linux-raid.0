Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED4AC6FD1C
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCFVah (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjCFV3d (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA4572001
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N1eV3bxFZPfbGAzGwd0oen2B8BNg5mPqcX2IboFX07Q=;
        b=Mcr9ixtJCGy4soUUpe/UaIPJrALpSJktJjdasXmeMvsJm0QVXBud5hjWfRuK0O5+8Wrq3M
        W9gqfTtU2pOfnhNjdBO4v14lPErGcIL5RIiyQ8fu0hC+5Vlr5E+X/iZ5Yglcz8zCViQEq+
        XIFJJUXJ+6Qs5Zm1uF5RcQzsytSCyiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-FGcoIUFXMsWU2Vs8xkEZkw-1; Mon, 06 Mar 2023 16:28:26 -0500
X-MC-Unique: FGcoIUFXMsWU2Vs8xkEZkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7202080D0EE
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:26 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF01C40CF8F0;
        Mon,  6 Mar 2023 21:28:25 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 27/34] md: prefer using "%s...", __func__ [WARNING]
Date:   Mon,  6 Mar 2023 22:27:50 +0100
Message-Id: <cc62c50b96ea6bf6779a4990a2b320f183283f4b.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md-multipath.c |  2 +-
 drivers/md/md.c           |  4 ++--
 drivers/md/raid5.c        | 17 +++++++----------
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 6cc169abef00..34fd6db61d79 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -45,7 +45,7 @@ static int multipath_map(struct mpconf *conf)
 	}
 	rcu_read_unlock();
 
-	pr_crit_ratelimited("multipath_map(): no more operational IO paths?\n");
+	pr_crit_ratelimited("%s(): no more operational IO paths?\n", __func__);
 	return (-1);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a495fad762ae..6a4d01efaca5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2487,7 +2487,7 @@ void md_autodetect_dev(dev_t dev);
 
 static void export_rdev(struct md_rdev *rdev)
 {
-	pr_debug("md: export_rdev(%pg)\n", rdev->bdev);
+	pr_debug("md: %s(%pg)\n", __func__, rdev->bdev);
 	md_rdev_clear(rdev);
 #ifndef MODULE
 	if (test_bit(AutoDetected, &rdev->flags))
@@ -2763,7 +2763,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 		 mdname(mddev), mddev->in_sync);
 
 	if (mddev->queue)
-		blk_add_trace_msg(mddev->queue, "md md_update_sb");
+		blk_add_trace_msg(mddev->queue, "md %s", __func__);
 rewrite:
 	md_bitmap_update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b41d0918b914..84e4eaa937cf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -426,8 +426,7 @@ void raid5_release_stripe(struct stripe_head *sh)
 
 static inline void remove_hash(struct stripe_head *sh)
 {
-	pr_debug("remove_hash(), stripe %llu\n",
-		(unsigned long long)sh->sector);
+	pr_debug("%s(), stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
 	hlist_del_init(&sh->hash);
 }
@@ -436,8 +435,7 @@ static inline void insert_hash(struct r5conf *conf, struct stripe_head *sh)
 {
 	struct hlist_head *hp = stripe_hash(conf, sh->sector);
 
-	pr_debug("insert_hash(), stripe %llu\n",
-		(unsigned long long)sh->sector);
+	pr_debug("%s(), stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
 	hlist_add_head(&sh->hash, hp);
 }
@@ -587,8 +585,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 	BUG_ON(stripe_operations_active(sh));
 	BUG_ON(sh->batch_head);
 
-	pr_debug("init_stripe called, stripe %llu\n",
-		(unsigned long long)sector);
+	pr_debug("%s called, stripe %llu\n", __func__, (unsigned long long)sector);
 retry:
 	seq = read_seqcount_begin(&conf->gen_lock);
 	sh->generation = conf->generation - previous;
@@ -624,7 +621,7 @@ static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
 {
 	struct stripe_head *sh;
 
-	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
+	pr_debug("%s, sector %llu\n", __func__, (unsigned long long)sector);
 	hlist_for_each_entry(sh, stripe_hash(conf, sector), hash)
 		if (sh->sector == sector && sh->generation == generation)
 			return sh;
@@ -5537,7 +5534,7 @@ static void raid5_align_endio(struct bio *bi)
 		return;
 	}
 
-	pr_debug("raid5_align_endio : io error...handing IO for a retry\n");
+	pr_debug("%s : io error...handing IO for a retry\n", __func__);
 
 	add_bio_to_retry(raid_bi, conf);
 }
@@ -6783,7 +6780,7 @@ static void raid5d(struct md_thread *thread)
 	int handled;
 	struct blk_plug plug;
 
-	pr_debug("+++ raid5d active\n");
+	pr_debug("+++ %s active\n", __func__);
 
 	md_check_recovery(mddev);
 
@@ -6865,7 +6862,7 @@ static void raid5d(struct md_thread *thread)
 	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
 
-	pr_debug("--- raid5d inactive\n");
+	pr_debug("--- %s inactive\n", __func__);
 }
 
 static ssize_t
-- 
2.39.2

