From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [BUG] Raid5 trouble
Date: Wed, 17 Oct 2007 17:46:08 -0700
Message-ID: <1192668368.22506.6.camel@dwillia2-linux.ch.intel.com>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>
	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>
	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>
	 <47163BF9.304@systella.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-PXCDo0BiKUXRpJFblluC"
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <47163BF9.304@systella.fr>
Sender: sparclinux-owner@vger.kernel.org
To: BERTRAND =?ISO-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids


--=-PXCDo0BiKUXRpJFblluC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Wed, 2007-10-17 at 09:44 -0700, BERTRAND Joël wrote:
>         Dan,
> 
>         I have modified get_stripe_work like this :
> 
> static unsigned long get_stripe_work(struct stripe_head *sh)
> {
>          unsigned long pending;
>          int ack = 0;
>          int a,b,c,d,e,f,g;
> 
>          pending = sh->ops.pending;
> 
>          test_and_ack_op(STRIPE_OP_BIOFILL, pending);
>          a=ack;
>          test_and_ack_op(STRIPE_OP_COMPUTE_BLK, pending);
>          b=ack;
>          test_and_ack_op(STRIPE_OP_PREXOR, pending);
>          c=ack;
>          test_and_ack_op(STRIPE_OP_BIODRAIN, pending);
>          d=ack;
>          test_and_ack_op(STRIPE_OP_POSTXOR, pending);
>          e=ack;
>          test_and_ack_op(STRIPE_OP_CHECK, pending);
>          f=ack;
>          if (test_and_clear_bit(STRIPE_OP_IO, &sh->ops.pending))
>                  ack++;
>          g=ack;
> 
>          sh->ops.count -= ack;
> 
>          if (sh->ops.count<0) printk("%d %d %d %d %d %d %d\n",
> a,b,c,d,e,f,g);
>          BUG_ON(sh->ops.count < 0);
> 
>          return pending;
> }
> 
> and I obtain on console :
> 
>   1 1 1 1 1 2
> kernel BUG at drivers/md/raid5.c:390!
>                \|/ ____ \|/
>                "@'/ .. \`@"
>                /_| \__/ |_\
>                   \__U_/
> md7_resync(5409): Kernel bad sw trap 5 [#1]
> 
>         If that can help you...
> 
>         JKB

This gives more evidence that it is probably mishandling of
STRIPE_OP_BIOFILL.  The attached patch (replacing the previous) moves
the clearing of these bits into handle_stripe5 and adds some debug
information.

--
Dan

--=-PXCDo0BiKUXRpJFblluC
Content-Disposition: attachment; filename=fix-biofill-clear2.patch
Content-Type: text/x-patch; name=fix-biofill-clear2.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

raid5: fix clearing of biofill operations (try2)

From: Dan Williams <dan.j.williams@intel.com>

ops_complete_biofill() runs outside of spin_lock(&sh->lock) and clears the
'pending' and 'ack' bits.  Since the test_and_ack_op() macro only checks
against 'complete' it can get an inconsistent snapshot of pending work.

Move the clearing of these bits to handle_stripe5(), under the lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f96dea9..3808f52 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -377,7 +377,12 @@ static unsigned long get_stripe_work(struct stripe_head *sh)
 		ack++;
 
 	sh->ops.count -= ack;
-	BUG_ON(sh->ops.count < 0);
+	if (unlikely(sh->ops.count < 0)) {
+		printk(KERN_ERR "pending: %#lx ops.pending: %#lx ops.ack: %#lx "
+			"ops.complete: %#lx\n", pending, sh->ops.pending,
+			sh->ops.ack, sh->ops.complete);
+		BUG();
+	}
 
 	return pending;
 }
@@ -551,8 +556,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 			}
 		}
 	}
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
 
 	return_io(return_bi);
 
@@ -2630,6 +2634,13 @@ static void handle_stripe5(struct stripe_head *sh)
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
+	/* clean-up completed biofill operations */
+	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	}
+
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;

--=-PXCDo0BiKUXRpJFblluC--
