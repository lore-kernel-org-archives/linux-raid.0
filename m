From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Thu, 14 Feb 2013 19:59:43 -0500
Message-ID: <CAKHEz2a3r=fLvHbvZ7yXA5386qga0yjSH6wn8X+e8HN9FzOUjQ@mail.gmail.com>
References: <20130214210029.203940@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130214210029.203940@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 14, 2013 at 4:00 PM, Dragon <Sunghost@gmx.de> wrote:
> Hello,
>
> the 40TB are in an filecluster and this machine is part of this. the system consists of 6x3tb in sw raid5. there are four partions on each machine. one with 100mb for the efi bios, one for the os in raid1, one for the swap in raid5 and one for the files in raid5. the machine was opened and the disk layed beside, i moved two disks slightly and in this moment both spinded for a second down and the raid was gone. there was no filetransfer but the raid couldnt rebuild because of missing two disks.
>
> mdadm -E /dev/sdd4
> /dev/sdd4:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 7b99380e:51d754cf:921c68e9:7b830d6a
>            Name : mfsnode1:2  (local to host mfsnode1)
>   Creation Time : Tue Feb  5 17:06:37 2013
>      Raid Level : raid5
>    Raid Devices : 6
>
>  Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
>      Array Size : 29213772800 (13930.21 GiB 14957.45 GB)
>   Used Dev Size : 5842754560 (2786.04 GiB 2991.49 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 0da58625:14ed8675:6a7c4ba4:337d8c4b
>
>     Update Time : Tue Feb  5 17:06:37 2013

This disk looks to have dropped first. The times on the others are identical.

>        Checksum : 5f97164a - correct
>          Events : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 5
>    Array State : AAA.AA ('A' == active, '.' == missing)

Lets see if we can just help the md driver along without having it
scan, try this

mdadm -A /dev/md2 -R /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdf4 /dev/sde4

If that complains try

mdadm -A /dev/md2 --force -R /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdf4 /dev/sde4

One of these should start your array with 1 missing disk. If neither
work let me know the output.


--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
