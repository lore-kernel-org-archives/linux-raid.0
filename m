From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Fix data corruption when a degraded raid5 array is reshaped.
Date: Fri, 4 Jan 2008 09:46:36 +1100
Message-ID: <1080103224636.19290@suse.de>
References: <20080104094516.19216.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, stable@kernel.org
List-Id: linux-raid.ids

This patch fixes a fairly serious bug in md/raid5 in 2.6.23 and 24-rc.
It would be great if it cold get into 23.13 and 24.final.
Thanks.
NeilBrown

### Comments for Changeset

We currently do not wait for the block from the missing device
to be computed from parity before copying data to the new stripe
layout.

The change in the raid6 code is not techincally needed as we
don't delay data block recovery in the same way for raid6 yet.
But making the change now is safer long-term.

This bug exists in 2.6.23 and 2.6.24-rc

Cc: stable@kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-01-04 09:42:05.000000000 +1100
+++ ./drivers/md/raid5.c	2008-01-04 09:42:27.000000000 +1100
@@ -2865,7 +2865,7 @@ static void handle_stripe5(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 && s.req_compute == 0)
 		handle_stripe_expansion(conf, sh, NULL);
 
 	if (sh->ops.count)
@@ -3067,7 +3067,7 @@ static void handle_stripe6(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 && s.req_compute == 0)
 		handle_stripe_expansion(conf, sh, &r6s);
 
 	spin_unlock(&sh->lock);
