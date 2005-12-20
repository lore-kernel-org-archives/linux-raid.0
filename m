From: Sebastian Kuzminsky <seb@highlab.com>
Subject: Re: Raid sync observations
Date: Tue, 20 Dec 2005 12:13:07 -0700
Message-ID: <E1Eomv5-0008Qz-CQ@highlab.com>
References: <200512201827.jBKIRf6m019390@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200512201827.jBKIRf6m019390@cichlid.com> 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Burgess <aab@cichlid.com> wrote:
> >Question 1: Why didnt the raid sync I/O show up with vmstat?
> 
> I switched to iostat because of similar observations with vmstat. iostat
> at least shows you which devices it is looking at and it agrees with
> /proc/mdstat's numbers in my experience.

Right.


> >Question 2: Why was it limited to 17 MB per second?  The maximum was
> >left at the default, 200 MB/s.  The min was also at the default, 1 MB/s.
> >I get 60 MB/s per disk with "hdparm -tT" (that's using one disk at a time,
> >but still).  The checksumming code does > 3 GB/s.
> 
> Try using dd to read each device in parallel as it might be a bus or controller
> limitation. Also, sync requires writing interspersed with the reads which
> unavoidably ruins the total throughput. Larger stripes should minimize this if
> you think it'll be a problem during everyday use.

Before creating the raid, I ran "badblocks -n" (non-destructive read-write
mode) on all 4 disks in parallel, and I was getting about 14 MB/s read &
14 MB/s write, per disk, with iostat reporting device utilizations around
97% on all disks.

"badblocks" (read-only test) on all 4 in parallel reads ~56 MB/s per disk,
call it ~220 MB/s total, with device utilizations again up around 98%.

Not bad!  I'll just call it sync access pattern overhead then.

The disks are Seagate Barracuda 7200.9 500 GB SATA-II.  The controller
card is a Sonnet Tempo-X 8 SATA, based on the Marvell 6081 chipset.
It's a 64-bit/133-MHz PCI-X card plugged in to a 64-bit/66-MHz PCI-X
slot, so the limiting factor is the bus, which runs at about 500 MB/s.
I should be able to hang eight 60 MB/s disks off this card and still
not run into any I/O bottlenecks.  :-)


-- 
Sebastian Kuzminsky
