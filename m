From: Michael Wang <yun.wang@profitbricks.com>
Subject: [RFC PATCH] blk: reset 'bi_next' when bio is done inside request
Date: Mon, 3 Apr 2017 14:05:16 +0200
Message-ID: <9505ff12-7307-7dec-76b5-2a233a592634@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids


blk_attempt_plug_merge() try to merge bio into request and chain them
by 'bi_next', while after the bio is done inside request, we forgot to
reset the 'bi_next'.

This lead into BUG while removing all the underlying devices from md-raid1,
the bio once go through:

  md_do_sync()
    sync_request()
      generic_make_request()
        blk_queue_bio()
          blk_attempt_plug_merge()
            CHAINED HERE

will keep chained and reused by:

  raid1d()
    sync_request_write()
      generic_make_request()
        BUG_ON(bio->bi_next)

After reset the 'bi_next' this can no longer happen.

Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 block/blk-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 43b7d06..91223b2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2619,8 +2619,10 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
                struct bio *bio = req->bio;
                unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);

-               if (bio_bytes == bio->bi_iter.bi_size)
+               if (bio_bytes == bio->bi_iter.bi_size) {
                        req->bio = bio->bi_next;
+                       bio->bi_next = NULL;
+               }

                req_bio_endio(req, bio, bio_bytes, error);

-- 
2.5.0
