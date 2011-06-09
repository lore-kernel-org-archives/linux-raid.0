From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH v2] md/raid10: share pages between read and write bio's during recovery
Date: Fri, 10 Jun 2011 02:31:08 +0900
Message-ID: <1307640668-15173-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When performing a recovery, only first 2 slots in r10_bio are in use,
for read and write respectively. However all of pages in the write bio
are never used and just replaced to read bio's when the read completes.

Get rid of those unused pages and share read pages properly.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid10.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a53779ffdf89..dea73bdb99b8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -123,7 +123,15 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	for (j = 0 ; j < nalloc; j++) {
 		bio = r10_bio->devs[j].bio;
 		for (i = 0; i < RESYNC_PAGES; i++) {
-			page = alloc_page(gfp_flags);
+			if (j == 1 && !test_bit(MD_RECOVERY_SYNC,
+						&conf->mddev->recovery)) {
+				/* we can share bv_page's during recovery */
+				struct bio *rbio = r10_bio->devs[0].bio;
+				page = rbio->bi_io_vec[i].bv_page;
+				get_page(page);
+			} else {
+				page = alloc_page(gfp_flags);
+			}
 			if (unlikely(!page))
 				goto out_free_pages;
 
@@ -1360,20 +1368,14 @@ done:
 static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 {
 	conf_t *conf = mddev->private;
-	int i, d;
-	struct bio *bio, *wbio;
-
+	int d;
+	struct bio *wbio;
 
-	/* move the pages across to the second bio
+	/*
+	 * share the pages with the first bio
 	 * and submit the write request
 	 */
-	bio = r10_bio->devs[0].bio;
 	wbio = r10_bio->devs[1].bio;
-	for (i=0; i < wbio->bi_vcnt; i++) {
-		struct page *p = bio->bi_io_vec[i].bv_page;
-		bio->bi_io_vec[i].bv_page = wbio->bi_io_vec[i].bv_page;
-		wbio->bi_io_vec[i].bv_page = p;
-	}
 	d = r10_bio->devs[1].devnum;
 
 	atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-- 
1.7.5.2

