From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID-6 check standalone
Date: Mon, 21 Mar 2011 22:04:57 +1100
Message-ID: <20110321220457.29d52f5c@notabene.brown>
References: <20110221204551.GA15675@lazy.lzy>
	<20110321140244.2314b4b4@notabene.brown>
	<20110321104007.GA15379@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110321104007.GA15379@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 21 Mar 2011 11:40:07 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:


> > I have applied this patch to me git now - with some minor changes.
> 
> Thanks.
> 
> One question, I did not find the previous patch to "restripe.c",
> which was adding the ":offset" capability. This was in order to
> be able to cope with metadata 1.1 or 1.2 (offset to be determined).

I cannot seem to find it.  Please resend.


> 
> > > Other item is that due to "sysfs.c" linking (see below) the
> > > "Makefile" needed some changes, I hope this is not a problem.
> > 
> > I have reverted most of these changes and the linking with sysfs.c isn't
> > needed yet.  When it is we can sort out how best to achieve it.
> > 
> > > 
> > > Next steps (TODO list you like) would be:
> > > 
> > > 1) Add the "sysfs.c" code in order to retrieve the HDDs info
> > > from the MD device. It is already linked, together with the
> > > whole (mdadm) universe, since it seems it cannot leave alone.
> > > I'll need some advice or hint on how to do use it. I checked
> > > "sysfs.c", but before I dig deep into it maybe better to
> > > have some advice (maybe just one function call will do it).
> > 
> > What exactly do you want to achieve?
> > 
> > I suspect you want to a open the md device, then
> > 
> >   info = sysfs_read(fd, -1,
> >   GET_LEVEL|GET_LAYOUT_GET_DISKS|GET_CHUNK|GET_DEVS|GET_OFFSET);
> > 
> > (possibly with other flags) and then extract the info you want from the data
> > structure returned - but I'm only guessing at what you might want.
> 
> I think this more or less correct.
> 
> I would like to pass, to "raid6check", the md device as only
> parameter, maybe with some start/stop position, and derive all
> the needed information from that.
> 
> That is, it should be: raid6check /dev/mdX start stop
> Or, possibly: raid6check /dev/mdX start length
> Or just: raid6check /dev/mdX
> 
> This means, the information that should be derived is:
> 
> 1) level, in order to confirm it is 6
> 2) layout
> 3) disk components
> 4) offset for each component
> 5) chunk size
> 
> That should be all, I guess.
> 
> Your "sysfs_read" seems to do exactly this, please confirm.

Yes, all that should be in there - experiment and see if you get what you
expect!

> 
> > > 
> > > 2) Add the suspend lo/hi control. Fellow John Robinson was
> > > suggesting to look into "Grow.c", which I did, but I guess
> > > the same story as 1) is valid: better to have some hint on
> > > where to look before wasting time.
> > 
> > This would be:
> > 
> >   sysfs_set_num(info, NULL, "suspend_lo", offset*data_disks);
> >   sysfs_set_num(info, NULL, "suspend_hi", (offset+chunksize)*data_disks);
> > 
> > to freeze one stripe.  Then work in there.
> > The addresses are addresses in the array, hence the multiplication
> > by data_disks (which is raid_disks - 2 for RAID6).
> > 
> > Don't hold the array suspended for too long or something might get
> > upset.  And allocate any memory you need first, and call
> >     	mlockall(MCL_CURRENT | MCL_FUTURE);
> > 
> > first to be even more safe.
> 
> Thanks for the explanation. How is, then, the "unfreeze"?
> Just writing (0) to both hi and lo?

Just make sure lo >= hi and it will unfreeze.
Some kernels are a bit fussy about the order of writing to these.
So if you just write a big number to 'lo', then the same to 'hi', you should
be safe.


NeilBrown

