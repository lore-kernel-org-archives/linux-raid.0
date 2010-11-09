From: =?ISO-8859-1?Q?Sebastian_F=E4rber?= <faerber@gmail.com>
Subject: md raid1 rebuild bug? (2.6.32.25)
Date: Tue, 9 Nov 2010 13:41:11 +0100
Message-ID: <AANLkTikbbcXH7Q1KqcOsS0n05TWYpgBev-wR9NVBdKxa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i just stumbled across a problem while rebuilding a MD RAID1 on 2.6.32.25.
The server has 2 disks, /dev/hda and /dev/sda. The RAID1 is degraded, so sda
was replaced and i tried rebuilding from /dev/hda to /dev/sdb.
While rebuilding i noticed that /dev/hda has some problems/bad sectors
but the kernel
seems to be stuck in some endless loop:

--
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=239147198,
sector=239147057
hda: possibly failed opcode: 0xc8
end_request: I/O error, dev hda, sector 239147057
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=239148174,
sector=239148081
hda: possibly failed opcode: 0xc8
end_request: I/O error, dev hda, sector 239148081
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=239147213,
sector=239147209
hda: possibly failed opcode: 0xc8
end_request: I/O error, dev hda, sector 239147209
raid1: hda: unrecoverable I/O read error for block 237892224
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=239148174,
sector=239148169
hda: possibly failed opcode: 0xc8
end_request: I/O error, dev hda, sector 239148169
raid1: hda: unrecoverable I/O read error for block 237893120
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=239148225,
sector=239148225
hda: possibly failed opcode: 0xc8
end_request: I/O error, dev hda, sector 239148225
raid1: hda: unrecoverable I/O read error for block 237893248
md: md1: recovery done.
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:hda6
 disk 1, wo:1, o:1, dev:sda6
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:hda6
 disk 1, wo:1, o:1, dev:sda6
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:hda6
 disk 1, wo:1, o:1, dev:sda6
--

I get a new "conf printout" message every few seconds until i used
mdadm to set /dev/sda6 to
"faulty". I know /dev/hda is bad and i probably won't be able to
rebuild the raid device, but this
endless loop seems fishy?
This is a md-raid1 on 2.6.32.25 with superblock version 0.90.
While the "conf printouts" were looping i had a look at /proc/mdstat:
--
# cat /proc/mdstat
Personalities : [raid1] [raid10]
md1 : active raid1 sda6[2] hda6[0]
      119011456 blocks [2/1] [U_]
--
This shows that md1 is not correctly rebuilded, but dmesg showed "md:
md1: recovery done" earlier?

Would be great if someone who knows the raid-code could have a look at
this. I can provide more information
if necessary.

Regards,

Sebastian
