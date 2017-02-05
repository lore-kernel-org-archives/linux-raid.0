From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/4] md/raid1: use bio_clone_slow_mddev_partial in case of write behind
Date: Sun,  5 Feb 2017 14:22:12 +0800
Message-ID: <1486275733-7268-4-git-send-email-tom.leiming@gmail.com>
References: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Write behind need to replace pages in bio's bvecs, and we have
to clone a fresh bio with new bvec table, so use the introduced
bio_clone_slow_mddev_partial() for it.

For other bio_clone_mddev() cases, we will use fast clone since
they don't need to touch bvec table.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 830ff2b20346..e1c5639febdb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1341,13 +1341,12 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	first_clone = 1;
 	for (i = 0; i < disks; i++) {
-		struct bio *mbio;
+		struct bio *mbio = NULL;
+		int offset;
 		if (!r1_bio->bios[i])
 			continue;
 
-		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		bio_trim(mbio, r1_bio->sector - bio->bi_iter.bi_sector,
-			 max_sectors);
+		offset = r1_bio->sector - bio->bi_iter.bi_sector;
 
 		if (first_clone) {
 			/* do behind I/O ?
@@ -1357,8 +1356,14 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			if (bitmap &&
 			    (atomic_read(&bitmap->behind_writes)
 			     < mddev->bitmap_info.max_write_behind) &&
-			    !waitqueue_active(&bitmap->behind_wait))
+			    !waitqueue_active(&bitmap->behind_wait)) {
+				mbio = bio_clone_slow_mddev_partial(bio,
+								    GFP_NOIO,
+								    mddev,
+								    offset,
+								    max_sectors);
 				alloc_behind_pages(mbio, r1_bio);
+			}
 
 			bitmap_startwrite(bitmap, r1_bio->sector,
 					  r1_bio->sectors,
@@ -1366,6 +1371,12 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 						   &r1_bio->state));
 			first_clone = 0;
 		}
+
+		if (!mbio) {
+			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+			bio_trim(mbio, offset, max_sectors);
+		}
+
 		if (r1_bio->behind_bvecs) {
 			struct bio_vec *bvec;
 			int j;
-- 
2.7.4
