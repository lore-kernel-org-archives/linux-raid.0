From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Wed, 28 Aug 2013 14:39:53 +0800
Message-ID: <20130828063953.GD17163@kernel.org>
References: <20130812022434.507702228@kernel.org>
 <20130812022549.013010221@kernel.org>
 <20130827131752.4d5ba375@notabene.brown>
 <20130827085330.GA30133@kernel.org>
 <20130828143252.1d48b04b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130828143252.1d48b04b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

On Wed, Aug 28, 2013 at 02:32:52PM +1000, NeilBrown wrote:
> On Tue, 27 Aug 2013 16:53:30 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Tue, Aug 27, 2013 at 01:17:52PM +1000, NeilBrown wrote:
> 
> > 
> > > Then get_active_stripe wouldn't need to worry about device_lock at all and
> > > would only need to get the hash lock for the particular sector.  That should
> > > make it a lot simpler.
> > 
> > did you mean get_active_stripe() doesn't need device_lock for any code path?
> > How could it be safe? device_lock still protects something like handle_list,
> > delayed_list, which release_stripe() will use while a get_active_stripe can run
> > concurrently.
> 
> Yes you will still need device_lock to protect list_del_init(&sh->lru),
> as well as the hash lock.
> Do you need device_lock anywhere else in there?

That's what I mean. So I need get both device_lock and hash_lock. To not
deadlock, I need release hash_lock and relock device_lock/hash_lock. Since I
release lock, I need recheck if I can find the stripe in hash again. So the
seqcount locking doesn't simplify things here. I thought the seqlock only fixes
one race. Did I miss anything?

I saw your tree only has seqcount_write lock in one place, but there are still
other places which changing quiesce, degraded. I thought we still need lock all
locks like what I did.

Thanks,
Shaohua
