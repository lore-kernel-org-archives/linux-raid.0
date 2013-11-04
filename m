From: Arnold Schulz <arnysch@gmx.net>
Subject: "Found some drive for an array that is already active"
Date: Tue, 05 Nov 2013 00:43:24 +0100
Message-ID: <5278311C.7000805@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

for some strange reason I dont't succeed any longer in starting my raid5.

See log below at line
    mdadm -Af /dev/md2  /dev/md1 /dev/sdc4 /dev/sdd4

BTW, there is no /etc/mdadm.conf.
Kernels tried are 3.11.6 an 3.12.0
mdadm version is "v3.3 - 3rd September 2013".

Does anyone see what I am missing?

Cheers,
Arnold

-------------------------------------------------
router:~#
router:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md1 : active raid0 sda2[0] sdb2[1]
       1924217344 blocks 64k chunks

md3 : active raid1 sdc2[1] sdb1[0]
       14651136 blocks [2/2] [UU]
       bitmap: 0/224 pages [0KB], 32KB chunk

md0 : active raid1 sdc1[1] sda1[0]
       14651136 blocks [2/2] [UU]
       bitmap: 1/224 pages [4KB], 32KB chunk

unused devices: <none>
router:~#
router:~#
router:~#
router:~# ls -l /dev/md
insgesamt 0
lrwxrwxrwx 1 root root 6 Nov  4 22:56 0_1 -> ../md0
lrwxrwxrwx 1 root root 6 Nov  4 22:56 3 -> ../md3
router:~#
router:~#
router:~#
router:~# mdadm -S /dev/md2
mdadm: error opening /dev/md2: No such file or directory
router:~#
router:~# mdadm -S md2
mdadm: stopped md2
router:~#
router:~# mdadm -S md2
mdadm: stopped md2
router:~#
router:~#
router:~#
router:~# mdadm -Af /dev/md2  /dev/md1 /dev/sdc4 /dev/sdd4
mdadm: Found some drive for an array that is already active: /dev/md/router:2
mdadm: giving up.
router:~#
router:~#
router:~#
router:~# mdadm -E /dev/md1
/dev/md1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : b618baac:270afcb4:cd3f90e9:96f89319
            Name : router:2  (local to host router)
   Creation Time : Tue Jan  1 09:42:46 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3848172544 (1834.95 GiB 1970.26 GB)
      Array Size : 3848156416 (3669.89 GiB 3940.51 GB)
   Used Dev Size : 3848156416 (1834.94 GiB 1970.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=16128 sectors
           State : clean
     Device UUID : c33e7694:c7432219:4529ef82:59a59abc

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov  4 21:34:51 2013
        Checksum : fb4bcd5 - correct
          Events : 36544

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 0
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
router:~#
router:~#
router:~#
router:~# mdadm -E /dev/sdc4
/dev/sdc4:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : b618baac:270afcb4:cd3f90e9:96f89319
            Name : router:2  (local to host router)
   Creation Time : Tue Jan  1 09:42:46 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3848156801 (1834.94 GiB 1970.26 GB)
      Array Size : 3848156416 (3669.89 GiB 3940.51 GB)
   Used Dev Size : 3848156416 (1834.94 GiB 1970.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=385 sectors
           State : clean
     Device UUID : 9b1d0cc1:079694b1:d44a0c6d:73335c12

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov  4 21:34:51 2013
        Checksum : 149b6452 - correct
          Events : 36544

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 1
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
router:~#
router:~#
router:~#
router:~# mdadm -E /dev/sdd4
/dev/sdd4:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : b618baac:270afcb4:cd3f90e9:96f89319
            Name : router:2  (local to host router)
   Creation Time : Tue Jan  1 09:42:46 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3848156800 (1834.94 GiB 1970.26 GB)
      Array Size : 3848156416 (3669.89 GiB 3940.51 GB)
   Used Dev Size : 3848156416 (1834.94 GiB 1970.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=384 sectors
           State : clean
     Device UUID : a2b2f0ef:f91dba0e:7c30c8cc:04eb1ac8

Internal Bitmap : 8 sectors from superblock
     Update Time : Mon Nov  4 21:34:51 2013
        Checksum : b6201ad2 - correct
          Events : 36544

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 2
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
router:~#
router:~#

