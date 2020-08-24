Return-Path: <SRS0=MG8V=CC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234D4C433E3
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 04:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0274E20768
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 04:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1aDraV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgHXEMS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Aug 2020 00:12:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30642 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726912AbgHXEMQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 Aug 2020 00:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598242335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=80t/+oHjtAeXn/2lpgMXVHWqrIavSz0K3UifGHYc0/s=;
        b=S1aDraV1EZb3u5WP8a/gna5qJKFtVh/5a4iRLkmBTrPxxRCTxSMI1KqepkAGYTx5egqG6z
        vhvTw/6K/JNYD7EXEzPEh8KUtfvd4FB7jIH5AfbNW9v/tWv5e6jQ1jNtn8PcMIDJBiTuuu
        ac4lib29mQhkAK/HcViZRgLi9ZUxrP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-RI4suM9EMZWoaI-wYmhXPw-1; Mon, 24 Aug 2020 00:12:12 -0400
X-MC-Unique: RI4suM9EMZWoaI-wYmhXPw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64A791885DAA;
        Mon, 24 Aug 2020 04:12:11 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49BC41944D;
        Mon, 24 Aug 2020 04:12:07 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
Subject: [PATCH V4 5/5] md/raid10: improve discard request for far layout
Date:   Mon, 24 Aug 2020 12:11:48 +0800
Message-Id: <1598242308-9619-6-git-send-email-xni@redhat.com>
In-Reply-To: <1598242308-9619-1-git-send-email-xni@redhat.com>
References: <1598242308-9619-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-raid-owner@vger.kernel.org
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
 drivers/md/raid10.c | 86 +++++++++++++++++++++++++++++++++++++++--------------
 drivers/md/raid10.h |  1 +
 2 files changed, 64 insertions(+), 23 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 58d36b9..c46fbec 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1535,6 +1535,28 @@ static struct bio *raid10_split_bio(struct r10conf *conf,
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
@@ -1562,11 +1584,7 @@ static void raid10_end_discard_request(struct bio *bio)
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
 
@@ -1579,7 +1597,9 @@ static bool raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct geom *geo = &conf->geo;
-	struct r10bio *r10_bio;
+	struct r10bio *r10_bio, *first_r10bio;
+	int far_copies = geo->far_copies;
+	bool first_copy = true;
 
 	int disk;
 	sector_t chunk;
@@ -1618,28 +1638,18 @@ static bool raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		bio_end > conf->reshape_progress)
 		goto out;
 
-	/* For far offset layout, if bio is not aligned with stripe size, it splits
-	 * the part that is not aligned with strip size.
+	/* For far and far offset layout, if bio is not aligned with stripe size,
+	 * it splits the part that is not aligned with strip size.
 	 */
-	if (geo->far_offset && (bio_start % stripe_size)) {
+	if ((far_copies > 1) && (bio_start % stripe_size)) {
 		split_size = (stripe_size - bio_start % stripe_size);
 		bio = raid10_split_bio(conf, bio, split_size, false);
 	}
-	if (geo->far_offset && (bio_end % stripe_size)) {
+	if ((far_copies > 1) && (bio_end % stripe_size)) {
 		split_size = bio_sectors(bio) - (bio_end % stripe_size);
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
 
@@ -1665,6 +1675,28 @@ static bool raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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
@@ -1751,11 +1783,19 @@ static bool raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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

