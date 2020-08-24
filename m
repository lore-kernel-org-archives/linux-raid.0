Return-Path: <SRS0=MG8V=CC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96FAC433E3
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 04:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4DC220768
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 04:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIxB/OMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHXEML (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Aug 2020 00:12:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44171 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727841AbgHXEMK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Aug 2020 00:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598242329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=5t3TL+JmqNT9tSx4u1bKUfH0MWLTNg+omdiiCiGhMxw=;
        b=DIxB/OMZzDUrPBP4NxKUsqUdWJvc9DLpjxOG+7Fd1nyjY8QmwBQBoYD4K0K0Ofy04TvIcq
        715Eud+jMnnduL1q5NAtthIGqA/EVmUyswG6R038bAyngOXplSwoMCaiOo9n0oOitpKXgK
        d7uchqIz4Q+6K8miQHvJmpI2JfAyGPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-14t8jlmmMYOzXOJ84by4UA-1; Mon, 24 Aug 2020 00:12:04 -0400
X-MC-Unique: 14t8jlmmMYOzXOJ84by4UA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC2DA1885DA7;
        Mon, 24 Aug 2020 04:12:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FF017E69B;
        Mon, 24 Aug 2020 04:12:01 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
Subject: [PATCH V4 3/5] md/raid10: pull codes that wait for blocked dev into one function
Date:   Mon, 24 Aug 2020 12:11:46 +0800
Message-Id: <1598242308-9619-4-git-send-email-xni@redhat.com>
In-Reply-To: <1598242308-9619-1-git-send-email-xni@redhat.com>
References: <1598242308-9619-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The following patch will do the same job. So pull the same codes
into one function.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 119 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 51 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c4c8477..68e7e6a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1275,12 +1275,76 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
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
+			/* Discard request doesn't care the write result
+			 * so it doesn't need to wait blocked disk here.
+			 */
+			if (!r10_bio->sectors)
+				continue;
+
+			is_bad = is_badblock(rdev, dev_sector, r10_bio->sectors,
+					     &first_bad, &bad_sectors);
+			if (is_bad < 0) {
+				/* Mustn't write here until the bad block
+				 * is acknowledged
+				 */
+				atomic_inc(&rdev->nr_pending);
+				set_bit(BlockedBadBlocks, &rdev->flags);
+				blocked_rdev = rdev;
+				break;
+			}
+		}
+
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
 
@@ -1338,8 +1402,9 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	r10_bio->read_slot = -1; /* make sure repl_bio gets freed */
 	raid10_find_phys(conf, r10_bio);
-retry_write:
-	blocked_rdev = NULL;
+
+	wait_blocked_dev(mddev, r10_bio);
+
 	rcu_read_lock();
 	max_sectors = r10_bio->sectors;
 
@@ -1350,16 +1415,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1380,15 +1435,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
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
@@ -1424,35 +1470,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
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

