From: "NeilBrown" <neilb@suse.de>
Subject: Re: Readding a drive fails because of wrong size?
Date: Fri, 26 Jun 2009 10:34:33 +1000 (EST)
Message-ID: <9be1aac09da53367651c62b7de9b668a.squirrel@neil.brown.name>
References: <4A43C8C7.7000209@canbytel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A43C8C7.7000209@canbytel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott Baker <bakers@canbytel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, June 26, 2009 4:58 am, Scott Baker wrote:
> I have a four disk RAID5 array, and one of the HDs got removed from the
> array. All four drives are identical in size and partitioning.
>
> --------------------------------------------------------------------------
>
> Disk /dev/sdc: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1       60801   488384032   fd  Linux raid
> autodetect
>
> Disk /dev/sdd: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdd1               1       60801   488384032   fd  Linux raid
> autodetect
>
> Disk /dev/sde: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sde1               1       60801   488384032   fd  Linux raid
> autodetect
>
> Disk /dev/sdf: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdf1               1       60801   488384032   fd  Linux raid
> autodetect
>
> --------------------------------------------------------------------------
>
> /dev/sde1 needs to get added back into the array, the other three drives
> are fine.
>
> --------------------------------------------------------------------------
>
> /dev/md8:
>          Version : 00.90.03
>    Creation Time : Fri Oct 26 16:00:51 2007
>       Raid Level : raid5
>       Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
>    Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>     Raid Devices : 4
>    Total Devices : 3
> Preferred Minor : 8
>      Persistence : Superblock is persistent
>
>      Update Time : Thu Jun 25 11:27:31 2009
>            State : clean, degraded
>   Active Devices : 3
> Working Devices : 3
>   Failed Devices : 0
>    Spare Devices : 0
>
>           Layout : left-symmetric
>       Chunk Size : 64K
>
>             UUID : 44c3189a:58ffab82:c2c79482:d044a0fb
>           Events : 0.218148
>
>      Number   Major   Minor   RaidDevice State
>         0       8       33        0      active sync   /dev/sdc1
>         1       8       49        1      active sync   /dev/sdd1
>         2       0        0        2      removed
>         3       8       81        3      active sync   /dev/sdf1
>
> --------------------------------------------------------------------------
>
> But when I try and add it to the array it gives me a array that the
> partition isn't big enough? Nothing has changed, I haven't formatted or
> anything. All I did was replace a SATA cable and now I can't add that
> drive
> back to the array? This server is running CentOS 5.3 with all the updates.
>

Very strange - I cannot explain this at all.
What does
  blockdev --getsz /dev/sde1
show?
Can you
  strace -o /tmp/str mdadm /dev/md8 --add /dev/sde1
and post "/tmp/str" ??

> --------------------------------------------------------------------------
>
> :./mdadm /dev/md8 --add /dev/sde1
> mdadm: /dev/sde1 not large enough to join array
>
> root@white(/tmp/mdadm-2.6.9)
> :mdadm --version
> mdadm - v2.6.4 - 19th October 2007

It looks like you have downloaded mdadm-2.6.9 and maybe even
compiled it.  Did you try it?
  cd /tmp/mdadm-2.6.9
  make
  ./mdadm /dev/md0 --add /dev/sde1
??

NeilBrown


>
> --------------------------------------------------------------------------
>
> HELP!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

