From: "Chris Mason" <lists@masonc.com>
Subject: Problem with missing drive
Date: Tue, 7 Sep 2004 20:50:56 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003301c4953d$e6af7a60$0600a8c0@poseiden>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID5 array with 5 160 GB WD drives, 3 data, 1 parity, 1 spare. 

RAID 
Personalities : [raid5] 
read_ahead 1024 sectors
md0 : active raid5 hde1[0] hdg1[1] hdi1[2] hdk1[3] hdl1[5]
      468864768 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]


Mdadm reports a missing drive which does not exist but I suspect is recorded
on the superblocks of one or more of the drives. I'd like some advice on
clearing this up and getting rid of the "dirty" flag.

[root@munster root]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Sat Sep  4 07:01:50 2004
     Raid Level : raid5
     Array Size : 468864768 (447.14 GiB 480.16 GB)
    Device Size : 156288256 (149.05 GiB 160.08 GB)
   Raid Devices : 4
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Sep  5 05:05:22 2004
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      34        1        1      active sync   /dev/hdg1
       2      56        1        2      active sync   /dev/hdi1
       3      57        1        3      active sync   /dev/hdk1
       5      57       65        5        /dev/hdl1
           UUID : 8cb5dd66:4d5944e4:4c8eacb8:9f4cae58


[root@munster root]# cat /etc/mdadm.conf
DEVICE /dev/hde1 /dev/hdg1 /dev/hdi1 /dev/hdk1 /dev/hdl1
ARRAY   /dev/md0 level=raid5 num-devices=5
UUID=8cb5dd66:4d5944e4:4c8eacb8:9f4cae58







Chris Mason
masonc@masonc.com
Box 340, The Valley, Anguilla, British West Indies
Tel. (264) 497-5670 - Cell: (264) 235-5670 - Also (305)-735-3483   
Fax: (264) 497-8463 - US Fax (815)301-9759
Yahoo IM: netconcepts_anguilla@yahoo.com

