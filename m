From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 2/3] md/isrt: read support
Date: Wed, 23 Apr 2014 23:18:54 -0700
Message-ID: <20140424061854.3187.41206.stgit@viggo.jf.intel.com>
References: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

Lookup incoming read requests in the cache.  Four cases to handle:

1/ If the request cross a frame boundary split it at the boundary and
   recursively resubmit. (unlikely due to the fact that we tell the upper
   layers to send us one request at a time)
2/ If the request finds fails a frame lookup or finds all sectors
   invalid in the per sector validity, route the i/o to the backing device.
3/ If the request succeeds at frame lookup and finds all sectos valid in
   the per sector validity, remap the i/o to the cache frame sector and
   route the i/o to the cache device.
4/ If the request is a partial hit split off a sector and recurisvely
   submit until case 2 or case 3 is hit.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/isrt.c |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 136 insertions(+), 8 deletions(-)

diff --git a/drivers/md/isrt.c b/drivers/md/isrt.c
index 8dad8fada52c..81ff9246e94d 100644
--- a/drivers/md/isrt.c
+++ b/drivers/md/isrt.c
@@ -465,26 +465,154 @@ static int isrt_stop(struct mddev *mddev)
 	return 0;
 }
 
+static bool is_io_in_frame_boundary(struct bio *bio)
+{
+	return SECTORS_PER_FRAME >= (bio->bi_iter.bi_sector & FRAME_MASK)
+		+ bio_sectors(bio);
+}
+
+static bool __is_io_cached(struct nv_cache_packed_md *frame, struct bio *bio, bool negate)
+{
+	u16 invalid = le16_to_cpu(frame->per_sector_validity);
+	int sector_idx = bio->bi_iter.bi_sector & FRAME_MASK;
+	int end = sector_idx + bio_sectors(bio);
+	int i;
+
+	if (WARN_ONCE(end > SECTORS_PER_FRAME, "bio crosses frame boundary by %d sectors\n",
+		      end - SECTORS_PER_FRAME))
+		return false;
+
+	if (negate)
+		invalid = ~invalid;
+
+	for (i = sector_idx; i < end; i++)
+		if (invalid & (1 << i))
+			break;
+
+	return i >= end;
+}
+
+static bool is_io_cached(struct nv_cache_packed_md *frame, struct bio *bio)
+{
+	if (!frame)
+		return false;
+	return __is_io_cached(frame, bio, false);
+}
+
+static bool is_io_uncached(struct nv_cache_packed_md *frame, struct bio *bio)
+{
+	if (!frame)
+		return true;
+	return __is_io_cached(frame, bio, true);
+}
+
+static struct bio *isrt_split(struct mddev *mddev, struct bio *bio,
+				  sector_t sectors)
+{
+	struct bio *split;
+
+	/* Sanity check -- queue functions should prevent this happening */
+	if (bio->bi_vcnt != 1 || bio->bi_iter.bi_idx != 0
+	    || bio_sectors(bio) == 1) {
+		pr_err("%s: make_request bug: can't convert block across frame"
+		       " or bigger than %dk %llu %d\n",
+		       mdname(mddev), SECTORS_PER_FRAME / 2,
+		       (unsigned long long)bio->bi_iter.bi_sector, bio_sectors(bio));
+		bio_io_error(bio);
+		return bio;
+	}
+
+	pr_debug("%s: sector: %llu split: %llu/%llu\n", __func__,
+		 (unsigned long long) bio->bi_iter.bi_sector,
+		 (unsigned long long) sectors,
+		 (unsigned long long) bio_sectors(bio) - sectors);
+
+	split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
+	if (!split) {
+		pr_err("%s: bio_split() allocation failure\n", mdname(mddev));
+		bio_io_error(bio);
+		return bio;
+	}
+	bio_chain(split, bio);
+
+	generic_make_request(split);
+
+	return split;
+}
+
+static sector_t next_frame(sector_t sector)
+{
+	return SECTORS_PER_FRAME - (sector & FRAME_MASK);
+}
+
 static void isrt_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct isrt_conf *conf = mddev->private;
 	struct nv_cache_packed_md *frame;
 	struct isrt_page *p;
+	struct md_rdev *rdev;
+	struct bio *split;
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
 
-	spin_lock(&conf->lock);
-	p = isrt_lookup_page(conf, bio->bi_iter.bi_sector);
-	frame = isrt_lookup_frame(conf, p, bio->bi_iter.bi_sector);
-	spin_unlock(&conf->lock);
+	if (bio_data_dir(bio) == WRITE) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return;
+	}
+
+	if (WARN_ONCE(bio->bi_vcnt > 1,
+		      pr_fmt("%s: block bug: 1 segment supported, got: %d\n"),
+		      mdname(mddev), bio->bi_vcnt)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return;
+	}
+
+	do {
+		sector_t sector = bio->bi_iter.bi_sector;
+
+		if (!is_io_in_frame_boundary(bio)) {
+			split = isrt_split(mddev, bio, next_frame(sector));
+		} else {
+			spin_lock(&conf->lock);
+			p = isrt_lookup_page(conf, sector);
+			frame = isrt_lookup_frame(conf, p, sector);
+			spin_unlock(&conf->lock);
+
+			pr_debug("%s: %s sector: %llu+%d cache: %s\n",
+				 mdname(mddev),
+				 bio_data_dir(bio) == READ ? "READ" : "WRITE",
+				 (unsigned long long) sector, bio_sectors(bio),
+				 is_io_cached(frame, bio) ? "hit" :
+				 is_io_uncached(frame, bio) ? "miss" : "partial");
+
+			/* we now have a single frame i/o that may need
+			 * to be split according to per-sector validity,
+			 * otherwise re-route the bio to the proper
+			 * device
+			 */
+			split = bio;
+			if (is_io_uncached(frame, bio)) {
+				rdev = conf->dev[ISRT_TARGET_DEV_IDX];
+				bio->bi_bdev = rdev->bdev;
+			} else if (is_io_cached(frame, bio)) {
+				int frame_idx = to_frame_idx(conf, frame);
+
+				sector_t offset = sector & FRAME_MASK;
+				sector_t frame_offset = frame_idx * SECTORS_PER_FRAME;
+
+				rdev = conf->dev[ISRT_DEV_IDX];
+				bio->bi_bdev = rdev->bdev;
+				bio->bi_iter.bi_sector = conf->cache_frame0_lba
+					+ frame_offset + offset;
+			} else
+				split = isrt_split(mddev, bio, 1);
+		}
 
-	pr_debug("%s: sector: %llu cache: %s\n",
-		 __func__, (unsigned long long) bio->bi_iter.bi_sector,
-		 frame ? "hit" : "miss");
-	bio_endio(bio, -EOPNOTSUPP);
+		generic_make_request(split);
+	} while (split != bio);
 }
 
 static void isrt_status(struct seq_file *seq, struct mddev *mddev)

