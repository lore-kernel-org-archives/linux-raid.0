From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 03/14] md: raid1/raid10: use bio_remove_last_page()
Date: Fri, 24 Feb 2017 23:42:40 +0800
Message-ID: <1487950971-1131-4-git-send-email-tom.leiming@gmail.com>
References: <1487950971-1131-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487950971-1131-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c  | 3 +--
 drivers/md/raid10.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0628c07dd16d..2a0bf5b430c9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2912,8 +2912,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
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
index 33f6a535dc1f..125d74dba27e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3446,8 +3446,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			     bio2 && bio2 != bio;
 			     bio2 = bio2->bi_next) {
 				/* remove last page from this bio */
-				bio2->bi_vcnt--;
-				bio2->bi_iter.bi_size -= len;
+				bio_remove_last_page(bio2);
 				bio_clear_flag(bio2, BIO_SEG_VALID);
 			}
 			goto bio_full;
@@ -4537,8 +4536,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
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
