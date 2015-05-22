From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v4 07/11] md/raid5: split bio for chunk_aligned_read
Date: Fri, 22 May 2015 11:18:39 -0700
Message-ID: <1432318723-18829-8-git-send-email-mlin@kernel.org>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1432318723-18829-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Ming Lin <mlin@kernel.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a read request fits entirely in a chunk, it will be passed directly to the
underlying device (providing it hasn't failed of course).  If it doesn't fit,
the slightly less efficient path that uses the stripe_cache is used.
Requests that get to the stripe cache are always completely split up as
necessary.

So with RAID5, ripping out the merge_bvec_fn doesn't cause it to stop work,
but could cause it to take the less efficient path more often.

All that is needed to manage this is for 'chunk_aligned_read' do some bio
splitting, much like the RAID0 code does.

Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ming Lin <mlin@kernel.org>
---
 drivers/md/raid5.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b303ded..b6c6ace 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4743,7 +4743,7 @@ static void raid5_align_endio(struct bio *bi, int error)
 	add_bio_to_retry(raid_bi, conf);
 }
 
-static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
+static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
@@ -4752,7 +4752,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 	sector_t end_sector;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		pr_debug("chunk_aligned_read : non aligned\n");
+		pr_debug("%s: non aligned\n", __func__);
 		return 0;
 	}
 	/*
@@ -4827,6 +4827,31 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 	}
 }
 
+static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
+{
+	struct bio *split;
+
+	do {
+		sector_t sector = raid_bio->bi_iter.bi_sector;
+		unsigned chunk_sects = mddev->chunk_sectors;
+		unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
+
+		if (sectors < bio_sectors(raid_bio)) {
+			split = bio_split(raid_bio, sectors, GFP_NOIO, fs_bio_set);
+			bio_chain(split, raid_bio);
+		} else
+			split = raid_bio;
+
+		if (!raid5_read_one_chunk(mddev, split)) {
+			if (split != raid_bio)
+				generic_make_request(raid_bio);
+			return split;
+		}
+	} while (split != raid_bio);
+
+	return NULL;
+}
+
 /* __get_priority_stripe - get the next stripe to process
  *
  * Full stripe writes are allowed to pass preread active stripes up until
@@ -5104,9 +5129,11 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	 * data on failed drives.
 	 */
 	if (rw == READ && mddev->degraded == 0 &&
-	     mddev->reshape_position == MaxSector &&
-	     chunk_aligned_read(mddev,bi))
-		return;
+	    mddev->reshape_position == MaxSector) {
+		bi = chunk_aligned_read(mddev, bi);
+		if (!bi)
+			return;
+	}
 
 	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
 		make_discard_request(mddev, bi);
-- 
1.9.1
