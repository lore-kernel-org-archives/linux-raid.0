From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 4/4] md: fast clone bio in bio_clone_mddev()
Date: Sun,  5 Feb 2017 14:22:13 +0800
Message-ID: <1486275733-7268-5-git-send-email-tom.leiming@gmail.com>
References: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Firstly bio_clone_mddev() is used in raid normal I/O and isn't
in resync I/O path.

Secondly all the direct access to bvec table in raid happens on
resync I/O except for write behind of raid1, in which we still
use bio_clone() for allocating new bvec table.

So this patch replaces bio_clone() with bio_clone_fast()
in bio_clone_mddev().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/md.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 704be11355a9..7d176f025add 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -193,10 +193,14 @@ EXPORT_SYMBOL_GPL(bio_alloc_mddev);
 struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 			    struct mddev *mddev)
 {
+	struct bio_set *bs;
+
 	if (!mddev || !mddev->bio_set)
-		return bio_clone(bio, gfp_mask);
+		bs = fs_bio_set;
+	else
+		bs = mddev->bio_set;
 
-	return bio_clone_bioset(bio, gfp_mask, mddev->bio_set);
+	return bio_clone_fast(bio, gfp_mask, bs);
 }
 EXPORT_SYMBOL_GPL(bio_clone_mddev);
 
-- 
2.7.4
