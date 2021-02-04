Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FE7C433E0
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C8E464F55
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhBDHwh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 02:52:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234740AbhBDHwe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 02:52:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612425068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=NrC9kOao5VaBJH8otSmom9J8ZpiXoWuwqjDRNcP4u4s=;
        b=asu33saL7Zmc/43ot7lMIjezp+ocugBoUjQpD0uw1Q3qoABHYLR8CRJzWUNtBB8CFCZUYB
        qkMo4WVqnRJd7NvBHi+kh+GHIE8DwuNk9e4nMW6je9uQiy/dh66C+gfL+RhylCEAg7DztZ
        LXgFcfHDwEWXJ3Nbtd8GyfnfVg/dG/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-XZgS3ignMWqpsVTnC8tt0g-1; Thu, 04 Feb 2021 02:51:06 -0500
X-MC-Unique: XZgS3ignMWqpsVTnC8tt0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 987D4107ACC7;
        Thu,  4 Feb 2021 07:51:05 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D2875B695;
        Thu,  4 Feb 2021 07:51:00 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
Subject: [PATCH V2 3/5] md/raid10: pull the code that wait for blocked dev into one function
Date:   Thu,  4 Feb 2021 15:50:45 +0800
Message-Id: <1612425047-10953-4-git-send-email-xni@redhat.com>
In-Reply-To: <1612425047-10953-1-git-send-email-xni@redhat.com>
References: <1612425047-10953-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The following patch will reuse these logics, so pull the same codes into
one function.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 120 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 51 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a734de..ea97ce3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1273,12 +1273,77 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	}
 }
 
+static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
+{
+	int i;
+	struct r10conf *conf = mddev->private;
+	struct md_rdev *blocked_rdev;
+
+retry_wait:
+	blocked_rdev = NULL;
+	rcu_read_lock();
+	for (i = 0; i < conf->copies; i++) {
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		struct md_rdev *rrdev = rcu_dereference(
+			conf->mirrors[i].replacement);
+		if (rdev == rrdev)
+			rrdev = NULL;
+		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
+			atomic_inc(&rdev->nr_pending);
+			blocked_rdev = rdev;
+			break;
+		}
+		if (rrdev && unlikely(test_bit(Blocked, &rrdev->flags))) {
+			atomic_inc(&rrdev->nr_pending);
+			blocked_rdev = rrdev;
+			break;
+		}
+
+		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
+			sector_t first_bad;
+			sector_t dev_sector = r10_bio->devs[i].addr;
+			int bad_sectors;
+			int is_bad;
+
+			/*
+			 * Discard request doesn't care the write result
+			 * so it doesn't need to wait blocked disk here.
+			 */
+			if (!r10_bio->sectors)
+				continue;
+
+			is_bad = is_badblock(rdev, dev_sector, r10_bio->sectors,
+					     &first_bad, &bad_sectors);
+			if (is_bad < 0) {
+				/*
+				 * Mustn't write here until the bad block
+				 * is acknowledged
+				 */
+				atomic_inc(&rdev->nr_pending);
+				set_bit(BlockedBadBlocks, &rdev->flags);
+				blocked_rdev = rdev;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	if (unlikely(blocked_rdev)) {
+		/* Have to wait for this device to get unblocked, then retry */
+		allow_barrier(conf);
+		raid10_log(conf->mddev, "%s wait rdev %d blocked",
+				__func__, blocked_rdev->raid_disk);
+		md_wait_for_blocked_rdev(blocked_rdev, mddev);
+		wait_barrier(conf);
+		goto retry_wait;
+	}
+}
+
 static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
 	int i;
-	struct md_rdev *blocked_rdev;
 	sector_t sectors;
 	int max_sectors;
 
@@ -1336,8 +1401,9 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	r10_bio->read_slot = -1; /* make sure repl_bio gets freed */
 	raid10_find_phys(conf, r10_bio);
-retry_write:
-	blocked_rdev = NULL;
+
+	wait_blocked_dev(mddev, r10_bio);
+
 	rcu_read_lock();
 	max_sectors = r10_bio->sectors;
 
@@ -1348,16 +1414,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			conf->mirrors[d].replacement);
 		if (rdev == rrdev)
 			rrdev = NULL;
-		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
-			atomic_inc(&rdev->nr_pending);
-			blocked_rdev = rdev;
-			break;
-		}
-		if (rrdev && unlikely(test_bit(Blocked, &rrdev->flags))) {
-			atomic_inc(&rrdev->nr_pending);
-			blocked_rdev = rrdev;
-			break;
-		}
 		if (rdev && (test_bit(Faulty, &rdev->flags)))
 			rdev = NULL;
 		if (rrdev && (test_bit(Faulty, &rrdev->flags)))
@@ -1378,15 +1434,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 			is_bad = is_badblock(rdev, dev_sector, max_sectors,
 					     &first_bad, &bad_sectors);
-			if (is_bad < 0) {
-				/* Mustn't write here until the bad block
-				 * is acknowledged
-				 */
-				atomic_inc(&rdev->nr_pending);
-				set_bit(BlockedBadBlocks, &rdev->flags);
-				blocked_rdev = rdev;
-				break;
-			}
 			if (is_bad && first_bad <= dev_sector) {
 				/* Cannot write here at all */
 				bad_sectors -= (dev_sector - first_bad);
@@ -1422,35 +1469,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	}
 	rcu_read_unlock();
 
-	if (unlikely(blocked_rdev)) {
-		/* Have to wait for this device to get unblocked, then retry */
-		int j;
-		int d;
-
-		for (j = 0; j < i; j++) {
-			if (r10_bio->devs[j].bio) {
-				d = r10_bio->devs[j].devnum;
-				rdev_dec_pending(conf->mirrors[d].rdev, mddev);
-			}
-			if (r10_bio->devs[j].repl_bio) {
-				struct md_rdev *rdev;
-				d = r10_bio->devs[j].devnum;
-				rdev = conf->mirrors[d].replacement;
-				if (!rdev) {
-					/* Race with remove_disk */
-					smp_mb();
-					rdev = conf->mirrors[d].rdev;
-				}
-				rdev_dec_pending(rdev, mddev);
-			}
-		}
-		allow_barrier(conf);
-		raid10_log(conf->mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
-		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf);
-		goto retry_write;
-	}
-
 	if (max_sectors < r10_bio->sectors)
 		r10_bio->sectors = max_sectors;
 
-- 
2.7.5

