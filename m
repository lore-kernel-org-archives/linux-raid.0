From: Steve Fairbairn <steve@fairbairn-family.com>
Subject: Re: Superblock limits / conversion
Date: Thu, 13 Nov 2008 15:36:03 +0000
Message-ID: <491C4963.3040709@fairbairn-family.com>
References: <7d86ddb90811130646k440676aakecc62defc8d42b7a@mail.gmail.com> <20081113151206.GB25751@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.0811131019350.7992@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811131019350.7992@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids


Apologies to Justin for failing to reply to all the first time.

Justin Piszcz wrote:
> 
> I grew 400GiB drives in a raid5 configuration  from 1.8TiB to 3.3TiB one 
> at a time with the 0.90 superblock (I believe), is that limit correct?
> 
> It was awhile ago but FYI.
> 
> Justin.
> 

I have 8 500GB drives in a RAID 5...

[root@space ~]# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md3 : active raid5 sdh1[3] sdg1[2] sdf1[1] sde1[0] sdd1[7] sdc1[5] 
sdb1[4] sda1[6]
       3418687552 blocks level 5, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]
[root@space ~]# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90.03
   Creation Time : Wed Jan  9 18:57:53 2008
      Raid Level : raid5
      Array Size : 3418687552 (3260.31 GiB 3500.74 GB)
   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
    Raid Devices : 8
   Total Devices : 8
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Thu Nov 13 05:43:22 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 382c157a:405e0640:c30f9e9e:888a5e63
          Events : 0.1575598

     Number   Major   Minor   RaidDevice State
        0       8       65        0      active sync   /dev/sde1
        1       8       81        1      active sync   /dev/sdf1
        2       8       97        2      active sync   /dev/sdg1
        3       8      113        3      active sync   /dev/sdh1
        4       8       17        4      active sync   /dev/sdb1
        5       8       33        5      active sync   /dev/sdc1
        6       8        1        6      active sync   /dev/sda1
        7       8       49        7      active sync   /dev/sdd1
[root@space ~]# df -k /dev/md3
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md3             3365042864 2732709404 598146588  83% /Space
[root@space ~]#

Regards,

Steve.
