From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch]raid5: make release_stripe lockless
Date: Fri, 22 Mar 2013 14:36:17 +0800
Message-ID: <20130322063617.GA22668@kernel.org>
References: <20130318043146.GA7016@kernel.org>
 <CAA9_cmeNpXtR91z8Ni=WBAZmiERvRTJre9Px47S-mzTOoNYucg@mail.gmail.com>
 <20130320005548.GA1343@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130320005548.GA1343@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Mar 20, 2013 at 08:55:48AM +0800, Shaohua Li wrote:
> On Tue, Mar 19, 2013 at 02:53:05PM -0700, Dan Williams wrote:
> > On Sun, Mar 17, 2013 at 9:31 PM, Shaohua Li <shli@kernel.org> wrote:
> > > release_stripe still has big lock contention. We just add the stripe to a llist
> > > without taking device_lock. We let the raid5d thread to do the real stripe
> > > release, which must hold device_lock anyway. In this way, release_stripe
> > > doesn't hold any locks.
> > >
> > > The side effect is the released stripes order is changed. But sounds not a big
> > > deal, stripes are never handled in order. And I thought block layer can already
> > > do nice request merge, which means order isn't that important.
> > >
> > > I kept the unplug release batch, which is unnecessary with this patch from lock
> > > contention avoid point of view, and actually if we delete it, the stripe_head
> > > release_list and lru can share storage. But the unplug release batch is also
> > > helpful for request merge. We probably can delay wakeup raid5d till unplug, but
> > > I'm still afraid of the case which raid5d is running.
> > >
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > ---
> > >  drivers/md/raid5.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-----
> > >  drivers/md/raid5.h |    3 +++
> > >  2 files changed, 51 insertions(+), 5 deletions(-)
> > >
> > > Index: linux/drivers/md/raid5.c
> > > ===================================================================
> > > --- linux.orig/drivers/md/raid5.c       2013-03-18 08:49:43.276628437 +0800
> > > +++ linux/drivers/md/raid5.c    2013-03-18 10:33:58.561988946 +0800
> > > @@ -262,12 +262,45 @@ static void __release_stripe(struct r5co
> > >                 do_release_stripe(conf, sh);
> > >  }
> > >
> > > +/* should hold conf->device_lock already */
> > > +static int release_stripe_list(struct r5conf *conf)
> > > +{
> > > +       struct stripe_head *sh;
> > > +       struct llist_node *node;
> > > +       int count = 0;
> > > +
> > > +       while (1) {
> > > +               node = llist_del_first(&conf->released_stripes);
> > > +               if (!node)
> > > +                       break;
> > > +               sh = llist_entry(node, struct stripe_head, release_list);
> > 
> > Do we need a smp_mb__before_clear_bit() here to pair with the
> > test_and_set_bit() to preclude re-adding the stripe_head before it is
> > fully deleted?
> 
> The llist_del_first uses a cmpxchg to do the deletion, assume we are ok because
> it implies a barrier. But this is subtle, maybe I should add a comment here.

Updated comments as promised.


Subject: raid5: make release_stripe lockless

release_stripe still has big lock contention. We just add the stripe to a llist
without taking device_lock. We let the raid5d thread to do the real stripe
release, which must hold device_lock anyway. In this way, release_stripe
doesn't hold any locks.

The side effect is the released stripes order is changed. But sounds not a big
deal, stripes are never handled in order. And I thought block layer can already
do nice request merge, which means order isn't that important.

I kept the unplug release batch, which is unnecessary with this patch from lock
contention avoid point of view, and actually if we delete it, the stripe_head
release_list and lru can share storage. But the unplug release batch is also
helpful for request merge. We probably can delay wakeup raid5d till unplug, but
I'm still afraid of the case which raid5d is running.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.h |    3 ++
 2 files changed, 56 insertions(+), 5 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-03-21 10:34:56.452256640 +0800
+++ linux/drivers/md/raid5.c	2013-03-21 10:50:59.144154533 +0800
@@ -262,12 +262,50 @@ static void __release_stripe(struct r5co
 		do_release_stripe(conf, sh);
 }
 
+/* should hold conf->device_lock already */
+static int release_stripe_list(struct r5conf *conf)
+{
+	struct stripe_head *sh;
+	struct llist_node *node;
+	int count = 0;
+
+	while (1) {
+		node = llist_del_first(&conf->released_stripes);
+		if (!node)
+			break;
+		sh = llist_entry(node, struct stripe_head, release_list);
+		/*
+		 * llist_del_first() uses cmpxchg, so implies a memory fence.
+		 * It's guaranteed the stripe isn't in released_stripes list
+		 * now, clearing STRIPE_ON_RELEASE_LIST is safe.
+		 */
+		clear_bit(STRIPE_ON_RELEASE_LIST, &sh->state);
+		/*
+		 * Don't worry the bit is set here, because if the bit is set
+		 * again, the count is always > 1. This is true for
+		 * STRIPE_ON_UNPLUG_LIST bit too.
+		 */
+		__release_stripe(conf, sh);
+		count++;
+	}
+	return count;
+}
+
 static void release_stripe(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
+	bool wakeup;
 
+	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
+		goto slow_path;
+	wakeup = llist_add(&sh->release_list, &conf->released_stripes);
+	if (wakeup)
+		md_wakeup_thread(conf->mddev->thread);
+	return;
+slow_path:
 	local_irq_save(flags);
+	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
 	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
 		do_release_stripe(conf, sh);
 		spin_unlock(&conf->device_lock);
@@ -515,7 +553,8 @@ get_active_stripe(struct r5conf *conf, s
 			if (atomic_read(&sh->count)) {
 				BUG_ON(!list_empty(&sh->lru)
 				    && !test_bit(STRIPE_EXPANDING, &sh->state)
-				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state));
+				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
+				    && !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
 			} else {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
@@ -4128,6 +4167,10 @@ static void raid5_unplug(struct blk_plug
 			 */
 			smp_mb__before_clear_bit();
 			clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
+			/*
+			 * STRIPE_ON_RELEASE_LIST could be set here. In that
+			 * case, the count is always > 1 here
+			 */
 			__release_stripe(conf, sh);
 			cnt++;
 		}
@@ -4813,10 +4856,12 @@ static void raid5auxd(struct md_thread *
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
-		int batch_size;
+		int batch_size, released;
+
+		released = release_stripe_list(conf);
 
 		batch_size = handle_active_stripes(conf, &auxth->work_mask);
-		if (!batch_size)
+		if (!batch_size && !released)
 			break;
 		handled += batch_size;
 	}
@@ -4851,7 +4896,9 @@ static void raid5d(struct md_thread *thr
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct bio *bio;
-		int batch_size;
+		int batch_size, released;
+
+		released = release_stripe_list(conf);
 
 		if (
 		    !list_empty(&conf->bitmap_list)) {
@@ -4876,7 +4923,7 @@ static void raid5d(struct md_thread *thr
 		}
 
 		batch_size = handle_active_stripes(conf, &conf->work_mask);
-		if (!batch_size)
+		if (!batch_size && !released)
 			break;
 		handled += batch_size;
 
@@ -5471,6 +5518,7 @@ static struct r5conf *setup_conf(struct
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
+	init_llist_head(&conf->released_stripes);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2013-03-21 10:34:56.452256640 +0800
+++ linux/drivers/md/raid5.h	2013-03-21 10:34:57.256246529 +0800
@@ -197,6 +197,7 @@ enum reconstruct_states {
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;	      /* inactive_list or handle_list */
+	struct llist_node	release_list;
 	struct r5conf		*raid_conf;
 	short			generation;	/* increments with every
 						 * reshape */
@@ -324,6 +325,7 @@ enum {
 	STRIPE_COMPUTE_RUN,
 	STRIPE_OPS_REQ_PENDING,
 	STRIPE_ON_UNPLUG_LIST,
+	STRIPE_ON_RELEASE_LIST,
 };
 
 /*
@@ -462,6 +464,7 @@ struct r5conf {
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list;
+	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
 	int			inactive_blocked;	/* release of inactive stripes blocked,
