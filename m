From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: I was dump, I need help.
Date: Sun, 1 May 2016 12:30:34 +0100
Message-ID: <20160501113034.GA24215@cthulhu.home.robinhill.me.uk>
References: <5725DCA9.9010901@pboenig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5725DCA9.9010901@pboenig.de>
Sender: linux-raid-owner@vger.kernel.org
To: Patrice <mailinglist@pboenig.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun May 01, 2016 at 12:38:33pm +0200, Patrice wrote:

> It has a Debian 7 installed and a RAID 5.
> Here some more Informations.
> 
> Thank you and best regards.
> Patrice
> 
> 
> 
> 
> root@ReadyNAS:/proc# cat mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md1 : active raid6 sda2[0] sdc2[3] sdb2[2] sdd2[1]
>        1046528 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] 
> [UUUU]
> 
> md0 : active raid1 sda1[4] sdd1[3] sdc1[2] sdb1[5]
>        4190208 blocks super 1.2 [4/4] [UUUU]
> 
> unused devices: <none>
> 
This shows two RAID devices, both up and running without any issues.

> /dev/sda1:
> /dev/sdb1:
> /dev/sdc1:
> /dev/sdd1:

The info provided here is just for the first partition on each disk.
There's definitely at least 2 partitions on each disk (as the second one
is used for md1 above) - are there any others which should be being
assembled into another array? "fdisk -l" will show the partitions for
all disks - if there's more than 2 on sda/b/c/d then we'll need to see
the "mdadm -E" report for each of the others.

Cheers,
    Robin
-- 
     ___        
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |
