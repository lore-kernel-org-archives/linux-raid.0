From: Wolfram Schlich <lists@schlich.org>
Subject: IDE Soft-RAID5, poor performance (suspected)
Date: Thu, 13 Mar 2003 16:00:47 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030313150047.ALLYOURBASEAREBELONGTOUS.C10081@bla.fasel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm using software RAID5 on 4 IDE devices and it appears to be really
slow. This is my second array, the first one wasn't really faster at
all.

Details:
- Tyan S2462UNG Thunder K7
- 2x AMD Athlon MP 1.2GHz
- 4x 256MB PC2100 reg. ECC DDR-SDRAM

First (old) array:
- 2x Promise Ultra100 PDC20267 UDMA100-IDE PCI adapter
- 4x IBM Deskstar 60GXP IC35L060AVER07 61.49GB 7200rpm 2MB cache
  UDMA100-IDE HDD
- 1 disk per bus  
- 4x 90cm UDMA133 cable, rounded (they were advertised to be ok for 133)
- 128k chunk-size, left-symmetric  
- ReiserFS 3.6 with no special options  

Second (current) array:
- 2x Promise Ultra133TX2 PDC20269 UDMA133-IDE PCI adapter
- 4x Western Digital WD1200JB 120GB 7200rpm 8MB cache
  UDMA100-IDE HDD
- 1 disk per bus 
- 4x 90cm UDMA133 cable, rounded (same as above)
- 64k chunk-size, left-symmetric
- Ext3 with "-b 4096 -R stride=16"  

I do experience nearly the same with both configurations:
The max. transfer rate shown by e.g. 'mc' is ~45MB (when copying a
~700M file from the array onto an attached SCSI disk), but gets stuck
some times in between. Same with copying from the array to the array
(another location/filename). Copying from the SCSI disk to the array
starts with slow ~6M/s and raises to somewhat around 19M/s at the end.
Is this a hardware problem? Should I try other cables (I cannot really
use shorter cables, because my cube-case is too big :-( 45cm cables
just cannot reach the disks)?

Overall I'm not very satisfied with the current situation, as you'd
expect ;-) The hardware *should* be capable of doing much better, I
believe.

I'd be pleased to give more details as needed.
Should I run any tiobench/tiotest or bonnie++ benchmarks?

TIA.
-- 
Wolfram Schlich; Friedhofstr. 8, D-88069 Tettnang; +49-(0)178-SCHLICH
