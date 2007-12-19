From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: help diagnosing bad disk
Date: Wed, 19 Dec 2007 14:43:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712191442350.2468@p34.internal.lan>
References: <fa2952810712191018l76085e90l4eb2c6a81115fa1f@mail.gmail.com>
 <Pine.LNX.4.64.0712191323010.2468@p34.internal.lan>
 <fa2952810712191049g50dcf80al8a745ff8706aff20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa2952810712191049g50dcf80al8a745ff8706aff20@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Sabo <jonathan.sabo@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 19 Dec 2007, Jon Sabo wrote:

> I found the problem.   The power was unplugged from the drive.  The
> sata power connectors aren't very good at securing the connector.  I
> reattached the power connector to the sata drive and booted up.  This
> is what it looks like now:
>
> root@recoil:/home/illsci# mdadm --detail /dev/md0
> /dev/md0:
>        Version : 00.90.03
>  Creation Time : Mon Jul 30 21:47:14 2007
>     Raid Level : raid1
>     Array Size : 1951744 (1906.32 MiB 1998.59 MB)
>    Device Size : 1951744 (1906.32 MiB 1998.59 MB)
>   Raid Devices : 2
>  Total Devices : 1
> Preferred Minor : 0
>    Persistence : Superblock is persistent
>
>    Update Time : Wed Dec 19 13:48:12 2007
>          State : clean, degraded
> Active Devices : 1
> Working Devices : 1
> Failed Devices : 0
>  Spare Devices : 0
>
>           UUID : 157f716c:0e7aebca:c20741f6:bb6099c9
>         Events : 0.44
>
>    Number   Major   Minor   RaidDevice State
>       0       8        1        0      active sync   /dev/sda1
>       1       0        0        1      removed
> root@recoil:/home/illsci# mdadm --detail /dev/md1
> /dev/md1:
>        Version : 00.90.03
>  Creation Time : Mon Jul 30 21:47:47 2007
>     Raid Level : raid1
>     Array Size : 974808064 (929.65 GiB 998.20 GB)
>    Device Size : 974808064 (929.65 GiB 998.20 GB)
>   Raid Devices : 2
>  Total Devices : 1
> Preferred Minor : 1
>    Persistence : Superblock is persistent
>
>    Update Time : Wed Dec 19 13:50:02 2007
>          State : clean, degraded
> Active Devices : 1
> Working Devices : 1
> Failed Devices : 0
>  Spare Devices : 0
>
>           UUID : 156a030e:9a6f8eb3:9b0c439e:d718e744
>         Events : 0.1498340
>
>    Number   Major   Minor   RaidDevice State
>       0       0        0        0      removed
>       1       8       18        1      active sync   /dev/sdb2
>
>
> How do I put it back into the correct state?
>
> Thanks!

mdadm /dev/md0 -a /dev/sdb1
mdadm /dev/md1 -a /dev/sda1

Weird that they got out out of sync on different drives.

Justin.

