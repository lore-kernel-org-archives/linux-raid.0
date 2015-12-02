From: Semyon Enskiy <semyon.enskiy@yandex.ru>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Wed, 2 Dec 2015 16:35:55 +0300
Message-ID: <565EF3BB.3000306@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello, Phil, thank you for help.

Writing to report, that array and LVM/ext4 on it successfully restored.



# Before rebooting and committing changes, dump of first 10 MB was done, 
now restore headers.
# for i in f i h g d e b c a j; do dd if=devsd"$i"3-head-bigger.raw 
of=/dev/sd"$i"3; done

# Without revert-reshape assembling.
# mdadm --create --assume-clean --level=5 --raid-devices=10 
--metadata=1.2 /dev/md3 /dev/sd{f,i,h,g,d,e,b,c,a,j}3

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md3 : active raid5 sdj3[9] sda3[8] sdc3[7] sdb3[6] sde3[5] sdd3[4] 
sdg3[3] sdh3[2] sdi3[1] sdf3[0]
       35095924224 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[10/10] [UUUUUUUUUU]
       bitmap: 1/30 pages [4KB], 65536KB chunk

# blkid /dev/md3
/dev/md3: UUID="4bz7kl-2QWk-4YZX-IDmH-IFXL-eM3l-F2dB2n" TYPE="LVM2_member"

# vgchange -aay

# blkid /dev/vg/data
/dev/vg/data: UUID="60e11554-074d-4156-a4d3-ed43318f5446" TYPE="ext4"

# fsck.ext4 /dev/vg/data
e2fsck 1.42.9 (4-Feb-2014)
/dev/vg/data: clean, 464/548112384 files, 4798924497/8769786880 blocks

# mount /dev/vg/data

# echo check > /sys/block/md3/md/sync_action



# mdadm --detail /dev/md3
/dev/md3:
         Version : 1.2
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 3899547136 (3718.90 GiB 3993.14 GB)
    Raid Devices : 10
   Total Devices : 10
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Wed Dec  2 13:40:04 2015
           State : active
  Active Devices : 10
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : ubuntu:3  (local to host ubuntu)
            UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
          Events : 2

     Number   Major   Minor   RaidDevice State
        0       8       83        0      active sync   /dev/sdf3
        1       8      131        1      active sync   /dev/sdi3
        2       8      115        2      active sync   /dev/sdh3
        3       8       99        3      active sync   /dev/sdg3
        4       8       51        4      active sync   /dev/sdd3
        5       8       67        5      active sync   /dev/sde3
        6       8       19        6      active sync   /dev/sdb3
        7       8       35        7      active sync   /dev/sdc3
        8       8        3        8      active sync   /dev/sda3
        9       8      147        9      active sync   /dev/sdj3



# mdadm --examine /dev/sd?3
/dev/sda3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : 074ebbe7:81662e37:cc777096:3d50d481

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : d47becef - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 8
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdb3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : 4adc3cf2:9d813d1e:ab8044ab:0cc5afe8

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 41bc13fb - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdc3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : ddc9c73b:007f6c0f:35a03e5c:e5fc8157

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 9c425653 - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 7
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdd3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : 73077551:029e51dc:6d036bf4:b81195a4

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 64142af5 - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sde3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : 1edcf3a7:9decc271:262271a6:54cff640

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 9e6c2a90 - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdf3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : 0438b536:b5943d93:70280dd9:70952d14

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 547afaef - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdg3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : e16e0db6:5d8e9016:84d2034b:7519f24d

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 2e15990 - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdh3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : 32bdd4dd:934c3ba5:adc8bfc2:0f1f323e

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 214f61da - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdi3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : bd0d56ba:78e5ee76:d600d587:ab65cbc9

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 2032ca0e - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
/dev/sdj3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 39b91f6d:7fd12764:825bb342:dd4d14fd
            Name : ubuntu:3  (local to host ubuntu)
   Creation Time : Wed Dec  2 13:09:01 2015
      Raid Level : raid5
    Raid Devices : 10

  Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
      Array Size : 35095924224 (33470.08 GiB 35938.23 GB)
   Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=655 sectors
           State : clean
     Device UUID : 35d4e323:8e2485cb:2c6492a1:e9f8e215

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Dec  2 15:19:29 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 442bc637 - correct
          Events : 2

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 9
    Array State : AAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)
