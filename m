From: Michael Frotscher <infomails@tronserver.dyndns.org>
Subject: mdadm reports one device too many
Date: Fri, 26 Mar 2004 07:53:57 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403260753.57580.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello, Linux-Raid

I have a RAID1-Array which consists of two equal partitions (hde4 and hdg4) on 
two drives. However, mdadm reports the array to consist of three devices, one 
of which is reported faulty:

/dev/md4:
        Version : 00.90.00
  Creation Time : Sun Feb 15 15:22:07 2004
     Raid Level : raid1
     Array Size : 188088896 (179.38 GiB 192.60 GB)
    Device Size : 188088896 (179.38 GiB 192.60 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Wed Mar 24 19:44:53 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0      33        4        0      active sync   /dev/hde4
       1      34        4        1      active sync   /dev/hdg4
           UUID : f3bf6c26:ec5523a9:b6a4f5ca:0f3713e6
         Events : 0.63

How can I delete this nonexistent device from the array?

Sincerely,
-- 
Michael
