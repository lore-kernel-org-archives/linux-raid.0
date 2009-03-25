From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 reshape problems
Date: Thu, 26 Mar 2009 09:13:06 +1100
Message-ID: <18890.44146.95223.103114@notabene.brown>
References: <49CA787C.2090100@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stefan G. Weichinger on Wednesday March 25
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 25, lists@xunil.at wrote:
> 
> Could someone *please* help me out?
> 
> I have a problematic RAID5 and don't know how to proceed.
> 
> Situation:
> 
> gentoo linux, 32bit, 2.6.25-gentoo-r8
> 
> mdadm-2.6.4-r1
> 
> Initially 4 x 1TB SATA-disks, partitioned.
> 
> SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X
> Fusion-MPT SAS (rev 01)
> 
> /dev/md2 contained of /dev/sd{abcd}4 ...
> 
> 2 x 1 TB added (hotplugged), disks detected fine, partitioned
> 
> Added /dev/sd{ef}4 to /dev/md2, triggered grow to 6 raid-devices.
> 
> Started fine. Projected end of reshape ~3100 minutes, started at around
> 17h local time. Maybe it accelerated while I was out and userload decreased.
> 
> --
> 
> Then sdf failed:
> 
> Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] CDB: cdb[0]=0x28: 28 00 01 5d de
> a4 00 00 18 00
....
> Mar 25 17:23:47 horde md: md2: reshape done.
> Mar 25 17:23:47 horde mdadm: Fail event detected on md device /dev/md2,
> component device /dev/sdf4
> 
> 

On getting a device failure, md will abort the reshape.  It should
then notice that a reshape needs to be completed and start again.
I guess it didn't.

> 
> ----
> 
> 
> Now I have a system with load ~77 ...
> 
> I don't get answers to "cat /proc/mdstat" ...
> 
> We removed sdf, which didn't decrease the load.
> 
> top doesn't show any particular hog, CPUs near idle, disks as well.

With a load of 77 you should see something odd in
   ps axgu

either processes in status 'R' or 'D'.

> 
> "mdadm -D" doesn't give me answers.

Must be some sort of deadlock....

> 
> Only this:
> 
> # mdadm -E /dev/sda4
> /dev/sda4:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 2e27c42d:40936d45:53eb5abe:265a9668
>   Creation Time : Wed Oct 22 19:43:13 2008
>      Raid Level : raid5
>   Used Dev Size : 967795648 (922.96 GiB 991.02 GB)
>      Array Size : 4838978240 (4614.81 GiB 4955.11 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
> 
>   Reshape pos'n : 61125760 (58.29 GiB 62.59 GB)
>   Delta Devices : 2 (4->6)
> 
>     Update Time : Wed Mar 25 17:23:47 2009
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 65f12171 - correct
>          Events : 0.8247
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8        4        0      active sync   /dev/sda4
> 
>    0     0       8        4        0      active sync   /dev/sda4
>    1     1       8       20        1      active sync   /dev/sdb4
>    2     2       8       36        2      active sync   /dev/sdc4
>    3     3       8       52        3      active sync   /dev/sdd4
>    4     4       0        0        4      faulty removed
>    5     5       8       68        5      active sync   /dev/sde4
> 

This looks good.  The devices knows that it is in the middle of a
reshape, and knows how far along it is.  After a reboot it should just
pick up where it left off.

> 
> ---
> 
> 
> /dev/md2 is the single PV in an LVM-VG, I don't get output from
> vgdisplay, pvdisplay.
> 
> But I see the mounted LVs, and I am able to browse the data.
> 
> The OS itself is on /dev/md1 which only contains /dev/sd{abcd}3 , so no
> new/faulty disks included.
> 
> ---
> 
> My question:
> 
> How to proceed? Is the raid OK? May I try a reboot and everything is OK
> or NOT? Is it possible that the reshape with now only 5 disks was
> finished so much faster?

The raid is OK.  It is, of course, degraded now and if another device
fails you will lose data.  Reboot should be perfectly safe.  However
you might need to re-assemble the array using the "--force" flag.
This is safe.
The reshape didn't finish.  It is only up to 
>   Reshape pos'n : 61125760 (58.29 GiB 62.59 GB)

NeilBrown
