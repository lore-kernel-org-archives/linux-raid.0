From: Henrik Holst <holst@matmech.com>
Subject: Re: Q: how to move "spare" back into raid?
Date: Sun, 3 Oct 2010 02:05:28 +0200
Message-ID: <20101003000528.GA5253@zoidberg.farscape.se>
References: <20100927114520.GA9896@zoidberg.farscape.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100927114520.GA9896@zoidberg.farscape.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again linux-raid!

I solved the problem by recreating the raid and by fixating
the 9 first drives and trying all 6 combinations of sdb1,
sdc1 and sdk1 as the last 3 drivers. And it worked! 

The one-liner I used was:
mdadm -C /dev/md0 -l5 -c128 -z 976562432 -n12 --auto=yes
--assume-clean /dev/sdg1 /dev/sdi1 /dev/sdh1 /dev/sdf1 \
/dev/sdl1 /dev/sdm1 /dev/sde1 /dev/sdj1 /dev/sdd1 \
/dev/sdk1 /dev/sdc1 /dev/sdb1

in combination with cryptsetup isLuks /dev/md0
and fsck.jfs -n /dev/mapper/cmd0

It almost worked perfectly! But the file system was damaged
in the initial mistake.  But I was able to mount the RAID
again (in R/O with the -oro option) and extract the latest
data which I did not have a backup on, yet.

linux-raid is still great and for sure very robust!

Henrik Holst

On Mon, Sep 27, 2010 at 01:45:20PM +0200, Henrik Holst wrote:
> Hi linux-raid!
> 
> I have not been working with linux raid for a few years,
> everything has been working great in my 12x1TB RAID5 system.
> Last week smartctl gave me some information that two of my
> discs where failing so I had to replace them. I used
> dd_rescue to copy the entire discs into two new discs.  And
> then I tried to reassemble them. I do not know what I did
> wrong but now the system is in a broken state.
> 
> My guess is that I have tried to reassemble the raid from
> /dev/sd{...} instead of /dev/sd{...}1 as I was supposed to.
> If anyone can give me some hints on how I can rescue this
> mess I would be very glad.  If the procedure is lengthy I
> would be willing to pay you (Paypal?) something for your
> time to type it up.
> 
> The raid state as-is now:
> 
> lurch:~# mdadm -A /dev/md0 -Rfv /dev/sd[b-m]1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 13.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 12.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 8.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 6.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdj1 is identified as a member of /dev/md0, slot 7.
> mdadm: /dev/sdk1 is identified as a member of /dev/md0, slot 14.
> mdadm: /dev/sdl1 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdm1 is identified as a member of /dev/md0, slot 5.
> mdadm: added /dev/sdi1 to /dev/md0 as 1
> mdadm: added /dev/sdh1 to /dev/md0 as 2
> mdadm: added /dev/sdf1 to /dev/md0 as 3
> mdadm: added /dev/sdl1 to /dev/md0 as 4
> mdadm: added /dev/sdm1 to /dev/md0 as 5
> mdadm: added /dev/sde1 to /dev/md0 as 6
> mdadm: added /dev/sdj1 to /dev/md0 as 7
> mdadm: added /dev/sdd1 to /dev/md0 as 8
> mdadm: no uptodate device for slot 9 of /dev/md0
> mdadm: no uptodate device for slot 10 of /dev/md0
> mdadm: no uptodate device for slot 11 of /dev/md0
> mdadm: added /dev/sdc1 to /dev/md0 as 12
> mdadm: added /dev/sdb1 to /dev/md0 as 13
> mdadm: added /dev/sdk1 to /dev/md0 as 14
> mdadm: added /dev/sdg1 to /dev/md0 as 0
> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> mdadm: Not enough devices to start the array.
> lurch:~#
> lurch:~# mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90
>   Creation Time : Sun Aug  3 02:50:49 2008
>      Raid Level : raid5
>   Used Dev Size : 976562432 (931.32 GiB 1000.00 GB)
>    Raid Devices : 12
>   Total Devices : 12
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Fri Sep 24 22:12:18 2010
>           State : active, degraded, Not Started
>  Active Devices : 9
> Working Devices : 12
>  Failed Devices : 0
>   Spare Devices : 3
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>            UUID : 6ba6a0be:6f2da934:e368bf24:bd0fce41
>          Events : 0.68570
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       97        0      active sync   /dev/sdg1
>        1       8      129        1      active sync   /dev/sdi1
>        2       8      113        2      active sync   /dev/sdh1
>        3       8       81        3      active sync   /dev/sdf1
>        4       8      177        4      active sync   /dev/sdl1
>        5       8      193        5      active sync   /dev/sdm1
>        6       8       65        6      active sync   /dev/sde1
>        7       8      145        7      active sync   /dev/sdj1
>        8       8       49        8      active sync   /dev/sdd1
>        9       0        0        9      removed
>       10       0        0       10      removed
>       11       0        0       11      removed
> 
>       12       8       33        -      spare   /dev/sdc1
>       13       8       17        -      spare   /dev/sdb1
>       14       8      161        -      spare   /dev/sdk1
> lurch:~#
> 
> Any hints on how to proceed is welcome.
> 
> Thank you!
> 
> Henrik Holst
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
