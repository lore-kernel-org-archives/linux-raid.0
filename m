From: Phil Turmel <philip@turmel.org>
Subject: Re: Data recovery from linear array (Intel SS4000-E)
Date: Sun, 16 Oct 2011 14:46:46 -0400
Message-ID: <4E9B2696.6030500@turmel.org>
References: <4E972C82.1020605@gmx.de> <4E97539D.8040007@turmel.org> <4E985902.1070606@gmx.de> <4E98ECC1.8080403@turmel.org> <4E998037.50204@gmx.de> <4E99B61C.40704@turmel.org> <4E9AFD02.9070600@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E9AFD02.9070600@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Moos <jmoos@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/16/2011 11:49 AM, Johannes Moos wrote:
> Hi Phil,
> 
> I recreated the Array and it started.
> 
>> As you can see, the partition table corresponds to the size of the combined devices. Metadata type 0.90 is at the end of each member, so the first sector of loop0 will become the first sector of md0. 
> 
> Right, /dev/md0 now looks exactly the same as /dev/loop0:
> 
> root@ThinkPad /media/Backup/NAS # fdisk -l /dev/md0
> Disk /dev/md0: 1638.7 GB, 1638744850432 bytes
> 255 heads, 63 sectors/track, 199232 cylinders, total 3200673536 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
> 
>     Device Boot      Start         End      Blocks   Id  System
> /dev/md0p1               1       16064        8032   77  Unknown
> /dev/md0p2           16065  3200673535  1600328735+  88  Linux plaintext
> 
>>>  From what I read in a forum it's possible to mount the XFS partition with an offset, in my case that would be 00ae0000 (last line in hexdump).
>> Shouldn't be necessary.  I expect your LV w/ XFS to show up properly.
> 
> Nothing happened, so I tried as described in the forum post I mentioned (about a pretty much identical NAS and so LVM):

Hmmm.  pvs should have shown it.

> root@ThinkPad /media/Backup/NAS # hexdump -C /dev/md0 | head -n 150 | grep XFSB
> 00ae0000  58 46 53 42 00 00 10 00  00 00 00 00 00 04 00 00  |XFSB............|
> 
> Offset for XFS-Partition is 00ae0000, that's 11403264 in decimal, so I tried (read only):
> 
> root@ThinkPad /media/Backup/NAS # losetup -r -o 11403264 /dev/loop4 /dev/md0
> 
> and then I got:
> 
> root@ThinkPad /media/Backup/NAS # disktype /dev/loop4
> --- /dev/loop4
> Block device, size 1.490 TiB (1638733447168 bytes)
> XFS file system, version 4
>   Volume name ""
>   UUID 705BF11E-8F69-1CDA-8727-00004868BBE3 (DCE, v1)
>   Volume size 1 GiB (1073741824 bytes, 262144 blocks of 4 KiB)
> 
> Small progress, but volume size only 1 GiB?
> I didn't ran xfs_check or xfs_repair so far because there's probably a better way to do it :)

I'm a bit weak on XFS.  Anyone else care to comment?

Phil
