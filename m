From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 4] md: Fix an occasional deadlock in raid5 - FIX
Date: Fri, 18 Jan 2008 22:02:51 +1100
Message-ID: <1080118110251.30514@suse.de>
References: <20080118215531.30136.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


(This should be merged with fix-occasional-deadlock-in-raid5.patch)

As we don't call stripe_handle in make_request any more, we need to
clear STRIPE_DELAYED to (previously done by stripe_handle) to ensure
that we test if the stripe still needs to be delayed or not.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-01-18 14:58:55.000000000 +1100
+++ ./drivers/md/raid5.c	2008-01-18 14:59:53.000000000 +1100
@@ -3549,6 +3549,7 @@ static int make_request(struct request_q
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
+			clear_bit(STRIPE_DELAYED, &sh->state);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
