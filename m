From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: help diagnosing bad disk
Date: Wed, 19 Dec 2007 13:23:40 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712191323010.2468@p34.internal.lan>
References: <fa2952810712191018l76085e90l4eb2c6a81115fa1f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa2952810712191018l76085e90l4eb2c6a81115fa1f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Sabo <jonathan.sabo@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 19 Dec 2007, Jon Sabo wrote:

> So I was trying to copy over some Indiana Jones wav files and it
> wasn't going my way.  I noticed that my software raid device showed:
>
> /dev/md1 on / type ext3 (rw,errors=remount-ro)
>
> Is this saying that it was remounted, read only because it found a
> problem with the md1 meta device?  That's what it looks like it's
> saying but I can still write to /.
>
> mdadm --detail showed:
>
> root@recoil:/home/illsci# mdadm --detail /dev/md0
> /dev/md0:
>        Version : 00.90.03
>  Creation Time : Mon Jul 30 21:47:14 2007
>     Raid Level : raid1
>     Array Size : 1951744 ( 1906.32 MiB 1998.59 MB)
>    Device Size : 1951744 (1906.32 MiB 1998.59 MB)
>   Raid Devices : 2
>  Total Devices : 1
> Preferred Minor : 0
>    Persistence : Superblock is persistent
>
>    Update Time : Wed Dec 19 12:59:56 2007
>          State : clean, degraded
> Active Devices : 1
> Working Devices : 1
> Failed Devices : 0
>  Spare Devices : 0
>
>           UUID : 157f716c:0e7aebca:c20741f6
> :bb6099c9
>         Events : 0.28
>
>     Number   Major   Minor   RaidDevice State
>       0       8        1        0      active sync   /dev/sda1
>       1       0        0        1      removed
>
> root@recoil:/home/illsci# mdadm --detail /dev/md1
> /dev/md1:
>        Version : 00.90.03
>  Creation Time : Mon Jul 30 21:47:47 2007
>     Raid Level : raid1
>     Array Size : 974808064 (929.65 GiB 998.20 GB)
>    Device Size : 974808064 (929.65 GiB 998.20 GB)
>    Raid Devices : 2
>  Total Devices : 1
> Preferred Minor : 1
>    Persistence : Superblock is persistent
>
>    Update Time : Wed Dec 19 13:14:53 2007
>          State : clean, degraded
> Active Devices : 1
> Working Devices : 1
> Failed Devices : 0
>  Spare Devices : 0
>
>           UUID : 156a030e:9a6f8eb3:9b0c439e:d718e744
>         Events : 0.1990
>
>    Number   Major   Minor   RaidDevice State
>       0       8        2        0      active sync   /dev/sda2
>       1       0        0        1      removed
>
>
> I have two 1 terabyte sata drives in this box.  From what I was
> reading wouldn't it show an F for the failed drive?  I thought I would
> see that /dev/sdb1 and /dev/sdb2 were failed and it would show an F.
> What is this saying and how do you know that its /dev/sdb and not some
> other drive?  It shows removed and that the state is clean, degraded.
> Is that something you can recover from with out returning this disk
> and putting in a new one to add to the raid1 array?

mdadm /dev/md1 -a /dev/sdb2 to re-add it back into the array

What does cat /proc/mdstat show?

I would also show us: smartctl -a /dev/sdb

Justin.

