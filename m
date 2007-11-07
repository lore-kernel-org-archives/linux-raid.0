From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Tue, 06 Nov 2007 18:25:00 -0700
Message-ID: <1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
	 <18222.16003.92062.970530@notabene.brown>
	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
	 <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
	 <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>
	 <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>
	 <47303FB8.7000801@systella.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-iuvdnzXEF/isZMFWbVRx"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47303FB8.7000801@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: BERTRAND =?ISO-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jeff@lessem.org
List-Id: linux-raid.ids


--=-iuvdnzXEF/isZMFWbVRx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 2007-11-06 at 03:19 -0700, BERTRAND Joël wrote:
>         Done. Here is obtained ouput :

Much appreciated.
> 
> [ 1260.969314] handling stripe 7629696, state=0x14 cnt=1, pd_idx=2 ops=0:0:0
> [ 1260.980606] check 5: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ffcffcc0 written 0000000000000000
> [ 1260.994808] check 4: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fdd4e360 written 0000000000000000
> [ 1261.009325] check 3: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
> [ 1261.244478] check 2: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
> [ 1261.270821] check 1: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ff517e40 written 0000000000000000
> [ 1261.312320] check 0: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fd4cae60 written 0000000000000000
> [ 1261.361030] locked=4 uptodate=2 to_read=0 to_write=4 failed=0 failed_num=0
> [ 1261.443120] for sector 7629696, rmw=0 rcw=0
[..]

This looks as if the blocks were prepared to be written out, but were
never handled in ops_run_biodrain(), so they remain locked forever.  The
operations flags are all clear which means handle_stripe thinks nothing
else needs to be done.

The following patch, also attached, cleans up cases where the code looks
at sh->ops.pending when it should be looking at the consistent
stack-based snapshot of the operations flags.


---

 drivers/md/raid5.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 496b9a3..e1a3942 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -693,7 +693,8 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		 unsigned long pending)
 {
 	int disks = sh->disks;
 	int pd_idx = sh->pd_idx, i;
@@ -701,7 +702,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
 	 */
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -778,7 +779,8 @@ static void ops_complete_write(void *stripe_head_ref)
 }
 
 static void
-ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		unsigned long pending)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -786,7 +788,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 	unsigned long flags;
 	dma_async_tx_callback callback;
 
@@ -813,7 +815,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	}
 
 	/* check whether this postxor is part of a write */
-	callback = test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
+	callback = test_bit(STRIPE_OP_BIODRAIN, &pending) ?
 		ops_complete_write : ops_complete_postxor;
 
 	/* 1/ if we prexor'd then the dest is reused as a source
@@ -901,12 +903,12 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 		tx = ops_run_prexor(sh, tx);
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
-		tx = ops_run_biodrain(sh, tx);
+		tx = ops_run_biodrain(sh, tx, pending);
 		overlap_clear++;
 	}
 
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
-		ops_run_postxor(sh, tx);
+		ops_run_postxor(sh, tx, pending);
 
 	if (test_bit(STRIPE_OP_CHECK, &pending))
 		ops_run_check(sh);


--=-iuvdnzXEF/isZMFWbVRx
Content-Disposition: attachment; filename=raid5-fix-unending-write-sequence.patch
Content-Type: text/x-patch; name=raid5-fix-unending-write-sequence.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

raid5: fix unending write sequence

From: Dan Williams <dan.j.williams@intel.com>


---

 drivers/md/raid5.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 496b9a3..e1a3942 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -693,7 +693,8 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		 unsigned long pending)
 {
 	int disks = sh->disks;
 	int pd_idx = sh->pd_idx, i;
@@ -701,7 +702,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
 	 */
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -778,7 +779,8 @@ static void ops_complete_write(void *stripe_head_ref)
 }
 
 static void
-ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		unsigned long pending)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -786,7 +788,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 	unsigned long flags;
 	dma_async_tx_callback callback;
 
@@ -813,7 +815,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	}
 
 	/* check whether this postxor is part of a write */
-	callback = test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
+	callback = test_bit(STRIPE_OP_BIODRAIN, &pending) ?
 		ops_complete_write : ops_complete_postxor;
 
 	/* 1/ if we prexor'd then the dest is reused as a source
@@ -901,12 +903,12 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 		tx = ops_run_prexor(sh, tx);
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
-		tx = ops_run_biodrain(sh, tx);
+		tx = ops_run_biodrain(sh, tx, pending);
 		overlap_clear++;
 	}
 
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
-		ops_run_postxor(sh, tx);
+		ops_run_postxor(sh, tx, pending);
 
 	if (test_bit(STRIPE_OP_CHECK, &pending))
 		ops_run_check(sh);

--=-iuvdnzXEF/isZMFWbVRx--
