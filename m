From: NeilBrown <neilb@suse.de>
Subject: Re: RAID10 failed with two disks
Date: Mon, 22 Aug 2011 21:09:03 +1000
Message-ID: <20110822210903.2582bcfd@notabene.brown>
References: <4E5231EE.3010001@pum.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5231EE.3010001@pum.edu.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Piotr Legiecki <piotrlg@pum.edu.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 22 Aug 2011 12:39:42 +0200 Piotr Legiecki <piotrlg@pum.edu.pl> wrote:

> Hi
> 
> I'v got RAID10 on 4 disks. Suddenly two of the disks failed (I doubt the 
> disks actually failed, rather it is a kernel failure or maybe 
> motherboard SATA controller)?
> 
> So after rebootig I cannot start the array. So my first question is: on 
> RAID10 (default layout) which disks may fail and still the array survive?

Not adjacent disks.

> 
> mdadm --examine /dev/sda1
> /dev/sda1:
>            Magic : a92b4efc
>          Version : 00.90.00
>             UUID : fab2336d:71210520:990002ab:4fde9f0c (local to host bez)
>    Creation Time : Mon Aug 22 10:40:36 2011
>       Raid Level : raid10
>    Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>       Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 4
> 
>      Update Time : Mon Aug 22 10:40:36 2011
>            State : clean
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 2
>    Spare Devices : 0
>         Checksum : d4ba8390 - correct
>           Events : 1
> 
>           Layout : near=2, far=1
>       Chunk Size : 64K
> 
>        Number   Major   Minor   RaidDevice State
> this     0       8        1        0      active sync   /dev/sda1
> 
>     0     0       8        1        0      active sync   /dev/sda1
>     1     1       8       17        1      active sync   /dev/sdb1
>     2     2       0        0        2      faulty
>     3     3       0        0        3      faulty
> 
> The last two disks (failed ones) are sde1 and sdf1.
> 
> So do I have any chances to get the array running or it is dead?

Possible.
Report "mdadm --examine" of all devices that you believe should be part of
the array.

NeilBrown


> 
> I've tried a few steps to run the array but with no luck.
> 
> Regards
> P.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

