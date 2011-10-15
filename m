From: Phil Turmel <philip@turmel.org>
Subject: Re: Data recovery from linear array (Intel SS4000-E)
Date: Sat, 15 Oct 2011 12:34:36 -0400
Message-ID: <4E99B61C.40704@turmel.org>
References: <4E972C82.1020605@gmx.de> <4E97539D.8040007@turmel.org> <4E985902.1070606@gmx.de> <4E98ECC1.8080403@turmel.org> <4E998037.50204@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E998037.50204@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Moos <jmoos@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Johannes,

On 10/15/2011 08:44 AM, Johannes Moos wrote:
> Hi Phil,
> here's my current status:
> 
> root@ThinkPad /media/Backup/NAS # mdadm --zero-superblock /dev/loop{0,1,3}
> 
> root@ThinkPad /media/Backup/NAS # mdadm --create --chunk=64 --metadata=0.90 --level=linear -n 4 /dev/md0 /dev/loop{0,1,2,3}
> mdadm: partition table exists on /dev/loop0 but will be lost or
>        meaningless after creating array
> Continue creating array? n
> mdadm: create aborted.
> 
> I answered 'no' and checked the loop devices with disktype:

Caution is good.

> root@ThinkPad /media/Backup/NAS # disktype /dev/loop{0,1,2,3}
> 
> --- /dev/loop0
> Block device, size 297.7 GiB (319668830208 bytes)
> DOS/MBR partition map
> Partition 1: 7.844 MiB (8224768 bytes, 16064 sectors from 1)
>   Type 0x77 (Unknown)
> Partition 2: 1.490 TiB (1638736625152 bytes, 3200657471 sectors from 16065)
>   Type 0x88 (Unknown)
> 
> --- /dev/loop1
> Block device, size 297.7 GiB (319668830208 bytes)
> 
> --- /dev/loop2
> Block device, size 465.4 GiB (499703758848 bytes)
> Blank disk/medium
> 
> --- /dev/loop3
> Block device, size 465.4 GiB (499703758848 bytes)
> 
> 
> fdisk output:
> 
> root@ThinkPad /usr/src/linux # fdisk -l /dev/loop0
> 
> Disk /dev/loop0: 319.7 GB, 319668830208 bytes
> 255 heads, 63 sectors/track, 38864 cylinders, total 624353184 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
> 
>       Device Boot      Start         End      Blocks   Id  System
> /dev/loop0p1               1       16064        8032   77  Unknown
> /dev/loop0p2           16065  3200673535  1600328735+  88  Linux plaintext

As you can see, the partition table corresponds to the size of the combined devices.  Metadata type 0.90 is at the end of each member, so the first sector of loop0 will become the first sector of md0.

> After examining /dev/loop0 with hexdump I found LVM on there as well:

The LVM PV should be recognized by udev as soon as the array is started.

> From what I read in a forum it's possible to mount the XFS partition with an offset, in my case that would be 00ae0000 (last line in hexdump).
> But the guy in the forum had no problem assembling his array, so I have to proceed with that first.

Shouldn't be necessary.  I expect your LV w/ XFS to show up properly.

> Just wanted to make sure that it's OK to answer 'yes' and let mdadm do its job?

Yes.

Phil
