From: Tudor Holton <tudor@smartguide.com.au>
Subject: Aren't 2TB+ disk sizes supposed to be standardized?
Date: Fri, 05 Jul 2013 15:19:52 +1000
Message-ID: <51D65778.9010502@smartguide.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys,

I just discovered this when I was about to do a disk transfer:

[edited for brevity]

$ sudo fdisk -l
Disk /dev/sdc: 2000.4 GB, 2000397852160 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907027055 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00027892
Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

$ sudo smartctl -a /dev/sdc
Model Family:     Seagate Barracuda (SATA 3Gb/s, 4K Sectors)
Device Model:     ST2000DM001-1CH164
Firmware Version: CC43
User Capacity:    2,000,397,852,160 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4

$ sudo smartctl -a /dev/sdd
Model Family:     Seagate Barracuda LP
Device Model:     ST32000542AS
Firmware Version: CC34
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4

These are from the same manufacturer!  Interestingly, the larger drive 
is actually the older one!

Is the "standardization" not a fixed value but a minimum?  If so, what 
is that actual minimum?  If it's an actual 2 terabyte (2x10^12), then I 
suppose they're both technically over, but that means that we can't just 
simply create partitions that fill the space and expect to be able to 
transfer them later. :-(

Cheers,
Tudor.

