From: Alexander Kisselev <kisselev@mail.desy.de>
Subject: MD device id change
Date: Thu, 3 Apr 2003 18:20:29 +0200 (MEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0304031754490.5184-100000@worf.desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
To: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  Hallo colleagues,

  I have few 4-disk boxes arranged in the following way:

  [root@data]: ~ > more /proc/mdstat
Personalities : [linear] [raid1]
read_ahead 1024 sectors
md1 : active linear sda2[0] 292021440 blocks 16k rounding
md2 : active linear sdb2[0] 292021440 blocks 16k rounding
md3 : active linear sdc2[0] 292021440 blocks 16k rounding
md0 : active raid1 sdd1[3] sdc1[2] sdb1[1] sda1[0] 1028032 blocks [4/4] [UUUU]
md4 : active linear sdd2[0] 292021440 blocks 16k rounding
unused devices: <none>

  as you see 'md0' is a small RAID1 across 1-st partitions of all 4
disks while md1..md4 are one-disk RAID linear volumes. Well, sda..sdd
are in turn 4-disk 3Ware hardware RAID5 volumes each, but I hope this does
not matter here.

  Now I want to shuffle volumes between machines and consequently
want to put let's say 'md1' from machine A and 'md1' from machine B
in one box C. This does not work (or at least it did not when I tried
it last time, perhaps with kernel 2.2.19), since RAID layer
recognizes only the first 'md1' device.

  Here is the question: is there an easy way to change RAID device ID?
If not, is the following sequence correct in my case (1-disk RAID linear):

  - stop device;
  - 'dd' 4k RAID superblock from /dev/sda2 at offset 292021440;
  - change 4-byte field at offset 11 (md_minor) to the desired number
    (say '5' for md5);
  - copy superblock back;
  - reboot;

  I remember I tried this trick once and it seemed to work, but am I
probably missing something here?

  Regards,
    Alexander.

