From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Tue, 27 Aug 2013 16:53:30 +0800
Message-ID: <20130827085330.GA30133@kernel.org>
References: <20130812022434.507702228@kernel.org>
 <20130812022549.013010221@kernel.org>
 <20130827131752.4d5ba375@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130827131752.4d5ba375@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

On Tue, Aug 27, 2013 at 01:17:52PM +1000, NeilBrown wrote:
> On Mon, 12 Aug 2013 10:24:37 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > get_active_stripe() is the last place we have lock contention. It has two
> > paths. One is stripe isn't found and new stripe is allocated, the other is
> > stripe is found.
> 
> Hi Shaohua Li,
>  thanks for the patch.  I think it is a good idea but it needs more work.
> But first we will need to fix some bugs ... in md.c and in your patch.
> 
> > 
> > The first path basically calls __find_stripe and init_stripe. It accesses
> > conf->generation, conf->previous_raid_disks, conf->raid_disks,
> > conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
> > conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_list. Except
> > stripe_hashtbl and inactive_list, other fields are changed very rarely.
> 
> Yes, those fields don't change very often, but our current locking doesn't
> properly protect against them changing.
> In particular in "make_request()", if  raid5_start_reshape() changes these
> fields between the point where reshape_progress is seen to be MaxSector, and
> where get_active_stripe() is called, get_active_stripe will return the wrong
> stripe.
> 
> I think we should probably introduce a seqlock to protect these fields.
> It is very cheap to get a read-lock on a seqlock so we can do that every time
> we enter make_request.

Looks good.

> Then get_active_stripe wouldn't need to worry about device_lock at all and
> would only need to get the hash lock for the particular sector.  That should
> make it a lot simpler.

did you mean get_active_stripe() doesn't need device_lock for any code path?
How could it be safe? device_lock still protects something like handle_list,
delayed_list, which release_stripe() will use while a get_active_stripe can run
concurrently.
 
> Also your new shrink_stripes() and similar code in resize_stripes is wrong.
> It seems to assume that the stripe_heads will be evenly distributed over all
> hash values, which isn't the case.
> In particular, shrink_stripes() will stop calling drop_one_stripe() as soon
> as any inactive_list is empty, but it must continue until all inactive lists
> are empty.

ah, yes.

> I'll add the seqlock and push that out to my for-next branch, and then you
> can rebase this patch on top of that.

Ok.

Thanks,
Shaohua
