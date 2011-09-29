From: William Thompson <wt@electro-mechanical.com>
Subject: Re: RAID1 question
Date: Thu, 29 Sep 2011 15:37:05 -0400
Message-ID: <20110929193705.GE19871@electro-mechanical.com>
References: <20110929183457.GA19871@electro-mechanical.com>
 <20110929192611.GA23316@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110929192611.GA23316@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 29, 2011 at 08:26:11PM +0100, Robin Hill wrote:
> On Thu Sep 29, 2011 at 02:34:57PM -0400, William Thompson wrote:
> 
> > Please keep me in the CC.  I am not on the list.
> > 
> > If I have a RAID1 of 2 disks and I decide to move them to another computer
> > and recreate the raid, does it really need to do the initial recovery?
> > 
> You don't need to recreate the raid at all, just reassemble it. You may
> want to update the homehost though, otherwise it will (IIRC) auto
> assemble to md_126 (or so) instead of md0.

The reason I asked this was because a mirrored pair that I currently have is
0.90 version and I was going to use 1.0

> > For that matter, when creating a RAID1 on 2 disks, is it really needed to do
> > the initial recovery?
> > 
> > I understand why it's needed for RAID4/5/6 though.
> >
> Probably not, no. Anything written would go to both mirrors, and reads
> of any un-mirrored areas are indeterminate anyway. You would lose the

I figured this would be the case.

> ability to check the array for mismatches though, and the recovery
> process would bring everything into sync whenever it's run anyway. More

I've rarely done this.  On large disks, this takes may hours to perform.

> of a question would be why not do the initial recovery? It doesn't delay
> access to the array, and at least the I/O load is happening at a
> controlled point (rather than at recovery time, when you have no

I guess the only reason I can come up with would be to avoid extra head
seeks.  Well, that and the time it takes.

During the initial sync, if a write happens to an area that has been synced,
does it go to all drives?  What about a write to an area that as not been
synced yet?

> control). Anyway, if you do want to avoid the initial recovery, just use
> --assume-clean.

I am aware of this option.  I've have been fortunate with mdadm in the many
years I've used it (except 1 time).
