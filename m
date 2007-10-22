From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 2] md: raid5: fix clearing of biofill operations
Date: Mon, 22 Oct 2007 17:15:50 +1000
Message-ID: <1071022071550.31281@suse.de>
References: <20071022171426.31103.patches@notabene>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Stable <stable@kernel.org>
List-Id: linux-raid.ids


=46rom: Dan Williams <dan.j.williams@intel.com>

ops_complete_biofill() runs outside of spin_lock(&sh->lock) and clears =
the
'pending' and 'ack' bits.  Since the test_and_ack_op() macro only check=
s
against 'complete' it can get an inconsistent snapshot of pending work.

Move the clearing of these bits to handle_stripe5(), under the lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Jo=C3=ABl Bertrand <joel.bertrand@systella.fr>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Stable <stable@kernel.org>

### Diffstat output
 ./drivers/md/raid5.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-10-22 16:55:49.000000000 +1000
+++ ./drivers/md/raid5.c	2007-10-22 16:57:41.000000000 +1000
@@ -665,7 +665,12 @@ static unsigned long get_stripe_work(str
 		ack++;
=20
 	sh->ops.count -=3D ack;
-	BUG_ON(sh->ops.count < 0);
+	if (unlikely(sh->ops.count < 0)) {
+		printk(KERN_ERR "pending: %#lx ops.pending: %#lx ops.ack: %#lx "
+			"ops.complete: %#lx\n", pending, sh->ops.pending,
+			sh->ops.ack, sh->ops.complete);
+		BUG();
+	}
=20
 	return pending;
 }
@@ -842,8 +847,7 @@ static void ops_complete_biofill(void *s
 			}
 		}
 	}
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
=20
 	return_io(return_bi);
=20
@@ -3130,6 +3134,13 @@ static void handle_stripe5(struct stripe
 	s.expanded =3D test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
=20
+	/* clean-up completed biofill operations */
+	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	}
+
 	rcu_read_lock();
 	for (i=3Ddisks; i--; ) {
 		mdk_rdev_t *rdev;
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
