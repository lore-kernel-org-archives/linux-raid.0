From: "Dragon" <Sunghost@gmx.de>
Subject: (unknown)
Date: Fri, 10 Jun 2011 22:26:38 +0200
Message-ID: <20110610202638.220520@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"No, it must be "Used Device Size" * 11 = 16116523456.  Try it without the 'k'."
-> was better:
mdadm /dev/md0 --grow --array-size=16116523456
mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Fri Jun 10 14:19:24 2011
     Raid Level : raid5
     Array Size : 16116523456 (15369.91 GiB 16503.32 GB)
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
   Raid Devices : 13
  Total Devices : 13
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun 10 16:49:37 2011
          State : clean
 Active Devices : 13
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 8c4d8438:42aa49f9:a6d866f6:b6ea6b93 (local to host nassrv01)
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0       8      160        0      active sync   /dev/sdk
       1       8      208        1      active sync   /dev/sdn
       2       8      176        2      active sync   /dev/sdl
       3       8      192        3      active sync   /dev/sdm
       4       8        0        4      active sync   /dev/sda
       5       8       16        5      active sync   /dev/sdb
       6       8       64        6      active sync   /dev/sde
       7       8       48        7      active sync   /dev/sdd
       8       8       80        8      active sync   /dev/sdf
       9       8       96        9      active sync   /dev/sdg
      10       8      112       10      active sync   /dev/sdh
      11       8      128       11      active sync   /dev/sdi
      12       8      144       12      active sync   /dev/sdj

->fsck -n /dev/md0, was ok
->now:mdadm /dev/md0 --grow -n 12 --backup-file=/reshape.bak
->and after that, how become the disk out of the raid?
--

at this point i think i take the disk out of the raid, because i need the space of the disk.

I need another advise of you. While the computer is actualy build with 13 disk and i will become more data in the next month and the limit of power supply connecotors is reached i am looking forward to another solution. one possibility is to build up a better computer with more sata and sas connectors and add further raid-controller-cards. an other idea is to build a kind of cluster or dfs with two and later 3,4... computer. i read something about gluster.org. do you have a tip for me or experience in this?
-- 
NEU: FreePhone - kostenlos mobil telefonieren!			
Jetzt informieren: http://www.gmx.net/de/go/freephone


-- 
NEU: FreePhone - kostenlos mobil telefonieren!			
Jetzt informieren: http://www.gmx.net/de/go/freephone
