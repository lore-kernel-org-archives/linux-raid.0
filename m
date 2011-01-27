From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Help - raid not assembling right on boot (was: Resizing a
 RAID1)
Date: Thu, 27 Jan 2011 07:37:57 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101270736480.31246@p34.internal.lan>
References: <AANLkTimJiZHjAYkd4+93=-5b3QZfSqxaz2Ap+YPLYLEL@mail.gmail.com> <alpine.DEB.2.00.1101270656230.31246@p34.internal.lan> <AANLkTikP3mVU+=F6Luy5dzj7J9+6cvfZKUaifFW6RUf6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikP3mVU+=F6Luy5dzj7J9+6cvfZKUaifFW6RUf6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 27 Jan 2011, Hank Barta wrote:

> Thanks for the suggestion:
>
> =============================
> hbarta@oak:~$ sudo fdisk -luc /dev/sd[bc]
>
> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1            2048    20973567    10485760   fd  Linux raid autodetect
> /dev/sdb2        20973568  3907029167  1943027800   fd  Linux raid autodetect
>
> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1            2048    20973567    10485760   fd  Linux raid autodetect
> /dev/sdc2        20973568  3907029167  1943027800   fd  Linux raid autodetect
> hbarta@oak:~$
> =============================
>
> Everything seems OK as far as I can see.
>
> thanks,
> hank

Hi,

That looks correct, so you boot from /dev/sdb, /dev/sdc?  Normally when I
do a RAID1 it is with /dev/sda, /dev/sdb for SATA systems...  It looks
good, if you reboot again does it want to resync again?

Justin.


