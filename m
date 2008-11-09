From: "Stefan Heinrichsen" <gelbemauer@gmx.de>
Subject: Recovering RAID-5 from images
Date: Mon, 10 Nov 2008 00:10:23 +0100
Message-ID: <20081109231023.16840@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a RAID-5 with 3 devices. One disked failed and I added a new one. During sync a second disc failed. This second "Disc" is a RAID-0 consisting of to 120GB IDE Discs. I handled to dump an image of both disc with ddrescue. Only a few kilobytes of the broken disk could not been read (some where in the middle of the disc).
For my recovering experiments I made an Image of the remaining disc of the RAID-5 (/dev/loop3). No I tried to assemble the both RAIDs using loopbackdevice. The RAID-0 (/dev/md0) started without any problems. But the RAID-5 is not starting. It seems like both discs are marked as spare (see below).


========= (Image of the working device of the RAID-5)========
livecd ~ # mdadm --examine /dev/loop3
/dev/loop3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : b3081913:cee36385:187ba9cf:56150f19
  Creation Time : Mon May  7 08:37:48 2007
     Raid Level : raid5
  Used Dev Size : 237866112 (226.85 GiB 243.57 GB)
     Array Size : 475732224 (453.69 GiB 487.15 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 6

    Update Time : Sat Nov  1 02:26:45 2008
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 37352dcc - correct
         Events : 0.670720

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       9        0        3      spare   /dev/md0

==================================

===The RAID consisting of 2 IDE Device Images====
livecd ~ # mdadm --examine /dev/md0
/dev/md0:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : b3081913:cee36385:187ba9cf:56150f19
  Creation Time : Mon May  7 08:37:48 2007
     Raid Level : raid5
  Used Dev Size : 237866112 (226.85 GiB 243.57 GB)
     Array Size : 475732224 (453.69 GiB 487.15 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 6

    Update Time : Sat Nov  1 01:44:09 2008
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 3735239e - correct
         Events : 0.670714

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       9        1        2      active sync   /dev/md1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       9        1        2      active sync   /dev/md1
   3     3       9        0        3      spare   /dev/md0

================================

livecd ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : inactive loop3[0](S) md0[2](S)
      482062016 blocks

md0 : active raid0 loop2[0] loop1[1]
      237866176 blocks 64k chunks

unused devices: <none>

====================================

livecd ~ # mdadm --detail /dev/md1
mdadm: md device /dev/md1 does not appear to be active.

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
