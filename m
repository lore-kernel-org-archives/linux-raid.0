From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Software RAID6 broke after power outage
Date: Wed, 22 Jul 2020 10:14:48 +0100
Message-ID: <5F180388.6020402@youngman.org.uk>
References: <CA+CBf3QZP4Yss0U=6Aa_5a+3D2Yy-WT545VazHiFWCZsreNOEg@mail.gmail.com>
 <CA+CBf3Q8sKv9k83dp38ekkBY1qgvOe2seQOYvxukg-X4__7JkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+CBf3Q8sKv9k83dp38ekkBY1qgvOe2seQOYvxukg-X4__7JkA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Derenburger <cory.derenburger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/07/20 08:41, Cory Derenburger wrote:
> My server lost power this morning. The server is running Linux Mint
> (14?) on a battery backup and I believe it shutdown before losing
> power. Upon restarting the server the computer hung for a while, and
> after resetting and booting up in recovery mode my RAID is now
> nonfunctional.
> 
> The server was set up years ago with a RAID 6 array built with mdadm.
> To be honest I don't really know what is wrong with the array, it
> seems to be an issue with disk sdc. I wanted to reach out for help to
> confirm the issue and get some guidance before proceeding (or making
> things worse).
> 
> Any assistance that can help me determine what steps to take to get
> this server back up and running would be greatly appreciated. It's
> been 4+ since I have touched RAID, and only attempted a recovery once.
> If anyone can help I would be super appreciative.

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
https://raid.wiki.kernel.org/index.php/Asking_for_help

I see you've included some stuff which is helpful, but can you do
everything that last page asks for. In particular, lsdrv.
> 
> Below I'm including outputs from various commands for the 3rd disk
> which seems to be the culprit
> 
> dmesg - boot section section where first errors begin occurring
> [    2.637856] md: bind<sdd1>
> [    2.646987] random: nonblocking pool is initialized
> [    2.647432] md: bind<sde1>
> [    2.651429] md: bind<sdb1>
> [    2.863538] ata3.00: exception Emask 0x0 SAct 0x10 SErr 0x0 action 0x0
> [    2.863594] ata3.00: irq_stat 0x40000008
> [    2.863643] ata3.00: failed command: READ FPDMA QUEUED
> [    2.863695] ata3.00: cmd 60/08:20:08:08:00/00:00:00:00:00/40 tag 4
> ncq 4096 in
> [    2.863695]          res 41/40:00:09:08:00/00:00:00:00:00/40 Emask
> 0x409 (media error) <F>
> [    2.863775] ata3.00: status: { DRDY ERR }
> [    2.863822] ata3.00: error: { UNC }
> [    2.873407] ata3.00: configured for UDMA/133
> [    2.873476] sd 2:0:0:0: [sdc] Unhandled sense code
> [    2.873525] sd 2:0:0:0: [sdc]
> [    2.873571] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [    2.873619] sd 2:0:0:0: [sdc]
> [    2.873665] Sense Key : Medium Error [current] [descriptor]
> [    2.873819] Descriptor sense data with sense descriptors (in hex):
> [    2.873901]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [    2.874544]         00 00 08 09
> [    2.874764] sd 2:0:0:0: [sdc]
> [    2.874811] Add. Sense: Unrecovered read error - auto reallocate failed
> [    2.874895] sd 2:0:0:0: [sdc] CDB:
> [    2.874941] Read(10): 28 00 00 00 08 08 00 00 08 00
> [    2.875428] end_request: I/O error, dev sdc, sector 2057
> [    2.875478] Buffer I/O error on device sdc1, logical block 1
> 
> cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdb1[0](S) sde1[3](S) sdd1[2](S)
>       5860147464 blocks super 1.2
> 
> {not sure why these drives are now showing as spares}

This is very common when an array fails to assemble properly.
Unfortunately, when there's one error, it often triggers a cascade of
fake errors, and this is probably the case here.
> 
> Below running mdstat for sdc.  Checking sdb, sdd, sde appear fine.
> 
> mdadm --examine /dev/sdc
> /dev/sdc:   MBR Magic : aa55
> Partition[0] :   3907027120 sectors at         2048 (type fd)
> 
> mdadm --examine /dev/sdc1
> mdadm: No md superblock detected on /dev/sdc1.
> 
> fdisk -l
> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x38389fdc
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1            2048  3907029167  1953513560   fd  Linux raid autodetect
> 
> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0xd108824d
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1            2048  3907029167  1953513560   fd  Linux raid autodetect
> 
> Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x6207659a
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdd1            2048  3907029167  1953513560   fd  Linux raid autodetect
> 
> Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0xd9a4afcf
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sde1            2048  3907029167  1953513560   fd  Linux raid autodetect
> 
> 
> Is there other information needed to determine the issue?  Where do I
> go from here?
> 
How old is linux mint? Have you kept it up-to-date? Unfortunately, it
seems a lot of older systems suffer issues when the kernel is heavily
patched and mdadm is not updated, and this regularly surfaces on this
list where Ubuntu is concerned ...

mdadm --version
uname -a

Make sure you have a "latest and greatest" rescue disk to hand, and
we'll see what the others say.

Cheers,
Wol
