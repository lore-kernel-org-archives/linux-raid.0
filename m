From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 4/5] md: remove unnecessary check on mddev
Date: Tue, 14 Feb 2017 23:29:02 +0800
Message-ID: <1487086143-10255-5-git-send-email-tom.leiming@gmail.com>
References: <1487086143-10255-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487086143-10255-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

mddev is never NULL and neither is ->bio_set, so
remove the check.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/md.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b5e2adf3493b..6cd96fde2a67 100644
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
