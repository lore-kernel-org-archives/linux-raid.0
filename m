From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Wed, 4 Oct 2017 19:28:20 +0200
Message-ID: <20171004172819.GA3181@lazy.lzy>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
 <874ls0s7un.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lgkr3fgj.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 04, 2017 at 11:49:00AM +1100, NeilBrown wrote:
> On Sun, Oct 01 2017, Mikael Abrahamsson wrote:
> 
> > On Mon, 18 Sep 2017, NeilBrown wrote:
> >
> >> Anyway, thanks for the example of a real problem related to this.  It 
> >> does make it easier to think about.
> >
> > Btw, if someone does --zero-superblock or dd /dev/zero to to a component 
> > device that is active, what happens when mdadm --stop /dev/mdX is run? 
> > Does it write out the complete superblock again?
> 
> --zero-superblock won't work on a device that is currently part of an
> array.  dd /dev/zero will.
> When the array is stopped the metadata will be written if the array is
> not read-only and is not clean.
> So for 'linear' and 'raid0' it is never written.  For others it probably
> is but may not be.
> I'm not sure that forcing a write makes sense.  A dd could corrupt lots
> of stuff, and just saving the metadata is not a big win.
> 
> I've been playing with some code, and this patch makes it impossible to
> write to a device which is in-use by md.
> Well... not exactly.  If a partition is in-use by md, the whole device
> can still be written to.  But the partition itself cannot.
> Also if metadata is managed by user-space, writes are still allowed.
> To fix that, we would need to capture each write request and validate
> the sector range.  Not impossible, but ugly.
> 
> Also, by itself, this patch breaks the use of raid6check on an active
> array.  We could fix that by enabling writes whenever a region is
> suspended.

Maybe you all have to make up your mind on how
to handle md devices and components.

We had long discussions about "not having code
in kernel space", to avoid useless burden, and
use user space, instead.
Now, someone discovers that user space is very
dangerous and should be blocked.

So, what should we do? Add an interface to the
md devices in order to access the components?
Will this really be safe against clueless people
trying "dd" here and there?

I think, if someone destroys a RAID using "dd"
on the single components he/she deserves it.

I made similar mistakes, I would not blame md
for them.

And having "mdadm" protecting from things like
"--zero-superblock" is fine, correct and exactly
what is needed as safety net.

In order to conclude, please decide kernel vs.
user space approaches *before* making changes.

Thanks!

> Still... maybe it is a starting point for thinking about the problem.

Yes, you're right,

bye,

-- 

piergiorgio
