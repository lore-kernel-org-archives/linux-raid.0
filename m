From: Kasper Sandberg <lkml@metanurb.dk>
Subject: RE: Sharing disks amoung multiple software RAIDs
Date: Fri, 02 May 2008 04:42:59 +0200
Message-ID: <1209696179.16523.13.camel@localhost>
References: <1209692359.16523.2.camel@localhost>
	 <73000.21239.qm@web50212.mail.re2.yahoo.com>
	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2008-05-01 at 21:31 -0500, David Lethe wrote:
> In a perfect world, my expectation is that sharing a disk is safe and
> even a reasonable thing to do. The shared disk is effectively a range of
> addressable blocks in the same way an individual disk or even a hardware
> RAID LUN is a range of blocks. From this limited perspective, the only
> penalty is performance related, assuming you don't mind having to
> explain yourself to an IT supervisor somewhere in your company.
> 
> However, consider what COULD happen in event of a drive failure, either
> with the shared or an unshared disk. What are the odds all of the
> failure scenarios have been tested for all ATA and SCSI command sets;
> with threaded I/Os pending; with dirty cache; bus resets when hardware
> dies; etc... ?
> 
> The odds are zero.  Look how many problems people post to the thread on
> a weekly basis where people lose their data when md rebuilds go bad with
> non-shared disks.  Why make the problem worse?

What? are you saying linux md is unreliable?! in other words, would i be
safer to run rsync every day to my other disk, and run in non-raid
mode?!

> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Alex Davis
> Sent: Thursday, May 01, 2008 8:52 PM
> To: Justin Piszcz; Kasper Sandberg
> Cc: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: Sharing disks amoung multiple software RAIDs
> 
> --- On Thu, 5/1/08, Kasper Sandberg <lkml@metanurb.dk> wrote:
> 
> > From: Kasper Sandberg <lkml@metanurb.dk>
> > Subject: Re: Sharing disks amoung multiple software RAIDs
> > To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
> > Cc: "Alex Davis" <alex14641@yahoo.com>, linux-raid@vger.kernel.org,
> linux-kernel@vger.kernel.org
> > Date: Thursday, May 1, 2008, 9:39 PM
> > On Thu, 2008-05-01 at 08:50 -0400, Justin Piszcz wrote:
> > > 
> > > On Thu, 1 May 2008, Alex Davis wrote:
> > > 
> > > > Is this a bad thing? I'm guessing that it is,
> > but I want independent
> > > > confirmation before I spoke to someone I know
> > who's doing this.
> > > >
> > > > Thanks
> > > >
> > > >
> > > >     
> >
> ________________________________________________________________________
> ____________
> > > > Be a better friend, newshound, and
> > > > know-it-all with Yahoo! Mobile.  Try it now. 
> > http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
> > > > --
> > > > To unsubscribe from this list: send the line
> > "unsubscribe linux-raid" in
> > > > the body of a message to
> > majordomo@vger.kernel.org
> > > > More majordomo info at 
> > http://vger.kernel.org/majordomo-info.html
> > > >
> > > 
> > > What is the use case, why would you want to do that?
> > > I have seen people on the list do it before, for
> > example are you going to 
> > > be utilizing both raids at the same time?  If so, I
> > would advise against 
> > > it.
> > > 
> > > What is the reasoning?
> > 
> > I do this!
> > 
> > is this really bad? i would surely like a list of reasons
> > why..
> > 
> > I do it because.. well.. first off, it allows me to have
> > /boot on
> > different raidlevel than / or /home without extra disks.
> > secondly, it allows me to with the same disks use different
> > filesystems.. for instance, it allows me to have /home
> > encrypted with
> > dm-crypt, while still raided.. Not that i would mind
> > encrypting /
> > and /home as 1 partition, but it creates a whole slew of
> > issues with
> > having to create initrd and stuff..
> > 
> > I realize that performance probably suffers abit from this,
> > but well..
> > is there any stability or security wise risk? i mostly use
> > raid1 and
> > raid5 only..
> > 
> I would guess if the RAIDs are heavily used simultaneously it could
> cause the disk head actuators to jump around more, causing more wear
> and tear.
> 
> 
>  
> ________________________________________________________________________
> ____________
> Be a better friend, newshound, and 
> know-it-all with Yahoo! Mobile.  Try it now.
> http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

