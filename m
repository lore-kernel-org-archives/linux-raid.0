From: Ronny Plattner <ronny_p@gmx.net>
Subject: Re: once again raid5
Date: Sun, 03 Apr 2005 18:56:24 +0200
Message-ID: <d2p73g$9u5$1@sea.gmane.org>
References: <d2gr28$aeb$1@sea.gmane.org> <16971.62329.939077.933653@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16971.62329.939077.933653@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi !

Neil Brown schrieb:
> Your best bet would be:
> 
>   mdadm --create /dev/md2 --level 5 -n 4 /dev/hda1 /dev/hdk1 missing  /dev/hdo1
> 
> and hope that the data you find on md2 isn't too corrupted.  You might be
> lucky, but I'm not holding my breath - sorry.

This worked AFAIS but there are troubles with the filesystems ( no 
superblocks ...ext3,xfs) :-(

-snip-
~# mdadm  --detail /dev/md2
/dev/md2:
         Version : 00.90.01
   Creation Time : Sun Apr  3 12:34:42 2005
      Raid Level : raid5
      Array Size : 735334848 (701.27 GiB 752.98 GB)
     Device Size : 245111616 (233.76 GiB 250.99 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Sun Apr  3 12:34:42 2005
           State : clean, degraded
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 39e90883:c8f824d7:16732793:9ba70289
          Events : 0.60470023

     Number   Major   Minor   RaidDevice State
        0      56        1        0      active sync   /dev/hdi1
        1      57        1        1      active sync   /dev/hdk1
        2       0        0        -      removed
        3      89        1        3      active sync   /dev/hdo1
-snap-


Thanks
Ronny

ps: For people which are interested in...

-snip-
server:~# mount -t ext3 /dev/mapper/raid5--volume-home /mnt/data
mount: wrong fs type, bad option, bad superblock on 
/dev/mapper/raid5--volume-home,
        or too many mounted file systems
        (could this be the IDE device where you in fact use
        ide-scsi so that sr0 or sda or so is needed?)

server:~# mount -t xfs /dev/mapper/raid5--volume-data  /mnt/data
mount: /dev/mapper/raid5--volume-data: can't read superblock
-snap-


