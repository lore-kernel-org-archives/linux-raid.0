From: rdc <denrdc@gmail.com>
Subject: Missing md superblock on added devices after grow ...
Date: Sat, 23 May 2009 17:03:03 +0200
Message-ID: <200905231703.03692.denrdc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yesterday i grew my 4*500GB raid5 array to 7*500GB. The reshape operation 
ended succesfully according to the logs : 

May 22 22:24:56 [kernel] md: md2: reshape done.
May 22 22:24:56 [kernel] RAID5 conf printout:
May 22 22:24:56 [kernel]  --- rd:7 wd:7
May 22 22:24:56 [kernel]  disk 0, o:1, dev:dm-3
May 22 22:24:56 [kernel]  disk 1, o:1, dev:dm-0
May 22 22:24:56 [kernel]  disk 2, o:1, dev:dm-2
May 22 22:24:56 [kernel]  disk 3, o:1, dev:dm-1
May 22 22:24:56 [kernel]  disk 4, o:1, dev:dm-8
May 22 22:24:56 [kernel]  disk 5, o:1, dev:dm-6
May 22 22:24:56 [kernel]  disk 6, o:1, dev:dm-5

However, upon restarting this morning the grown array was no longer detected, 
and my investigation revealed that the 3 device that were added do not contain 
an md superblock at all !

One of the 3 new devices :
mdadm --examine -v /dev/sdb1
mdadm: No md superblock detected on /dev/sdb1.

The 4 original devices do contain a superblock :
mdadm --examine -v /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 9ee9252c:7eeb7160:fd021026:b68a2612
           Name : md/md2
  Creation Time : Thu Jan  1 01:00:00 1970
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 976751872 (465.75 GiB 500.10 GB)
     Array Size : 5860511232 (2794.51 GiB 3000.58 GB)
   Super Offset : 976751920 sectors
          State : clean
    Device UUID : e2e95a27:c1d3d21d:2c7f1870:97156b44

    Update Time : Sat May 23 03:31:39 2009
       Checksum : 2b125ad9 - correct
         Events : 1790846

         Layout : left-symmetric
     Chunk Size : 32K

    Array Slot : 1 (failed, 1, failed, 3, 6, 2, 0, 5, 4)
   Array State : uUuuuuu 2 failed

Kernel version is 2.6.29-gentoo-r1, mdadm is v2.6.9
Any ideas how i could fix this, or even start the array to get my data off ?
