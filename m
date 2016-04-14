From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 14/27] bcache: writeback: use bio_set_vec_table()
Date: Thu, 14 Apr 2016 20:02:32 +0800
Message-ID: <1460635375-28282-15-git-send-email-tom.leiming@gmail.com>
References: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/writeback.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index b9346cd..49a8f8a 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -112,9 +112,9 @@ static void dirty_init(struct keybuf_key *w)
 		bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
-	bio->bi_max_vecs	= DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS);
 	bio->bi_private		= w;
-	bio->bi_io_vec		= bio->bi_inline_vecs;
+	bio_set_vec_table(bio, bio->bi_inline_vecs,
+			  DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS));
 	bch_bio_map(bio, NULL);
 }
 
-- 
1.9.1

