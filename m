From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 6/8] raid5: make_request use batch stripe release
Date: Fri, 8 Jun 2012 14:16:57 +0800
Message-ID: <20120608061657.GA785@kernel.org>
References: <20120604080152.098975870@kernel.org>
 <20120604080335.029329200@kernel.org>
 <20120607112345.1429436b@notabene.brown>
 <20120607063358.GB779@kernel.org>
 <20120607173310.2a3f147b@notabene.brown>
 <20120607075816.GA915@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120607075816.GA915@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Thu, Jun 07, 2012 at 03:58:16PM +0800, Shaohua Li wrote:
> On Thu, Jun 07, 2012 at 05:33:10PM +1000, NeilBrown wrote:
> > On Thu, 7 Jun 2012 14:33:58 +0800 Shaohua Li <shli@kernel.org> wrote:
> > 
> > > On Thu, Jun 07, 2012 at 11:23:45AM +1000, NeilBrown wrote:
> > > > On Mon, 04 Jun 2012 16:01:58 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > > 
> > > > > make_request() does stripe release for every stripe and the stripe usually has
> > > > > count 1, which makes previous release_stripe() optimization not work. In my
> > > > > test, this release_stripe() becomes the heaviest pleace to take
> > > > > conf->device_lock after previous patches applied.
> > > > > 
> > > > > Below patch makes stripe release batch. When maxium strips of a batch reach,
> > > > > the batch will be flushed out. Another way to do the flush is when unplug is
> > > > > called.
> > > > > 
> > > > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > > 
> > > > I like the idea of a batched release.
> > > > I don't like the per-cpu variables... and I don't think it is safe to only
> > > > allocate them for_each_present_cpu without support cpu-hot-plug.
> > > > 
> > > > I would much rather keep a list of stripes (linked on ->lru) in struct
> > > > md_plug_cb (or maybe in some structure which contains that) and release them
> > > > all on unplug - and only on unplug.
> > > > 
> > > > Maybe pass a size to mddev_check_unplugged, and it allocates that much more
> > > > space.  Get mddev_check_unplugged to return the md_plug_cb structure.
> > > > If the new space is NULL, then list_head_init it, and change the cb.callback
> > > > to a raid5 specific function.
> > > > Then add any stripe to the md_plug_cb, and in the unplug function, release
> > > > them all.
> > > > 
> > > > Does that make sense?
> > > > 
> > > > Also I would rather the batched stripe release code were defined in the same
> > > > patch that used it.  It isn't big enough to justify a separate patch.
> > > 
> > > The stripe->lru need protection of device_lock, so I can't use a list. An array
> > > is preferred. I really didn't like the idea to allocate memory especially when
> > > allocating an array. I'll fix the code for cpuhotplug.
> > 
> > You don't need device_lock to use ->lru.
> > Currently the lru is not used when sh->count is not-zero unless
> > STRIPE_EXPANDING is set - and we never attach IO requests if STRIPE_EXPANDING
> > is set.
> > So when make_request wants to release a stripe_head, ->lru is currently
> > unused.
> > So we can use it to put the stripe on a per-thread list without locking.
> > 
> > We need another stripe_head flag to say "is on a per-thread unplug list" to
> > avoid racing between processes, but we don't need a spinlock for that.
> > ie.
> >   if (!test_and_set(STRIPE_ON_UNPLUG_LIST, &sh->state))
> >            list_add(&plug->list, &sh->lru);
> > 
> > or similar.
> 
> I did see some BUG_ON trigger when I access ->lru without device_lock hold
> before, for example get_active_stripe will remove it from list. Maybe can use
> the same bit to avoid it. Let me try.

Thinking a bit more, the STRIPE_ON_UNPLUG_LIST bit can't avoid races. For
example,
Task 1 hit a stripe, assume stripe count 0 (could not be 0 too):
it does:
1. inc count
2. set STRIPE_ON_UNPLUG_LIST
3. add stripe to plug list
4. unplug to release the stripe
Between 3 and 4, task 2 hit the stripe, it does:
A: inc count. Since the bit set, do nothing more
B: unplug
If the order is 3, A, 4, B. Task1 will not release the stripe, since the
count is 2. Tasks2 will not release the stripe, since stripe isn't in its
list. The stripe will never be handled.
