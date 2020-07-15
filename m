From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v6 06/15] md/raid5: set correct page offset for async_copy_data()
Date: Wed, 15 Jul 2020 08:42:48 -0400
Message-ID: <20200715124257.3175816-7-yuyufen@huawei.com>
References: <20200715124257.3175816-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200715124257.3175816-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

ops_run_biofill() and ops_run_biodrain() will call async_copy_data()
to copy sh->dev[i].page from or to bio. It also need to set correct
page offset for dev->page when use r5pages.

Without modifying original code logic, we replace 'page_offset' with
'page_offset + poff' simplify. In case of that wihtout using r5pages,
poff is zero.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 96efb4ad8835..6f13ac9502a5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1296,7 +1296,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 static struct dma_async_tx_descriptor *
 async_copy_data(int frombio, struct bio *bio, struct page **page,
-	sector_t sector, struct dma_async_tx_descriptor *tx,
+	unsigned int poff, sector_t sector, struct dma_async_tx_descriptor *tx,
 	struct stripe_head *sh, int no_skipcopy)
 {
 	struct bio_vec bvl;
@@ -1342,11 +1342,13 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
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
+						page_offset + poff,
+						clen, &submit);
 		}
 		/* chain the operations */
 		submit.depend_tx = tx;
@@ -1418,7 +1420,8 @@ static void ops_run_biofill(struct stripe_head *sh)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + sh->raid_conf->stripe_sectors) {
 				tx = async_copy_data(0, rbi, &dev->page,
-						     dev->sector, tx, sh, 0);
+						dev->offset,
+						dev->sector, tx, sh, 0);
 				rbi = r5_next_bio(sh->raid_conf, rbi,
 						dev->sector);
 			}
@@ -1846,6 +1849,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
+							     dev->offset,
 							     dev->sector, tx, sh,
 							     r5c_is_writeback(conf->log));
 					if (dev->page != dev->orig_page &&
-- 
2.25.4
