From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/4 v2] optimize raid1 read balance for SSD
Date: Thu, 28 Jun 2012 11:29:01 +0800
Message-ID: <20120628032901.GA21233@kernel.org>
References: <20120613090922.971820942@kernel.org>
 <20120628110616.79d4481e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120628110616.79d4481e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

On Thu, Jun 28, 2012 at 11:06:16AM +1000, NeilBrown wrote:
> On Wed, 13 Jun 2012 17:09:22 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > raid1 read balance is an important algorithm to make read performance optimal.
> > It's a distance based algorithm, eg, for each request dispatch, choose disk
> > whose last finished request is close the request. This is great for hard disk.
> > But SSD has some special characteristics:
> > 
> > 1. nonrotational. Distance means nothing for SSD, though merging small rquests
> > to big request is still optimal for SSD. If no merge, distributing rquests to
> > raid disks as more as possible is more optimal.
> 
> This, of course, has nothing to do with the devices rotating, and everything
> to do with there being a seek-penalty.  So why the block-device flag is
> called "rotational" I really don't know :-(
> 
> Can we make the flags that md uses be "seek_penalty" or "no_seek" or
> something, even if the block layer has less meaningful names?

purely borrowed from block layer. I'm ok to change it.
 
> > 
> > 2. Getting too big request isn't always optimal. For hard disk, compared to
> > spindle move, data transfer overhead is trival, so we always prefer bigger
> > request. In SSD, request size exceeds specific value, performance isn't always
> > increased with request size increased.  An example is readahead. If readahead
> > merges too big request and causes some disks idle, the performance is less
> > optimal than that when all disks are busy and running small requests.
> 
> I note that the patch doesn't actually split requests, rather it avoids
> allocating adjacent requests to the same device - is that right?
> That seems sensible but doesn't seem to match your description so I wanted to
> check.

Yes, it doesn't do split, sorry for the misleading. I used to think about
split, but gave up later, but forgot to change the description. There are two
types of IO driving big request size: buffered read (readahead) buffered write
and direct read or write I assume buffered write and direct read/write can
drive high iodepth, so doing split is useless. buffered read split makes sense,
which really should be 'prevent merging to big request'

> > 
> > The patches try to address the issues. The first two patches are clean up. The
> > third patch addresses the first item above. The forth addresses the second item
> > above. The idea can be applied to raid10 too, which is in my todo list.
> 
> Thanks for these - there is a lot to like here.
> 
> One concern that I have has that they assume that all devices are the same.
> i.e. they are all "rotational", or none of them are.
>      they all have the same optimal IO size.
> 
> md aims to work well on heterogeneous arrays so I'll like to make it more
> general if I can.
> Whether to "split" adjacent requests or not is decided in the context of a
> single device (the device that the first request is queued for) so that
> should be able to use the optimal IO size of that devices.
> 
> General balancing is a little harder as the decision is made in the context
> of all active devices.  In particular we need to know how to choose between a
> seek-penalty device and a no-seek-penalty device, if they both have requests
> queued to them and the seek-penalty device is a long way from the target.
> 
> Maybe:
>  - if the last request to some device is within optimal-io-size of this
>    requests, then send this request to that device.
>  - if either of two possible devices has no seek penalty, choose the one with
>    the fewest outstanding requests.
>  - if both of two possible devices have a seek-penalty, then choose the
>    closest
> 
> I think this will do the same as the current code for 'rotational' devices,
> and will be close to what your code does for 'non-rotational' devices.

This is close to what I did except for the case of one hard disk and one SSD.
Talking about heterogeneous arrary, I assume people only do it with two
different hard disks or two different ssd. Will people really mix hard disk and
SSD? A hard disk can only drive 600 IOPS while a lowend SATA SSD can drive 20k
~ 40k IOPS. Plusing 600 to 20k doesn't significantly change IOPS.

> There may well be room to improve this, but a key point is that it won't work
> to have two separate balancing routines - one for disks and one for ssds.
> I'm certainly happy for raid1_read_balance to be split up if it is too big,
> but I don't think that they way the first patch splits it is useful.
> Would you be able to try something like that instead?

Yep, it's not worthy a separate function. My point is just making them
independent. I can try this but not be convinced we need handle mixed
harddisk/ssd case.

> BTW, in a couple of places you use an 'rdev' taken out of the 'conf'
> structure without testing for NULL first.  That isn't safe.
> We get the 'rdev' at the top of the loop and test for NULL and other things.
> After that you need to always use *that* rdev value, don't try to get it out
> of the conf->mirrors structure again.

Thanks for pointing out, I'll fix it later.

Thanks,
Shaohua
