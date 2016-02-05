From: =?UTF-8?Q?Andr=c3=a9_Teichert?= <andre_teichert@gmx.de>
Subject: mdadm raid5 dropped 2 disks
Date: Fri, 5 Feb 2016 11:30:53 +0100
Message-ID: <56B479DD.7070600@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a raid5 (mdadm V. 3.2.5) with 3 disks. Within an hour 2 disks dropped.
Both disks show smart error 184, but I can still read them.

First I did a full dd-copy of each disk to imagefile image[123] and 
wrote it back to a large 4tb disk with 3 partitions.

mdadm -E /dev/sda1
/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 8bf0a3b8:a98e95fd:6a0884e6:fbe6ab09
            Name : server:0  (local to host server)
   Creation Time : Sun Nov 24 04:21:09 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 1953262961 (931.39 GiB 1000.07 GB)
      Array Size : 1953262592 (1862.78 GiB 2000.14 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 6f793025:415d8c8b:e7d37bbb:19524380

     Update Time : Wed Feb  3 10:16:27 2016
        Checksum : 74a4a730 - correct
          Events : 311

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : .AA ('A' == active, '.' == missing)


mdadm -E /dev/sda2
/dev/sda2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 8bf0a3b8:a98e95fd:6a0884e6:fbe6ab09
            Name : server:0  (local to host server)
   Creation Time : Sun Nov 24 04:21:09 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 1953262961 (931.39 GiB 1000.07 GB)
      Array Size : 1953262592 (1862.78 GiB 2000.14 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : fc963d80:307b6345:c95b6d94:162c7c7c

     Update Time : Wed Feb  3 10:16:40 2016
        Checksum : 5eaf449a - correct
          Events : 314

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : .A. ('A' == active, '.' == missing)


mdadm -E /dev/sda3
/dev/sda3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 8bf0a3b8:a98e95fd:6a0884e6:fbe6ab09
            Name : server:0  (local to host server)
   Creation Time : Sun Nov 24 04:21:09 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 1953262961 (931.39 GiB 1000.07 GB)
      Array Size : 1953262592 (1862.78 GiB 2000.14 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 73b1275f:8600a6b4:51234150:e035eef3

     Update Time : Wed Feb  3 09:37:09 2016
        Checksum : e024ac15 - correct
          Events : 217

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAA ('A' == active, '.' == missing)



Seems like sda3 dropped first and big difference in events so I started 
only sda1+sda2
mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sda2
Seemed to work and assembled the raid with 2/3 disks clean.

The filesystem is ext4.
Runnung "fsck -y /dev/md0" with lots of errors.

mount -t ext4 /dev/md0 /mnt didnt recognize the filesystem


Should I try --create --assmume-clean sda1 sda2 missing?
I try to stay calm and pray for help.
thx a lot
