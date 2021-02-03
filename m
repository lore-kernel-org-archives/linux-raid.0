Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB49AC43381
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 13:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB8664F78
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 13:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhBCNrq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 08:47:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232035AbhBCNrb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 08:47:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612359962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=W5mu/UxmzAIqG53eYruKaqg2mhQdXcjKNst6mn2f+zI=;
        b=NGkVOt7dWvsY0aimX2RFL9iZj1rx7rM/TcvO8GMk7J+Rqp4kL3LwlcXxjcSRGgUvy18JBU
        JeE5O3ZBM6s1/wkyTQPN9JWr8PHvTlVFpkU0TB4NjUrelr0kTCiFAsj29tTWm5Z5hAiKDs
        LrK1g8lRmojUdGOeCCm1XX3/bXs1BfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-hQq5BRTSOd6bdc9o2685cA-1; Wed, 03 Feb 2021 08:46:00 -0500
X-MC-Unique: hQq5BRTSOd6bdc9o2685cA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 766B985B663;
        Wed,  3 Feb 2021 13:45:59 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 134833828;
        Wed,  3 Feb 2021 13:45:55 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
Subject: [PATCH 5/5] md/raid10: improve discard request for far layout
Date:   Wed,  3 Feb 2021 21:45:31 +0800
Message-Id: <1612359931-24209-6-git-send-email-xni@redhat.com>
In-Reply-To: <1612359931-24209-1-git-send-email-xni@redhat.com>
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 drivers/md/raid10.c | 78 ++++++++++++++++++++++++++++++++++++++++-------------
 drivers/md/raid10.h |  1 +
 2 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e059796..10be0f3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1533,6 +1533,28 @@ static struct bio *raid10_split_bio(struct r10conf *conf,
 	return bio;
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
@@ -1559,11 +1581,7 @@ static void raid10_end_discard_request(struct bio *bio)
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
 
@@ -1576,7 +1594,9 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct geom *geo = &conf->geo;
-	struct r10bio *r10_bio;
+	struct r10bio *r10_bio, *first_r10bio;
+	int far_copies = geo->far_copies;
+	bool first_copy = true;
 
 	int disk;
 	sector_t chunk;
@@ -1635,16 +1655,6 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		bio = raid10_split_bio(conf, bio, split_size, true);
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
 
@@ -1670,6 +1680,28 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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
+	/* For far layout it needs more than one r10bio to cover all regions.
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
@@ -1760,11 +1792,19 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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

