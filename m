From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v3 05/11] md/raid5: set correct page offset for async_copy_data()
Date: Wed, 27 May 2020 21:19:27 +0800
Message-ID: <20200527131933.34400-6-yuyufen@huawei.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200527131933.34400-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

ops_run_biofill() and ops_run_biodrain() will call async_copy_data()
to copy sh->dev[i].page from or to bio. It also need to set correct
page offset for dev->page when use r5pages.

Without modifying original code logic, we replace 'page_offset' with
'page_offset + poff' simplify. In case of that wihtout using r5pages,
poff is zero.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9890f21e4f47..4b7b5cc1ba1f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1290,7 +1290,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 static struct dma_async_tx_descriptor *
 async_copy_data(int frombio, struct bio *bio, struct page **page,
-	sector_t sector, struct dma_async_tx_descriptor *tx,
+	unsigned int poff, sector_t sector, struct dma_async_tx_descriptor *tx,
 	struct stripe_head *sh, int no_skipcopy)
 {
 	struct bio_vec bvl;
@@ -1325,6 +1325,7 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 		else
 			clen = len;
 
+
 		if (clen > 0) {
 			b_offset += bvl.bv_offset;
 			bio_page = bvl.bv_page;
@@ -1335,11 +1336,12 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 				    !no_skipcopy)
 					*page = bio_page;
 				else
-					tx = async_memcpy(*page, bio_page, page_offset,
-						  b_offset, clen, &submit);
+					tx = async_memcpy(*page, bio_page,
+						  page_offset + poff, b_offset,
+						  clen, &submit);
 			} else
 				tx = async_memcpy(bio_page, *page, b_offset,
-						  page_offset, clen, &submit);
+						  page_offset + poff, clen, &submit);
 		}
 		/* chain the operations */
 		submit.depend_tx = tx;
@@ -1410,7 +1412,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, &dev->page,
-						     dev->sector, tx, sh, 0);
+						dev->offset, dev->sector, tx, sh, 0);
 				rbi = r5_next_bio(rbi, dev->sector);
 			}
 		}
@@ -1825,7 +1827,8 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
-							     dev->sector, tx, sh,
+							     dev->offset, dev->sector,
+							     tx, sh,
 							     r5c_is_writeback(conf->log));
 					if (dev->page != dev->orig_page &&
 					    !r5c_is_writeback(conf->log)) {
-- 
2.21.3
