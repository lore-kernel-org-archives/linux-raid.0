From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] raid5-ppl: two minor improvements
Date: Fri, 10 Mar 2017 16:40:44 +0100
Message-ID: <20170310154044.11198-1-artur.paszkiewicz@intel.com>
References: <20170309233240.r64itd7oreuxkumz@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170309233240.r64itd7oreuxkumz@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

- Remove 'page_result' parameter from ppl_xor() and always write result
  to 'page1'.
- Use blkdev_issue_flush() instead of open coding the flush bio
  submission.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-ppl.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index ca1ef644351a..2419fbc6f684 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -524,8 +524,7 @@ void ppl_stripe_write_finished(struct stripe_head *sh)
 		ppl_io_unit_finished(io);
 }
 
-static void ppl_xor(int size, struct page *page1, struct page *page2,
-		    struct page *page_result)
+static void ppl_xor(int size, struct page *page1, struct page *page2)
 {
 	struct async_submit_ctl submit;
 	struct dma_async_tx_descriptor *tx;
@@ -533,7 +532,7 @@ static void ppl_xor(int size, struct page *page1, struct page *page2,
 
 	init_async_submit(&submit, ASYNC_TX_ACK|ASYNC_TX_XOR_DROP_DST,
 			  NULL, NULL, NULL, NULL);
-	tx = async_xor(page_result, xor_srcs, 0, 2, size, &submit);
+	tx = async_xor(page1, xor_srcs, 0, 2, size, &submit);
 
 	async_tx_quiesce(&tx);
 }
@@ -724,7 +723,7 @@ static int ppl_recover_entry(struct ppl_log *log, struct ppl_header_entry *e,
 				goto out;
 			}
 
-			ppl_xor(block_size, page1, page2, page1);
+			ppl_xor(block_size, page1, page2);
 
 			indent -= 2;
 		}
@@ -747,7 +746,7 @@ static int ppl_recover_entry(struct ppl_log *log, struct ppl_header_entry *e,
 				goto out;
 			}
 
-			ppl_xor(block_size, page1, page2, page1);
+			ppl_xor(block_size, page1, page2);
 		}
 
 		/* map raid sector to parity disk */
@@ -846,14 +845,7 @@ static int ppl_recover(struct ppl_log *log, struct ppl_header *pplhdr)
 	}
 
 	/* flush the disk cache after recovery if necessary */
-	if (test_bit(QUEUE_FLAG_WC, &bdev_get_queue(rdev->bdev)->queue_flags)) {
-		struct bio *bio = bio_alloc_bioset(GFP_KERNEL, 0, ppl_conf->bs);
-
-		bio->bi_bdev = rdev->bdev;
-		bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-		ret = submit_bio_wait(bio);
-		bio_put(bio);
-	}
+	ret = blkdev_issue_flush(rdev->bdev, GFP_KERNEL, NULL);
 out:
 	__free_page(page);
 	return ret;
-- 
2.11.0

