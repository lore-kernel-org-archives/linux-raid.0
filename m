From: Henrik Johnson <henrik.johnson@quest.com>
Subject: How do I start an array with an invalid bitmap file
Date: Thu, 11 Jun 2009 12:49:22 -0700
Message-ID: <6592BDAF72405343BA096C66B735B38E017D64335C@alvxmbw04.prod.quest.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Something went horribly wrong on one of my servers a little while ago (I think it ran out of memory somehow from looking at /var/log/messages). Anyway, I have an array of around 5tb in size and everything in the array seems fine except that the internal bitmap file is invalid. I get this in output on any of the drives when I try to inspect the bitmap:

---------
# mdadm -X /dev/sda1
mdadm: WARNING: bitmap file is not large enough for array size 5049649737776778669!

        Filename : /dev/sda1
           Magic : 4f1bc599
mdadm: invalid bitmap magic 0x4f1bc599, the bitmap file appears to be corrupted
         Version : 647686106
mdadm: unknown bitmap version 647686106, either the bitmap file is corrupted or you need to upgrade your tools
---------

Every disk seem to have the same magic and version and it seems that it is completely hosed (I assume you can probably see that too). When I try to start the array I get this in my kernel messages (I removed all the drives but the first and last):

---------
md: md0: raid array is not clean -- starting background reconstruction
raid6: device hdc1 operational as raid disk 0
...
raid6: device hda1 operational as raid disk 1
raid6: allocated 23983kB for md0
raid6: raid level 6 set md0 active with 23 out of 23 devices, algorithm 2
RAID6 conf printout:
 --- rd:23 wd:23 fd:0
 disk 0, o:1, dev:hdc1
...
 disk 22, o:1, dev:sdj1
md0: invalid bitmap file superblock: bad magic
md0: bitmap file superblock:
         magic: 4f1bc599
       version: 647686106
          uuid: 11cb9c4a.e16b426e.3633b4d4.ba9030e7
        events: 14688928058079908303
events cleared: 851610086378394782
         state: b6c8edbc
     chunksize: -1082087762 B
  daemon sleep: 976598253s
     sync size: 2524824868888389334 KB
max write behind: -107147461
md0: failed to create bitmap (-22)
md: pers->run() failed ...
---------

This is obviously not right. Here is my question though. Is there any way for me to start the array md to start the array and just ignore the bitmap. Or is there any way for me to remove the bitmap from the non running array?

All the drives seem to be there and valid (Here is what mdadm -E tells me for the same drive above and they all look the same and all seem ok):

---------
[root@cadiz ~]# mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 8de83e4a:3a655116:488819ae:6277fd62
  Creation Time : Tue May 31 15:25:58 2005
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 5128113984 (4890.55 GiB 5251.19 GB)
   Raid Devices : 23
  Total Devices : 23
Preferred Minor : 0

    Update Time : Thu Jun 11 14:27:36 2009
          State : active
 Active Devices : 23
Working Devices : 23
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b9a76499 - expected b9a76399
         Events : 0.30488482


      Number   Major   Minor   RaidDevice State
this     2       8        1        2      active sync   /dev/sda1

   0     0      22        1        0      active sync   /dev/hdc1
...
  22    22       8      145       22      active sync   /dev/sdj1
---------

I'm currently running a pretty old version of both the kernel (2.6.17-5mdv) and mdadm (v2.5.3) on this machine, but I am willing to upgrade if that will help.

I'm also pretty proficient and C so if I need to tweak the kernel sources to get this done I can handle it but I haven't looked much at the Linux kernel (Or the md subsystem) so pointers would be greatly appreciated.

/Regards
Henrik Johnson

