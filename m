From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH -stable, 2.6.24-rc] raid5: fix clearing of biofill
	operations (try2)
Date: Fri, 19 Oct 2007 09:23:27 -0700
Message-ID: <1192811007.30976.22.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: BERTRAND =?ISO-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

The following patch fixes a case where STRIPE_OP_BIOFILL can be counted
twice causing sh->ops.count to get out of sync thus triggering a BUG()
statement.  The patch applies cleanly on top of 2.6.23 and 2.6.24-rc.

--
Dan

---snip---

raid5: fix clearing of biofill operations (try2)

=46rom: Dan Williams <dan.j.williams@intel.com>

ops_complete_biofill() runs outside of spin_lock(&sh->lock) and clears =
the
'pending' and 'ack' bits.  Since the test_and_ack_op() macro only check=
s
against 'complete' it can get an inconsistent snapshot of pending work.

Move the clearing of these bits to handle_stripe5(), under the lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Jo=C3=ABl Bertrand <joel.bertrand@systella.fr>
---

 drivers/md/raid5.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f96dea9..3808f52 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -377,7 +377,12 @@ static unsigned long get_stripe_work(struct stripe=
_head *sh)
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
@@ -551,8 +556,7 @@ static void ops_complete_biofill(void *stripe_head_=
ref)
 			}
 		}
 	}
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
=20
 	return_io(return_bi);
=20
@@ -2630,6 +2634,13 @@ static void handle_stripe5(struct stripe_head *s=
h)
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
