From: "Rechenberg, Andrew" <ARechenberg@sfg.com>
Subject: RE: Forcing raid1 resync
Date: Tue, 17 Aug 2004 13:26:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E1373776451186488C3@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the reply.

> 
> quad xeons are *normally* memory-bound, since their design is 
> really quite poor, with all four CPUs sharing a relatively 
> slow bus.  they'll be OK for purely cache-bound workloads, 
> but are pretty much a huge mistake for anything out-of-cache 
> (as, indeed, md raid5 is carefully designed to be!)
> 

All of my RAID arrays are raid1 except for the raid0 array of which the
raid1 arrays are members.  I have no raid5 arrays in this system.  The
system in question has 16GB of RAM.

> > > Is this behavior expected/by design?  Waiting for 26 arrays to 
> > > reconstruct one at a time is painfully slow.  When I
> 
> I wonder whether your configuration might have something to 
> do with this - iirc the kernel tries to be smart about 
> sequencing the md's that it resyncs, since it would be very 
> bad to resync 10 arrays which share the same spindles.
> perhaps it doesn't understand which block devices correspond 
> with separate spindles.
> 

Is there any way to make the kernel "less smart?" :)  Maybe there should
be a /proc entry to specify the number of simultaneous arrays to allow
to sync at once.  None of the arrays in this box share the same spindles
(although there are 6 or 7 disks per SCSI channel; each SCSI card is on
it's own PCI bus as to make sure each set of disks has the most
available bus bandwidth).

> > > about 5 arrays started syncing, but the rest waited until 
> those were 
> > > finished and then synced one at a time.
> 
> that sounds like a (good, in principle) designed behavior.
> 

Yes, it would be fine with me if there were 5 arrays syncing at a time,
however it dwindles down to 1 and then stays there. :\ 

Would it be advisable for me to post this issue to the lkml and see if
anyone knows anymore out there in kernel-land?

Thanks again for the reply,
Andy. 
