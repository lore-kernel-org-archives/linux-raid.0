From: Simon Frettloeh <sifr@aifb.uni-karlsruhe.de>
Subject: What does "State : dirty" mean?
Date: Tue, 31 Aug 2004 16:50:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41349022.6000708@aifb.uni-karlsruhe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

We had several RAID-Problems in last time and now are trying to monitor 
those raids better in future. But we're wondering about the output of 
"mdadm --detail" (see below).
What does the state "dirty" mean? What other states are possible? I've 
tried to search the net for an answer but wasn't able to find something 
about it.

==snip==
[root@XXX root]# mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.00
   Creation Time : Thu Dec 13 15:36:07 2001
      Raid Level : raid0
      Array Size : 20480000 (19.53 GiB 20.102 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Aug 24 13:57:41 2004
           State : dirty, no-errors
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 128K

     Number   Major   Minor   RaidDevice State
        0       3        1        0      active sync   /dev/hda1
        1       3       65        1      active sync   /dev/hdb1
        2      22        1        2      active sync   /dev/hdc1
        3      22       65        3      active sync   /dev/hdd1
            UUID : d02faae1:77fbad31:a47bb162:75f1003a
==snap==

Best regards,
Simon Frettloeh

-- 
Simon Frettloeh
Institute AIFB
(Applied Computer Science and Formal Description Methods)
University of Karlsruhe
Engler Str. 11 - 76128 Karlsruhe - Germany

