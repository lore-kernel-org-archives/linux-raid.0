From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/11] md/async: don't pass a memory pointer as a page
	pointer.
Date: Fri, 16 Oct 2009 16:49:19 +1100
Message-ID: <20091016054919.24208.89478.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

md/raid6 passes a list of 'struct page *' to the async_tx routines,
which then either DMA map them for offload, or take the page_address
for CPU based calculations.

For RAID6 we sometime leave 'blanks' in the list of pages.
For CPU based calcs, we want to treat theses as a page of zeros.
For offloaded calculations, we simply don't pass a page to the
hardware.

Currently the 'blanks' are encoded as a pointer to
raid6_empty_zero_page.  This is a 4096 byte memory region, not a
'struct page'.  This is mostly handled correctly but is rather ugly.

So change the code to pass and expect a NULL pointer for the blanks.
When taking page_address of a page, we need to check for a NULL and
in that case use raid6_empty_zero_page.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 crypto/async_tx/async_pq.c          |   15 ++++-----------
 crypto/async_tx/async_raid6_recov.c |   16 +++++++++++-----
 drivers/md/raid5.c                  |    4 ++--
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index b88db6d..9ab1ce4 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -30,11 +30,6 @@
  */
 static struct page *scribble;
 
-static bool is_raid6_zero_block(struct page *p)
-{
-	return p == (void *) raid6_empty_zero_page;
-}
-
 /* the struct page *blocks[] parameter passed to async_gen_syndrome()
  * and async_syndrome_val() contains the 'P' destination address at
  * blocks[disks-2] and the 'Q' destination address at blocks[disks-1]
@@ -83,7 +78,7 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 	 * sources and update the coefficients accordingly
 	 */
 	for (i = 0, idx = 0; i < src_cnt; i++) {
-		if (is_raid6_zero_block(blocks[i]))
+		if (blocks[i] == NULL)
 			continue;
 		dma_src[idx] = dma_map_page(dma->dev, blocks[i], offset, len,
 					    DMA_TO_DEVICE);
@@ -160,9 +155,9 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		srcs = (void **) blocks;
 
 	for (i = 0; i < disks; i++) {
-		if (is_raid6_zero_block(blocks[i])) {
+		if (blocks[i] == NULL) {
 			BUG_ON(i > disks - 3); /* P or Q can't be zero */
-			srcs[i] = blocks[i];
+			srcs[i] = (void*)raid6_empty_zero_page;
 		} else
 			srcs[i] = page_address(blocks[i]) + offset;
 	}
@@ -290,12 +285,10 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
 		for (i = 0; i < disks; i++)
-			if (likely(blocks[i])) {
-				BUG_ON(is_raid6_zero_block(blocks[i]));
+			if (likely(blocks[i]))
 				dma_src[i] = dma_map_page(dev, blocks[i],
 							  offset, len,
 							  DMA_TO_DEVICE);
-			}
 
 		for (;;) {
 			tx = device->device_prep_dma_pq_val(chan, pq, dma_src,
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 6d73dde..8e30b6e 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -263,10 +263,10 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
 	 * delta p and delta q
 	 */
 	dp = blocks[faila];
-	blocks[faila] = (void *)raid6_empty_zero_page;
+	blocks[faila] = NULL;
 	blocks[disks-2] = dp;
 	dq = blocks[failb];
-	blocks[failb] = (void *)raid6_empty_zero_page;
+	blocks[failb] = NULL;
 	blocks[disks-1] = dq;
 
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
@@ -338,7 +338,10 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
-			ptrs[i] = page_address(blocks[i]);
+			if (blocks[i] == NULL)
+				ptrs[i] = (void*)raid6_empty_zero_page;
+			else
+				ptrs[i] = page_address(blocks[i]);
 
 		raid6_2data_recov(disks, bytes, faila, failb, ptrs);
 
@@ -398,7 +401,10 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
-			ptrs[i] = page_address(blocks[i]);
+			if (blocks[i] == NULL)
+				ptrs[i] = (void*)raid6_empty_zero_page;
+			else
+				ptrs[i] = page_address(blocks[i]);
 
 		raid6_datap_recov(disks, bytes, faila, ptrs);
 
@@ -414,7 +420,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = blocks[faila];
-	blocks[faila] = (void *)raid6_empty_zero_page;
+	blocks[faila] = NULL;
 	blocks[disks-1] = dq;
 
 	/* in the 4 disk case we only need to perform a single source
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c4366c9..dcd9e65 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -720,7 +720,7 @@ static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
 	int i;
 
 	for (i = 0; i < disks; i++)
-		srcs[i] = (void *)raid6_empty_zero_page;
+		srcs[i] = NULL;
 
 	count = 0;
 	i = d0_idx;
@@ -816,7 +816,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	 * slot number conversion for 'faila' and 'failb'
 	 */
 	for (i = 0; i < disks ; i++)
-		blocks[i] = (void *)raid6_empty_zero_page;
+		blocks[i] = NULL;
 	count = 0;
 	i = d0_idx;
 	do {


