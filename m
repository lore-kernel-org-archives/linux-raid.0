From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Very small internal bitmap after recreate
Date: Fri, 2 Nov 2007 10:01:47 +0100
Message-ID: <58CC73B2-35E8-412A-A7ED-8CACE786CE00@bj-ig.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 5 disk version 1.0 superblock RAID5 which had an internal  
bitmap that has been reported to have a size of 299 pages in /proc/ 
mdstat. For whatever reason I removed this bitmap (mdadm --grow -- 
bitmap=none) and recreated it afterwards (mdadm --grow -- 
bitmap=internal). Now it has a reported size of 10 pages.

Do I have a problem?

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : active raid5 sdd1[0] sdh1[5] sdf1[4] sdg1[3] sde1[1]
       1250273792 blocks super 1.0 level 5, 128k chunk, algorithm 2  
[5/5] [UUUUU]
       bitmap: 0/10 pages [0KB], 16384KB chunk

# mdadm -X /dev/sdg1
         Filename : /dev/sdg1
            Magic : 6d746962
          Version : 4
             UUID : e1a335a8:fc0f0626:d70687a6:5d9a9c19
           Events : 408088
   Events Cleared : 408088
            State : OK
        Chunksize : 16 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 312568448 (298.09 GiB 320.07 GB)
           Bitmap : 19078 bits (chunks), 0 dirty (0.0%)

# mdadm --version
mdadm - v2.6.2 - 21st May 2007

# uname -a
Linux DatenGrab 2.6.22.9-0.4-default #1 SMP 2007/10/05 21:32:04 UTC  
i686 i686 i386 GNU/Linux


Regards Ralf

