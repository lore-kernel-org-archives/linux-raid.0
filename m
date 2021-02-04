Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E0AC433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 05:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F0064F58
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 05:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhBDF7B (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 00:59:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhBDF7A (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 00:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612418254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=8BFAVYSlpd7pWm8uFXJIyPgqARfuukU+KXTC7jIIjS0=;
        b=eMQwR1HKRZElFGa8o1J2X2OMkDSIP7e/+f6yggHGsW/rHkqNzzydmDycz4h5VetVWEnoND
        MVXl+AE8/mtFlBiTYBofYkPVlvjkTRrlCuHqBWL2ygMoR1dMTCnEf8NbMG8Cr3aeDYD2ak
        ZEVlj/Rw6f+FG3OFnBSmYcqosKPsqDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-EgKNlFFKMXqlR8y64WEkgg-1; Thu, 04 Feb 2021 00:57:30 -0500
X-MC-Unique: EgKNlFFKMXqlR8y64WEkgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7DFC801962;
        Thu,  4 Feb 2021 05:57:28 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 546F160C13;
        Thu,  4 Feb 2021 05:57:24 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com,
        hch@infradead.org
Subject: [PATCH V2 1/5] md: add md_submit_discard_bio() for submitting discard bio
Date:   Thu,  4 Feb 2021 13:57:14 +0800
Message-Id: <1612418238-9976-2-git-send-email-xni@redhat.com>
In-Reply-To: <1612418238-9976-1-git-send-email-xni@redhat.com>
References: <1612418238-9976-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Move these logic from raid0.c to md.c, so that we can also use it in
raid10.c.

Reviewed-by: Coly Li <colyli@suse.de>
Reviewed-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    | 20 ++++++++++++++++++++
 drivers/md/md.h    |  2 ++
 drivers/md/raid0.c | 14 ++------------
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7d1bb24..f18cd0d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8590,6 +8590,26 @@ void md_write_end(struct mddev *mddev)
 
 EXPORT_SYMBOL(md_write_end);
 
+/* This is used by raid0 and raid10 */
+void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
+			struct bio *bio, sector_t start, sector_t size)
+{
+	struct bio *discard_bio = NULL;
+
+	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, 0,
+			&discard_bio) || !discard_bio)
+		return;
+
+	bio_chain(discard_bio, bio);
+	bio_clone_blkg_association(discard_bio, bio);
+	if (mddev->gendisk)
+		trace_block_bio_remap(discard_bio,
+				disk_devt(mddev->gendisk),
+				bio->bi_iter.bi_sector);
+	submit_bio_noacct(discard_bio);
+}
+EXPORT_SYMBOL_GPL(md_submit_discard_bio);
+
 /* md_allow_write(mddev)
  * Calling this ensures that the array is marked 'active' so that writes
  * may proceed without blocking.  It is important to call this before
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f13290c..501fdcc57 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -713,6 +713,8 @@ extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
+extern void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
+			struct bio *bio, sector_t start, sector_t size);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 67f157f..e5d7411 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -477,7 +477,6 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 
 	for (disk = 0; disk < zone->nb_dev; disk++) {
 		sector_t dev_start, dev_end;
-		struct bio *discard_bio = NULL;
 		struct md_rdev *rdev;
 
 		if (disk < start_disk_index)
@@ -500,18 +499,9 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 
 		rdev = conf->devlist[(zone - conf->strip_zone) *
 			conf->strip_zone[0].nb_dev + disk];
-		if (__blkdev_issue_discard(rdev->bdev,
+		md_submit_discard_bio(mddev, rdev, bio,
 			dev_start + zone->dev_start + rdev->data_offset,
-			dev_end - dev_start, GFP_NOIO, 0, &discard_bio) ||
-		    !discard_bio)
-			continue;
-		bio_chain(discard_bio, bio);
-		bio_clone_blkg_association(discard_bio, bio);
-		if (mddev->gendisk)
-			trace_block_bio_remap(discard_bio,
-				disk_devt(mddev->gendisk),
-				bio->bi_iter.bi_sector);
-		submit_bio_noacct(discard_bio);
+			dev_end - dev_start);
 	}
 	bio_endio(bio);
 }
-- 
2.7.5

