From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 3] md: md: fix prexor vs sync_request race
Date: Tue, 27 May 2008 16:32:03 +1000
Message-ID: <1080527063203.16418@suse.de>
References: <20080527162558.16305.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, stable@kernel.org
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

During the initial array synchronization process there is a window between
when a prexor operation is scheduled to a specific stripe and when it
completes for a sync_request to be scheduled to the same stripe.  When this
happens the prexor completes and the stripe is unconditionally marked
"insync", effectively canceling the sync_request for the stripe.  Prior to
2.6.23 this was not a problem because the prexor operation was done under
sh->lock.  The effect in older kernels being that the prexor would still
erroneously mark the stripe "insync", but sync_request would be held off
and re-mark the stripe as "!in_sync".

Change the write completion logic to not mark the stripe "in_sync" if
a prexor was performed. The effect of the change is to sometimes not
set STRIPE_INSYNC.  The worst this can do is cause the resync to stall
waiting for STRIPE_INSYNC to be set.  If this were happening, then
STRIPE_SYNCING would be set and handle_issuing_new_read_requests would
cause all available blocks to eventually be read, at which point
prexor would never be used on that stripe any more and STRIPE_INSYNC
would eventually be set.

echo repair > /sys/block/mdN/md/sync_action will correct arrays that may
have lost this race.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    5 +++++
 1 file changed, 5 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-05-27 16:24:02.000000000 +1000
+++ ./drivers/md/raid5.c	2008-05-27 16:24:18.000000000 +1000
@@ -2645,6 +2645,7 @@ static void handle_stripe5(struct stripe
 	struct r5dev *dev;
 	unsigned long pending = 0;
 	mdk_rdev_t *blocked_rdev = NULL;
+	int prexor;
 
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
@@ -2774,9 +2775,11 @@ static void handle_stripe5(struct stripe
 	/* leave prexor set until postxor is done, allows us to distinguish
 	 * a rmw from a rcw during biodrain
 	 */
+	prexor = 0;
 	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete) &&
 		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
 
+		prexor = 1;
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
@@ -2810,6 +2813,8 @@ static void handle_stripe5(struct stripe
 				if (!test_and_set_bit(
 				    STRIPE_OP_IO, &sh->ops.pending))
 					sh->ops.count++;
+				if (prexor)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    (i == sh->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
