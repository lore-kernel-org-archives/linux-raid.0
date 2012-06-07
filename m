From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 6/8] raid5: make_request use batch stripe release
Date: Thu, 7 Jun 2012 15:58:16 +0800
Message-ID: <20120607075816.GA915@kernel.org>
References: <20120604080152.098975870@kernel.org>
 <20120604080335.029329200@kernel.org>
 <20120607112345.1429436b@notabene.brown>
 <20120607063358.GB779@kernel.org>
 <20120607173310.2a3f147b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120607173310.2a3f147b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Thu, Jun 07, 2012 at 05:33:10PM +1000, NeilBrown wrote:
> On Thu, 7 Jun 2012 14:33:58 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Thu, Jun 07, 2012 at 11:23:45AM +1000, NeilBrown wrote:
> > > On Mon, 04 Jun 2012 16:01:58 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > make_request() does stripe release for every stripe and the stripe usually has
> > > > count 1, which makes previous release_stripe() optimization not work. In my
> > > > test, this release_stripe() becomes the heaviest pleace to take
> > > > conf->device_lock after previous patches applied.
> > > > 
> > > > Below patch makes stripe release batch. When maxium strips of a batch reach,
> > > > the batch will be flushed out. Another way to do the flush is when unplug is
> > > > called.
> > > > 
> > > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > 
> > > I like the idea of a batched release.
> > > I don't like the per-cpu variables... and I don't think it is safe to only
> > > allocate them for_each_present_cpu without support cpu-hot-plug.
> > > 
> > > I would much rather keep a list of stripes (linked on ->lru) in struct
> > > md_plug_cb (or maybe in some structure which contains that) and release them
> > > all on unplug - and only on unplug.
> > > 
> > > Maybe pass a size to mddev_check_unplugged, and it allocates that much more
> > > space.  Get mddev_check_unplugged to return the md_plug_cb structure.
> > > If the new space is NULL, then list_head_init it, and change the cb.callback
> > > to a raid5 specific function.
> > > Then add any stripe to the md_plug_cb, and in the unplug function, release
> > > them all.
> > > 
> > > Does that make sense?
> > > 
> > > Also I would rather the batched stripe release code were defined in the same
> > > patch that used it.  It isn't big enough to justify a separate patch.
> > 
> > The stripe->lru need protection of device_lock, so I can't use a list. An array
> > is preferred. I really didn't like the idea to allocate memory especially when
> > allocating an array. I'll fix the code for cpuhotplug.
> 
> You don't need device_lock to use ->lru.
> Currently the lru is not used when sh->count is not-zero unless
> STRIPE_EXPANDING is set - and we never attach IO requests if STRIPE_EXPANDING
> is set.
> So when make_request wants to release a stripe_head, ->lru is currently
> unused.
> So we can use it to put the stripe on a per-thread list without locking.
> 
> We need another stripe_head flag to say "is on a per-thread unplug list" to
> avoid racing between processes, but we don't need a spinlock for that.
> ie.
>   if (!test_and_set(STRIPE_ON_UNPLUG_LIST, &sh->state))
>            list_add(&plug->list, &sh->lru);
> 
> or similar.

I did see some BUG_ON trigger when I access ->lru without device_lock hold
before, for example get_active_stripe will remove it from list. Maybe can use
the same bit to avoid it. Let me try.
