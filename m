From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 12/27] bcache: journal.c: use bio_set_vec_table()
Date: Tue,  5 Apr 2016 19:56:57 +0800
Message-ID: <1459857443-20611-13-git-send-email-tom.leiming@gmail.com>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/journal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 29eba72..bf8924f 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -453,8 +453,7 @@ static void do_journal_discard(struct cache *ca)
 						ca->sb.d[ja->discard_idx]);
 		bio->bi_bdev		= ca->bdev;
 		bio->bi_rw		= REQ_WRITE|REQ_DISCARD;
-		bio->bi_max_vecs	= 1;
-		bio->bi_io_vec		= bio->bi_inline_vecs;
+		bio_set_vec_table(bio, bio->bi_inline_vecs, 1);
 		bio->bi_iter.bi_size	= bucket_bytes(ca);
 		bio->bi_end_io		= journal_discard_endio;
 
-- 
1.9.1
