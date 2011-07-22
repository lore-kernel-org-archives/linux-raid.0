From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 10/34] md/raid5: unify stripe_head_state and r6_state
Date: Fri, 22 Jul 2011 15:37:46 +1000
Message-ID: <20110722153746.0f58c356@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.40355.stgit@notabene.brown>
	<878vrqex7i.fsf@gmail.com>
	<20110722151506.54c66e82@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110722151506.54c66e82@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011 15:15:06 +1000 NeilBrown <neilb@suse.de> wrote:

> On Fri, 22 Jul 2011 13:49:37 +0900 Namhyung Kim <namhyung@gmail.com> wrote:
> 
>  
> > > @@ -2964,7 +2964,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
> > >  			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
> > >  			for (j = 0; j < conf->raid_disks; j++)
> > >  				if (j != sh2->pd_idx &&
> > > -				    (!r6s || j != sh2->qd_idx) &&
> > > +				    (r6s || j != sh2->qd_idx) &&
> > 
> > Why is this changed?
> > 
> 
> No good reason that I can think of ... so must be a bug.  I'll fix it.
> 
> In the current code, r6s is always NULL! which is also a bug.
> When you get to
> 
>    md/raid5: Move code for finishing a reconstruction into handle_stripe.
> 
> You'll find that the call which passed 's' in was changed to pass 'NULL' in
> when merging the RAID5 and RAID6 code.  I'll fix that too.
> 

To be specific:

1/ I removed the hunk that you noticed above.
2/ I added the following patch.
3/ I made the obvious changes to the subsequent patch so that it would still
   apply.

This is all now in my for-next branch (I haven't added the Reviewed-by's -
I'll do them all together later.

Thanks,
NeilBrown

From 74721b68b4cf8d4845aa9efa3daf99247a611b70 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Fri, 22 Jul 2011 15:29:38 +1000
Subject: [PATCH] md/raid5: Remove stripe_head_state arg from handle_stripe_expansion.

This arg is only used to differentiate between RAID5 and RAID6 but
that is not needed.  For RAID5, raid5_compute_sector will set qd_idx
to "~0" so j with certainly not equals qd_idx, so there is no need
for a guard on that condition.

So remove the guard and remove the arg from the declaration and
callers of handle_stripe_expansion.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 36873cf..793dd76 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2921,8 +2921,7 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 	}
 }
 
-static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
-				    struct stripe_head_state *r6s)
+static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh)
 {
 	int i;
 
@@ -2964,7 +2963,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
 				if (j != sh2->pd_idx &&
-				    (!r6s || j != sh2->qd_idx) &&
+				    j != sh2->qd_idx &&
 				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
 					break;
 			if (j == conf->raid_disks) {
@@ -3249,7 +3248,7 @@ static void handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
 
 	if (s->expanding && s->locked == 0 &&
 	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
-		handle_stripe_expansion(conf, sh, NULL);
+		handle_stripe_expansion(conf, sh);
 }
 
 static void handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
@@ -3512,7 +3511,7 @@ static void handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 
 	if (s->expanding && s->locked == 0 &&
 	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
-		handle_stripe_expansion(conf, sh, s);
+		handle_stripe_expansion(conf, sh);
 }
 
 static void handle_stripe(struct stripe_head *sh)
