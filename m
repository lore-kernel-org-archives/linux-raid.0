From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 4/5] md: remove unnecessary check on mddev
Date: Fri, 10 Feb 2017 18:56:16 +0800
Message-ID: <1486724177-14817-5-git-send-email-tom.leiming@gmail.com>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

mddev is never NULL and neither is ->bio_set, so
remove the check.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/md.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3425c2b779a6..2835f09b9e71 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -193,9 +193,6 @@ EXPORT_SYMBOL_GPL(bio_alloc_mddev);
 struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 			    struct mddev *mddev)
 {
-	if (!mddev || !mddev->bio_set)
-		return bio_clone(bio, gfp_mask);
-
 	return bio_clone_bioset(bio, gfp_mask, mddev->bio_set);
 }
 EXPORT_SYMBOL_GPL(bio_clone_mddev);
-- 
2.7.4

