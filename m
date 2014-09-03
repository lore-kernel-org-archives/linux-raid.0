From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC]RAID5: batch adjacent full stripe write
Date: Wed, 3 Sep 2014 09:04:59 +0800
Message-ID: <20140903010459.GA1790@kernel.org>
References: <20140818082531.GA13732@kernel.org>
 <20140902165240.3affa8b0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140902165240.3affa8b0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 02, 2014 at 04:52:40PM +1000, NeilBrown wrote:
> On Mon, 18 Aug 2014 16:25:31 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > 
> > stripe cache is 4k size. Even adjacent full stripe writes are handled in 4k
> > unit. Idealy we should use big size for adjacent full stripe writes. Bigger
> > stripe cache size means less stripes runing in the state machine so can reduce
> > cpu overhead. And also bigger size can cause bigger IO size dispatched to under
> > layer disks.
> > 
> > With below patch, we will automatically batch adjacent full stripe write
> > together. Such stripes will form to a container and be added to the container
> > list. Only the first stripe of a container will be put to handle_list and so
> > run handle_stripe(). Some steps of handle_stripe() are extended to cover whole
> > container stripes, including ops_run_io, ops_run_biodrain and so on. With this
> > patch, we have less stripes running in handle_stripe() and we send IO of whole
> > container stripes together to increase IO size.
> > 
> > Stripes added to a container have some limitations. A container can only
> > include full stripe write and can't cross chunk boundary to make sure stripes
> > have the same parity disk. Stripes in a container must in the same state (no
> > written, toread and so on). If a stripe is in a container, all new read/write
> > to add_stripe_bio will be blocked to overlap conflict till the container are
> > handled. The limitations will make sure stripes in a container in exactly the
> > same state in the life circly of the container.
> > 
> > I did test running 160k randwrite in a RAID5 array with 32k chunk size and 6
> > PCIe SSD. This patch improves around 30% performance and IO size to under layer
> > disk is exactly 32k. I also run a 4k randwrite test in the same array to make
> > sure the performance isn't changed with the patch.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> 
> 
> Thanks for posting this ... and sorry for taking so long to look at it - I'm
> still fighting of the flu so I'm not thinking a clearly as I would like so
> I'll have to look over this again once I'm fully recovered.
> 
> I think I like it.  It seems more complex than I would like, which makes it
> harder to review, but it probably needs to be that complex to actually work.
> 
> I'm a bit worried about the ->scribble  usage.  The default chunk size of
> 512K with means 128 stripe_heads in a batch.  On a 64 bit machine that is
> 1kilobyte of pointers per device.  8 devices in a RAID6 means more than 8K
> needs to be allocated for ->scribble.  That has a risk of failing.
> 
> Maybe it would make sense to use a flex_array
> (Documentation/flexible-arrays.txt).
> 
> Splitting out the changes for ->scribble into a separate patch might help.

Ok, I'll check this.
 
> The testing for "can this stripe_head be batched" seems a bit clumsy - lots
> of loops hunting for problems.
> Could we just set a "don't batch" flag whenever something happens that makes
> a stripe un-batchable?  Have another flag that gets set when a stripe becomes
> a full-write stripe?

good point!

> Can we call the collections of stripe_heads "batch"es rather than
> "container"s?   mdadm already used the name "containers" for something else,
> and I think "batch" fits better.

Ok.
> I think it might be useful if we could start batching together stripe_heads
> that are in the same stripe, even before they are full-write.  That might
> help the scheduling and avoid some of the unnecessary pre-reading that we
> currently do.  I haven't really thought properly about it and don't expect
> you to do that, but I thought I'd mention it anyway.

Yep, batching doesn't need to be a full-write. We can do it later. At current
stage, I'd like to make the simplest case work.

Thanks,
Shaohua
