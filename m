From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: 2.6.15-mm3 sata_mv / raid 5 array start failure on boot
Date: Tue, 03 Jan 2006 15:37:08 +0000
Message-ID: <43BA9A24.7030002@projecthugo.co.uk>
References: <43B82DDE.3060509@projecthugo.co.uk>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43B82DDE.3060509@projecthugo.co.uk>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Matt Darcy <kernel-lists@projecthugo.co.uk>
List-Id: linux-raid.ids

Matt Darcy wrote:

> Hello all,
>
> I am still persisting with my quest for a usable sata_mv driver.
>
> The 2.5.15-rc5-m3 kernel appear to have been good to me.
>
> Before I attempt moving to later releases of the 2.6.15 tree I thought 
> I'd get feedback from the people in the know
>
> This is an intentional cross-post as I'm not %100 sure if the problems 
> sits in the raid error or the actual libata/driver area (more probable)
>
> I have 7 SATA disks hanging of an 8 port controller which uses the 
> sata_mv driver.
>
> I create a raid 5 array consisting of 6 disks (using 1 full disk 
> partition) and 1 spare
>
> The array builds fine - although it takes 300 minutes so its not a 
> quick process to run through tests.
>
>
> md6 : active raid5 sdh[5] sdi[6](S) sdg[4] sdf[3] sde[2] sdd[1] sdc[0]
>      1225586560 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>
>
> as you can see, all looking good. sdi is marked as the spare./dev/md6:
>        Version : 00.90.03
>  Creation Time : Sat Dec 31 16:23:11 2005
>     Raid Level : raid5
>     Array Size : 1225586560 (1168.81 GiB 1255.00 GB)
>    Device Size : 245117312 (233.76 GiB 251.00 GB)
>   Raid Devices : 6
>  Total Devices : 7
> Preferred Minor : 6
>    Persistence : Superblock is persistent
>
>    Update Time : Sat Dec 31 22:04:56 2005
>          State : clean
> Active Devices : 6
> Working Devices : 7
> Failed Devices : 0
>  Spare Devices : 1
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>           UUID : f92fa512:1fe54278:d3ba820f:cecb842a
>         Events : 0.2
>
>    Number   Major   Minor   RaidDevice State
>       0       8       32        0      active sync   /dev/sdc
>       1       8       48        1      active sync   /dev/sdd
>       2       8       64        2      active sync   /dev/sde
>       3       8       80        3      active sync   /dev/sdf
>       4       8       96        4      active sync   /dev/sdg
>       5       8      112        5      active sync   /dev/sdh
>
>       6       8      128        -      spare   /dev/sdi
>
>
>
>
> I've played around with this large md, using lvm2, and as a flat 
> filesystem, it performs well, interacts well, seems solid and stable. 
> I'm pretty pleased with it.
>
> When I reboot however, the md6 device fails to start
>
> when I look into this its because only 2 devices are showing as usable 
> for the array, so not enough to start the raid 5 array.
>
> However when I actually look all the devices are physically there and 
> I can interact with them as seperate disks, fdisk them, format them 
> etc etc.
>
> On close inspection, it appears that although the devices are there, 
> raid subsystem finds reasons not to use them. I've attatched the 
> syslog so you can see for yourself as its quite a long post to put in 
> the body of this message.
>
> I understand why the array is not starting, however I don't understand 
> why the disks are not forming into the raid array.
>
> even now, I can't start the array manually, however, if I issue the 
> create array command again now, it builds a perfect array and the loop 
> starts again.
>
> I've followed a lot of changed in the 2.6.15-rc7 branch, but I thought 
> I'd get input before blindly upgrading.
>
> Matt

<snip>

Too add a little more to my own post in the hopes of sparking a clue in 
someone else.

I re-created the array - and took a dump of the raid config

ARRAY /dev/md6 level=raid5 num-devices=6 spares=1 
UUID=f92fa512:1fe54278:d3ba820f:cecb842a

I rebooted the box and in the same method as I mentioned in my initial 
post, the array did not come up, complaining that it could not seen any 
disks.

A little more mdadm reading and I realised I could tell mdadm to 
assemble the array based off the config file.

first I tried to run it (I expected this to fail)
 mdadm --assemble --run /dev/md6
mdadm: no devices found for /dev/md6

then I realised that even though the Sata disks are visible (two random 
examples bellow)
root@berger:~# fdisk -l /dev/sde

Disk /dev/sde: 251.0 GB, 251000193024 bytes
255 heads, 63 sectors/track, 30515 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1       30515   245111706   fd  Linux raid 
autodetect
root@berger:~# fdisk -l /dev/sdh

Disk /dev/sdh: 251.0 GB, 251000193024 bytes
255 heads, 63 sectors/track, 30515 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdh1               1       30515   245111706   fd  Linux raid 
autodetect
root@berger:~#


the array would not be aware of them as the disks where marked as "bad" 
at start up

so....

mdadm --assemble --scan --config=/etc/mdadm.conf /dev/md6
mdadm: no devices found for /dev/md6

now, I'm reading the config that I pasted above, which has all the 
details for md6 and all 7 (6 + spare) disks are visable, yet it STILL 
cannot see any of the disks for md6 ??

I've re-created the array using the same disks and it worked fine - 
rebooted and again into this same problem.

I don't understand why a.) the disks are being marked as unsuable at 
boot up b.) I cannot manually re-assemble/start the array.

I've never seen behaviour like this before.

thanks,

Matt












~






