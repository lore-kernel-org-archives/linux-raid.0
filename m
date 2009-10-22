From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [md PATCH 4/4] async_tx: fix asynchronous raid6 recovery for
	ddf	layouts
Date: Wed, 21 Oct 2009 17:42:14 -0700
Message-ID: <1256172134.11089.3.camel@dwillia2-linux.ch.intel.com>
References: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
	 <20091020071138.6489.73870.stgit@dwillia2-linux.ch.intel.com>
	 <19167.39058.385807.420558@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19167.39058.385807.420558@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2009-10-21 at 16:26 -0700, Neil Brown wrote:
> Thanks for these Dan.  I have pulled them and will ask Linus to pull
> them shortly.
> 
> I'm a little concerned about the following patch though.  While it
> looks like it is probably correct, it seems to be creating some rather
> complex code.
> 
> How hard would it be do simply scan the src_ptrs list for non-NULL
> entries and if there are 0 or 1 of them, handle them with special case
> code, rather than carrying around the 'is_ddf' flag and so forth??
> 

To be honest I did not really like the 'is_ddf' flag either.  How about
the following totally untested cleanup?

 crypto/async_tx/async_raid6_recov.c |  142 +++++++++++++++--------------------
 crypto/async_tx/raid6test.c         |    6 -
 drivers/md/raid5.c                  |    6 -
 include/linux/async_tx.h            |    6 -
 4 files changed, 67 insertions(+), 93 deletions(-)

diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 54b39d2..9fdd824 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -131,8 +131,8 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 }
 
 static struct dma_async_tx_descriptor *
-__2data_recov_4(size_t bytes, int faila, int failb, struct page **blocks,
-		bool is_ddf, struct async_submit_ctl *submit)
+__2data_recov_4(int disks, size_t bytes, int faila, int failb,
+		struct page **blocks, struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct page *p, *q, *a, *b;
@@ -143,13 +143,8 @@ __2data_recov_4(size_t bytes, int faila, int failb, struct page **blocks,
 	void *cb_param = submit->cb_param;
 	void *scribble = submit->scribble;
 
-	if (is_ddf) {
-		p = blocks[6-2];
-		q = blocks[6-1];
-	} else {
-		p = blocks[4-2];
-		q = blocks[4-1];
-	}
+	p = blocks[disks-2];
+	q = blocks[disks-1];
 
 	a = blocks[faila];
 	b = blocks[failb];
@@ -175,8 +170,8 @@ __2data_recov_4(size_t bytes, int faila, int failb, struct page **blocks,
 }
 
 static struct dma_async_tx_descriptor *
-__2data_recov_5(size_t bytes, int faila, int failb, struct page **blocks,
-		bool is_ddf, struct async_submit_ctl *submit)
+__2data_recov_5(int disks, size_t bytes, int faila, int failb,
+		struct page **blocks, struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct page *p, *q, *g, *dp, *dq;
@@ -186,34 +181,22 @@ __2data_recov_5(size_t bytes, int faila, int failb, struct page **blocks,
 	dma_async_tx_callback cb_fn = submit->cb_fn;
 	void *cb_param = submit->cb_param;
 	void *scribble = submit->scribble;
-	int good = -1;
-	int i;
-
-	if (is_ddf) {
-		/* a 7-disk ddf operation devolves to the 5-disk native
-		 * layout case modulo these fixups
-		 */
-		for (i = 0; i < 7-2; i++) {
-			if (blocks[i] == NULL)
-				continue;
-			if (i == faila || i == failb)
-				continue;
-			BUG_ON(good != -1);
-			good = i;
-		}
-		p = blocks[7-2];
-		q = blocks[7-1];
-	} else {
-		for (i = 0; i < 5-2; i++) {
-			if (i == faila || i == failb)
-				continue;
-			BUG_ON(good != -1);
-			good = i;
-		}
-		p = blocks[5-2];
-		q = blocks[5-1];
+	int good_srcs, good, i;
+
+	good_srcs = 0;
+	good = -1;
+	for (i = 0; i < disks-2; i++) {
+		if (blocks[i] == NULL)
+			continue;
+		if (i == faila || i == failb)
+			continue;
+		good = i;
+		good_srcs++;
 	}
-	BUG_ON(good == -1);
+	BUG_ON(good_srcs > 1);
+
+	p = blocks[disks-2];
+	q = blocks[disks-1];
 	g = blocks[good];
 
 	/* Compute syndrome with zero for the missing data pages
@@ -335,14 +318,14 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
  * @faila: first failed drive index
  * @failb: second failed drive index
  * @blocks: array of source pointers where the last two entries are p and q
- * @is_ddf: flag to indicate whether 'blocks' is in the ddf layout
  * @submit: submission/completion modifiers
  */
 struct dma_async_tx_descriptor *
 async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
-			struct page **blocks, bool is_ddf,
-			struct async_submit_ctl *submit)
+			struct page **blocks, struct async_submit_ctl *submit)
 {
+	int non_zero_srcs, i;
+
 	BUG_ON(faila == failb);
 	if (failb < faila)
 		swap(faila, failb);
@@ -376,26 +359,35 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 		 * operation (in contrast to the synchronous case), so
 		 * explicitly handle the 4 disk special case
 		 */
-		return __2data_recov_4(bytes, faila, failb, blocks, false, submit);
+		return __2data_recov_4(disks, bytes, faila, failb, blocks, submit);
 	case 5:
 		/* dma devices do not uniformly understand a single
 		 * source pq operation (in contrast to the synchronous
 		 * case), so explicitly handle the 5 disk special case
 		 */
-		return __2data_recov_5(bytes, faila, failb, blocks, false, submit);
+		return __2data_recov_5(disks, bytes, faila, failb, blocks, submit);
 	case 6:
-		if (is_ddf)
-			return __2data_recov_4(bytes, faila, failb, blocks,
-					       true, submit);
-		/* fall through */
+		non_zero_srcs = 0;
+		for (i = 0; i < disks-2; i++)
+			if (blocks[i])
+				non_zero_srcs++;
+		if (non_zero_srcs > 4) 
+			break;
+		/* catch the ddf 6-disk special case */
+		return __2data_recov_4(disks, bytes, faila, failb, blocks, submit);
 	case 7:
-		if (is_ddf)
-			return __2data_recov_5(bytes, faila, failb, blocks,
-					       true, submit);
-		/* fall through */
+		non_zero_srcs = 0;
+		for (i = 0; i < disks-2; i++)
+			if (blocks[i])
+				non_zero_srcs++;
+		if (non_zero_srcs > 5)
+			break;
+		/* catch the ddf 7-disk special case */
+		return __2data_recov_5(disks, bytes, faila, failb, blocks, submit);
 	default:
-		return __2data_recov_n(disks, bytes, faila, failb, blocks, submit);
+		break;
 	}
+	return __2data_recov_n(disks, bytes, faila, failb, blocks, submit);
 }
 EXPORT_SYMBOL_GPL(async_raid6_2data_recov);
 
@@ -405,13 +397,11 @@ EXPORT_SYMBOL_GPL(async_raid6_2data_recov);
  * @bytes: block size
  * @faila: failed drive index
  * @blocks: array of source pointers where the last two entries are p and q
- * @is_ddf: flag to indicate whether 'blocks' is in the ddf layout
  * @submit: submission/completion modifiers
  */
 struct dma_async_tx_descriptor *
 async_raid6_datap_recov(int disks, size_t bytes, int faila,
-			struct page **blocks, bool is_ddf,
-			struct async_submit_ctl *submit)
+			struct page **blocks, struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct page *p, *q, *dq;
@@ -420,6 +410,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	dma_async_tx_callback cb_fn = submit->cb_fn;
 	void *cb_param = submit->cb_param;
 	void *scribble = submit->scribble;
+	int good_srcs, good, i;
 	struct page *srcs[2];
 
 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
@@ -429,7 +420,6 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	 */
 	if (!scribble) {
 		void **ptrs = (void **) blocks;
-		int i;
 
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
@@ -445,6 +435,20 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 		return NULL;
 	}
 
+	good_srcs = 0;
+	good = -1;
+	for (i = 0; i < disks-2; i++) {
+		if (i == faila)
+			continue;
+		if (blocks[i]) {
+			good = i;
+			good_srcs++;
+			if (good_srcs > 1)
+				break;
+		}
+	}
+	BUG_ON(good_srcs == 0);
+
 	p = blocks[disks-2];
 	q = blocks[disks-1];
 
@@ -459,8 +463,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	 * perform a single source multiplication with the one good data
 	 * block.
 	 */
-	if (disks == 4 && !is_ddf) {
-		int good = faila == 0 ? 1 : 0;
+	if (good_srcs == 1) {
 		struct page *g = blocks[good];
 
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
@@ -470,29 +473,6 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
 				  scribble);
 		tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
-	} else if (disks == 6 && is_ddf) {
-		struct page *g;
-		int good = -1;
-		int i;
-
-		for (i = 0; i < 6-2; i++) {
-			if (blocks[i] == NULL)
-				continue;
-			if (i == faila)
-				continue;
-			BUG_ON(good != -1);
-			good = i;
-		}
-		BUG_ON(good == -1);
-		g = blocks[good];
-
-		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
-				  scribble);
-		tx = async_memcpy(p, g, 0, 0, bytes, submit);
-
-		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
-				  scribble);
-		tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
 	} else {
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
 				  scribble);
diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 9d7b3e1..3ec27c7 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -108,13 +108,11 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, stru
 		if (failb == disks-2) {
 			/* data+P failure. */
 			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
-			tx = async_raid6_datap_recov(disks, bytes, faila, ptrs,
-						     false, &submit);
+			tx = async_raid6_datap_recov(disks, bytes, faila, ptrs, &submit);
 		} else {
 			/* data+data failure. */
 			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
-			tx = async_raid6_2data_recov(disks, bytes, faila, failb,
-						     ptrs, false, &submit);
+			tx = async_raid6_2data_recov(disks, bytes, faila, failb, ptrs, &submit);
 		}
 	}
 	init_completion(&cmp);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 18d6ed4..81abefc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -888,14 +888,12 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			/* We're missing D+P. */
 			return async_raid6_datap_recov(syndrome_disks+2,
 						       STRIPE_SIZE, faila,
-						       blocks, sh->ddf_layout,
-						       &submit);
+						       blocks, &submit);
 		} else {
 			/* We're missing D+D. */
 			return async_raid6_2data_recov(syndrome_disks+2,
 						       STRIPE_SIZE, faila, failb,
-						       blocks, sh->ddf_layout,
-						       &submit);
+						       blocks, &submit);
 		}
 	}
 }
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 7520204..a1c486a 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -199,13 +199,11 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int src_cnt,
 
 struct dma_async_tx_descriptor *
 async_raid6_2data_recov(int src_num, size_t bytes, int faila, int failb,
-			struct page **ptrs, bool is_ddf,
-			struct async_submit_ctl *submit);
+			struct page **ptrs, struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
 async_raid6_datap_recov(int src_num, size_t bytes, int faila,
-			struct page **ptrs, bool is_ddf,
-			struct async_submit_ctl *submit);
+			struct page **ptrs, struct async_submit_ctl *submit);
 
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */


