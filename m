From: "=?KOI8-R?B?7cHSyyDrz9LFzsLF0sc=?=" <socketpair@gmail.com>
Subject: mdadm raid10 performance
Date: Mon, 2 Jun 2008 02:47:53 +0600
Message-ID: <b8f627e0806011347x49630976gf9bcf57d7356489b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello. I have a simple question.

I just created mdadm raid10 with four disks. The raid  build process
complete successfully.
All of 4 HDD are connected with separate SATA wires directly to motherboard.
The mode of operation (selected in bios) neither AHCI nor RAID.

I decide to acheive performance information of software RAID.
So I read 10 blocks by 64Mb. This give me roughly performance of one disk.
(I expect that it will be 4x speed ! it should read from 4 hdd
simultaneously!!!, BUT NOT! )

So, second test were reading 10 blocks (from 0 to 9) in one process,
and 10 blocks (from 10 to 19) in second thread.
I acheive performance of half disk... in each thread.

WTF? maybe raid is configured incorrectly ? Or my tests are invalid ?

=========================================
hoster:/etc/network# mdadm --misc --detail /dev/md_d127
/dev/md_d127:
        Version : 00.90.03
  Creation Time : Sat Jun  2 21:57:07 2007
     Raid Level : raid10
     Array Size : 321672832 (306.77 GiB 329.39 GB)
    Device Size : 160836416 (153.39 GiB 164.70 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Mon Jun  2 02:16:42 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2, far=1
     Chunk Size : 64K

           UUID : 77f3a162:77989072:b81e87f5:476e32bb
         Events : 0.30

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       32        1      active sync   /dev/sdc
       2       8       16        2      active sync   /dev/sdb
       3       8       48        3      active sync   /dev/sdd

=========================================
hoster:~# export LANG=C; dd if=/dev/sda of=/dev/null bs=64M count=10
671088640 bytes (671 MB) copied, 11.7029 seconds, 57.3 MB/s
=========================================
hoster:~# export LANG=C; for i in sda sdb sdc sdd; do dd if=/dev/$i
of=/dev/null bs=64M count=10 & done
671088640 bytes (671 MB) copied, 13.2656 seconds, 50.6 MB/s
671088640 bytes (671 MB) copied, 13.3142 seconds, 50.4 MB/s
671088640 bytes (671 MB) copied, 14.1144 seconds, 47.5 MB/s
671088640 bytes (671 MB) copied, 14.1733 seconds, 47.3 MB/s
=========================================
hoster:~#  export LANG=C; dd if=/dev/md_d127 of=/dev/null bs=64M count=10
671088640 bytes (671 MB) copied, 9.55816 seconds, 70.2 MB/s
=========================================
hoster:~# for i in 0 10; do time dd skip=$i if=/dev/md_d127
of=/dev/null bs=64M count=10& done
671088640 bytes (671 MB) copied, 24.0492 seconds, 27.9 MB/s
671088640 bytes (671 MB) copied, 24.821 seconds, 27.0 MB/s
=========================================
hoster:~# for i in 1 2; do time dd if=/dev/md_d127 of=/dev/null bs=64M
count=10& done
671088640 bytes (671 MB) copied, 19.4049 seconds, 34.6 MB/s
671088640 bytes (671 MB) copied, 19.4407 seconds, 34.5 MB/s
=========================================
hoster:~# uname -a
Linux hoster 2.6.18-4-686 #1 SMP Wed May 9 23:03:12 UTC 2007 i686 GNU/Linux

hoster:~# cat /proc/cpuinfo
processor       : 0
model name      : Intel(R) Xeon(TM) CPU 2.66GHz
cpu MHz         : 2660.173
cache size      : 2048 KB
(and so on for processors 1-7)
(total 8 processors)
==================================

Any ideas ?

-- 
Segmentation fault
