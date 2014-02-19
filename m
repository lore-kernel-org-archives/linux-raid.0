From: Lars Ellenberg <lars@linbit.com>
Subject: [PATCH] bcache: fix NULL pointer deref in blk_add_request_payload
Date: Wed, 19 Feb 2014 13:07:14 +0000
Message-ID: <1392815234-27015-1-git-send-email-lars@linbit.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Lars Ellenberg <lars@linbit.com>
List-Id: linux-raid.ids

bch_generic_make_request_hack() tries to be smart,
and fake a bi_max_bvecs = bi_vcnt.

If those bios have been REQ_DISCARD, and get submitted to a driver
(md raid) that uses bio_clone, the clone will end up with bi_io_vec == NULL,
passed down the stack, end up in sd_prep_fn and blk_add_request_payload,
which then tries to use bio->bi_io_vec->page.

Fix: try to be even smarter in bch_generic_make_request_hack(),
and always pretend to have at least bi_max_vecs of 1,
unless the incoming bio was already created without a single bvec.

Signed-off-by: Lars Ellenberg <lars@linbit.com>
---
 drivers/md/bcache/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 9056632..a638ac6 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -47,7 +47,7 @@ static void bch_generic_make_request_hack(struct bio *bio)
 	 *
 	 * To be taken out once immutable bvec stuff is in.
 	 */
-	bio->bi_max_vecs = bio->bi_vcnt;
+	bio->bi_max_vecs = bio->bi_vcnt ?: (bio->bi_io_vec ? 1 : 0);
 
 	generic_make_request(bio);
 }
-- 
1.7.10.4
