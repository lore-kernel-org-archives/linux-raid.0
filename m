From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 2/6] md: convert to kvmalloc
Date: Fri,  7 Sep 2018 12:56:31 -0400
Message-ID: <20180907165635.8469-3-kent.overstreet@gmail.com>
References: <20180907165635.8469-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180907165635.8469-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Matthew Wilcox <willy@infradead.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The code really just wants a big flat buffer, so just do that.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/raid5-ppl.c |  7 ++--
 drivers/md/raid5.c     | 82 +++++++++++++++++++-----------------------
 drivers/md/raid5.h     |  9 ++---
 3 files changed, 45 insertions(+), 53 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 3a7c363265..5911810101 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -16,7 +16,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/crc32c.h>
-#include <linux/flex_array.h>
 #include <linux/async_tx.h>
 #include <linux/raid/md_p.h>
 #include "md.h"
@@ -165,7 +164,7 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
 		       struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	struct page **srcs = flex_array_get(percpu->scribble, 0);
+	struct page **srcs = percpu->scribble;
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
@@ -196,8 +195,8 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
-			  NULL, sh, flex_array_get(percpu->scribble, 0)
-			  + sizeof(struct page *) * (sh->disks + 2));
+			  NULL, sh, percpu->scribble +
+			  sizeof(struct page *) * (sh->disks + 2));
 
 	if (count == 1)
 		tx = async_memcpy(sh->ppl_page, srcs[0], 0, 0, PAGE_SIZE,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2031506a0e..d5603946dc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -54,7 +54,6 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/nodemask.h>
-#include <linux/flex_array.h>
 
 #include <trace/events/block.h>
 #include <linux/list_sort.h>
@@ -1399,19 +1398,14 @@ static void ops_complete_compute(void *stripe_head_ref)
 static addr_conv_t *to_addr_conv(struct stripe_head *sh,
 				 struct raid5_percpu *percpu, int i)
 {
-	void *addr;
-
-	addr = flex_array_get(percpu->scribble, i);
-	return addr + sizeof(struct page *) * (sh->disks + 2);
+	return percpu->scribble + i * percpu->scribble_obj_size +
+		sizeof(struct page *) * (sh->disks + 2);
 }
 
 /* return a pointer to the address conversion region of the scribble buffer */
 static struct page **to_addr_page(struct raid5_percpu *percpu, int i)
 {
-	void *addr;
-
-	addr = flex_array_get(percpu->scribble, i);
-	return addr;
+	return percpu->scribble + i * percpu->scribble_obj_size;
 }
 
 static struct dma_async_tx_descriptor *
@@ -2240,21 +2234,23 @@ static int grow_stripes(struct r5conf *conf, int num)
  * calculate over all devices (not just the data blocks), using zeros in place
  * of the P and Q blocks.
  */
-static struct flex_array *scribble_alloc(int num, int cnt, gfp_t flags)
+static int scribble_alloc(struct raid5_percpu *percpu,
+			  int num, int cnt, gfp_t flags)
 {
-	struct flex_array *ret;
-	size_t len;
+	size_t obj_size =
+		sizeof(struct page *) * (num+2) +
+		sizeof(addr_conv_t) * (num+2);
+	void *scribble;
 
-	len = sizeof(struct page *) * (num+2) + sizeof(addr_conv_t) * (num+2);
-	ret = flex_array_alloc(len, cnt, flags);
-	if (!ret)
-		return NULL;
-	/* always prealloc all elements, so no locking is required */
-	if (flex_array_prealloc(ret, 0, cnt, flags)) {
-		flex_array_free(ret);
-		return NULL;
-	}
-	return ret;
+	scribble = kvmalloc_array(cnt, obj_size, flags);
+	if (!scribble)
+		return -ENOMEM;
+
+	kvfree(percpu->scribble);
+
+	percpu->scribble = scribble;
+	percpu->scribble_obj_size = obj_size;
+	return 0;
 }
 
 static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
@@ -2272,23 +2268,18 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 		return 0;
 	mddev_suspend(conf->mddev);
 	get_online_cpus();
+
 	for_each_present_cpu(cpu) {
 		struct raid5_percpu *percpu;
-		struct flex_array *scribble;
 
 		percpu = per_cpu_ptr(conf->percpu, cpu);
-		scribble = scribble_alloc(new_disks,
-					  new_sectors / STRIPE_SECTORS,
-					  GFP_NOIO);
-
-		if (scribble) {
-			flex_array_free(percpu->scribble);
-			percpu->scribble = scribble;
-		} else {
-			err = -ENOMEM;
+		err = scribble_alloc(percpu, new_disks,
+				     new_sectors / STRIPE_SECTORS,
+				     GFP_NOIO);
+		if (err)
 			break;
-		}
 	}
+
 	put_online_cpus();
 	mddev_resume(conf->mddev);
 	if (!err) {
@@ -6722,25 +6713,26 @@ raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
 {
 	safe_put_page(percpu->spare_page);
-	if (percpu->scribble)
-		flex_array_free(percpu->scribble);
 	percpu->spare_page = NULL;
+	kvfree(percpu->scribble);
 	percpu->scribble = NULL;
 }
 
 static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
 {
-	if (conf->level == 6 && !percpu->spare_page)
+	if (conf->level == 6 && !percpu->spare_page) {
 		percpu->spare_page = alloc_page(GFP_KERNEL);
-	if (!percpu->scribble)
-		percpu->scribble = scribble_alloc(max(conf->raid_disks,
-						      conf->previous_raid_disks),
-						  max(conf->chunk_sectors,
-						      conf->prev_chunk_sectors)
-						   / STRIPE_SECTORS,
-						  GFP_KERNEL);
-
-	if (!percpu->scribble || (conf->level == 6 && !percpu->spare_page)) {
+		if (!percpu->spare_page)
+			return -ENOMEM;
+	}
+
+	if (scribble_alloc(percpu,
+			   max(conf->raid_disks,
+			       conf->previous_raid_disks),
+			   max(conf->chunk_sectors,
+			       conf->prev_chunk_sectors)
+			   / STRIPE_SECTORS,
+			   GFP_KERNEL)) {
 		free_scratch_buffer(conf, percpu);
 		return -ENOMEM;
 	}
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 8474c22412..cf991f1340 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -638,10 +638,11 @@ struct r5conf {
 	/* per cpu variables */
 	struct raid5_percpu {
 		struct page	*spare_page; /* Used when checking P/Q in raid6 */
-		struct flex_array *scribble;   /* space for constructing buffer
-					      * lists and performing address
-					      * conversions
-					      */
+		void		*scribble;  /* space for constructing buffer
+					     * lists and performing address
+					     * conversions
+					     */
+		int scribble_obj_size;
 	} __percpu *percpu;
 	int scribble_disks;
 	int scribble_sectors;
-- 
2.19.0.rc2
