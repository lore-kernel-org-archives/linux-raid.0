Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56602C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 05:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32B3E6108B
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 05:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbhHRF6b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Aug 2021 01:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237618AbhHRF6b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 18 Aug 2021 01:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629266276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=R7O2D9YbluH9jenZi3Pl5p3kpSbcwYjyil1ldQcM/Uw=;
        b=NPBPHYuAkOX8NyZSdfEy8kyA61tc9CKoHO/2DyziGyPUbJyPltmL3vhjl07ZKkaEOsT2j5
        VYt9Zlqvh5i1mKyDDDKrlUN8L1YMcZccgtoH6EQoKoQYRIBwfi9sV+8hdlbzsTdgZdXlrI
        UMRhNdAHUoFMF/XAZkwjG7243VzpqHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-CdSLihz-NH2ANpMeDLHZ7Q-1; Wed, 18 Aug 2021 01:57:54 -0400
X-MC-Unique: CdSLihz-NH2ANpMeDLHZ7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40A86801B3C;
        Wed, 18 Aug 2021 05:57:53 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E19A60916;
        Wed, 18 Aug 2021 05:57:50 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     ncroxon@redhat.com, linux-raid@vger.kernel.org,
        guoqing.jiang@linux.dev
Subject: [PATCH v2] md/raid10: Remove rcu_dereference when it doesn't need rcu lock to protect
Date:   Wed, 18 Aug 2021 13:57:48 +0800
Message-Id: <1629266268-3624-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

One warning message is triggered like this:
[  695.110751] =============================
[  695.131439] WARNING: suspicious RCU usage
[  695.151389] 4.18.0-319.el8.x86_64+debug #1 Not tainted
[  695.174413] -----------------------------
[  695.192603] drivers/md/raid10.c:1776 suspicious
rcu_dereference_check() usage!
[  695.225107] other info that might help us debug this:
[  695.260940] rcu_scheduler_active = 2, debug_locks = 1
[  695.290157] no locks held by mkfs.xfs/10186.

In the first loop of function raid10_handle_discard. It already
determines which disk need to handle discard request and add the
rdev reference count rdev->nr_pending. So the conf->mirrors will
not change until all bios come back from underlayer disks. It
doesn't need to use rcu_dereference to get rdev.

Fixes: d30588b2731f ('md/raid10: improve raid10 discard request')
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
V2: Fix comment style problem

 drivers/md/raid10.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 16977e8..d5d9233 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1712,6 +1712,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	} else
 		r10_bio->master_bio = (struct bio *)first_r10bio;
 
+	/*
+	 * first select target devices under rcu_lock and
+	 * inc refcount on their rdev.  Record them by setting
+	 * bios[x] to bio
+	 */
 	rcu_read_lock();
 	for (disk = 0; disk < geo->raid_disks; disk++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
@@ -1743,9 +1748,6 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	for (disk = 0; disk < geo->raid_disks; disk++) {
 		sector_t dev_start, dev_end;
 		struct bio *mbio, *rbio = NULL;
-		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		struct md_rdev *rrdev = rcu_dereference(
-			conf->mirrors[disk].replacement);
 
 		/*
 		 * Now start to calculate the start and end address for each disk.
@@ -1775,9 +1777,12 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 
 		/*
 		 * It only handles discard bio which size is >= stripe size, so
-		 * dev_end > dev_start all the time
+		 * dev_end > dev_start all the time.
+		 * It doesn't need to use rcu lock to get rdev here. We already
+		 * add rdev->nr_pending in the first loop.
 		 */
 		if (r10_bio->devs[disk].bio) {
+			struct md_rdev *rdev = conf->mirrors[disk].rdev;
 			mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 			mbio->bi_end_io = raid10_end_discard_request;
 			mbio->bi_private = r10_bio;
@@ -1790,6 +1795,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 			bio_endio(mbio);
 		}
 		if (r10_bio->devs[disk].repl_bio) {
+			struct md_rdev *rrdev = conf->mirrors[disk].replacement;
 			rbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 			rbio->bi_end_io = raid10_end_discard_request;
 			rbio->bi_private = r10_bio;
-- 
2.7.5

