From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 16:01:43 +0100 (MET)
Message-ID: <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

On Wed, 19 Dec 2007, Justin Piszcz wrote:

> ------
>
> Now to my setup / question:
>
> # fdisk -l /dev/sdc
>
> Disk /dev/sdc: 150.0 GB, 150039945216 bytes
> 255 heads, 63 sectors/track, 18241 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x5667c24a
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1       18241   146520801   fd  Linux raid autodetect
>
> ---
>
> If I use 10-disk RAID5 with 1024 KiB stripe, what would be the correct start 
> and end size if I wanted to make sure the RAID5 was stripe aligned?
>
> Or is there a better way to do this, does parted handle this situation 
> better?

From that setup it seems simple, scrap the partition table and use the 
disk device for raid. This is what we do for all data storage disks (hw 
raid) and sw raid members.

/Mattias Wadenstein
