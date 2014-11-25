From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Is it possible to grow a (far) RAID 10?
Date: Tue, 25 Nov 2014 10:25:02 +0100
Message-ID: <54744AEE.10908@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

after browsing various search results I'm not sure if a RAID0 (or a 
RAID10) can be grown at all, especially as
https://raid.wiki.kernel.org/index.php/Growing
only mentions levels 1/4/5/6 while the mdadm man-page suggests raid0 but 
not raid 10 - so consider me confused.

However, if at all possible, here is what I have/plan:

We have four 100GB SSDs partitioned only to use 50% of that, e.g.

parted -s /dev/sdc print
Model: ATA INTEL SSDSC2BA10 (scsi)
Disk /dev/sdc: 100GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system     Name     Flags
  1      2097kB  50.0GB  50.0GB                  primary  raid

These are assembled like this:

# mdadm -D /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Thu Oct  9 14:11:36 2014
      Raid Level : raid10
      Array Size : 97615616 (93.09 GiB 99.96 GB)
   Used Dev Size : 48807808 (46.55 GiB 49.98 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Tue Nov 25 10:18:33 2014
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : far=2
      Chunk Size : 64K

            Name : einstein-db1.atlas.local:0
            UUID : dcd28f40:a020f822:d87a5b91:31bedccf
          Events : 38

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        3       8       65        3      active sync   /dev/sde1

But life always tells you your initial thoughts are wrong, so we would 
like to expand this to use 75% of each SSD.

Without much thinking, I would simply follow the wiki page, mark a 
device as failed, remove it, repartition it, add it again, and wait for 
sync to complete. Repeat for all 4 devices and finally --grow with mdadm 
(followed by xfs resizing) - and of course, all online, while machine is 
in flight.

The question now is, will this really work with RAID10 or would one need 
to change it to RAID0 first, then perform this exercise and convert back 
to RAID10 afterwards (and possibly lose all data because I will 
inadvertently will make a serious typo somewhere ;)).

cheers

Carsten


-- 
Dr. Carsten Aulbert - Max Planck Institute for Gravitational Physics
Callinstrasse 38, 30167 Hannover, Germany
phone/fax: +49 511 762-17185 / -17193
https://wiki.atlas.aei.uni-hannover.de/foswiki/bin/view/ATLAS/WebHome
