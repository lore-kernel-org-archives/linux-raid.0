From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 29] md: Don't acknowlege that stripe-expand is complete until it really is.
Date: Fri, 27 Jun 2008 16:49:30 +1000
Message-ID: <1080627064930.10302@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids


We shouldn't acknowledge that a stripe has been expanded (When
reshaping a raid5 by adding a device) until the moved data has
actually been written out.  However we are currently
acknowledging (by calling md_done_sync) when the POST_XOR
is complete and before the write.

So track in s.locked whether there are pending writes, and don't
call md_done_sync yet if there are.

Note: we all set R5_LOCKED on devices which are are about to
read from.  This probably isn't technically necessary, but is
usually done when writing a block, and justifies the use of
s.locked here.

This bug can lead to a crash if an array is stopped while an reshape
is in progress.

Cc: <stable@kernel.org>
Signed-off-by: Neil Brown <neilb@suse.de>



### Diffstat output
 ./drivers/md/raid5.c |    3 +++
 1 file changed, 3 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 15:30:19.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 15:22:48.000000000 +1000
@@ -2898,6 +2898,8 @@ static void handle_stripe5(struct stripe
 
 		for (i = conf->raid_disks; i--; ) {
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			s.locked++;
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 		}
@@ -2911,6 +2913,7 @@ static void handle_stripe5(struct stripe
 			conf->raid_disks);
 		s.locked += handle_write_operations5(sh, 1, 1);
 	} else if (s.expanded &&
+		   s.locked == 0 &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
