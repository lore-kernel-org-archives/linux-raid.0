From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch]raid5: make release_stripe lockless
Date: Thu, 28 Mar 2013 10:00:04 +0800
Message-ID: <20130328020004.GB17351@kernel.org>
References: <20130318043146.GA7016@kernel.org>
 <CAA9_cmeNpXtR91z8Ni=WBAZmiERvRTJre9Px47S-mzTOoNYucg@mail.gmail.com>
 <20130320005548.GA1343@kernel.org>
 <20130322063617.GA22668@kernel.org>
 <20130328114546.207e1d74@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130328114546.207e1d74@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <djbw@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 28, 2013 at 11:45:46AM +1100, NeilBrown wrote:
> On Fri, 22 Mar 2013 14:36:17 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > 
> > Subject: raid5: make release_stripe lockless
> > 
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
> 
> Looks good, thanks.
> 
> One comment:
> 
> 
> > +/* should hold conf->device_lock already */
> > +static int release_stripe_list(struct r5conf *conf)
> > +{
> > +	struct stripe_head *sh;
> > +	struct llist_node *node;
> > +	int count = 0;
> > +
> > +	while (1) {
> > +		node = llist_del_first(&conf->released_stripes);
> > +		if (!node)
> > +			break;
> 
> Why not:
>  llist_for_each_entry(sh, llist_delete_all(&conf->released_stripes), release_list) {
>       clear_bit()
>       __release_stripe(conf, sh);
>       count++;
>  }

This absolutly is ok too. I didn't clearly remember why I do it in my way,
maybe because new entry can be added. If you prefer llist_for_each_entry(), I
can change it.
