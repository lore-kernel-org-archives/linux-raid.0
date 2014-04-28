From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Mon, 28 Apr 2014 15:28:21 +0800
Message-ID: <20140428072821.GB28726@kernel.org>
References: <20140428065841.GA28726@kernel.org>
 <20140428170628.5587b6a1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140428170628.5587b6a1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 28, 2014 at 05:06:28PM +1000, NeilBrown wrote:
> On Mon, 28 Apr 2014 14:58:41 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > 
> > The stripe cache has two goals:
> > 1. cache data, so next time if data can be found in stripe cache, disk access
> > can be avoided.
> > 2. stable data. data is copied from bio to stripe cache and calculated parity.
> > data written to disk is from stripe cache, so if upper layer changes bio data,
> > data written to disk isn't impacted.
> > 
> > In my environment, I can guarantee 2 will not happen. For 1, it's not common
> > too. block plug mechanism will dispatch a bunch of sequentail small requests
> > together. And since I'm using SSD, I'm using small chunk size. It's rare case
> > stripe cache is really useful.
> > 
> > So I'd like to avoid the copy from bio to stripe cache and it's very helpful
> > for performance. In my 1M randwrite tests, avoid the copy can increase the
> > performance more than 30%.
> > 
> > Of course, this shouldn't be enabled by default, so I added an option to
> > control it.
> 
> I'm happy to avoid copying when we know that we can.
> 
> I'm not really happy about using a sysfs attribute to control it.
> 
> How do you guarantee that '2' won't happen?
> 
> BTW I don't see '1' as important.  The stripe cache is really for gathering
> writes together to increase the chance of full-stripe writes, and for
> handling synchronisation between IO and resync/reshape/etc. The copying is
> primarily for stability.

We are using raid5 in a SCSI target appliance. BIO is dispatched from a SCSI
target layer (like LIO) and no filesytem is involved, so I can guarantee the
BIO data is stable.

What's your favorite way to control it?

Thanks,
Shaohua
