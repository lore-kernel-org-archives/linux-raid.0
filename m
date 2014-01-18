From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid recovery - raid5 - one active, two spares
Date: Sat, 18 Jan 2014 10:42:09 -0500
Message-ID: <52DAA0D1.60005@turmel.org>
References: <CAPZL0fpbkAy=L7i3RcTL_z0y2dQ5K00Y2Vnhss_agtCoZEur4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPZL0fpbkAy=L7i3RcTL_z0y2dQ5K00Y2Vnhss_agtCoZEur4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Zalewski <mariusz@zalewscy.eu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Mariusz,

On 01/17/2014 08:10 PM, Mariusz Zalewski wrote:
> Hi,
> 
> Encouraged via information found on the wiki
> <https://raid.wiki.kernel.org/index.php/RAID_Recovery> it would be
> great to receive advice from linux-raid community.

This is the right place for help.

> Recently I bought a extra hard drive (next to existing raid level 5
> three discs). Unfortunately during physical installation probably
> disconnect two hard drives of existing raid on my PC. I didn't notice
> that cables was not properly inserted. After system bootup (Linux Mint
> 13) md doesn't start. Because /home directory should be mounted on
> LVM@RAID my system doesn't start properly
> 
> I've disconnected new hard drive, check and correct every cable on
> previously working hard drives and run LiveUSB linux to check if RAID
> will go OK. It wasn't.

I wonder if you've left out some things you tried . . .

> From liveCD perspective raid 5 should be worked on three partitions:
> /dev/sdb1
> /dev/sdd1
> /dev/sde1
> 
> There are also other storage devices on PC:
> /dev/sda - main drive, system without /home
> /dev/sdc - LiveUSB usb
> 
> 
> LiveUSBmint ~ # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md2 : inactive sdd1[1](S) sde1[3](S)
>       5859354352 blocks super 1.0
> 
> unused devices: <none>
> 
> LiveUSBmint ~ # mdadm --examine /dev/sd[bde]1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : e494f7d3:bef9154e:1de134d7:476ed4e0
>            Name : tobik:2
>   Creation Time : Wed May 23 00:05:55 2012
>      Raid Level : raid5
>    Raid Devices : 3
> 
>  Avail Dev Size : 5859354352 (2793.96 GiB 2999.99 GB)
>      Array Size : 11718708480 (5587.92 GiB 5999.98 GB)
>   Used Dev Size : 5859354240 (2793.96 GiB 2999.99 GB)
>    Super Offset : 5859354608 sectors
>           State : clean
>     Device UUID : 8aa81e09:22237f15:0801f42d:95104515
> 
>     Update Time : Fri Jan 17 18:32:50 2014
>        Checksum : 8454c6e - correct
>          Events : 91
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>    Device Role : Active device 0
>    Array State : AAA ('A' == active, '.' == missing)

This is good.

> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : e494f7d3:bef9154e:1de134d7:476ed4e0
>            Name : tobik:2
>   Creation Time : Wed May 23 00:05:55 2012
>      Raid Level : -unknown-
>    Raid Devices : 0
> 
>  Avail Dev Size : 5859354352 (2793.96 GiB 2999.99 GB)
>    Super Offset : 5859354608 sectors
>           State : active
>     Device UUID : ec85b3b8:30a31d27:6af31507:dcb4e8dc
> 
>     Update Time : Fri Jan 17 20:07:12 2014
>        Checksum : 6a2b13f4 - correct
>          Events : 1
> 
> 
>    Device Role : spare
>    Array State :  ('A' == active, '.' == missing)

This is bad.  Simply attempting to assemble an array will not change a
drive to a spare.

> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : e494f7d3:bef9154e:1de134d7:476ed4e0
>            Name : tobik:2
>   Creation Time : Wed May 23 00:05:55 2012
>      Raid Level : -unknown-
>    Raid Devices : 0
> 
>  Avail Dev Size : 5859354352 (2793.96 GiB 2999.99 GB)
>    Super Offset : 5859354608 sectors
>           State : active
>     Device UUID : 0bc9b05f:bc35f218:82798504:ef62ff32
> 
>     Update Time : Fri Jan 17 20:07:12 2014
>        Checksum : 56831dcb - correct
>          Events : 1
> 
> 
>    Device Role : spare
>    Array State :  ('A' == active, '.' == missing)

Same here.

If the unintended disconnect was the only thing that had gone wrong,
mdadm --assemble --force would have fixed it.

Did you try to "--add" these devices to the array while in the LiveCD?

> mint etc # mdadm --examine /dev/sd[bde]1 | egrep "/dev/sd|Events|Role|Time"
> /dev/sdb1:
>   Creation Time : Wed May 23 00:05:55 2012
>     Update Time : Fri Jan 17 18:32:50 2014
>          Events : 91
>    Device Role : Active device 0
> /dev/sdd1:
>   Creation Time : Wed May 23 00:05:55 2012
>     Update Time : Fri Jan 17 20:07:12 2014
>          Events : 1
>    Device Role : spare
> /dev/sde1:
>   Creation Time : Wed May 23 00:05:55 2012
>     Update Time : Fri Jan 17 20:07:12 2014
>          Events : 1
>    Device Role : spare
> 
> 
> LiveUSBmint ~ # uname -a
> Linux mint 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC
> 2012 x86_64 x86_64 x86_64 GNU/Linux
> 
> LiveUSBmint ~ # mdadm -V
> mdadm - v3.2.5 - 18th May 2012
> 
> 
> It is possible to recover Raid 5 from this disks? I consider
> "Restoring array by recreating..."
> <https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_recreating_.28after_multiple_device_failure.29>
> but I would like to know Your opinion. According to wiki it should be
> considered as *last* resort.

It is a last resort, but appears to be necessary in your case.  There's
only two possible device orders to choose from.  Your array has version
1.0 metadata, so the data offset won't be a problem, but you must use
the --size option to make sure the new array has the same size as the
original:

Try #1:

mdadm --stop /dev/md2
mdadm --create --assume-clean --metadata=1.0 --size=2929677120 \
  --chunk=64 /dev/md2 /dev/sd{b,d,e}1

Show "mdadm -E /dev/sdb1" and verify that all of the sizes & offsets
match the original.

Do *not* mount the array! (Yet)

Use "fsck -n" to see if the filesystem is reasonably consistent.  If
not, switch /dev/sdd1 and /dev/sde1 in try #2.

When you are confortable with the device order based on "fsck -n"
output, perform a normal fsck, then mount.

> P.S. Fortunately I have a backup, but time spend on recover can take
> much longer.

Backups are good.

HTH,

Phil
