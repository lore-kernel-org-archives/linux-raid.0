From: Neil Brown <neilb@suse.de>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Mon, 15 Sep 2008 20:16:52 +1000
Message-ID: <18638.13844.94632.293014@notabene.brown>
References: <48CE250C.8000603@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maarten on Monday September 15
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 15, maarten@ultratux.net wrote:
> 
> This weekend I promoted my new 6-disk raid6 array to production use and 
> was busy copying data to it overnight. The next morning the machine had 
> crashed, and the array is down with an (apparent?) 4-disk failure, as 
> witnessed by this info:

Pity about that crash.  I don't suppose there are any useful kernel
logs leading up to it.  Maybe the machine needs more burn-in testing
before going into production?


> 
> md5 : inactive sdj1[2](S) sdb1[5](S) sda1[4](S) sdf1[3](S) sdc1[1](S) 
> sdk1[0](S)
>        2925435648 blocks

That suggests that the kernel tried to assemble the array, but failed
because it was too degraded.

> 
> apoc ~ # mdadm --assemble /dev/md5 /dev/sd[abcfjk]1
> mdadm: /dev/md5 assembled from 2 drives - not enough to start the array.
> 
> apoc log # fdisk -l|grep 4875727
> /dev/sda1        1       60700   487572718+  fd  Linux raid autodetect
> /dev/sdb1        1       60700   487572718+  fd  Linux raid autodetect
> /dev/sdc1        1       60700   487572718+  fd  Linux raid autodetect
> /dev/sdf1        1       60700   487572718+  fd  Linux raid autodetect
> /dev/sdj1        1       60700   487572718+  fd  Linux raid autodetect
> /dev/sdk1        1       60700   487572718+  fd  Linux raid autodetect
> 
> apoc log # mdadm --examine /dev/sd[abcfjk]1|grep Events
>           Events : 0.1057345
>           Events : 0.1057343
>           Events : 0.1057343
>           Events : 0.1057343
>           Events : 0.1057345
>           Events : 0.1057343
> 

So sda1 and sdj1 are newer, but not by much.
Looking at the full --examine output below, the time difference
between 1057343 and 1057345 is 61 seconds.  That is probably one or
two device timeouts.

'a' and 'j' think that 'k' failed and was removed.  Everyone else
think that the world is a happy place.

So I suspect that an IO to k failed, and the attempt to update the
metadata worked on 'a' and 'j' but not anywhere else.  So then the
array just stopped.  When md tried to update 'a' and 'j' with the new
failure information, it failed on them as well.

> Note: the array was built half-degraded, ie. it misses one disk. This is 
> how it was displayed when it was still OK yesterday:
> 
> md5 : active raid6 sdk1[0] sdj1[2] sdf1[3] sdc1[1] sdb1[5] sda1[4]
>        2437863040 blocks level 6, 64k chunk, algorithm 2 [7/6] [UUUUUU_]
> 
> 
> By these event counters, one would maybe assume that 4 disks failed 
> simultaneously, however weird this may be. But when looking at the other 
> info of the examine command, this seems unlikely: all drives report (I 
> think) that they were online until the end, except for two drives. The 
> first drive of those two is the one that reports it has failed. The 
> second is the one that 'sees' that that first drive did fail. All the 
> others seem oblivious to that...  I included that data below at the end.

Not quite.  'k' is reported as failed, 'a' 'and 'j' know this.


> 
> My questions...
> 
> 1) Is my analysis correct so far ?

Not exactly, but fairly close.

> 2) Can/should I try to assemble --force, or it that very bad in these 
> circumstances?

Yes, you should assemble with --force.  The evidence is strong that
nothing was successfully written after 'k' failed, so all the data
should be consistent.  You will need to sit through a recovery with
probably won't make any changes, but it is certainly safest to let it
try.


> 3) Should I say farewell to my ~2400 GB of data ? :-(

Not yet.

> 4) If it was only a one-drive failure, why did it kill the array ?

It wasn't just one drive.  Maybe it was a controller/connector
failure.  Maybe when one drive failed it did bad things to the buss.
It is hard to know for sure.
Are these drives SATA or SCSI or SAS or ???

> 5) Any insight as to how this happened / can be prevented in future ?

See above.
You need to identify the failing component and correct it - either
replace or re-seat or whatever is needed.
Finding the failing component is not easy.   Lots of burn-in testing
and catching any kernel logs if/when it crashes is your best bet.

Good luck.

NeilBrown
