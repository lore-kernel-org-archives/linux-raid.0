From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 13/27] bcache: movinggc: use bio_set_vec_table()
Date: Tue,  5 Apr 2016 19:56:58 +0800
Message-ID: <1459857443-20611-14-git-send-email-tom.leiming@gmail.com>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/movinggc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index b929fc9..dbe5af2 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -85,10 +85,10 @@ static void moving_init(struct moving_io *io)
 	bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&io->w->key) << 9;
-	bio->bi_max_vecs	= DIV_ROUND_UP(KEY_SIZE(&io->w->key),
-					       PAGE_SECTORS);
 	bio->bi_private		= &io->cl;
-	bio->bi_io_vec		= bio->bi_inline_vecs;
+	bio_set_vec_table(bio, bio->bi_inline_vecs,
+			  DIV_ROUND_UP(KEY_SIZE(&io->w->key),
+			  PAGE_SECTORS));
 	bch_bio_map(bio, NULL);
 }
 
-- 
1.9.1
