From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: mdadm bug - inconsistent output in -D mode
Date: Thu, 15 Jan 2009 12:50:23 +0100
Message-ID: <496F22FF.2080305@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I suppose this is a remnant of the effort to convert all sector counts
to bytes. Consider this output:

root@Thesaurus:~# mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 6b11b1ba:78985745:b320fc1a:1db68bcf
           Name : Thesaurus:Crypta  (local to host Thesaurus)
  Creation Time : Sat Mar  8 16:33:41 2008
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 578130828 (275.67 GiB 296.00 GB)   <--- Correct:
     Array Size : 1730162688 (825.01 GiB 885.84 GB)  <--- sectors(bytes)
  Used Dev Size : 576720896 (275.00 GiB 295.28 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : 85e0e62b:56129e5f:b0d82e78:2ace7d37

    Update Time : Thu Jan 15 12:42:53 2009
       Checksum : 61a32529 - correct
         Events : 764390

         Layout : left-symmetric
     Chunk Size : 2048K

    Array Slot : 5 (failed, failed, 2, 3, 0, 1)  <--- by the way: wtf?
   Array State : uUuu 2 failed                   <--- ditto


root@Thesaurus:~# mdadm -D /dev/md5
/dev/md5:
        Version : 01.01
  Creation Time : Sat Mar  8 16:33:41 2008
     Raid Level : raid5
     Array Size : 865081344 (825.01 GiB 885.84 GB) <--- bytes(bytes)
  Used Dev Size : 576720896 (550.00 GiB 590.56 GB) <--- sectors(2xbytes)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 5
    Persistence : Superblock is persistent

    Update Time : Thu Jan 15 12:42:29 2009
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 2048K

           Name : Thesaurus:Crypta  (local to host Thesaurus)
           UUID : 6b11b1ba:78985745:b320fc1a:1db68bcf
         Events : 764391

    Number   Major   Minor   RaidDevice State
       4       8       67        0      active sync   /dev/sde3
       5       8        1        1      active sync   /dev/sda1
       2       8       19        2      active sync   /dev/sdb3
       3       8       35        3      active sync   /dev/sdc3

root@Thesaurus:~# mdadm -V
mdadm - v2.6.7.1 - 15th October 2008
root@Thesaurus:~# uname -a
Linux Thesaurus 2.6.24.7.th1 #1 PREEMPT Sun May 11 20:18:05 CEST 2008
i686 GNU/Linux

P.S. I know my kernel is old, but I suspect it's a mdadm problem.
