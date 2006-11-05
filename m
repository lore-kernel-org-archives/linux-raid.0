From: "Robert Hulme" <rob@robhulme.com>
Subject: Is my RAID broken?
Date: Sun, 5 Nov 2006 07:29:22 +0000
Message-ID: <e50d039c0611042329m29046e6fjf56a8f52a82294ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

I recently got an email warning from Zabbix about my raid array, so I
went to have a look at it:

----------
Personalities : [linear] [raid0] [raid1] [raid10] [raid5] [raid4]
md2 : active raid5 hdk1[3] hdi1[2] hdg1[1] hde1[0]
      1172126208 blocks level 5, 32k chunk, algorithm 2 [4/4] [UUUU]
      [===============>.....]  resync = 77.6% (303281336/390708736)
finish=102.7min speed=14181K/sec

md1 : active raid5 sdd3[2] sdc3[3] sdb3[1] sda3[0]
      184490112 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

md0 : active raid1 sdb1[1] sda1[0]
      9767424 blocks [2/2] [UU]

unused devices: <none>
----------

Then I got detail on md2:

----------
weebl:/var/log# mdadm --detail /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Sun May 14 09:43:37 2006
     Raid Level : raid5
     Array Size : 1172126208 (1117.83 GiB 1200.26 GB)
    Device Size : 390708736 (372.61 GiB 400.09 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sun Nov  5 07:13:01 2006
          State : clean, resyncing
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 32K

 Rebuild Status : 77% complete

           UUID : 41af16c5:36143507:8dcabe0b:f372280d
         Events : 0.12485388

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      34        1        1      active sync   /dev/hdg1
       2      56        1        2      active sync   /dev/hdi1
       3      57        1        3      active sync   /dev/hdk1
----------

I thought it would be good to check /var/log/messages:

----------
Nov  5 01:06:01 xen-dom0 kernel: md: syncing RAID array md0
Nov  5 01:06:01 xen-dom0 kernel: md: minimum _guaranteed_
reconstruction speed: 1000 KB/sec/disc.
Nov  5 01:06:01 xen-dom0 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Nov  5 01:06:01 xen-dom0 kernel: md: using 128k window, over a total
of 9767424 blocks.
Nov  5 01:06:01 xen-dom0 kernel: md: delaying resync of md1 until md0
has finished resync (they share one or more physical units)
Nov  5 01:06:01 xen-dom0 kernel: md: syncing RAID array md2
Nov  5 01:06:01 xen-dom0 kernel: md: minimum _guaranteed_
reconstruction speed: 1000 KB/sec/disc.
Nov  5 01:06:01 xen-dom0 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Nov  5 01:06:01 xen-dom0 kernel: md: using 128k window, over a total
of 390708736 blocks.

Nov  5 01:12:37 xen-dom0 kernel: md: md0: sync done.
Nov  5 01:12:37 xen-dom0 kernel: md: syncing RAID array md1
Nov  5 01:12:37 xen-dom0 kernel: RAID1 conf printout:
Nov  5 01:12:37 xen-dom0 kernel:  --- wd:2 rd:2
Nov  5 01:12:37 xen-dom0 kernel:  disk 0, wo:0, o:1, dev:sda1
Nov  5 01:12:37 xen-dom0 kernel:  disk 1, wo:0, o:1, dev:sdb1
Nov  5 01:12:37 xen-dom0 kernel: md: minimum _guaranteed_
reconstruction speed: 1000 KB/sec/disc.
Nov  5 01:12:37 xen-dom0 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Nov  5 01:12:37 xen-dom0 kernel: md: using 128k window, over a total
of 61496704 blocks.

Nov  5 02:21:14 xen-dom0 kernel: RAID5 conf printout:
Nov  5 02:21:14 xen-dom0 kernel:  --- rd:4 wd:4 fd:0
Nov  5 02:21:14 xen-dom0 kernel:  disk 0, o:1, dev:sda3
Nov  5 02:21:14 xen-dom0 kernel:  disk 1, o:1, dev:sdb3
Nov  5 02:21:14 xen-dom0 kernel:  disk 2, o:1, dev:sdd3
Nov  5 02:21:14 xen-dom0 kernel:  disk 3, o:1, dev:sdc3
----------

This system has been running for a year now without problems so it is
really disappointing to think there is a problem :'(

Why might this happen? Is it serious? What should I do to resolve the situation?

If its resyncing that means it detected an error, right?


Thank you for your help
-Rob

-- 
------------------------------------------------------
"By all means let's be open-minded, but not so open-minded that our
brains drop out." - Richard Dawkins

"It is far better to grasp the universe as it really is than to
persist in delusion, however satisfying and reassuring." - Carl Sagan

http://www.robhulme.com/
http://robhu.livejournal.com/
