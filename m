From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 05/17] md: raid1/raid10: use the introduced helpers
Date: Thu, 16 Feb 2017 19:45:35 +0800
Message-ID: <1487245547-24384-6-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

This patch uses the introduced helpers to fetch pre-allocated
page from bio bvec table, and store it back.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c  | 4 ++--
 drivers/md/raid10.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6e4e0b868ff2..c4791fbd69ac 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2814,10 +2814,10 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		for (i = 0 ; i < conf->raid_disks * 2; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io) {
-				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
+				page = mdev_get_page_from_bio(bio, bio->bi_vcnt);
 				if (bio_add_page(bio, page, len, 0) == 0) {
 					/* stop here */
-					bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
+					mdev_put_page_to_bio(bio, bio->bi_vcnt, page);
 					while (i > 0) {
 						i--;
 						bio = r1_bio->bios[i];
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index aa37d4c7900a..b7dfbca869a3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3437,12 +3437,12 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			break;
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
 			struct bio *bio2;
-			page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
+			page = mdev_get_page_from_bio(bio, bio->bi_vcnt);
 			if (bio_add_page(bio, page, len, 0))
 				continue;
 
 			/* stop here */
-			bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
+			mdev_put_page_to_bio(bio, bio->bi_vcnt, page);
 			for (bio2 = biolist;
 			     bio2 && bio2 != bio;
 			     bio2 = bio2->bi_next) {
-- 
2.7.4
