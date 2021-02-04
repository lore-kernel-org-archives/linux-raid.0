Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD37AC433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 05:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 953F864E55
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 05:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhBDF7R (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 00:59:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53043 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhBDF7R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 00:59:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612418271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=SnfJ5bTL+AOXIpG4BIE64j8FVpkzKMfveJCUnuyt/kI=;
        b=Wv61KBuVT3Z8THm8ZksQ2Eq4izN6wrtgZT/hUHKslWpFS+nNQ9V7LzhvtrweM0X1hEkz2u
        idE7r3KEwlzAT30aLFluGirUfXLRb1bxMXccSoUn0koEITOntderXtTZmG/bb8u4LvoFYe
        6Pk4QUNDflaWfJbR6JB7lk5IXg36doU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-MJ4MrC1YPtC_PD2IutcuOw-1; Thu, 04 Feb 2021 00:57:49 -0500
X-MC-Unique: MJ4MrC1YPtC_PD2IutcuOw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AA47107ACF6;
        Thu,  4 Feb 2021 05:57:48 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB13060C13;
        Thu,  4 Feb 2021 05:57:44 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com,
        hch@infradead.org
Subject: [PATCH V2 5/5] md/raid10: improve discard request for far layout
Date:   Thu,  4 Feb 2021 13:57:18 +0800
Message-Id: <1612418238-9976-6-git-send-email-xni@redhat.com>
In-Reply-To: <1612418238-9976-1-git-send-email-xni@redhat.com>
References: <1612418238-9976-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

For far layout, the discard region is not continuous on disks. So it needs
far copies r10bio to cover all regions. It needs a way to know all r10bios
have finish or not. Similar with raid10_sync_request, only the first r10bio
master_bio records the discard bio. Other r10bios master_bio record the
first r10bio. The first r10bio can finish after other r10bios finish and
then return the discard bio.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 79 ++++++++++++++++++++++++++++++++++++++++-------------
 drivers/md/raid10.h |  1 +
 2 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 73d1b250..f78212d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1518,6 +1518,28 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 		raid10_write_request(mddev, bio, r10_bio);
 }
 
+static void raid_end_discard_bio(struct r10bio *r10bio)
+{
+	struct r10conf *conf = r10bio->mddev->private;
+	struct r10bio *first_r10bio;
+
+	while (atomic_dec_and_test(&r10bio->remaining)) {
+
+		allow_barrier(conf);
+
+		if (!test_bit(R10BIO_Discard, &r10bio->state)) {
+			first_r10bio = (struct r10bio *)r10bio->master_bio;
+			free_r10bio(r10bio);
+			r10bio = first_r10bio;
+		} else {
+			md_write_end(r10bio->mddev);
+			bio_endio(r10bio->master_bio);
+			free_r10bio(r10bio);
+			break;
+		}
+	}
+}
+
 static void raid10_end_discard_request(struct bio *bio)
 {
 	struct r10bio *r10_bio = bio->bi_private;
@@ -1545,11 +1567,7 @@ static void raid10_end_discard_request(struct bio *bio)
 		rdev = conf->mirrors[dev].rdev;
 	}
 
-	if (atomic_dec_and_test(&r10_bio->remaining)) {
-		md_write_end(r10_bio->mddev);
-		raid_end_bio_io(r10_bio);
-	}
-
+	raid_end_discard_bio(r10_bio);
 	rdev_dec_pending(rdev, conf->mddev);
 }
 
@@ -1563,7 +1581,9 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct geom *geo = &conf->geo;
-	struct r10bio *r10_bio;
+	int far_copies = geo->far_copies;
+	bool first_copy = true;
+	struct r10bio *r10_bio, *first_r10bio;
 	struct bio *split;
 	int disk;
 	sector_t chunk;
@@ -1637,16 +1657,6 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		wait_barrier(conf);
 	}
 
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
-	r10_bio->mddev = mddev;
-	r10_bio->state = 0;
-	r10_bio->sectors = 0;
-	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
-
-	wait_blocked_dev(mddev, r10_bio);
-
-	r10_bio->master_bio = bio;
-
 	bio_start = bio->bi_iter.bi_sector;
 	bio_end = bio_end_sector(bio);
 
@@ -1673,6 +1683,29 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	end_disk_offset = (bio_end & geo->chunk_mask) +
 				(last_stripe_index << geo->chunk_shift);
 
+retry_discard:
+	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio->mddev = mddev;
+	r10_bio->state = 0;
+	r10_bio->sectors = 0;
+	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
+	wait_blocked_dev(mddev, r10_bio);
+
+	/*
+	 * For far layout it needs more than one r10bio to cover all regions.
+	 * Inspired by raid10_sync_request, we can use the first r10bio->master_bio
+	 * to record the discard bio. Other r10bio->master_bio record the first
+	 * r10bio. The first r10bio only release after all other r10bios finish.
+	 * The discard bio returns only first r10bio finishes
+	 */
+	if (first_copy) {
+		r10_bio->master_bio = bio;
+		set_bit(R10BIO_Discard, &r10_bio->state);
+		first_copy = false;
+		first_r10bio = r10_bio;
+	} else
+		r10_bio->master_bio = (struct bio *)first_r10bio;
+
 	rcu_read_lock();
 	for (disk = 0; disk < geo->raid_disks; disk++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
@@ -1764,11 +1797,19 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		}
 	}
 
-	if (atomic_dec_and_test(&r10_bio->remaining)) {
-		md_write_end(r10_bio->mddev);
-		raid_end_bio_io(r10_bio);
+	if (!geo->far_offset && --far_copies) {
+		first_stripe_index += geo->stride >> geo->chunk_shift;
+		start_disk_offset += geo->stride;
+		last_stripe_index += geo->stride >> geo->chunk_shift;
+		end_disk_offset += geo->stride;
+		atomic_inc(&first_r10bio->remaining);
+		raid_end_discard_bio(r10_bio);
+		wait_barrier(conf);
+		goto retry_discard;
 	}
 
+	raid_end_discard_bio(r10_bio);
+
 	return 0;
 out:
 	allow_barrier(conf);
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 79cd2b7..1461fd5 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -179,5 +179,6 @@ enum r10bio_state {
 	R10BIO_Previous,
 /* failfast devices did receive failfast requests. */
 	R10BIO_FailFast,
+	R10BIO_Discard,
 };
 #endif
-- 
2.7.5

