From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 02/13] md: raid1/raid10: don't handle failure of bio_add_page()
Date: Tue, 28 Feb 2017 23:41:32 +0800
Message-ID: <1488296503-4987-3-git-send-email-tom.leiming@gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

All bio_add_page() is for adding one page into resync bio,
which is big enough to hold RESYNC_PAGES pages, and
the current bio_add_page() doesn't check queue limit any more,
so it won't fail at all.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c  | 21 ++++++---------------
 drivers/md/raid10.c | 41 ++++++++++-------------------------------
 2 files changed, 16 insertions(+), 46 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0628c07dd16d..b3021355c7e2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2903,21 +2903,12 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io) {
 				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
-				if (bio_add_page(bio, page, len, 0) == 0) {
-					/* stop here */
-					bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
-					while (i > 0) {
-						i--;
-						bio = r1_bio->bios[i];
-						if (bio->bi_end_io==NULL)
-							continue;
-						/* remove last page from this bio */
-						bio->bi_vcnt--;
-						bio->bi_iter.bi_size -= len;
-						bio_clear_flag(bio, BIO_SEG_VALID);
-					}
-					goto bio_full;
-				}
+
+				/*
+				 * won't fail because the vec table is big
+				 * enough to hold all these pages
+				 */
+				bio_add_page(bio, page, len, 0);
 			}
 		}
 		nr_sectors += len>>9;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 33f6a535dc1f..ceb3acc793cf 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3435,27 +3435,16 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (len == 0)
 			break;
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
-			struct bio *bio2;
 			page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
-			if (bio_add_page(bio, page, len, 0))
-				continue;
-
-			/* stop here */
-			bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
-			for (bio2 = biolist;
-			     bio2 && bio2 != bio;
-			     bio2 = bio2->bi_next) {
-				/* remove last page from this bio */
-				bio2->bi_vcnt--;
-				bio2->bi_iter.bi_size -= len;
-				bio_clear_flag(bio2, BIO_SEG_VALID);
-			}
-			goto bio_full;
+			/*
+			 * won't fail because the vec table is big enough
+			 * to hold all these pages
+			 */
+			bio_add_page(bio, page, len, 0);
 		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
 	} while (biolist->bi_vcnt < RESYNC_PAGES);
- bio_full:
 	r10_bio->sectors = nr_sectors;
 
 	while (biolist) {
@@ -4528,25 +4517,15 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		if (len > PAGE_SIZE)
 			len = PAGE_SIZE;
 		for (bio = blist; bio ; bio = bio->bi_next) {
-			struct bio *bio2;
-			if (bio_add_page(bio, page, len, 0))
-				continue;
-
-			/* Didn't fit, must stop */
-			for (bio2 = blist;
-			     bio2 && bio2 != bio;
-			     bio2 = bio2->bi_next) {
-				/* Remove last page from this bio */
-				bio2->bi_vcnt--;
-				bio2->bi_iter.bi_size -= len;
-				bio_clear_flag(bio2, BIO_SEG_VALID);
-			}
-			goto bio_full;
+			/*
+			 * won't fail because the vec table is big enough
+			 * to hold all these pages
+			 */
+			bio_add_page(bio, page, len, 0);
 		}
 		sector_nr += len >> 9;
 		nr_sectors += len >> 9;
 	}
-bio_full:
 	rcu_read_unlock();
 	r10_bio->sectors = nr_sectors;
 
-- 
2.7.4

