Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA4FC433E0
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 05:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0010064F58
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 05:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhBDF7U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 00:59:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231124AbhBDF7T (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 00:59:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612418271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5esikxUhAYv7WFcDhmCxr3WjY15S8viyre1qUMlQO4=;
        b=fFyMCzqZtqzw0kQuui+jqxN+uCn1aZzQYt0UjvXATJlaitOwWo4/MJdA+Eqn/ru/Q1Qzlg
        X9RneMyig8HAHVadzum/C+toOsgyH7CvG1wqVtPJu2U4fLXe2vWt04T7kZP+HUuMoe7kda
        8UeUSqfB4zF895Dd+lBRAAquqpEZ59w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-M9PkO4mgMAOI82q5sYcEKw-1; Thu, 04 Feb 2021 00:57:45 -0500
X-MC-Unique: M9PkO4mgMAOI82q5sYcEKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE650108C2AC;
        Thu,  4 Feb 2021 05:57:43 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 635C760C13;
        Thu,  4 Feb 2021 05:57:39 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com,
        hch@infradead.org
Subject: [PATCH V2 4/5] md/raid10: improve raid10 discard request
Date:   Thu,  4 Feb 2021 13:57:17 +0800
Message-Id: <1612418238-9976-5-git-send-email-xni@redhat.com>
In-Reply-To: <1612418238-9976-1-git-send-email-xni@redhat.com>
References: <1612418238-9976-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now the discard request is split by chunk size. So it takes a long time
to finish mkfs on disks which support discard function. This patch improve
handling raid10 discard request. It uses the similar way with patch
29efc390b (md/md0: optimize raid0 discard handling).

But it's a little complex than raid0. Because raid10 has different layout.
If raid10 is offset layout and the discard request is smaller than stripe
size. There are some holes when we submit discard bio to underlayer disks.

For example: five disks (disk1 - disk5)
D01 D02 D03 D04 D05
D05 D01 D02 D03 D04
D06 D07 D08 D09 D10
D10 D06 D07 D08 D09
The discard bio just wants to discard from D03 to D10. For disk3, there is
a hole between D03 and D08. For disk4, there is a hole between D04 and D09.
D03 is a chunk, raid10_write_request can handle one chunk perfectly. So
the part that is not aligned with stripe size is still handled by
raid10_write_request.

If reshape is running when discard bio comes and the discard bio spans the
reshape position, raid10_write_request is responsible to handle this
discard bio.

I did a test with this patch set.
Without patch:
time mkfs.xfs /dev/md0
real4m39.775s
user0m0.000s
sys0m0.298s

With patch:
time mkfs.xfs /dev/md0
real0m0.105s
user0m0.000s
sys0m0.007s

nvme3n1           259:1    0   477G  0 disk
└─nvme3n1p1       259:10   0    50G  0 part
nvme4n1           259:2    0   477G  0 disk
└─nvme4n1p1       259:11   0    50G  0 part
nvme5n1           259:6    0   477G  0 disk
└─nvme5n1p1       259:12   0    50G  0 part
nvme2n1           259:9    0   477G  0 disk
└─nvme2n1p1       259:15   0    50G  0 part
nvme0n1           259:13   0   477G  0 disk
└─nvme0n1p1       259:14   0    50G  0 part

Reviewed-by: Coly Li <colyli@suse.de>
Reviewed-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 263 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 262 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ea97ce3..73d1b250 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1518,6 +1518,263 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 		raid10_write_request(mddev, bio, r10_bio);
 }
 
