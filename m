From: =?ISO-8859-15?Q?Karsten_R=F6mke?= <k.roemke@gmx.de>
Subject: big fault :-)
Date: Tue, 11 Oct 2005 18:26:50 +0200
Message-ID: <434BE7CA.4040707@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I think I do something which isn't very clever ...
I needed temporarily some disk-space, so I thought:
Look at your raid, if it works you can take one disk for
a short time (I use raid1).
cat /proc/mdstat looks good, so I hotremove one of two partitions.
When adding the disk again with raidhotadd /dev/md1 /dev/hdb3
it starts to synchronize but it never stops to synchronize...

in messages I found:
---------------
Oct 11 17:54:24 hhbgate kernel: md: trying to hot-add hdb3 to md1 ...
Oct 11 17:54:24 hhbgate kernel: md: bind<hdb3>
Oct 11 17:54:24 hhbgate kernel: RAID1 conf printout:
Oct 11 17:54:24 hhbgate kernel:  --- wd:1 rd:2
Oct 11 17:54:24 hhbgate kernel:  disk 0, wo:0, o:1, dev:hda3
Oct 11 17:54:24 hhbgate kernel:  disk 1, wo:1, o:1, dev:hdb3
Oct 11 17:54:24 hhbgate kernel: ..<6>md: syncing RAID array md1
Oct 11 17:54:24 hhbgate kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Oct 11 17:54:24 hhbgate kernel: md: using maximum available idle IO bandwith (but not more than 200
000 KB/sec) for reconstruction.
Oct 11 17:54:24 hhbgate kernel: md: using 128k window, over a total of 78482304 blocks.
---------------
and later, when I am around 60 % of recovering:
Oct 11 18:15:31 hhbgate kernel: hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
Oct 11 18:15:31 hhbgate kernel: hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=97562309,
  sector=97562224
Oct 11 18:15:31 hhbgate kernel: ide: failed opcode was: unknown
Oct 11 18:15:31 hhbgate kernel: end_request: I/O error, dev hda, sector 97562224
Oct 11 18:15:32 hhbgate kernel: hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
Oct 11 18:15:32 hhbgate kernel: hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=97562309,
  sector=97562232

and so on with some more sectors and later

Oct 11 18:15:44 hhbgate kernel: end_request: I/O error, dev hda, sector 97562304
Oct 11 18:15:44 hhbgate kernel: raid1: hda: unrecoverable I/O read error for block 94440448
Oct 11 18:15:44 hhbgate kernel: md: md1: sync done.
Oct 11 18:15:44 hhbgate kernel: RAID1 conf printout:
Oct 11 18:15:44 hhbgate kernel:  --- wd:1 rd:2
Oct 11 18:15:44 hhbgate kernel:  disk 0, wo:0, o:1, dev:hda3
Oct 11 18:15:44 hhbgate kernel:  disk 1, wo:1, o:1, dev:hdb3
Oct 11 18:15:44 hhbgate kernel: RAID1 conf printout:
Oct 11 18:15:44 hhbgate kernel:  --- wd:1 rd:2
Oct 11 18:15:44 hhbgate kernel:  disk 0, wo:0, o:1, dev:hda3
Oct 11 18:15:44 hhbgate kernel: RAID1 conf printout:
Oct 11 18:15:44 hhbgate kernel:  --- wd:1 rd:2
Oct 11 18:15:44 hhbgate kernel:  disk 0, wo:0, o:1, dev:hda3
Oct 11 18:15:44 hhbgate kernel:  disk 1, wo:1, o:1, dev:hdb3
Oct 11 18:15:44 hhbgate kernel: ..<6>md: syncing RAID array md1

the recovering prozess starts again and again.

Any hints what to do?

Thanks
             karsten
