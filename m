From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 57/60] bcache: convert to bio_for_each_segment_all_rd()
Date: Sat, 29 Oct 2016 16:08:56 +0800
Message-ID: <1477728600-12938-58-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Hannes Reinecke <hare@suse.com>, Jiri Kosina <jkosina@suse.cz>, Mike Christie <mchristi@redhat.com>, Guoqing Jiang <gqjiang@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index b419bc91ba32..89abada6a091 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -419,8 +419,9 @@ static void do_btree_node_write(struct btree *b)
 		int j;
 		struct bio_vec *bv;
 		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
+		struct bvec_iter_all bia;
 
-		bio_for_each_segment_all(bv, b->bio, j)
+		bio_for_each_segment_all_rd(bv, b->bio, j, bia)
 			memcpy(page_address(bv->bv_page),
 			       base + j * PAGE_SIZE, PAGE_SIZE);
 
-- 
2.7.4
