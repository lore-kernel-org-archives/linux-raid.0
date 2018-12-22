From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH] drivers/md.c: Make bio_alloc_mddev return bio_alloc_bioset
Date: Sat, 22 Dec 2018 08:08:45 -0200
Message-ID: <20181222100845.566772-1-marcos.souza.org@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: shli@kernel.org, marcos.souza.org@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

bio_alloc_bioset return a bio pointer or NULL, so we can avoid storing
the returned data into a new variable.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/md/md.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fc488cb30a94..42e018f014cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -207,15 +207,10 @@ static bool create_on_open = true;
 struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 			    struct mddev *mddev)
 {
-	struct bio *b;
-
 	if (!mddev || !bioset_initialized(&mddev->bio_set))
 		return bio_alloc(gfp_mask, nr_iovecs);
 
-	b = bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
-	if (!b)
-		return NULL;
-	return b;
+	return bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
 }
 EXPORT_SYMBOL_GPL(bio_alloc_mddev);
 
-- 
2.16.4
