From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: recovering failed raid5
Date: Thu, 27 Oct 2016 18:04:00 +0200
Message-ID: <20161027160400.GA21042@metamorpher.de>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 27, 2016 at 04:06:14PM +0100, Alexander Shenkin wrote:
> md2: raid5 mounted on /, via sd[abcd]3

Two failed disks...

> md0: raid1 mounted on /boot, via sd[abcd]1

Actually only two disks active in that one, the other two are spares.
It hardly matters for /boot, but you could grow it to a 4 disk raid1.
Spares are not useful.

> My sdb was recently reporting problems.  Instead of second guessing
> those problems, I just got a new disk, replaced it, and added it to
> the arrays.

Replacing right away is the right thing to do.
Unfortunately it seems you have another disk that is broke too.

> 2) smartctl (disabled on drives - can enable once back up.  should I?)
> note: SMART only enabled after problems started cropping up.

But... why? Why disable smart? And if you do, is it a surprise that you 
only notice disk failures when it's already too late?

You should enable smart, and not only that, also run regular selftests, 
and have smartd running, and have it send you mail when something happens. 
Same with raid checks, raid checks are at least something but it won't 
tell you about how many reallocated sectors your drive has.

> root@machinename:/home/username# smartctl --xall /dev/sda

Looks fine but never ran a selftest.

> root@machinename:/home/username# smartctl --xall /dev/sdb

Looks new. (New drives need selftests too.)

> root@machinename:/home/username# smartctl --xall /dev/sdc
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.19.0-39-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Barracuda 7200.14 (AF)
> Device Model:     ST3000DM001-1CH166
> Serial Number:    W1F1N909
>
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    8
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    8

This one is faulty and probably the reason why your resync failed.
You have no redundancy left, so an option here would be to get a 
new drive and ddrescue it over.

That's exactly the kind of thing you should be notified instantly 
about via mail. And it should be discovered when running selftests. 
Without full surface scan of the media, the disk itself won't know.

> ==> WARNING: A firmware update for this drive may be available,
> see the following Seagate web pages:
> http://knowledge.seagate.com/articles/en_US/FAQ/207931en
> http://knowledge.seagate.com/articles/en_US/FAQ/223651en

About this, *shrug*
I don't have these drives, you might want to check that out.
But it probably won't fix bad sectors.

> root@machinename:/home/username# smartctl --xall /dev/sdd

Some strange things in the error log here, but old.
Still, same as for all others - selftest.

> ################### mdadm --examine ###########################
> 
> /dev/sda1:
>      Raid Level : raid1
>    Raid Devices : 2

A RAID 1 with two drives, could be four.

> /dev/sdb1:
> /dev/sdc1:

So these would also have data instead of being spare.

> /dev/sda3:
>      Raid Level : raid5
>    Raid Devices : 4
> 
>     Update Time : Mon Oct 24 09:02:52 2016
>          Events : 53547
> 
>    Device Role : Active device 0
>    Array State : A..A ('A' == active, '.' == missing)

RAID-5 with two failed disks.

> /dev/sdc3:
>      Raid Level : raid5
>    Raid Devices : 4
> 
>     Update Time : Mon Oct 24 08:53:57 2016
>          Events : 53539
> 
>    Device Role : Active device 2
>    Array State : AAAA ('A' == active, '.' == missing)

This one failed, 8:53.

> ############ /proc/mdstat ############################################
> 
> md2 : active raid5 sda3[0] sdc3[2](F) sdd3[3]
>       8760565248 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2]
> [U__U]

[U__U] refers to device roles as in [0123], 
so device role 0 and 3 is okay, 1 and 2 missing.

> md0 : active raid1 sdb1[4](S) sdc1[2](S) sda1[0] sdd1[3]
>       1950656 blocks super 1.2 [2/2] [UU]

Those two spares again, could be [UUUU] instead.

tl;dr
stop it all,
ddrescue /dev/sdc to your new disk,
try your luck with --assemble --force (not using /dev/sdc!),
get yet another new disk, add, sync, cross fingers.

There's also mdadm --replace instead of --remove, --add, 
that sometimes helps if there's only a few bad sectors 
on each disk. If the disk you already removed wasn't 
already kicked from the array by the time you replaced, 
maybe it would have avoided this problem.

But good disk monitoring and testing is even more important.

Regards
Andreas Klauer
