From: linux@horizon.com
Subject: Re: suggestions for inexpensive linux jbod?
Date: 19 Jun 2007 01:43:38 -0400
Message-ID: <20070619054338.8539.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mikee@mikee.ath.cx
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Get 3 Hitachi 1TB drives and use SW RAID5 on an Intel 965 motherboard OR 
> use PCI-e cards that use the Silicon Image chipset.
> 
> 04:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid 
> II Controller (rev 01)

What he said.  After some thinking, I loaded up a machine with 3x
SiI3132 and figured I'll expand by port multiplier.  Port multipliers
are documented in the standard, not vendor-defined, and are currently
made only by, guess who, Silicon Image.  I haven't used any yet, but
apparently they're working, and you know that both the manufacturer and
the linux-ide deveopers have tested them throroughly with SiI controllers.

03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
04:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
05:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)

md4 : active raid10 sdf3[4] sde3[3] sdd3[2] sdc3[1] sdb3[0] sda3[5]
      131837184 blocks 256K chunks 2 near-copies [6/6] [UUUUUU]
      bitmap: 2/126 pages [8KB], 512KB chunk

md5 : active raid5 sdf4[5] sde4[4] sdd4[3] sdc4[2] sdb4[1] sda4[0]
      1719155200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
      bitmap: 27/164 pages [108KB], 1024KB chunk

md0 : active raid1 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      979840 blocks [6/6] [UUUUUU]
      bitmap: 0/120 pages [0KB], 4KB chunk

md0 is the boot partition, md4 is root, and md5 is the main backup data.
Note the way the drives ar arranged on the RAID-10; mirrored pairs are
aplit across different SATA controllers.
