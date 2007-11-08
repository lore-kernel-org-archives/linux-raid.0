From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] raid5: fix unending write sequence
Date: Thu, 08 Nov 2007 09:27:39 -0700
Message-ID: <1194539259.15713.30.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, stable@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Dan Williams <dan.j.williams@intel.com>

<debug output from Jo=C3=ABl's system>
handling stripe 7629696, state=3D0x14 cnt=3D1, pd_idx=3D2 ops=3D0:0:0
check 5: state 0x6 toread 0000000000000000 read 0000000000000000 write =
fffff800ffcffcc0 written 0000000000000000
check 4: state 0x6 toread 0000000000000000 read 0000000000000000 write =
fffff800fdd4e360 written 0000000000000000
check 3: state 0x1 toread 0000000000000000 read 0000000000000000 write =
0000000000000000 written 0000000000000000
check 2: state 0x1 toread 0000000000000000 read 0000000000000000 write =
0000000000000000 written 0000000000000000
check 1: state 0x6 toread 0000000000000000 read 0000000000000000 write =
fffff800ff517e40 written 0000000000000000
check 0: state 0x6 toread 0000000000000000 read 0000000000000000 write =
fffff800fd4cae60 written 0000000000000000
locked=3D4 uptodate=3D2 to_read=3D0 to_write=3D4 failed=3D0 failed_num=3D=
0
for sector 7629696, rmw=3D0 rcw=3D0
</debug>

These blocks were prepared to be written out, but were never handled in
ops_run_biodrain(), so they remain locked forever.  The operations flag=
s
are all clear which means handle_stripe() thinks nothing else needs to =
be
done.

This state suggests that the STRIPE_OP_PREXOR bit was sampled 'set' whe=
n it
should not have been.  This patch cleans up cases where the code looks =
at
sh->ops.pending when it should be looking at the consistent stack-based
snapshot of the operations flags.

Report from Jo=C3=ABl:
	Resync done. Patch fix this bug.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Jo=C3=ABl Bertrand <joel.bertrand@systella.fr>
Cc: stable@kernel.org
---

 drivers/md/raid5.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3808f52..e86cacb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -689,7 +689,8 @@ ops_run_prexor(struct stripe_head *sh, struct dma_a=
sync_tx_descriptor *tx)
 }
=20
 static struct dma_async_tx_descriptor *
-ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descripto=
r *tx)
+ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descripto=
r *tx,
+		 unsigned long pending)
 {
 	int disks =3D sh->disks;
 	int pd_idx =3D sh->pd_idx, i;
@@ -697,7 +698,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma=
_async_tx_descriptor *tx)
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
 	 */
-	int prexor =3D test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor =3D test_bit(STRIPE_OP_PREXOR, &pending);
=20
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -774,7 +775,8 @@ static void ops_complete_write(void *stripe_head_re=
f)
 }
=20
 static void
-ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor=
 *tx)
+ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor=
 *tx,
+		unsigned long pending)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks =3D sh->disks;
@@ -782,7 +784,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_=
async_tx_descriptor *tx)
=20
 	int count =3D 0, pd_idx =3D sh->pd_idx, i;
 	struct page *xor_dest;
-	int prexor =3D test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor =3D test_bit(STRIPE_OP_PREXOR, &pending);
 	unsigned long flags;
 	dma_async_tx_callback callback;
=20
@@ -809,7 +811,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_=
async_tx_descriptor *tx)
 	}
=20
 	/* check whether this postxor is part of a write */
-	callback =3D test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
+	callback =3D test_bit(STRIPE_OP_BIODRAIN, &pending) ?
 		ops_complete_write : ops_complete_postxor;
=20
 	/* 1/ if we prexor'd then the dest is reused as a source
@@ -897,12 +899,12 @@ static void raid5_run_ops(struct stripe_head *sh,=
 unsigned long pending)
 		tx =3D ops_run_prexor(sh, tx);
=20
 	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
-		tx =3D ops_run_biodrain(sh, tx);
+		tx =3D ops_run_biodrain(sh, tx, pending);
 		overlap_clear++;
 	}
=20
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
-		ops_run_postxor(sh, tx);
+		ops_run_postxor(sh, tx, pending);
=20
 	if (test_bit(STRIPE_OP_CHECK, &pending))
 		ops_run_check(sh);
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
