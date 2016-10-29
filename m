From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 39/60] bcache: debug: switch to bio_clone_sp()
Date: Sat, 29 Oct 2016 16:08:38 +0800
Message-ID: <1477728600-12938-40-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Guoqing Jiang <gqjiang@suse.com>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The cloned bio has to be singlepage bvec based, so
use bio_clone_sp(), and the allocated bvec table
is enough for hold the bvecs because QUEUE_FLAG_SPLIT_MP
is set for bcache.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/debug.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 71a9f05918eb..0735015b0842 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -111,12 +111,10 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	struct bvec_iter iter, citer = { 0 };
 
 	/*
-	 * Once multipage bvec is supported, the bio_clone()
-	 * has to make sure page count in this bio can be held
-	 * in the new cloned bio because each single page need
-	 * to assign to each bvec of the new bio.
+	 * QUEUE_FLAG_SPLIT_MP can make the cloned singlepage
+	 * bvecs to be held in the allocated bvec table.
 	 */
-	check = bio_clone(bio, GFP_NOIO);
+	check = bio_clone_sp(bio, GFP_NOIO);
 	if (!check)
 		return;
 	bio_set_op_attrs(check, REQ_OP_READ, READ_SYNC);
-- 
2.7.4
