From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: total devices 1 too many
Date: Thu, 16 Jan 2003 00:01:24 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.51.0301152357520.8266@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i created this array with mdadm ... with 7 devices.  then later i added a
spare disk.  it's always listed one too many in the Total Devices field,
and lists a failed drive... any idea what's up?

thanks
-dean

# mdadm --version
mdadm - v1.0.1 - 20 May 2002
# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Sat Jan  4 23:37:22 2003
     Raid Level : raid5
     Array Size : 720321792 (686.95 GiB 737.65 GB)
    Device Size : 120053632 (114.49 GiB 122.98 GB)
   Raid Devices : 7
  Total Devices : 9
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jan 15 23:42:41 2003
          State : dirty, no-errors
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       97        5      active sync   /dev/sdg1
       6       8      113        6      active sync   /dev/sdh1
       7       8       81        7        /dev/sdf1
           UUID : 2fc2f969:e12b7ceb:055fbb9c:4c2ac618
