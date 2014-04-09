From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch]raid5: get_active_stripe avoids device_lock
Date: Wed, 9 Apr 2014 11:27:42 +0800
Message-ID: <20140409032742.GA16051@kernel.org>
References: <20140408040553.GB20886@kernel.org>
 <20140409121729.18955461@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140409121729.18955461@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 09, 2014 at 12:17:29PM +1000, NeilBrown wrote:
> On Tue, 8 Apr 2014 12:05:53 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > 
> > For sequential workload (or request size big workload), get_active_stripe can
> > find cached stripe. In this case, we always hold device_lock, which exposes a
> > lot of lock contention for such workload. If stripe count isn't 0, we don't
> > need hold the lock actually, since we just increase its count. And this is the
> > hot code path for such workload. Unfortunately we must delete the BUG_ON.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > ---
> >  drivers/md/raid5.c |    9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> > 
> > Index: linux/drivers/md/raid5.c
> > ===================================================================
> > --- linux.orig/drivers/md/raid5.c	2014-04-08 09:16:39.377536607 +0800
> > +++ linux/drivers/md/raid5.c	2014-04-08 09:16:39.369536607 +0800
> > @@ -679,14 +679,9 @@ get_active_stripe(struct r5conf *conf, s
> >  				init_stripe(sh, sector, previous);
> >  				atomic_inc(&sh->count);
> >  			}
> > -		} else {
> > +		} else if (!atomic_add_unless(&sh->count, 1, 0)) {
> 
> Can I be really fussy and ask you to use "atomic_inc_not_zero" rather than
> "atomic_add_unless" ??
> I feel it makes the code a bit clearer.

Missed this API. Yes, it's better.


Subject: raid5: get_active_stripe avoids device_lock

For sequential workload (or request size big workload), get_active_stripe can
find cached stripe. In this case, we always hold device_lock, which exposes a
lot of lock contention for such workload. If stripe count isn't 0, we don't
need hold the lock actually, since we just increase its count. And this is the
hot code path for such workload. Unfortunately we must delete the BUG_ON.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-04-09 11:07:01.165231305 +0800
+++ linux/drivers/md/raid5.c	2014-04-09 11:07:26.492913067 +0800
@@ -679,14 +679,9 @@ get_active_stripe(struct r5conf *conf, s
 				init_stripe(sh, sector, previous);
 				atomic_inc(&sh->count);
 			}
-		} else {
+		} else if (!atomic_inc_not_zero(&sh->count)) {
 			spin_lock(&conf->device_lock);
-			if (atomic_read(&sh->count)) {
-				BUG_ON(!list_empty(&sh->lru)
-				    && !test_bit(STRIPE_EXPANDING, &sh->state)
-				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
-					);
-			} else {
+			if (!atomic_read(&sh->count)) {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
 				BUG_ON(list_empty(&sh->lru) &&