+static void raid10_end_discard_request(struct bio *bio)
+{
+	struct r10bio *r10_bio = bio->bi_private;
+	struct r10conf *conf = r10_bio->mddev->private;
+	struct md_rdev *rdev = NULL;
+	int dev;
+	int slot, repl;
+
+	/*
+	 * We don't care the return value of discard bio
+	 */
+	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
+		set_bit(R10BIO_Uptodate, &r10_bio->state);
+
+	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
+	if (repl)
+		rdev = conf->mirrors[dev].replacement;
+	if (!rdev) {
+		/*
+		 * raid10_remove_disk uses smp_mb to make sure rdev is set to
+		 * replacement before setting replacement to NULL. It can read
+		 * rdev first without barrier protect even replacment is NULL
+		 */
+		smp_rmb();
+		rdev = conf->mirrors[dev].rdev;
+	}
+
+	if (atomic_dec_and_test(&r10_bio->remaining)) {
+		md_write_end(r10_bio->mddev);
+		raid_end_bio_io(r10_bio);
+	}
+
+	rdev_dec_pending(rdev, conf->mddev);
+}
+
+/*
+ * There are some limitations to handle discard bio
+ * 1st, the discard size is bigger than stripe_size*2.
+ * 2st, if the discard bio spans reshape progress, we use the old way to
+ * handle discard bio
+ */
+static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
+{
+	struct r10conf *conf = mddev->private;
+	struct geom *geo = &conf->geo;
+	struct r10bio *r10_bio;
+	struct bio *split;
+	int disk;
+	sector_t chunk;
+	unsigned int stripe_size;
+	unsigned int stripe_data_disks;
+	sector_t split_size;
+	sector_t bio_start, bio_end;
+	sector_t first_stripe_index, last_stripe_index;
+	sector_t start_disk_offset;
+	unsigned int start_disk_index;
+	sector_t end_disk_offset;
+	unsigned int end_disk_index;
+	unsigned int remainder;
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+		return -EAGAIN;
+
+	wait_barrier(conf);
+
+	/*
+	 * Check reshape again to avoid reshape happens after checking
+	 * MD_RECOVERY_RESHAPE and before wait_barrier
+	 */
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+		goto out;
+
+	if (geo->near_copies)
+		stripe_data_disks = geo->raid_disks / geo->near_copies +
+					geo->raid_disks % geo->near_copies;
+	else
+		stripe_data_disks = geo->raid_disks;
+
+	stripe_size = stripe_data_disks << geo->chunk_shift;
+
+	bio_start = bio->bi_iter.bi_sector;
+	bio_end = bio_end_sector(bio);
+
+	/*
+	 * Maybe one discard bio is smaller than strip size or across one
+	 * stripe and discard region is larger than one stripe size. For far
+	 * offset layout, if the discard region is not aligned with stripe
+	 * size, there is hole when we submit discard bio to member disk.
+	 * For simplicity, we only handle discard bio which discard region
+	 * is bigger than stripe_size * 2
+	 */
+	if (bio_sectors(bio) < stripe_size*2)
+		goto out;
+
+	/*
+	 * Keep bio aligned with strip size.
+	 */
+	div_u64_rem(bio_start, stripe_size, &remainder);
+	if (remainder) {
+		split_size = stripe_size - remainder;
+		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		bio_chain(split, bio);
+		allow_barrier(conf);
+		/* Resend the fist split part */
+		submit_bio_noacct(split);
+		wait_barrier(conf);
+	}
+	div_u64_rem(bio_end, stripe_size, &remainder);
+	if (remainder) {
+		split_size = bio_sectors(bio) - remainder;
+		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		bio_chain(split, bio);
+		allow_barrier(conf);
+		/* Resend the second split part */
+		submit_bio_noacct(bio);
+		bio = split;
+		wait_barrier(conf);
+	}
+
+	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio->mddev = mddev;
+	r10_bio->state = 0;
+	r10_bio->sectors = 0;
+	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
+
+	wait_blocked_dev(mddev, r10_bio);
+
+	r10_bio->master_bio = bio;
+
+	bio_start = bio->bi_iter.bi_sector;
+	bio_end = bio_end_sector(bio);
+
+	/*
+	 * Raid10 uses chunk as the unit to store data. It's similar like raid0.
+	 * One stripe contains the chunks from all member disk (one chunk from
+	 * one disk at the same HBA address). For layout detail, see 'man md 4'
+	 */
+	chunk = bio_start >> geo->chunk_shift;
+	chunk *= geo->near_copies;
+	first_stripe_index = chunk;
+	start_disk_index = sector_div(first_stripe_index, geo->raid_disks);
+	if (geo->far_offset)
+		first_stripe_index *= geo->far_copies;
+	start_disk_offset = (bio_start & geo->chunk_mask) +
+				(first_stripe_index << geo->chunk_shift);
+
+	chunk = bio_end >> geo->chunk_shift;
+	chunk *= geo->near_copies;
+	last_stripe_index = chunk;
+	end_disk_index = sector_div(last_stripe_index, geo->raid_disks);
+	if (geo->far_offset)
+		last_stripe_index *= geo->far_copies;
+	end_disk_offset = (bio_end & geo->chunk_mask) +
+				(last_stripe_index << geo->chunk_shift);
+
+	rcu_read_lock();
+	for (disk = 0; disk < geo->raid_disks; disk++) {
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		struct md_rdev *rrdev = rcu_dereference(
+			conf->mirrors[disk].replacement);
+
+		r10_bio->devs[disk].bio = NULL;
+		r10_bio->devs[disk].repl_bio = NULL;
+
+		if (rdev && (test_bit(Faulty, &rdev->flags)))
+			rdev = NULL;
+		if (rrdev && (test_bit(Faulty, &rrdev->flags)))
+			rrdev = NULL;
+		if (!rdev && !rrdev)
+			continue;
+
+		if (rdev) {
+			r10_bio->devs[disk].bio = bio;
+			atomic_inc(&rdev->nr_pending);
+		}
+		if (rrdev) {
+			r10_bio->devs[disk].repl_bio = bio;
+			atomic_inc(&rrdev->nr_pending);
+		}
+	}
+	rcu_read_unlock();
+
+	atomic_set(&r10_bio->remaining, 1);
+	for (disk = 0; disk < geo->raid_disks; disk++) {
+		sector_t dev_start, dev_end;
+		struct bio *mbio, *rbio = NULL;
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		struct md_rdev *rrdev = rcu_dereference(
+			conf->mirrors[disk].replacement);
+
+		/*
+		 * Now start to calculate the start and end address for each disk.
+		 * The space between dev_start and dev_end is the discard region.
+		 *
+		 * For dev_start, it needs to consider three conditions:
+		 * 1st, the disk is before start_disk, you can imagine the disk in
+		 * the next stripe. So the dev_start is the start address of next
+		 * stripe.
+		 * 2st, the disk is after start_disk, it means the disk is at the
+		 * same stripe of first disk
+		 * 3st, the first disk itself, we can use start_disk_offset directly
+		 */
+		if (disk < start_disk_index)
+			dev_start = (first_stripe_index + 1) * mddev->chunk_sectors;
+		else if (disk > start_disk_index)
+			dev_start = first_stripe_index * mddev->chunk_sectors;
+		else
+			dev_start = start_disk_offset;
+
+		if (disk < end_disk_index)
+			dev_end = (last_stripe_index + 1) * mddev->chunk_sectors;
+		else if (disk > end_disk_index)
+			dev_end = last_stripe_index * mddev->chunk_sectors;
+		else
+			dev_end = end_disk_offset;
+
+		/*
+		 * It only handles discard bio which size is >= stripe size, so
+		 * dev_end > dev_start all the time
+		 */
+		if (r10_bio->devs[disk].bio) {
+			mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
+			mbio->bi_end_io = raid10_end_discard_request;
+			mbio->bi_private = r10_bio;
+			r10_bio->devs[disk].bio = mbio;
+			r10_bio->devs[disk].devnum = disk;
+			atomic_inc(&r10_bio->remaining);
+			md_submit_discard_bio(mddev, rdev, mbio,
+					dev_start + choose_data_offset(r10_bio, rdev),
+					dev_end - dev_start);
+			bio_endio(mbio);
+		}
+		if (r10_bio->devs[disk].repl_bio) {
+			rbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
+			rbio->bi_end_io = raid10_end_discard_request;
+			rbio->bi_private = r10_bio;
+			r10_bio->devs[disk].repl_bio = rbio;
+			r10_bio->devs[disk].devnum = disk;
+			atomic_inc(&r10_bio->remaining);
+			md_submit_discard_bio(mddev, rrdev, rbio,
+					dev_start + choose_data_offset(r10_bio, rrdev),
+					dev_end - dev_start);
+			bio_endio(rbio);
+		}
+	}
+
+	if (atomic_dec_and_test(&r10_bio->remaining)) {
+		md_write_end(r10_bio->mddev);
+		raid_end_bio_io(r10_bio);
+	}
+
+	return 0;
+out:
+	allow_barrier(conf);
+	return -EAGAIN;
+}
+
 static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1532,6 +1789,10 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	if (!md_write_start(mddev, bio))
 		return false;
 
+	if (unlikely(bio_op(bio) == REQ_OP_DISCARD))
+		if (!raid10_handle_discard(mddev, bio))
+			return true;
+
 	/*
 	 * If this request crosses a chunk boundary, we need to split
 	 * it.
@@ -3771,7 +4032,7 @@ static int raid10_run(struct mddev *mddev)
 
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
-					      mddev->chunk_sectors);
+					      UINT_MAX);
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
-- 
2.7.5

