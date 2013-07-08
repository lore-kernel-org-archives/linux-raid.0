From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 2/2] md: raid1: use bio_rewind() before bio_copy_data()
Date: Mon,  8 Jul 2013 16:25:14 -0400
Message-ID: <1373315114-16625-2-git-send-email-joe.lawrence@stratus.com>
References: <20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, kmo@daterainc.com, Joe Lawrence <joe.lawrence@stratus.com>
List-Id: linux-raid.ids

bio_copy_data() cannot execute on a fully completed source (or
destination) bio.  MD RAID1 is recycling a completed read bio for RAID
repair purposes and needs to fix up the source and destination bios for
bio_copy_data(): in particular, the io-vector index needs to be rewound
and the bios unchained.

Suggested-by: NeilBrown <neilb@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/md/raid1.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6e17f81..bb1e80f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1861,7 +1861,6 @@ static int process_checks(struct r1bio *r1_bio)
 		int j;
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
-		int size;
 
 		if (sbio->bi_end_io != end_sync_read)
 			continue;
@@ -1887,28 +1886,11 @@ static int process_checks(struct r1bio *r1_bio)
 			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 			continue;
 		}
-		/* fixup the bio for reuse */
-		bio_reset(sbio);
-		sbio->bi_vcnt = vcnt;
-		sbio->bi_size = r1_bio->sectors << 9;
-		sbio->bi_sector = r1_bio->sector +
-			conf->mirrors[i].rdev->data_offset;
-		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		sbio->bi_end_io = end_sync_read;
-		sbio->bi_private = r1_bio;
-
-		size = sbio->bi_size;
-		for (j = 0; j < vcnt ; j++) {
-			struct bio_vec *bi;
-			bi = &sbio->bi_io_vec[j];
-			bi->bv_offset = 0;
-			if (size > PAGE_SIZE)
-				bi->bv_len = PAGE_SIZE;
-			else
-				bi->bv_len = size;
-			size -= PAGE_SIZE;
-		}
-
+		/* copy pbio io_vec data into sbio, but first reset io_vec
+		 * index and unchain both */
+		bio_rewind(pbio);
+		bio_rewind(sbio);
+		pbio->bi_next = sbio->bi_next = NULL;
 		bio_copy_data(sbio, pbio);
 	}
 	return 0;
-- 
1.8.1.4

