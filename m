Return-Path: <SRS0=XO6g=CL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B0DC433E7
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 12:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE392078B
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 12:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0WbBU6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIBMBY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Sep 2020 08:01:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38436 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726307AbgIBMBE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Sep 2020 08:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599048056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=auDVl+pnNel3qm/JsrCAnfsKZrQmGAfBCWkgsKi4Lgc=;
        b=O0WbBU6gTVRlKK3PAY423DDrRNKLXSBsvlUPVMZX/KPoq9Mqq4IIA/5Y/Aj4FT4xjzgWM1
        p2T/lDSlLRvEIurPvNXLVuGbKAp3Niqh5YruKcsXhgZUF7TDGNcCXgNgyRbDBrhSC/2dp+
        WtobKfHhGfn1n5b36vjn6qi06VfA9wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-WvBTdNcENuuVaWqnN3zliw-1; Wed, 02 Sep 2020 08:00:52 -0400
X-MC-Unique: WvBTdNcENuuVaWqnN3zliw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73D2610ABDBB;
        Wed,  2 Sep 2020 12:00:51 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B1D17E581;
        Wed,  2 Sep 2020 12:00:46 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
Subject: [PATCH V6 1/3] md: calculate discard start address and size in specific raid type
Date:   Wed,  2 Sep 2020 20:00:21 +0800
Message-Id: <1599048023-9957-2-git-send-email-xni@redhat.com>
In-Reply-To: <1599048023-9957-1-git-send-email-xni@redhat.com>
References: <1599048023-9957-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

For raid10 it needs to choose new data offset and old offset
in reshape. So it's better to calculate discard start address
and size in specific raid type.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    | 9 +++------
 drivers/md/md.h    | 3 +--
 drivers/md/raid0.c | 5 +++--
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 10743be..e360d46 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8585,15 +8585,12 @@ EXPORT_SYMBOL(md_write_end);
 
 /* This is used by raid0 and raid10 */
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
-				struct bio *bio,
-				sector_t dev_start, sector_t dev_end)
+			struct bio *bio, sector_t start, sector_t size)
 {
 	struct bio *discard_bio = NULL;
 
-	if (__blkdev_issue_discard(rdev->bdev,
-	    dev_start + rdev->data_offset,
-	    dev_end - dev_start, GFP_NOIO, 0, &discard_bio) ||
-	    !discard_bio)
+	if (__blkdev_issue_discard(rdev->bdev, start, size,
+		GFP_NOIO, 0, &discard_bio) || !discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bae3bd5..da9997a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -714,8 +714,7 @@ extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 extern void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
-				struct bio *bio,
-				sector_t dev_start, sector_t dev_end);
+			struct bio *bio, sector_t start, sector_t size);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 2868294..d3da17b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -532,8 +532,9 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 
 		rdev = conf->devlist[(zone - conf->strip_zone) *
 			conf->strip_zone[0].nb_dev + disk];
-		dev_start += zone->dev_start;
-		md_submit_discard_bio(mddev, rdev, bio, dev_start, dev_end);
+		md_submit_discard_bio(mddev, rdev, bio,
+			dev_start + zone->dev_start + rdev->data_offset,
+			dev_end - dev_start);
 	}
 	bio_endio(bio);
 }
-- 
2.7.5

