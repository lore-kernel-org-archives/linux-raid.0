From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Data corruption on software raid.
Date: Sun, 18 Mar 2007 14:16:06 +0100
Message-ID: <20070318131606.GJ6063@freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!  Long story. Get some coke.

I'm having an odd problem with using software raid on two Western
Digital disks type WD2500JD-00F (250gb) connected to a Silicon Image
Sil3112 PCI SATA conroller running with Linux 2.6.20, mdadm 2.5.6

When these disks are in a raid1 set, downloading data to the raid1 set
using scp or ftp causes some blocks of the data to corrupt on disk. Only
the data downloaded gets corrupted, not the data that already was on the
set. But when the data is first downloaded to another disk and locally
moved to the raid1 set, the data stays just fine.

This alone is weird enough.

But i decided to dig deeper and switched off the raid1 set, mounted both
disks directly. Writing data to the disks directly works perfectly fine.
No corruption anymore. The data written to the disks before using raid
is still corrupted, so the corruption is really on disk.

Then i decided to 'mke2fs -c -c' (read/write badblock check) both disks
which returned null errors on the disks themselves. I stored ~240gb data
on disk1 and verify-copied it to disk2. The contents stay the same.

I also tried simultaneously writing data to disk1 and disk2 to 'emulate'
raid1 disk activity, but no corruption occurred. I even moved the SATA
PCI controller to a different slot to isolate IRQ problems. This made
no change to the whole situation.

So for all i know, the disks are fine, the controller is fine, it must
be something in the software raid code, right?

Wrong. My system is also running a raid1 set on IDE disks. This set is
working just perfectly normal. No corruption when downloading data, no
corruption when moving data about, no problems at all...

My /proc/mdstat is one pool op happiness. It now reads:

| Personalities : [raid1] 
| md0 : active raid1 hda2[0] hdb1[1]
|       120060736 blocks [2/2] [UU]
|       
| unused devices: <none>

With the SATA set active it also has:

| md1 : active raid1 sdb1[0] sda1[1]
|       244198584 blocks [2/2] [UU]
(NOTE: sdb1 is first, sda1 is second, this should not cause problems,
i've had this in other setups before?)

No problems are reported while rebuilding the md1 SATA set, although i
think the disk-to-disk speed is rather slow with ~17MiB/sec measured by
/proc/mdstat's output while rebuilding.

| md: data-check of RAID array md1
| md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
| md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) 
| md: using 128k window, over a total of 244195904 blocks.
| md: md1: data-check done.
| RAID1 conf printout:
|  --- wd:2 rd:2
|  disk 0, wo:0, o:1, dev:sdb1
|  disk 1, wo:0, o:1, dev:sda1

When /using/ the disks in raid1 set, my dmesg did show signs of badness:

| ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
| ata2.00: (BMDMA2 stat 0xc0009)
| ata2.00: cmd c8/00:00:3f:43:47/00:00:00:00:00/e2 tag 0 cdb 0x0 data 131072 in
|          res 51/40:00:86:43:47/00:00:00:00:00/e2 Emask 0x9 (media error)
| ata2.00: configured for UDMA/100
| ata2: EH complete
| ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
| ata2.00: (BMDMA2 stat 0xc0009)
| ata2.00: cmd c8/00:00:3f:43:47/00:00:00:00:00/e2 tag 0 cdb 0x0 data 131072 in
|          res 51/40:00:86:43:47/00:00:00:00:00/e2 Emask 0x9 (media error)
| ata2.00: configured for UDMA/100
| ata2: EH complete
| ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
| ata2.00: (BMDMA2 stat 0xc0009)
| ata2.00: cmd c8/00:00:3f:43:47/00:00:00:00:00/e2 tag 0 cdb 0x0 data 131072 in
|          res 51/40:00:86:43:47/00:00:00:00:00/e2 Emask 0x9 (media error)
| ata2.00: configured for UDMA/100
| ata2: EH complete

But what amazes me is that no media errors can be detected by doing a
write/read check on every sector of the disk with mke2fs, and no data
corruption occurs when moving data to the set locally!

Can anyone shed some light on what i can try next to isolate what is
causing all this?  It's not the software raid code, the IDE set is
working fine.  It's not the SATA controller, the disks are okay when
used separately.  It's not the disks themselves, they show no errors
with extensive testing.

Weird 'eh?  Any comments appreciated!

Kind regards,
Sander.
-- 
| Just remember -- if the world didn't suck, we would all fall off.
| 1024D/08CEC94D - 34B3 3314 B146 E13C 70C8  9BDB D463 7E41 08CE C94D
