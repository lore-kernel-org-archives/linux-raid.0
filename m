From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Sat, 16 Feb 2013 06:06:02 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302160604150.32644@uplift.swm.pp.se>
References: <20130215154120.95960@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130215154120.95960@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Feb 2013, Dragon wrote:

>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x0
>     Array UUID : 92a99ca0:8e22bc66:f8050881:78c344d9
>           Name : mfsnode1:2  (local to host mfsnode1)
>  Creation Time : Tue Jul 24 18:18:21 2012
>     Raid Level : raid5
>   Raid Devices : 6
>
> Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
>     Array Size : 29213783040 (13930.22 GiB 14957.46 GB)
>  Used Dev Size : 5842756608 (2786.04 GiB 2991.49 GB)
>    Data Offset : 2048 sectors
>   Super Offset : 8 sectors
>          State : clean
>    Device UUID : 6a679a1d:f42d6b9f:a13cd977:0fdbea86
>
>    Update Time : Mon Dec 17 00:13:56 2012
>       Checksum : 8c50873e - correct
>         Events : 211768
>
>         Layout : left-symmetric
>     Chunk Size : 512K

As far as I can tell, it looks like data offset, super offset,superblock 
version all match what you have after doing --create. So this is good.

> mdadm -E /dev/sdd4
>         Events : 0

> mdadm -E /dev/sdf4
>         Events : 0

Do you have any idea how this happened?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
