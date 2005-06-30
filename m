From: Sandro Dentella <sandro@e-den.it>
Subject: Re: Hung rebuilding
Date: Thu, 30 Jun 2005 19:42:40 +0200
Message-ID: <20050630174240.GA18469@casa.e-den.it>
References: <20050630134537.GA14145@casa.e-den.it> <42C41CEE.6020602@fooplanet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42C41CEE.6020602@fooplanet.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gil <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>     smartctl -l error /dev/hda

You are write... what is worse is that both hda and hdc have errors, 

hda: ATA Error Count: 6 (device log contains only the most recent five errors)
hdc: ATA Error Count: 49 (device log contains only the most recent five errors)

(should it be need: www.e-den.it/misc/smart-a   smart-c)

> Worse yet it appears that your bad block contains a part of the
> reiserfs superblock which would be why you can't mount the filesystem.

But does this mean that it failed reading from *both* HD? Shouldn't it use
both HD to read and one should provide the information in case the other
fails?

I'm really puzzled. Last year the same server lost 2 disk in a day in a way
that they where not even recogniable by the bios...

Here are the logs that refer to reiserfs, I wanted to understand if it is
possible that the superblock is positioned in both disk on bad blocks...

  Jun 30 11:47:56 srv-ornago kernel: hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
  Jun 30 11:47:56 srv-ornago kernel: hdc: dma_intr: error=0x40 { UncorrectableError }, LBAsect=11390276, sector=128
  Jun 30 11:47:56 srv-ornago kernel: end_request: I/O error, dev 16:07 (hdc), sector 128
  Jun 30 11:47:56 srv-ornago kernel: raid1: ide/host0/bus1/target0/lun0/part7: rescheduling block 128
  Jun 30 11:47:56 srv-ornago kernel: raid1: ide/host0/bus1/target0/lun0/part7: unrecoverable I/O read error for block 128
  Jun 30 11:47:56 srv-ornago kernel: sh-2007: reiserfs read_super_block: bread failed (dev 09:03, block 64, size 1024)
  Jun 30 11:47:56 srv-ornago kernel: sh-2021: reiserfs_read_super: can not find reiserfs on md(9,3)


  Jun 30 12:00:15 srv-ornago kernel: raid1: ide/host0/bus1/target0/lun0/part7: rescheduling block 134
  Jun 30 12:00:15 srv-ornago kernel: raid1: ide/host0/bus1/target0/lun0/part7: unrecoverable I/O read error for block 134
  Jun 30 12:00:15 srv-ornago kernel: hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
  Jun 30 12:00:15 srv-ornago kernel: hdc: dma_intr: error=0x40 { UncorrectableError }, LBAsect=11390276, sector=128
  Jun 30 12:00:15 srv-ornago kernel: end_request: I/O error, dev 16:07 (hdc), sector 128
  Jun 30 12:00:15 srv-ornago kernel: raid1: ide/host0/bus1/target0/lun0/part7: rescheduling block 128
  Jun 30 12:00:15 srv-ornago kernel: raid1: ide/host0/bus1/target0/lun0/part7: unrecoverable I/O read error for block 128
  Jun 30 12:00:15 srv-ornago kernel: sh-2006: reiserfs read_super_block: bread failed (dev 09:03, block 64, size 1024)
  Jun 30 12:00:15 srv-ornago kernel: sh-2021: reiserfs_read_super: can not find reiserfs on md(9,3)


  Jun 30 12:25:41 srv-ornago kernel: hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
  Jun 30 12:25:41 srv-ornago kernel: hdc: dma_intr: error=0x40 { UncorrectableError }, LBAsect=11390276, sector=128
  Jun 30 12:25:41 srv-ornago kernel: end_request: I/O error, dev 16:07 (hdc), sector 128
  Jun 30 12:25:41 srv-ornago kernel: raid1: ide/host0/bus1/target0/lun0/part7: rescheduling block 128
  Jun 30 12:25:41 srv-ornago kernel: raid1: ide/host0/bus1/target0/lun0/part7: unrecoverable I/O read error for block 128
  Jun 30 12:25:41 srv-ornago kernel: sh-2006: reiserfs read_super_block: bread failed (dev 09:03, block 64, size 1024)
  Jun 30 12:25:41 srv-ornago kernel: sh-2021: reiserfs_read_super: can not find reiserfs on md(9,3)


  Jun 30 14:33:48 srv-ornago kernel: md: cannot remove active disk ide/host0/bus0/target0/lun0/part7 from md3 ...
  Jun 30 14:40:30 srv-ornago kernel: reiserfs: found format "3.6" with standard journal
  Jun 30 14:40:31 srv-ornago kernel: hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
  Jun 30 14:40:31 srv-ornago kernel: hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=15584452, sector=4194304
  Jun 30 14:40:31 srv-ornago kernel: end_request: I/O error, dev 03:07 (hda), sector 4194304
  Jun 30 14:40:31 srv-ornago kernel: ide0(3,7):sh-2029: reiserfs read_bitmaps: bitmap block (#524288) reading failed
  Jun 30 14:40:31 srv-ornago kernel: ide0(3,7):sh-2014: reiserfs_read_super: unable to read bitmap
  Jun 30 14:40:33 srv-ornago kernel: hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
  Jun 30 14:40:33 srv-ornago kernel: hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=16108740, sector=4718592
  Jun 30 14:40:33 srv-ornago kernel: end_request: I/O error, dev 03:07 (hda), sector 4718592
  Jun 30 17:30:56 srv-ornago kernel: md: trying to remove ide/host0/bus0/target0/lun0/part7 from md3 ...


Thanks for any possible hint
sandro
*%-|


-- 
Sandro Dentella  *:-)
e-mail: sandro@e-den.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
