From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 3/6] md: convert to genradix
Date: Tue, 22 May 2018 21:18:18 -0400
Message-ID: <20180523011821.12165-3-kent.overstreet@gmail.com>
References: <20180523011821.12165-1-kent.overstreet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523011821.12165-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, willy@infradead.org, gregkh@linuxfoundation.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, dev@openvswitch.org, shli@kernel.org, linux-raid@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-raid.ids

the new generic radix trees have a simpler API and implementation, and
no limitations on number of elements, so all flex_array users are being
converted

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/raid5-ppl.c |  5 ++-
 drivers/md/raid5.c     | 77 ++++++++++++++++++++----------------------
 drivers/md/raid5.h     |  4 ++-
 3 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 42890a0837..ffb4ae0679 100644
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
+	struct page **srcs = __genradix_ptr(&percpu->scribble, 0);
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
@@ -196,7 +195,7 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
-			  NULL, sh, flex_array_get(percpu->scribble, 0)
+			  NULL, sh, __genradix_ptr(&percpu->scribble, 0)
 			  + sizeof(struct page *) * (sh->disks + 2));
 
 	if (count == 1)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b5d2601483..31f88db83c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -54,7 +54,6 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/nodemask.h>
-#include <linux/flex_array.h>
 
 #include <trace/events/block.h>
 #include <linux/list_sort.h>
@@ -1396,7 +1395,9 @@ static addr_conv_t *to_addr_conv(struct stripe_head *sh,
 {
 	void *addr;
 
-	addr = flex_array_get(percpu->scribble, i);
+	addr = __genradix_ptr(&percpu->scribble,
+			 __idx_to_offset(i, percpu->scribble_obj_size));
+
 	return addr + sizeof(struct page *) * (sh->disks + 2);
 }
 
@@ -1405,7 +1406,8 @@ static struct page **to_addr_page(struct raid5_percpu *percpu, int i)
 {
 	void *addr;
 
-	addr = flex_array_get(percpu->scribble, i);
+	addr = __genradix_ptr(&percpu->scribble,
+			 __idx_to_offset(i, percpu->scribble_obj_size));
 	return addr;
 }
 
@@ -2235,21 +2237,21 @@ static int grow_stripes(struct r5conf *conf, int num)
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
+	int ret;
 
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
+	ret = __genradix_prealloc(&percpu->scribble,
+			 __idx_to_offset(cnt + 1, obj_size), flags);
+	if (ret)
+		return ret;
+
+	percpu->scribble_obj_size = obj_size;
+	return 0;
 }
 
 static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
@@ -2267,23 +2269,18 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
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
@@ -6716,25 +6713,25 @@ raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
 {
 	safe_put_page(percpu->spare_page);
-	if (percpu->scribble)
-		flex_array_free(percpu->scribble);
 	percpu->spare_page = NULL;
-	percpu->scribble = NULL;
+	__genradix_free(&percpu->scribble);
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
index 3f8da26032..2c39bfce32 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -4,6 +4,7 @@
 
 #include <linux/raid/xor.h>
 #include <linux/dmaengine.h>
+#include <linux/generic-radix-tree.h>
 
 /*
  *
@@ -637,10 +638,11 @@ struct r5conf {
 	/* per cpu variables */
 	struct raid5_percpu {
 		struct page	*spare_page; /* Used when checking P/Q in raid6 */
-		struct flex_array *scribble;   /* space for constructing buffer
+		struct __genradix scribble;  /* space for constructing buffer
 					      * lists and performing address
 					      * conversions
 					      */
+		int scribble_obj_size;
 	} __percpu *percpu;
 	int scribble_disks;
 	int scribble_sectors;
-- 
2.17.0
