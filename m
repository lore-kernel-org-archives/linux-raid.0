From: Peter Rabbitson <rabbit@rabbit.us>
Subject: LVM on raid10 - severe performance drop
Date: Sun, 10 Jun 2007 01:56:20 +0200
Message-ID: <466B3E24.1020203@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

This question might be better suited for the lvm mailing list, but 
raid10 being rather new, I decided to ask here first. Feel free to 
direct me elsewhere.

I want to use lvm on top of a raid10 array, as I need the snapshot 
capability for backup purposes. The tuning and creation of the array 
went fine, I am getting the read performance I am looking for. However 
as soon as I create a VG using the array as the only PV, the raw read 
performance drops to the ground. I suspect it has to do with some minima 
l tuning of LVM parameters, but I am at a loss on what to tweak (and 
Google is certainly evil to me today). Below I am including my 
configuration and test results, please let me know if you spot anything 
wrong, or have any suggestions.

Thank you!

Peter

========================

root@Arzamas:~# mdadm -D /dev/md1
/dev/md1:
         Version : 00.90.03
   Creation Time : Sat Jun  9 15:28:01 2007
      Raid Level : raid10
      Array Size : 317444096 (302.74 GiB 325.06 GB)
   Used Dev Size : 238083072 (227.05 GiB 243.80 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Sat Jun  9 19:33:29 2007
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : near=1, far=3
      Chunk Size : 1024K

            UUID : c16dbfd8:8a139e54:6e26228f:2ab99bd0 (local to host 
Arzamas)
          Events : 0.4

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2
        3       8       50        3      active sync   /dev/sdd2
root@Arzamas:~#


root@Arzamas:~# pvs -v
     Scanning for physical volume names
   PV         VG     Fmt  Attr PSize   PFree   DevSize PV UUID 

   /dev/md1   raid10 lvm2 a-   302.73G 300.73G 302.74G 
vS7gT1-WTeh-kXng-Iw7y-gzQc-1KSH-mQ1PQk
root@Arzamas:~#


root@Arzamas:~# vgs -v
     Finding all volume groups
     Finding volume group "raid10"
   VG     Attr   Ext   #PV #LV #SN VSize   VFree   VG UUID 

   raid10 wz--n- 4.00M   1   1   0 302.73G 300.73G 
ZosHXa-B1Iu-bax1-zMDk-FUbp-37Ff-k01aOK
root@Arzamas:~#


root@Arzamas:~# lvs -v
     Finding all logical volumes
   LV    VG     #Seg Attr   LSize Maj Min KMaj KMin Origin Snap%  Move 
Copy%  Log LV UUID
   space raid10    1 -wi-a- 2.00G  -1  -1 253  0 
           i0p99S-tWFz-ELpl-bGXt-4CWz-Elr4-a1ao8f
root@Arzamas:~#


root@Arzamas:~# dd if=/dev/md1 of=/dev/null bs=1M count=2000
2000+0 records in
2000+0 records out
2097152000 bytes (2.1 GB) copied, 11.4846 seconds, 183 MB/s
root@Arzamas:~#


root@Arzamas:~# dd if=/dev/md1 of=/dev/null bs=512 count=4000000
4000000+0 records in
4000000+0 records out
2048000000 bytes (2.0 GB) copied, 11.4032 seconds, 180 MB/s
root@Arzamas:~#


root@Arzamas:~# dd if=/dev/raid10/space of=/dev/null bs=1M count=2000
2000+0 records in
2000+0 records out
2097152000 bytes (2.1 GB) copied, 25.7089 seconds, 81.6 MB/s
root@Arzamas:~#


root@Arzamas:~# dd if=/dev/raid10/space of=/dev/null bs=512 count=4000000
4000000+0 records in
4000000+0 records out
2048000000 bytes (2.0 GB) copied, 26.1776 seconds, 78.2 MB/s
root@Arzamas:~#


P.S. I know that dd is not the best benchmarking tool, but the 
difference is so big, that even this non-scientific approach works.

