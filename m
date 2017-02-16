From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 06/17] md: raid1/raid10: borrow .bi_error as pre-allocated page index
Date: Thu, 16 Feb 2017 19:45:36 +0800
Message-ID: <1487245547-24384-7-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Before bio is submitted, it is safe to borrow .bi_error. This
patch uses .bi_error as index of pre-allocated page in bio, so
that we can avoid to mess .bi_vcnt. Especially the old way
will not work any more when multipage bvec is introduced.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c  | 12 ++++++++++--
 drivers/md/raid10.c | 14 ++++++++++----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c4791fbd69ac..8904a9149671 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2811,13 +2811,14 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				len = sync_blocks<<9;
 		}
 
+		/* borrow .bi_error as pre-allocated page index */
 		for (i = 0 ; i < conf->raid_disks * 2; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io) {
-				page = mdev_get_page_from_bio(bio, bio->bi_vcnt);
+				page = mdev_get_page_from_bio(bio, bio->bi_error++);
 				if (bio_add_page(bio, page, len, 0) == 0) {
 					/* stop here */
-					mdev_put_page_to_bio(bio, bio->bi_vcnt, page);
+					mdev_put_page_to_bio(bio, --bio->bi_error, page);
 					while (i > 0) {
 						i--;
 						bio = r1_bio->bios[i];
@@ -2836,6 +2837,13 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		sync_blocks -= (len>>9);
 	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
  bio_full:
+	/* return .bi_error back to bio */
+	for (i = 0 ; i < conf->raid_disks * 2; i++) {
+		bio = r1_bio->bios[i];
+		if (bio->bi_end_io)
+			bio->bi_error = 0;
+	}
+
 	r1_bio->sectors = nr_sectors;
 
 	if (mddev_is_clustered(mddev) &&
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b7dfbca869a3..9cfc22cd1330 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3348,7 +3348,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 			bio = r10_bio->devs[i].bio;
 			bio_reset(bio);
-			bio->bi_error = -EIO;
 			rcu_read_lock();
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
@@ -3392,7 +3391,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			/* Need to set up for writing to the replacement */
 			bio = r10_bio->devs[i].repl_bio;
 			bio_reset(bio);
-			bio->bi_error = -EIO;
 
 			sector = r10_bio->devs[i].addr;
 			bio->bi_next = biolist;
@@ -3435,14 +3433,15 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
+		/* borrow .bi_error as pre-allocated page index */
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
 			struct bio *bio2;
-			page = mdev_get_page_from_bio(bio, bio->bi_vcnt);
+			page = mdev_get_page_from_bio(bio, bio->bi_error++);
 			if (bio_add_page(bio, page, len, 0))
 				continue;
 
 			/* stop here */
-			mdev_put_page_to_bio(bio, bio->bi_vcnt, page);
+			mdev_put_page_to_bio(bio, --bio->bi_error, page);
 			for (bio2 = biolist;
 			     bio2 && bio2 != bio;
 			     bio2 = bio2->bi_next) {
@@ -3456,6 +3455,13 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		sector_nr += len>>9;
 	} while (biolist->bi_vcnt < RESYNC_PAGES);
  bio_full:
+	/* return .bi_error back to bio, and set resync's as -EIO */
+	for (bio= biolist ; bio ; bio=bio->bi_next)
+		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+			bio->bi_error = -EIO;
+		else
+			bio->bi_error = 0;
+
 	r10_bio->sectors = nr_sectors;
 
 	while (biolist) {
-- 
2.7.4

