From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 4 Jan 2018 13:39:24 +0000
Message-ID: <cd34964a-e269-6dd7-3c36-73a9c8dbb61d@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <CACsGCyS9-K4ZJPKauRZkGFRPd0cvShYLViE87i47=RCY1UkbnQ@mail.gmail.com>
 <fcb32200-19f7-5513-24a0-70ca15ca6297@shenkin.org>
 <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
 <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
 <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
 <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
 <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org>
 <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com>
 <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org>
 <61e91b55-5b96-143e-15c8-4a320f89eeb2@turmel.org>
 <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org>
 <6572ed42-8559-84eb-0468-7823786c3001@turmel.org>
 <7bce6228-0695-ff30-7cc0-60486be128ff@shenkin.org>
 <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org>
 <97c75be5-1988-0e66-0d50-f06188418b3b@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <97c75be5-1988-0e66-0d50-f06188418b3b@fnarfbargle.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/4/2018 1:16 PM, Brad Campbell wrote:>
> Damn. I saw your initial mail, but I was out and nowhere near a device I 
> could use to reply sensibly.
> You should *really* check by looking at the mdadm --examine output and 
> calculating the position of the sectors in question to be absolutely 
> sure the area you just wrote over was not in the active array area. If 
> it was then you should stop the checkarray *now* and come back for advice.

Thanks Brad, no worries, really appreciate your attention.  I stopped 
checkarray.  It had one rebuild event (Rebuild99) in /dev/md0 (small 
RAID1, where /boot is mounted) before I stopped it.  Here's the examine 
output (not really sure what to do with it, will wait for advice):

user@machinename:~$ sudo mdadm --examine /dev/sd*
/dev/sda:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
            Name : arrayname:0
   Creation Time : Mon Dec  7 08:31:31 2015
      Raid Level : raid1
    Raid Devices : 4

  Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
      Array Size : 1950656 (1905.26 MiB 1997.47 MB)
   Used Dev Size : 3901312 (1905.26 MiB 1997.47 MB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 9cb1890b:ad675b3b:7517467f:0780ec8e

     Update Time : Thu Jan  4 12:00:45 2018
        Checksum : 682930c3 - correct
          Events : 215


    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sda2.
/dev/sda3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : c7303f62:d848d424:269581c8:83a045ec
            Name : ubuntu:2
   Creation Time : Sun Feb  5 23:39:58 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 5840377856 (2784.91 GiB 2990.27 GB)
      Array Size : 8760566784 (8354.73 GiB 8970.82 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 64c8db38:3d0a6895:be2259d8:4c3c3542

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Jan  4 13:34:53 2018
        Checksum : d9775efa - correct
          Events : 81186

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sda4.
/dev/sdb:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
            Name : arrayname:0
   Creation Time : Mon Dec  7 08:31:31 2015
      Raid Level : raid1
    Raid Devices : 4

  Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
      Array Size : 1950656 (1905.26 MiB 1997.47 MB)
   Used Dev Size : 3901312 (1905.26 MiB 1997.47 MB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 38999554:d1b0db8d:d8066e72:86865c31

     Update Time : Thu Jan  4 12:00:45 2018
        Checksum : 995557b1 - correct
          Events : 215


    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdb2.
/dev/sdb3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : c7303f62:d848d424:269581c8:83a045ec
            Name : ubuntu:2
   Creation Time : Sun Feb  5 23:39:58 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 5840377856 (2784.91 GiB 2990.27 GB)
      Array Size : 8760566784 (8354.73 GiB 8970.82 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : cf70dad5:0c9ff5f6:ede689f2:ccee2eb0

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Jan  4 13:34:53 2018
        Checksum : 602e12e9 - correct
          Events : 81186

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdb4.
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
            Name : arrayname:0
   Creation Time : Mon Dec  7 08:31:31 2015
      Raid Level : raid1
    Raid Devices : 4

  Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
      Array Size : 1950656 (1905.26 MiB 1997.47 MB)
   Used Dev Size : 3901312 (1905.26 MiB 1997.47 MB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : f162eae5:19f8926b:f5bb6a2a:8adbbefd

     Update Time : Thu Jan  4 12:00:45 2018
        Checksum : 8cb8728a - correct
          Events : 215


    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdc2.
/dev/sdc3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : c7303f62:d848d424:269581c8:83a045ec
            Name : ubuntu:2
   Creation Time : Sun Feb  5 23:39:58 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 5840377856 (2784.91 GiB 2990.27 GB)
      Array Size : 8760566784 (8354.73 GiB 8970.82 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : f8839952:eaba2e9c:c2c401d4:3e0592a5

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Jan  4 13:34:53 2018
        Checksum : 59013634 - correct
          Events : 81186

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdc4.
/dev/sdd:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
            Name : arrayname:0
   Creation Time : Mon Dec  7 08:31:31 2015
      Raid Level : raid1
    Raid Devices : 4

  Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
      Array Size : 1950656 (1905.26 MiB 1997.47 MB)
   Used Dev Size : 3901312 (1905.26 MiB 1997.47 MB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 4823f0b8:8e0d3ac3:e312c219:29f76622

     Update Time : Thu Jan  4 12:00:45 2018
        Checksum : cb64bae5 - correct
          Events : 215


    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdd2.
/dev/sdd3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : c7303f62:d848d424:269581c8:83a045ec
            Name : ubuntu:2
   Creation Time : Sun Feb  5 23:39:58 2017
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 5840377856 (2784.91 GiB 2990.27 GB)
      Array Size : 8760566784 (8354.73 GiB 8970.82 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 875a0dbd:965a9986:1b78eb3d:e15fee50

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Jan  4 13:34:53 2018
        Checksum : c325ba6d - correct
          Events : 81186

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdd4.




Here's mdadm --detail if needed:

user@machinename:~$ sudo mdadm --detail /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Sun Feb  5 23:39:58 2017
      Raid Level : raid5
      Array Size : 8760566784 (8354.73 GiB 8970.82 GB)
   Used Dev Size : 2920188928 (2784.91 GiB 2990.27 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Thu Jan  4 13:31:21 2018
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : ubuntu:2
            UUID : c7303f62:d848d424:269581c8:83a045ec
          Events : 81186

     Number   Major   Minor   RaidDevice State
        0       8        3        0      active sync   /dev/sda3
        4       8       19        1      active sync   /dev/sdb3
        2       8       35        2      active sync   /dev/sdc3
        5       8       51        3      active sync   /dev/sdd3

user@machinename:~$ sudo mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Mon Dec  7 08:31:31 2015
      Raid Level : raid1
      Array Size : 1950656 (1905.26 MiB 1997.47 MB)
   Used Dev Size : 1950656 (1905.26 MiB 1997.47 MB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Thu Jan  4 12:00:45 2018
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

            Name : arrayname:0
            UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
          Events : 215

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        5       8       49        1      active sync   /dev/sdd1
        4       8       17        2      active sync   /dev/sdb1
        2       8       33        3      active sync   /dev/sdc1
