From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 20/34] md/raid5: finalise new merged handle_stripe.
Date: Tue, 26 Jul 2011 12:02:05 +1000
Message-ID: <20110726120205.1962c301@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.78219.stgit@notabene.brown>
	<87hb6epshe.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hb6epshe.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011 18:36:13 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > handle_stripe5() and handle_stripe6() are now virtually identical.
> > So discard one and rename the other to 'analyse_stripe()'.
> >
> > It always returns 0, so change it to 'void' and remove the 'done'
> > variable in handle_stripe().
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>


> >  static void handle_stripe(struct stripe_head *sh)
> >  {
> >  	struct stripe_head_state s;
> > -	int done;
> >  	raid5_conf_t *conf = sh->raid_conf;
> >  	int i;
> >  	int prexor;
> > @@ -3099,13 +3015,7 @@ static void handle_stripe(struct stripe_head *sh)
> >  	s.failed_num[0] = -1;
> >  	s.failed_num[1] = -1;
> 
> There are codes that set/initialize some fields of stripe_head_state
> outside of analyse_stripe() and it'd better off moving them into the
> function, IMHO.
> 
> Thanks.

Thanks.  I have merged this change.

NeilBrown


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ed6729d..b321d6c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2905,6 +2905,14 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 	struct r5dev *dev;
 	int i;
 
+	memset(s, 0, sizeof(*s));
+
+	s->syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	s->expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	s->expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s->failed_num[0] = -1;
+	s->failed_num[1] = -1;
+
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
 	spin_lock_irq(&conf->device_lock);
@@ -3006,13 +3014,6 @@ static void handle_stripe(struct stripe_head *sh)
 	       (unsigned long long)sh->sector, sh->state,
 	       atomic_read(&sh->count), sh->pd_idx, sh->qd_idx,
 	       sh->check_state, sh->reconstruct_state);
-	memset(&s, 0, sizeof(s));
-
-	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
-	s.failed_num[0] = -1;
-	s.failed_num[1] = -1;
 
 	analyse_stripe(sh, &s);
 
