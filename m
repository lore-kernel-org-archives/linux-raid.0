From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 05/11] md/raid5: add scribble region for buffer lists
Date: Mon, 18 May 2009 17:59:51 -0700
Message-ID: <20090519005951.4104.27062.stgit@dwillia2-linux.ch.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
List-Id: linux-raid.ids

Hang some memory off of each stripe_head which can be used for storing
the buffer lists used in parity calculations.  Include space for dma
address conversions and pass that to async_tx via the
async_submit_ctl.scribble pointer.

[ Impact: move memory pressure from stack to heap ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |   61 ++++++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid5.h |    5 ++++
 2 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e1920f2..0e456a6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -275,6 +275,9 @@ static void shrink_buffers(struct stripe_head *sh, int num)
 	struct page *p;
 	int i;
 
+	kfree(sh->scribble);
+	sh->scribble = NULL;
+
 	for (i=0; i<num ; i++) {
 		p = sh->dev[i].page;
 		if (!p)
@@ -284,10 +287,26 @@ static void shrink_buffers(struct stripe_head *sh, int num)
 	}
 }
 
+static size_t scribble_len(int num)
+{
+	size_t len;
+
+	/* return enough space for an array of page pointers and dma
+	 * addresses for the ddf raid6 layout
+	 */
+	len = sizeof(struct page *) * (num+2) + sizeof(addr_conv_t) * (num+2);
+
+	return len;
+}
+
 static int grow_buffers(struct stripe_head *sh, int num)
 {
 	int i;
 
+	sh->scribble = kmalloc(scribble_len(num), GFP_KERNEL);
+	if (!sh->scribble)
+		return 1;
+
 	for (i=0; i<num; i++) {
 		struct page *page;
 
@@ -641,11 +660,16 @@ static void ops_complete_compute5(void *stripe_head_ref)
 	release_stripe(sh);
 }
 
+/* return a pointer to the address conversion region of the scribble buffer */
+static addr_conv_t *sh_to_addr_conv(struct stripe_head *sh)
+{
+	return sh->scribble + sizeof(struct page *) * (sh->disks + 2);
+}
+
 static struct dma_async_tx_descriptor *ops_run_compute5(struct stripe_head *sh)
 {
-	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
-	struct page *xor_srcs[disks];
+	struct page **xor_srcs = sh->scribble;
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
 	struct page *xor_dest = tgt->page;
@@ -665,7 +689,7 @@ static struct dma_async_tx_descriptor *ops_run_compute5(struct stripe_head *sh)
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
-			  ops_complete_compute5, sh, NULL);
+			  ops_complete_compute5, sh, sh_to_addr_conv(sh));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
@@ -685,9 +709,8 @@ static void ops_complete_prexor(void *stripe_head_ref)
 static struct dma_async_tx_descriptor *
 ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
-	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
-	struct page *xor_srcs[disks];
+	struct page **xor_srcs = sh->scribble;
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
@@ -705,7 +728,7 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	}
 
 	init_async_submit(&submit, ASYNC_TX_XOR_DROP_DST, tx,
-			  ops_complete_prexor, sh, NULL);
+			  ops_complete_prexor, sh, sh_to_addr_conv(sh));
 	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 
 	return tx;
@@ -776,9 +799,8 @@ static void ops_complete_postxor(void *stripe_head_ref)
 static void
 ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
-	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
-	struct page *xor_srcs[disks];
+	struct page **xor_srcs = sh->scribble;
 	struct async_submit_ctl submit;
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
@@ -818,7 +840,8 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	atomic_inc(&sh->count);
 
-	init_async_submit(&submit, flags, tx, ops_complete_postxor, sh, NULL);
+	init_async_submit(&submit, flags, tx, ops_complete_postxor, sh,
+			  sh_to_addr_conv(sh));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
@@ -839,9 +862,8 @@ static void ops_complete_check(void *stripe_head_ref)
 
 static void ops_run_check(struct stripe_head *sh)
 {
-	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
-	struct page *xor_srcs[disks];
+	struct page **xor_srcs = sh->scribble;
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 
@@ -857,7 +879,7 @@ static void ops_run_check(struct stripe_head *sh)
 			xor_srcs[count++] = dev->page;
 	}
 
-	init_async_submit(&submit, 0, NULL, NULL, NULL, NULL);
+	init_async_submit(&submit, 0, NULL, NULL, NULL, sh_to_addr_conv(sh));
 	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 			   &sh->ops.zero_sum_result, &submit);
 
@@ -871,6 +893,7 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
 
+	mutex_lock(&sh->scribble_lock);
 	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
 		ops_run_biofill(sh);
 		overlap_clear++;
@@ -903,6 +926,7 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&sh->raid_conf->wait_for_overlap);
 		}
+	mutex_unlock(&sh->scribble_lock);
 }
 
 static int grow_one_stripe(raid5_conf_t *conf)
@@ -914,6 +938,7 @@ static int grow_one_stripe(raid5_conf_t *conf)
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
 	sh->raid_conf = conf;
 	spin_lock_init(&sh->lock);
+	mutex_init(&sh->scribble_lock);
 
 	if (grow_buffers(sh, conf->raid_disks)) {
 		shrink_buffers(sh, conf->raid_disks);
@@ -1007,6 +1032,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 
 		nsh->raid_conf = conf;
 		spin_lock_init(&nsh->lock);
+		mutex_init(&nsh->scribble_lock);
 
 		list_add(&nsh->lru, &newstripes);
 	}
@@ -1038,6 +1064,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 			nsh->dev[i].page = osh->dev[i].page;
 		for( ; i<newsize; i++)
 			nsh->dev[i].page = NULL;
+		nsh->scribble = osh->scribble;
 		kmem_cache_free(conf->slab_cache, osh);
 	}
 	kmem_cache_destroy(conf->slab_cache);
@@ -1058,8 +1085,18 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 
 	/* Step 4, return new stripes to service */
 	while(!list_empty(&newstripes)) {
+		void *scribble;
+
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
 		list_del_init(&nsh->lru);
+
+		scribble = kmalloc(scribble_len(newsize), GFP_NOIO);
+		if (scribble) {
+			kfree(nsh->scribble);
+			nsh->scribble = scribble;
+		} else
+			err = -ENOMEM;
+
 		for (i=conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
 				struct page *p = alloc_page(GFP_NOIO);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 52ba999..6ab0ccd 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -211,6 +211,11 @@ struct stripe_head {
 	int			disks;		/* disks in stripe */
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
+	void			*scribble;	/* space for constructing buffer
+						 * lists and performing address
+						 * conversions
+						 */
+	struct mutex		scribble_lock; /* no concurrent scribbling */
 	/* stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
 	 */

