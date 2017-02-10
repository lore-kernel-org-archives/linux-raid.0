From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 5/5] md: fast clone bio in bio_clone_mddev()
Date: Fri, 10 Feb 2017 18:56:17 +0800
Message-ID: <1486724177-14817-6-git-send-email-tom.leiming@gmail.com>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Firstly bio_clone_mddev() is used in raid normal I/O and isn't
in resync I/O path.

Secondly all the direct access to bvec table in raid happens on
resync I/O except for write behind of raid1, in which we still
use bio_clone() for allocating new bvec table.

So this patch replaces bio_clone() with bio_clone_fast()
in bio_clone_mddev().

Rename bio_clone_mddev() as bio_clone_fast_mddev() too, as
suggested by Christoph Hellwig.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/faulty.c |  2 +-
 drivers/md/md.c     |  6 +++---
 drivers/md/md.h     |  4 ++--
 drivers/md/raid1.c  |  8 ++++----
 drivers/md/raid10.c | 11 +++++------
 drivers/md/raid5.c  |  4 ++--
 6 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 685aa2d77e25..f80e7b8f8c40 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -214,7 +214,7 @@ static void faulty_make_request(struct mddev *mddev, struct bio *bio)
 		}
 	}
 	if (failit) {
-		struct bio *b = bio_clone_mddev(bio, GFP_NOIO, mddev);
+		struct bio *b = bio_clone_fast_mddev(bio, GFP_NOIO, mddev);
 
 		b->bi_bdev = conf->rdev->bdev;
 		b->bi_private = bio;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2835f09b9e71..d45e8d1382ad 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -190,12 +190,12 @@ struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 }
 EXPORT_SYMBOL_GPL(bio_alloc_mddev);
 
-struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
+struct bio *bio_clone_fast_mddev(struct bio *bio, gfp_t gfp_mask,
 			    struct mddev *mddev)
 {
-	return bio_clone_bioset(bio, gfp_mask, mddev->bio_set);
+	return bio_clone_fast(bio, gfp_mask, mddev->bio_set);
 }
-EXPORT_SYMBOL_GPL(bio_clone_mddev);
+EXPORT_SYMBOL_GPL(bio_clone_fast_mddev);
 
 /*
  * We have a system wide 'event count' that is incremented
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 968bbe72b237..88d0a101fb4c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -673,8 +673,8 @@ extern void md_rdev_clear(struct md_rdev *rdev);
 
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
-extern struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
-				   struct mddev *mddev);
+extern struct bio *bio_clone_fast_mddev(struct bio *bio, gfp_t gfp_mask,
+					struct mddev *mddev);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4d7852c6ae97..9e0b5a5ec0bc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1108,7 +1108,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	r1_bio->read_disk = rdisk;
 	r1_bio->start_next_window = 0;
 
-	read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+	read_bio = bio_clone_fast_mddev(bio, GFP_NOIO, mddev);
 	bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
 		 max_sectors);
 
@@ -1372,7 +1372,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		}
 
 		if (!mbio) {
-			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+			mbio = bio_clone_fast_mddev(bio, GFP_NOIO, mddev);
 			bio_trim(mbio, offset, max_sectors);
 		}
 
@@ -2283,7 +2283,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 
 			wbio->bi_vcnt = vcnt;
 		} else {
-			wbio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
+			wbio = bio_clone_fast_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
 		}
 
 		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
@@ -2421,7 +2421,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 		const unsigned long do_sync
 			= r1_bio->master_bio->bi_opf & REQ_SYNC;
 		r1_bio->read_disk = disk;
-		bio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
+		bio = bio_clone_fast_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
 		bio_trim(bio, r1_bio->sector - bio->bi_iter.bi_sector,
 			 max_sectors);
 		r1_bio->bios[r1_bio->read_disk] = bio;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6bc5c2a85160..406d6651fd4c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1132,7 +1132,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
-	read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+	read_bio = bio_clone_fast_mddev(bio, GFP_NOIO, mddev);
 	bio_trim(read_bio, r10_bio->sector - bio->bi_iter.bi_sector,
 		 max_sectors);
 
@@ -1406,7 +1406,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		int d = r10_bio->devs[i].devnum;
 		if (r10_bio->devs[i].bio) {
 			struct md_rdev *rdev = conf->mirrors[d].rdev;
-			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+			mbio = bio_clone_fast_mddev(bio, GFP_NOIO, mddev);
 			bio_trim(mbio, r10_bio->sector - bio->bi_iter.bi_sector,
 				 max_sectors);
 			r10_bio->devs[i].bio = mbio;
@@ -1457,7 +1457,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				smp_mb();
 				rdev = conf->mirrors[d].rdev;
 			}
-			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+			mbio = bio_clone_fast_mddev(bio, GFP_NOIO, mddev);
 			bio_trim(mbio, r10_bio->sector - bio->bi_iter.bi_sector,
 				 max_sectors);
 			r10_bio->devs[i].repl_bio = mbio;
@@ -2565,7 +2565,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 		if (sectors > sect_to_write)
 			sectors = sect_to_write;
 		/* Write at 'sector' for 'sectors' */
-		wbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+		wbio = bio_clone_fast_mddev(bio, GFP_NOIO, mddev);
 		bio_trim(wbio, sector - bio->bi_iter.bi_sector, sectors);
 		wsector = r10_bio->devs[i].addr + (sector - r10_bio->sector);
 		wbio->bi_iter.bi_sector = wsector +
@@ -2641,8 +2641,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 			   mdname(mddev),
 			   bdevname(rdev->bdev, b),
 			   (unsigned long long)r10_bio->sector);
-	bio = bio_clone_mddev(r10_bio->master_bio,
-			      GFP_NOIO, mddev);
+	bio = bio_clone_fast_mddev(r10_bio->master_bio, GFP_NOIO, mddev);
 	bio_trim(bio, r10_bio->sector - bio->bi_iter.bi_sector, max_sectors);
 	r10_bio->devs[slot].bio = bio;
 	r10_bio->devs[slot].rdev = rdev;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 34f76615d620..b0bf647dd414 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5056,9 +5056,9 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 		return 0;
 	}
 	/*
-	 * use bio_clone_mddev to make a copy of the bio
+	 * use bio_clone_fast_mddev to make a copy of the bio
 	 */
-	align_bi = bio_clone_mddev(raid_bio, GFP_NOIO, mddev);
+	align_bi = bio_clone_fast_mddev(raid_bio, GFP_NOIO, mddev);
 	if (!align_bi)
 		return 0;
 	/*
-- 
2.7.4
