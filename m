From: maarten van den Berg <maarten@ultratux.net>
Subject: raid5 endless logging
Date: Mon, 11 Oct 2004 20:40:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410112040.55487.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Today I noticed my logs overflowing, since it is continuously printing this: 

Oct 11 18:11:35 dozer kernel: raid5: switching cache buffer size, 4096 --> 512
Oct 11 18:11:36 dozer kernel: raid5: switching cache buffer size, 512 --> 4096
Oct 11 18:11:36 dozer kernel: raid5: switching cache buffer size, 4096 --> 512
Oct 11 18:11:36 dozer kernel: raid5: switching cache buffer size, 512 --> 4096
Oct 11 18:11:36 dozer kernel: raid5: switching cache buffer size, 4096 --> 512
Oct 11 18:11:37 dozer kernel: raid5: switching cache buffer size, 512 --> 4096

However, my other raid5 system doesn't do this.  But that is not the exact 
same system, so that is not telling very much...

Is this an error, or some other misalignment ? Can I get it to stop ?

Info below-

System SuSE 9.0
# uname -a
Linux dozer 2.4.21-243-default #1 Thu Aug 12 15:22:14 UTC 2004 i686 athlon 
i386 GNU/Linux

# cat /proc/mdstat
Personalities : [raid1] [raid5]
read_ahead 1024 sectors
md1 : active raid5 hda3[2] hdc3[0] hde3[1] hdg3[3]
      233625024 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md0 : active raid1 hda1[2] hdc1[0] hde1[1]
      1953408 blocks [3/3] [UUU]

unused devices: <none>


# mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90.00
  Creation Time : Tue Sep  7 05:20:04 2004
     Raid Level : raid5
     Array Size : 233625024 (222.80 GiB 239.23 GB)
    Device Size : 77875008 (74.27 GiB 79.74 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Oct 11 18:08:01 2004
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      22        3        0      active sync   /dev/hdc3
       1      33        3        1      active sync   /dev/hde3
       2       3        3        2      active sync   /dev/hda3
       3      34        3        3      active sync   /dev/hdg3
           UUID : 4ca9411d:ed1db468:9c97b407:404788e5
         Events : 0.13

Note: I hate to say it, but mdadm is mistaken about those figures...  There 
are only 4 (four) devices in the system, not 5.  And there never was any 
failed drive.  Yes, /proc/mdstat does give the correct info.  

Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

