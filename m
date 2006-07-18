From: Shai <shaibn@gmail.com>
Subject: which disk the the one that data is on?
Date: Tue, 18 Jul 2006 10:53:07 +0300
Message-ID: <e3edb0fa0607180053x7a29bf71se8d30c591e7d10d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I rebooted my server today to find out that one of the arrays is being
re-synced (see output below)
.
1. What does the (S) to the right of hdh1[5](S) mean?
2. How do I know, from this output, which disk is the one holding the
most current data and from which all the other drives are syncing
from? Or are they all containing the data and this sync process is
something else? Maybe I'm just not understanding what is being done
exactly?

Thanks in advance for the help.

Shai
---

md0 : active raid5 hdd1[1] hdc1[0] hdh1[5](S) hdg1[4] hdf1[3] hde1[2]
      781433344 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
      [=>...................]  resync =  5.1% (9965184/195358336)
finish=180.5min speed=17110K/sec

-------------------
# mdadm -Q --detail /dev/md0
/dev/md0:
        Version : 00.90.02
  Creation Time : Mon Mar 20 20:40:24 2006
     Raid Level : raid5
     Array Size : 781433344 (745.23 GiB 800.19 GB)
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Jul 18 10:28:39 2006
          State : active, resyncing
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 8% complete

           UUID : 4bc2c7f7:b7ec1184:9c2c382d:2aaf7a98
         Events : 0.386738

    Number   Major   Minor   RaidDevice State
       0      22        1        0      active sync   /dev/.static/dev/hdc1
       1      22       65        1      active sync   /dev/.static/dev/hdd1
       2      33        1        2      active sync   /dev/.static/dev/hde1
       3      33       65        3      active sync   /dev/.static/dev/hdf1
       4      34        1        4      active sync   /dev/.static/dev/hdg1

       5      34       65        -      spare   /dev/.static/dev/hdh1
