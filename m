From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 09/17] md: raid1/raid10: use bio helper in *_pool_free
Date: Thu, 16 Feb 2017 19:45:39 +0800
Message-ID: <1487245547-24384-10-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c  | 13 ++++++++++---
 drivers/md/raid10.c | 11 +++++++----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ebea8615344a..1dd6b2760fba 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -172,9 +172,16 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 	int i,j;
 	struct r1bio *r1bio = __r1_bio;
 
-	for (i = 0; i < RESYNC_PAGES; i++)
-		for (j = pi->raid_disks; j-- ;)
-			safe_put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
+	for (i = 0; i < pi->raid_disks; i++) {
+		struct bio_vec *bvl;
+		struct bio *bio = r1bio->bios[i];
+
+		/* make sure all pages can be freed */
+		bio->bi_vcnt = RESYNC_PAGES;
+
+		bio_for_each_segment_all(bvl, bio, j)
+			safe_put_page(bvl->bv_page);
+	}
 	for (i=0 ; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8262f3e1dd93..5c698f3d3083 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -230,10 +230,13 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 	for (j=0; j < conf->copies; j++) {
 		struct bio *bio = r10bio->devs[j].bio;
 		if (bio) {
-			for (i = 0; i < RESYNC_PAGES; i++) {
-				safe_put_page(bio->bi_io_vec[i].bv_page);
-				bio->bi_io_vec[i].bv_page = NULL;
-			}
+			struct bio_vec *bvl;
+
+			/* make sure all pages can be freed */
+			bio->bi_vcnt = RESYNC_PAGES;
+
+			bio_for_each_segment_all(bvl, bio, i)
+				safe_put_page(bvl->bv_page);
 			bio_put(bio);
 		}
 		bio = r10bio->devs[j].repl_bio;
-- 
2.7.4
