From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: More tales of horror from the linux (HW) raid crypt
Date: Thu, 23 Jun 2005 09:03:35 -0400
Message-ID: <200506231303.j5ND3e224877@www.watkins-home.com>
References: <1119529907.5503.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1119529907.5503.1.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: bdameron@pivotlink.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: Ming Zhang [mailto:mingz@ele.uri.edu]
> Sent: Thursday, June 23, 2005 8:32 AM
> To: Guy
> Cc: bdameron@pivotlink.com; linux-raid@vger.kernel.org
> Subject: RE: More tales of horror from the linux (HW) raid crypt
> 
> On Wed, 2005-06-22 at 23:05 -0400, Guy wrote:
> > > -----Original Message-----
> > > >
> > > > > will this 24 port card itself will be a bottleneck?
> > > > >
> > > > > ming
> > > >
> > > > Since the card is PCI-X the only bottleneck on it might be the
> Processor
> > > since
> > > > it is shared with all 24 ports. But I do not know for sure without
> > > testing it.
> > > > I personally am going to stick with the new 16 port version. Which
> is a
> > > PCI-
> > > > Express card and has twice the CPU power. Since there are so many
> > > spindles it
> > > > should be pretty darn fast. And remember that even tho the drives
> are
> > > 150MBps
> > > > they realistically only do about 25-30MBps.
> > >
> > > the problem here is taht each HD can stably deliver 25-30MBps while
> the
> > > PCI-x will not arrive that high if have 16 or 24 ports. i do not have
> a
> > > chance to try out though. those bus at most arrive 70-80% the claimed
> > > peak # :P
> >
> > Maybe my math is wrong...
> > But 24 disks at 30 MB/s is 720 MB/s, that is about 68.2% of the PCI-X
> > bandwidth of 1056 MB/s.
> yes, u math is better.
> 
> >
> > Also, 30 MB/s assumes sequential disk access.  That does not occur in
> the
> > real world.  Only during testing.  IMO
> yes, only during test. but what if people build raid5 base on it, this
> is probably what people do. and then a disk fail? then a full disk
> sequential access becomes normal. and disk fail in 24 disk is not so
> uncommon.
But, this is hardware RAID.  A re-sync would not affect the PCI bus.  All
disk i/o related to re-building the array would be internal to the card.
However, even if it were a software RAID card, the PCI-X would be at 68.2%
load, so it should not be a problem.  If my math is correct!  :)

Also, a single RAID5 array on 24 disks would be high risk of a double
failure.  I think I would build 2 RAID5 arrays of 12 disks each.  Or 2 RAID5
arrays of 11 disks each, with 2 spares.

> 
> >
> > Guy
> >
> > >


