From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 03/17] md: raid1/raid10: use bio_remove_last_page()
Date: Thu, 16 Feb 2017 19:45:33 +0800
Message-ID: <1487245547-24384-4-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c  | 3 +--
 drivers/md/raid10.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 85f309836fd7..6e4e0b868ff2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2824,8 +2824,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 						if (bio->bi_end_io==NULL)
 							continue;
 						/* remove last page from this bio */
-						bio->bi_vcnt--;
-						bio->bi_iter.bi_size -= len;
+						bio_remove_last_page(bio);
 						bio_clear_flag(bio, BIO_SEG_VALID);
 					}
 					goto bio_full;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 063c43d83b72..aa37d4c7900a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3447,8 +3447,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			     bio2 && bio2 != bio;
 			     bio2 = bio2->bi_next) {
 				/* remove last page from this bio */
-				bio2->bi_vcnt--;
-				bio2->bi_iter.bi_size -= len;
+				bio_remove_last_page(bio2);
 				bio_clear_flag(bio2, BIO_SEG_VALID);
 			}
 			goto bio_full;
@@ -4538,8 +4537,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 			     bio2 && bio2 != bio;
 			     bio2 = bio2->bi_next) {
 				/* Remove last page from this bio */
-				bio2->bi_vcnt--;
-				bio2->bi_iter.bi_size -= len;
+				bio_remove_last_page(bio2);
 				bio_clear_flag(bio2, BIO_SEG_VALID);
 			}
 			goto bio_full;
-- 
2.7.4
