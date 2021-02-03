Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7AAC433E9
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 13:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3772464F78
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 13:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhBCNrh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 08:47:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231624AbhBCNrW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 08:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612359955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=uHgQGeoilVOLdBve6Q3thQVlJGNP2ZjZpHDp1HwD8Bw=;
        b=LLaWr5zjWwG7vKh4JC5cNXegJEj/K9QpE6tn2k+y3eLHcGQJysMSsigaxwYrj/7CnXpIc9
        J6ArpBD2qJHDY1vLJbzBA7S8QRlNn2burfSyJyEI8FkSOg/fptNr74e9zeYzg5RcsnkvP/
        cefVqWB1K8CGmgmg2SIeNAKrRT8pD/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-Yz-oYSoqNM2DnQGZTFnm7g-1; Wed, 03 Feb 2021 08:45:51 -0500
X-MC-Unique: Yz-oYSoqNM2DnQGZTFnm7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BD56107ACE8;
        Wed,  3 Feb 2021 13:45:50 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FF343828;
        Wed,  3 Feb 2021 13:45:46 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
Subject: [PATCH 3/5] md/raid10: pull codes that wait for blocked dev into one function
Date:   Wed,  3 Feb 2021 21:45:29 +0800
Message-Id: <1612359931-24209-4-git-send-email-xni@redhat.com>
In-Reply-To: <1612359931-24209-1-git-send-email-xni@redhat.com>
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The following patch will reuse these logics, so pull the same codes into
one function.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 118 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 51 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 891b249..388eb3f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1273,12 +1273,75 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
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
 
@@ -1336,8 +1399,9 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	r10_bio->read_slot = -1; /* make sure repl_bio gets freed */
 	raid10_find_phys(conf, r10_bio);
-retry_write:
-	blocked_rdev = NULL;
+
+	wait_blocked_dev(mddev, r10_bio);
+
 	rcu_read_lock();
 	max_sectors = r10_bio->sectors;
 
@@ -1348,16 +1412,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1378,15 +1432,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
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
@@ -1422,35 +1467,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
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

