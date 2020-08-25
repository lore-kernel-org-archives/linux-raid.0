Return-Path: <SRS0=YcZW=CD=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709B9C433DF
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 05:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522E6204FD
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 05:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gQXVV6FP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgHYFnR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Aug 2020 01:43:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728145AbgHYFnR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Aug 2020 01:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598334195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=PtLoG0S3vzlaRrKzFpcy9t73aqOtBzYImVl0ZfDUaRA=;
        b=gQXVV6FPK1Fnthn70sv8o+xJMNPAAtFntEbrLSx0vJEt02yYI6F1WLxTjnYqodCmaExyDl
        LbFFkRbFC/O1s77KUiNt1HVYgKdDfon6LqNe3MS6MmWxHluywRCGaRP4KUKi9pYlGsxnhg
        pfAHWXgD35HFG69cjan/irBBLtbD/JQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-mUXSHrOfOxChLJXLebqvqg-1; Tue, 25 Aug 2020 01:43:13 -0400
X-MC-Unique: mUXSHrOfOxChLJXLebqvqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79D071084C89;
        Tue, 25 Aug 2020 05:43:12 +0000 (UTC)
Received: from xiao.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50F57100239B;
        Tue, 25 Aug 2020 05:43:08 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
Subject: [PATCH V5 1/5] md/raid10: move codes related with submitting discard bio into one function
Date:   Tue, 25 Aug 2020 13:42:59 +0800
Message-Id: <1598334183-25301-2-git-send-email-xni@redhat.com>
In-Reply-To: <1598334183-25301-1-git-send-email-xni@redhat.com>
References: <1598334183-25301-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

These codes can be used in raid10. So we can move these codes into
md.c. raid0 and raid10 can share these codes.

Reviewed-by: Coly Li <colyli@suse.de>
Reviewed-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    | 23 +++++++++++++++++++++++
 drivers/md/md.h    |  3 +++
 drivers/md/raid0.c | 15 ++-------------
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6072782..10743be 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8583,6 +8583,29 @@ void md_write_end(struct mddev *mddev)
 
 EXPORT_SYMBOL(md_write_end);
 
+/* This is used by raid0 and raid10 */
+void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
+				struct bio *bio,
+				sector_t dev_start, sector_t dev_end)
+{
+	struct bio *discard_bio = NULL;
+
+	if (__blkdev_issue_discard(rdev->bdev,
+	    dev_start + rdev->data_offset,
+	    dev_end - dev_start, GFP_NOIO, 0, &discard_bio) ||
+	    !discard_bio)
+		return;
+
+	bio_chain(discard_bio, bio);
+	bio_clone_blkg_association(discard_bio, bio);
+	if (mddev->gendisk)
+		trace_block_bio_remap(bdev_get_queue(rdev->bdev),
+			discard_bio, disk_devt(mddev->gendisk),
+			bio->bi_iter.bi_sector);
+	submit_bio_noacct(discard_bio);
+}
+EXPORT_SYMBOL(md_submit_discard_bio);
+
 /* md_allow_write(mddev)
  * Calling this ensures that the array is marked 'active' so that writes
  * may proceed without blocking.  It is important to call this before
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d9c4e6b..bae3bd5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -713,6 +713,9 @@ extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
+extern void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
+				struct bio *bio,
+				sector_t dev_start, sector_t dev_end);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f54a449..2868294 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -510,7 +510,6 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 
 	for (disk = 0; disk < zone->nb_dev; disk++) {
 		sector_t dev_start, dev_end;
-		struct bio *discard_bio = NULL;
 		struct md_rdev *rdev;
 
 		if (disk < start_disk_index)
@@ -533,18 +532,8 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 
 		rdev = conf->devlist[(zone - conf->strip_zone) *
 			conf->strip_zone[0].nb_dev + disk];
-		if (__blkdev_issue_discard(rdev->bdev,
-			dev_start + zone->dev_start + rdev->data_offset,
-			dev_end - dev_start, GFP_NOIO, 0, &discard_bio) ||
-		    !discard_bio)
-			continue;
-		bio_chain(discard_bio, bio);
-		bio_clone_blkg_association(discard_bio, bio);
-		if (mddev->gendisk)
-			trace_block_bio_remap(bdev_get_queue(rdev->bdev),
-				discard_bio, disk_devt(mddev->gendisk),
-				bio->bi_iter.bi_sector);
-		submit_bio_noacct(discard_bio);
+		dev_start += zone->dev_start;
+		md_submit_discard_bio(mddev, rdev, bio, dev_start, dev_end);
 	}
 	bio_endio(bio);
 }
-- 
2.7.5

