From: Shaohua Li <shli@kernel.org>
Subject: Re: Shouldn't the /sys/block/md*/queue/max_*sectors_kb be set to the
 chunk size?
Date: Thu, 18 May 2017 14:48:45 -0700
Message-ID: <20170518214845.v7ltyetvi4bxiviq@kernel.org>
References: <CANWz5fiQ1O5k43QKfurd84nwdeCZL0-EOD6p_2vp+wHaJmsVEw@mail.gmail.com>
 <20170518185023.3z5byy5uqpfb46w6@kernel.org>
 <CANWz5fhwLVxirvQ7j5Re66hD0uRsh4QpOapkKVM0+MK+pSXu+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANWz5fhwLVxirvQ7j5Re66hD0uRsh4QpOapkKVM0+MK+pSXu+Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 18, 2017 at 11:33:45AM -1000, Chris Worley wrote:
> On Thu, May 18, 2017 at 8:50 AM, Shaohua Li <shli@kernel.org> wrote:
> > On Thu, May 18, 2017 at 05:52:28AM -1000, Chris Worley wrote:
> >> I'm obviously missing something...
> >>
> >> If chunk size is a stride, why is the
> >> /sys/block/md*/queue/max_*sectors_kb being inherited from one of the
> >> underlying devices rather than being set to the chunk size or the
> >> drive multiple of their max sector settings?
> >
> > We set it to chunk size unless underlying disks have a smaller max_*sectors_kb.
> > Underlying disks usually have much bigger max_sectors than chunk size.
> 
> And if not the case, then, for maximum efficiency/performance, the
> chunk size should be lowered to the max sector size for the device...
> or maybe the [devices max sector size] / [number of devices]?
> 
> >
> >> Or, in other words, would the chunk size setting have a natural upper
> >> bound/limit of one of the drives max_sectors, or the sum of all of the
> >> constituent drives max sectors?
> >
> > I don't know such upper bound and don't think it matters. The max_sectors
> > basically is the size we split the bio to fit for one underlying disk.
> 
> I realize that, but am thinking that, if the chunk size was larger,
> you would want (for performance/efficiency) the max sector size for
> the MD device to be larger than the underlying device too, which the
> MD driver would then break-up into the underlying devices max sector
> size?  Or, is it more efficient to have the OS break-up the bios into
> the smaller sizes for the driver?
> 
> For example, if there are four devices, each with 128KB max sectors,
> and the chunk size is 512K, wouldn't MD want the bio to show the users
> complete 512K write in a single bio for MD to dole-out to the
> different devices, rather than receiving four different bio's?

We could do something like this. But if we accept a single 512k write in a
single bio, md still need to split them to 4 bios and send the 4 bios to
underlying disks. In current implementation we get 4 bios directly and don't
need to do the split. This's the difference. I'd doubt your suggestion (one big
bio) has better performance, but if you can prove it, we definitely can change.

Thanks,
Shaohua
