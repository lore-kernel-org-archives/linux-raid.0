From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch]raid5: make release_stripe lockless
Date: Wed, 20 Mar 2013 08:55:48 +0800
Message-ID: <20130320005548.GA1343@kernel.org>
References: <20130318043146.GA7016@kernel.org>
 <CAA9_cmeNpXtR91z8Ni=WBAZmiERvRTJre9Px47S-mzTOoNYucg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmeNpXtR91z8Ni=WBAZmiERvRTJre9Px47S-mzTOoNYucg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Tue, Mar 19, 2013 at 02:53:05PM -0700, Dan Williams wrote:
> On Sun, Mar 17, 2013 at 9:31 PM, Shaohua Li <shli@kernel.org> wrote:
> > release_stripe still has big lock contention. We just add the stripe to a llist
> > without taking device_lock. We let the raid5d thread to do the real stripe
> > release, which must hold device_lock anyway. In this way, release_stripe
> > doesn't hold any locks.
> >
> > The side effect is the released stripes order is changed. But sounds not a big
> > deal, stripes are never handled in order. And I thought block layer can already
> > do nice request merge, which means order isn't that important.
> >
> > I kept the unplug release batch, which is unnecessary with this patch from lock
> > contention avoid point of view, and actually if we delete it, the stripe_head
> > release_list and lru can share storage. But the unplug release batch is also
> > helpful for request merge. We probably can delay wakeup raid5d till unplug, but
> > I'm still afraid of the case which raid5d is running.
> >
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > ---
> >  drivers/md/raid5.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  drivers/md/raid5.h |    3 +++
> >  2 files changed, 51 insertions(+), 5 deletions(-)
> >
> > Index: linux/drivers/md/raid5.c
> > ===================================================================
> > --- linux.orig/drivers/md/raid5.c       2013-03-18 08:49:43.276628437 +0800
> > +++ linux/drivers/md/raid5.c    2013-03-18 10:33:58.561988946 +0800
> > @@ -262,12 +262,45 @@ static void __release_stripe(struct r5co
> >                 do_release_stripe(conf, sh);
> >  }
> >
> > +/* should hold conf->device_lock already */
> > +static int release_stripe_list(struct r5conf *conf)
> > +{
> > +       struct stripe_head *sh;
> > +       struct llist_node *node;
> > +       int count = 0;
> > +
> > +       while (1) {
> > +               node = llist_del_first(&conf->released_stripes);
> > +               if (!node)
> > +                       break;
> > +               sh = llist_entry(node, struct stripe_head, release_list);
> 
> Do we need a smp_mb__before_clear_bit() here to pair with the
> test_and_set_bit() to preclude re-adding the stripe_head before it is
> fully deleted?

The llist_del_first uses a cmpxchg to do the deletion, assume we are ok because
it implies a barrier. But this is subtle, maybe I should add a comment here.

Thanks,
Shaohua
