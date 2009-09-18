From: John Hughes <john@Calva.COM>
Subject: Dumb questions about mdadm #1 - replacing broken disks - "slot" reuse?
Date: Fri, 18 Sep 2009 14:13:44 +0200
Message-ID: <4AB37978.5030403@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mdadm version 2.6.7.2-3 on Debian Lenny, kernel  2.6.26-2-xen-amd64

I'm new to mdadm, all my experience with software raid/volume management 
type systems has been with Vertas VxVM on UnixWare.

I'm replacing an existing UnixWare system by Linux and I'm trying to get 
a feel for how to perform some simple operations.

As I understand it to replace a failed disk (assuming no hot spares for 
the moment) I just do:

    mdadm --manage /dev/md0 --remove /dev/failed-disk
    mdadm --manage /dev/md0 --add /dev/new-disk

This works, but when I look at the results it looks rather ugly, the new 
disk goes in a new "slot" in the raid superblock.  Is it the case that 
every time I replace a disk I'm going to get a new slot?  Doesn't that 
make the raid "superblock" grow without limit?

Before:

# cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 sdw[11] sdg[10] sdv[9] sdf[8] sdu[7] sde[6] sdt[5] sdd[4] sds[3] sdc[2] sdr[1] sdb[0]
      426970368 blocks super 1.2 64K chunks 2 near-copies [12/12] [UUUUUUUUUUUU]
      bitmap: 1/204 pages [4KB], 1024KB chunk

unused devices: <none>

# mdadm --examine /dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 9477b121:204de4c4:a96d58e9:85746699
           Name : caronia:testarray2  (local to host caronia)
  Creation Time : Fri Sep 18 12:59:24 2009
     Raid Level : raid10
   Raid Devices : 12

 Avail Dev Size : 142323568 (67.87 GiB 72.87 GB)
     Array Size : 853940736 (407.19 GiB 437.22 GB)
  Used Dev Size : 142323456 (67.87 GiB 72.87 GB)
    Data Offset : 144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 64949ade:b6d618a8:f45a3b07:29ddc35e

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 18 13:38:41 2009
       Checksum : 256ea9d4 - correct
         Events : 4

         Layout : near=2, far=1
     Chunk Size : 64K

    Array Slot : 0 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
   Array State : Uuuuuuuuuuuu


After:

# mdadm --manage /dev/md0 --fail /dev/sdc
mdadm: set /dev/sdc faulty in /dev/md0
# mdadm --manage /dev/md0 --remove /dev/sdc
mdadm: hot removed /dev/sdc
# mdadm --manage /dev/md0 --add /dev/sdh
mdadm: added /dev/sdh

[...]
# cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 sdh[12] sdw[11] sdg[10] sdv[9] sdf[8] sdu[7] sde[6] sdt[5] sdd[4] sds[3] sdr[1] sdb[0]
      426970368 blocks super 1.2 64K chunks 2 near-copies [12/12] [UUUUUUUUUUUU]
      bitmap: 0/204 pages [0KB], 1024KB chunk

unused devices: <none>

Eeew, /dev/sdh is in slot 12, where is slot 2?

And:

# mdadm --examine /dev/sdh
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 9477b121:204de4c4:a96d58e9:85746699
           Name : caronia:testarray2  (local to host caronia)
  Creation Time : Fri Sep 18 12:59:24 2009
     Raid Level : raid10
   Raid Devices : 12

 Avail Dev Size : 142323568 (67.87 GiB 72.87 GB)
     Array Size : 853940736 (407.19 GiB 437.22 GB)
  Used Dev Size : 142323456 (67.87 GiB 72.87 GB)
    Data Offset : 144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 31c4a4f5:7aef046d:8981c552:b63165c2

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 18 13:56:55 2009
       Checksum : b09071e2 - correct
         Events : 14

         Layout : near=2, far=1
     Chunk Size : 64K

    Array Slot : 12 (0, 1, failed, 3, 4, 5, 6, 7, 8, 9, 10, 11, 2)
   Array State : uuUuuuuuuuuu 1 failed


Is it the case that every time I replace a disk I'm going to get a new 
slot?  Doesn't that make the raid "superblock" grow without limit?


 

 



