From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Tue, 3 Sep 2013 15:02:28 +0800
Message-ID: <20130903070228.GA25041@kernel.org>
References: <20130812022434.507702228@kernel.org>
 <20130812022549.013010221@kernel.org>
 <20130827131752.4d5ba375@notabene.brown>
 <20130827085330.GA30133@kernel.org>
 <20130828143252.1d48b04b@notabene.brown>
 <20130828063953.GD17163@kernel.org>
 <20130903160858.2175a41b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130903160858.2175a41b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

On Tue, Sep 03, 2013 at 04:08:58PM +1000, NeilBrown wrote:
> On Wed, 28 Aug 2013 14:39:53 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Wed, Aug 28, 2013 at 02:32:52PM +1000, NeilBrown wrote:
> > > On Tue, 27 Aug 2013 16:53:30 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > On Tue, Aug 27, 2013 at 01:17:52PM +1000, NeilBrown wrote:
> > > 
> > > > 
> > > > > Then get_active_stripe wouldn't need to worry about device_lock at all and
> > > > > would only need to get the hash lock for the particular sector.  That should
> > > > > make it a lot simpler.
> > > > 
> > > > did you mean get_active_stripe() doesn't need device_lock for any code path?
> > > > How could it be safe? device_lock still protects something like handle_list,
> > > > delayed_list, which release_stripe() will use while a get_active_stripe can run
> > > > concurrently.
> > > 
> > > Yes you will still need device_lock to protect list_del_init(&sh->lru),
> > > as well as the hash lock.
> > > Do you need device_lock anywhere else in there?
> > 
> > That's what I mean. So I need get both device_lock and hash_lock. To not
> > deadlock, I need release hash_lock and relock device_lock/hash_lock. Since I
> > release lock, I need recheck if I can find the stripe in hash again. So the
> > seqcount locking doesn't simplify things here. I thought the seqlock only fixes
> > one race. Did I miss anything?
> 
> Can you order the locks so that you take the hash_lock first, then the
> device_lock?  That would be a lot simpler.

Looks impossible. For example, in handle_active_stripes() we release several
stripes, we can't take hash_lock first.
 
> > I saw your tree only has seqcount_write lock in one place, but there are still
> > other places which changing quiesce, degraded. I thought we still need lock all
> > locks like what I did.
> 
> Can you be specific?  I thought I had convinced my self that I covered
> everything that was necessary, but I might have missed something.

For example, raid5_quiesce() will change quiesce which get_active_stripe() will
use. So my point is get_active_stripe() still need get device_lock. Appears you
agree get_active_stripe() need get device_lock. Maybe I confused your
comments.

Thanks,
Shaohua
