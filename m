From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] md/raid10: share pages between read and write bio's during recovery
Date: Thu,  9 Jun 2011 03:04:33 +0900
Message-ID: <1307556273-16730-1-git-send-email-namhyung@gmail.com>
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
 drivers/md/raid10.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a53779ffdf89..621594981339 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -116,6 +116,13 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 			goto out_free_bio;
 		r10_bio->devs[j].bio = bio;
 	}
+
+	/*
+	 * We can share bv_page's during the recovery
+	 */
+	if (!test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery))
+		nalloc--;
+
 	/*
 	 * Allocate RESYNC_PAGES data pages and attach them
 	 * where needed.
@@ -1363,16 +1370,16 @@ static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 	int i, d;
 	struct bio *bio, *wbio;
 
-
-	/* move the pages across to the second bio
+	/*
+	 * share the pages with the first bio
 	 * and submit the write request
 	 */
 	bio = r10_bio->devs[0].bio;
 	wbio = r10_bio->devs[1].bio;
 	for (i=0; i < wbio->bi_vcnt; i++) {
 		struct page *p = bio->bi_io_vec[i].bv_page;
-		bio->bi_io_vec[i].bv_page = wbio->bi_io_vec[i].bv_page;
 		wbio->bi_io_vec[i].bv_page = p;
+		get_page(p);
 	}
 	d = r10_bio->devs[1].devnum;
 
-- 
1.7.5.2

