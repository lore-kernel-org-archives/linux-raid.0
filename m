From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 17:49:32 +0100
Message-ID: <200501081749.32816.maarten@ultratux.net>
References: <crmt7e$8d6$1@sea.gmane.org> <200501072157.j07Lvg906301@www.watkins-home.com> <20050108145228.GB26475@janus>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050108145228.GB26475@janus>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 08 January 2005 15:52, Frank van Maarseveen wrote:
> On Fri, Jan 07, 2005 at 04:57:35PM -0500, Guy wrote:
> > His plan is to split the disks into 6 partitions.
> > Each of his six RAID5 arrays will only use 1 partition of each physical
> > disk.
> > If he were to lose a disk, all 6 RAID5 arrays would only see 1 failed
> > disk. If he gets 2 read errors, on different disks, at the same time, he
> > has a 1/6 chance they would be in the same array (which would be bad).
> > His plan is to combine the 6 arrays with LVM or a linear array.
>
> Intriguing setup. Do you think this actually improves the reliability
> with respect to disk failure compared to creating just one large RAID5
> array?

Yes.  But I get no credits; someone else here invented the idea.

> For one second I thought it's a clever trick but gut feeling tells
> me the odds of losing the entire array won't change (simplified --
> because the increased complexity creates room for additional errors).

No.  It is somewhat more complex, true, but no different than making, for 
example, 6 md arrays for six different mountpoints. And I just add all six 
together in an LVM. The idea behind it is that not all errors with md are 
fatal.  In the case of a non-fatal error, just re-adding the disk might solve 
it since the drive then will remap the bad sector.  However, IF during that 
resync one other drive has a read error, it gets kicked too and the array 
dies.  The chances of that happening are not very small; during resync all of 
the other drives get read in whole, so that is much more intensive than 
normal operation. So at the precise moment you really can't afford to get a 
read error, the chances of getting one are greater than ever(!). 

By dividing the physical disk in smaller parts one decreases the chance of a 
second disk with a bad sector being on the same array. You could have 3 or 
even 4 disks with bad sectors without losing the array, provided you're lucky 
and they all are on different parts of the drive platters (precisely: in 
different arrays). This is in theory of course, you'd be stupid to leave an 
array degraded and let chance decide which one breaks next... ;-)

Besides this, the resync time in case of a fault decreases by a factor 6 too 
as an added bonus. I don't know about you but over here resyncing a 250GB 
disk takes the better part of the day. (To be honest, that was a slow system)

Now it is certain that you'll strike a compromise between the added complexity 
and the benefits of this setup, so you choose an arbitrary amount of md 
arrays to define. For me six seemed okay, there is no need to go overboard 
and define real small arrays like 10 GB ones (24 of them).  ;-)

Maarten


