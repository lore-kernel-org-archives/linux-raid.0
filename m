From: =?ISO-8859-1?Q?Jakub_Hus=E1k?= <jakub@gooseman.cz>
Subject: bug: 4-disk md raid10 far2 can be assembled clean with only two disks,
 causing "silent" data corruption
Date: Mon, 24 Sep 2012 10:46:38 +0200
Message-ID: <50601DEE.3030200@gooseman.cz>
References: <50601CED.1050607@gooseman.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50601CED.1050607@gooseman.cz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I have found a serious bug, that affects at least 4-disk md raid10 
with far2 layout. The kernel allows it to run with two failed drives 
silently without failing the whole array, despite it's not possible for 
it to work correctly because of chunks distribution with far2 layout.
The worst thing about it is that the write IO errors are invisible for 
the file system and running processes, the written data are just lost, 
only with IO errors reported in dmesg. Even force-reassembling ends up 
with clean,degraded array, with TWO disks, ignoring that I've tried to 
assemble it with all four devices. Recreating the array with 
--assume-clean is the only way to put it together.

System:

Ubuntu 12.04
Linux version 3.2.0-30-generic (buildd@batsu) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #48-Ubuntu SMP Fri Aug 24 16:52:48 UTC 2012
mdadm - v3.2.5 - 18th May 2012

and

Debian 6.0
Linux version 2.6.32-5-xen-amd64 (Debian 2.6.32-35) (dannf@debian.org) 
(gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Tue Jun 14 12:46:30 UTC 2011
mdadm - v3.1.4 - 31st August 2010

and

Centos 6.3


How to repeat:

dd if=/dev/zero of=d0 bs=1M count=100
dd if=/dev/zero of=d1 bs=1M count=100
dd if=/dev/zero of=d2 bs=1M count=100
dd if=/dev/zero of=d3 bs=1M count=100
losetup -f d0
losetup -f d1
losetup -f d2
losetup -f d3

mdadm -C /dev/md0 --level=10 --raid-devices=4 --layout=f2 /dev/loop[0-3]

dd if=/dev/zero of=/dev/md0 bs=512K count=10
10+0 records in
10+0 records out
5242880 bytes (5,2 MB) copied, 0,0409824 s, 128 MB/s

OK

mdadm /dev/md0 --fail /dev/loop0
mdadm /dev/md0 --fail /dev/loop3

mdadm -D /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Mon Sep 24 08:47:10 2012
      Raid Level : raid10
      Array Size : 202752 (198.03 MiB 207.62 MB)
   Used Dev Size : 101376 (99.02 MiB 103.81 MB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Mon Sep 24 08:48:55 2012
           State : clean, degraded                 <<< !!!!!!!!
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0

          Layout : far=2
      Chunk Size : 512K

            Name : koubas-desktop:0  (local to host koubas-desktop)
            UUID : 3ea4ded7:c10b1778:dc9f92aa:6e7cb196
          Events : 21

     Number   Major   Minor   RaidDevice State
        0       0        0        0 removed                   <<< !!!!!!!!
        1       7        1        1      active sync   /dev/loop1
        2       7        2        2      active sync   /dev/loop2
        3       0        0        3 removed                   <<< !!!!!!!!

        0       7        0        -      faulty spare /dev/loop0
        3       7        3        -      faulty spare /dev/loop3

dd if=/dev/zero of=/dev/md0 bs=512K count=10
10+0 records in
10+0 records out
5242880 bytes (5,2 MB) copied, 0,0245752 s, 213 MB/s
echo $?
0    <<< !!!!!!!

dmesg:
[883011.442366] md/raid10:md0: Disk failure on loop0, disabling device.
[883011.442367] md/raid10:md0: Operation continuing on 3 devices.
[883011.473292] RAID10 conf printout:
[883011.473296]  --- wd:3 rd:4
[883011.473299]  disk 0, wo:1, o:0, dev:loop0
[883011.473301]  disk 1, wo:0, o:1, dev:loop1
[883011.473302]  disk 2, wo:0, o:1, dev:loop2
[883011.473304]  disk 3, wo:0, o:1, dev:loop3
[883011.492046] RAID10 conf printout:
[883011.492051]  --- wd:3 rd:4
[883011.492054]  disk 1, wo:0, o:1, dev:loop1
[883011.492056]  disk 2, wo:0, o:1, dev:loop2
[883011.492058]  disk 3, wo:0, o:1, dev:loop3
[883015.875089] md/raid10:md0: Disk failure on loop3, disabling device.
[883015.875090] md/raid10:md0: Operation continuing on 2 devices.  <<< !!!!!
[883015.886686] RAID10 conf printout:
[883015.886692]  --- wd:2 rd:4
[883015.886695]  disk 1, wo:0, o:1, dev:loop1
[883015.886697]  disk 2, wo:0, o:1, dev:loop2
[883015.886699]  disk 3, wo:1, o:0, dev:loop3
[883015.900018] RAID10 conf printout:
[883015.900023]  --- wd:2 rd:4
[883015.900025]  disk 1, wo:0, o:1, dev:loop1
[883015.900027]  disk 2, wo:0, o:1, dev:loop2
************* "successful" dd follows: *******************
[883015.903622] quiet_error: 6 callbacks suppressed
[883015.903624] Buffer I/O error on device md0, logical block 50672
[883015.903628] Buffer I/O error on device md0, logical block 50672
[883015.903635] Buffer I/O error on device md0, logical block 50686
[883015.903638] Buffer I/O error on device md0, logical block 50686
[883015.903669] Buffer I/O error on device md0, logical block 50687
[883015.903672] Buffer I/O error on device md0, logical block 50687
[883015.903706] Buffer I/O error on device md0, logical block 50687
[883015.903710] Buffer I/O error on device md0, logical block 50687
[883015.903714] Buffer I/O error on device md0, logical block 50687
[883015.903717] Buffer I/O error on device md0, logical block 50687
[883052.136435] quiet_error: 6 callbacks suppressed
[883052.136439] Buffer I/O error on device md0, logical block 384
[883052.136442] lost page write due to I/O error on md0
[883052.136448] Buffer I/O error on device md0, logical block 385
[883052.136450] lost page write due to I/O error on md0
[883052.136454] Buffer I/O error on device md0, logical block 386
[883052.136456] lost page write due to I/O error on md0
[883052.136460] Buffer I/O error on device md0, logical block 387
[883052.136462] lost page write due to I/O error on md0
[883052.136466] Buffer I/O error on device md0, logical block 388
[883052.136468] lost page write due to I/O error on md0
[883052.136472] Buffer I/O error on device md0, logical block 389
[883052.136474] lost page write due to I/O error on md0
[883052.136478] Buffer I/O error on device md0, logical block 390
[883052.136480] lost page write due to I/O error on md0
[883052.136484] Buffer I/O error on device md0, logical block 391
[883052.136486] lost page write due to I/O error on md0
[883052.136492] Buffer I/O error on device md0, logical block 392
[883052.136494] lost page write due to I/O error on md0
[883052.136498] Buffer I/O error on device md0, logical block 393
[883052.136500] lost page write due to I/O error on md0



