From: dave dowless <ddowless@gmail.com>
Subject: How assemble this array? All devices listed as spares and busy. Huh?
 Unclear what this means.
Date: Mon, 27 Jun 2016 14:16:25 -0400
Message-ID: <CAM=c-cABEJMShf0m=evmehcfuCM5pBcp5iFOOAi5V1XRa2ekiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How to assemble this array? Note, mdadm.conf has no array line.

Originally this was Raid5 with 4disk (sda1, sdb1, sdc1, sdd1)

The current /proc/mdstat list everything as spares:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdc1[2](S) sdd1[4](S) sda1[0](S) sdb1[5](S)
      23441559552 blocks super 1.2

The last working /proc/mdstat was (yes with failed disk):

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdb1[5](S) sdd1[4] sdc1[2] sda1[0](F)
      17581168128 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2] [__UU]

I ended up rebooting, but a force assemble returns all devices are
busy. What gives?

mdadm: /dev/sda1 is busy - skipping
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping

Also know I that I had set sdb1 faulty and it came back as a spare and
rebuilt just prior to this problem.

== Drives examined =========

/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13d20dae:40e86bdf:437f8b51:bf2b4dd8
           Name : zippy:0  (local to host zippy)
  Creation Time : Thu Oct  1 15:37:52 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 11720779776 (5588.90 GiB 6001.04 GB)
     Array Size : 17581168128 (16766.71 GiB 18003.12 GB)
  Used Dev Size : 11720778752 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 008c8a3f:9e4295b8:48bdc532:c6c2ab4d

    Update Time : Thu Jun  9 21:22:12 2016
       Checksum : 6c151ac3 - correct
         Events : 406

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13d20dae:40e86bdf:437f8b51:bf2b4dd8
           Name : zippy:0  (local to host zippy)
  Creation Time : Thu Oct  1 15:37:52 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 11720779776 (5588.90 GiB 6001.04 GB)
     Array Size : 17581168128 (16766.71 GiB 18003.12 GB)
  Used Dev Size : 11720778752 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4f7deb5f:32333098:c97b360f:578ea16f

    Update Time : Fri Jun 10 11:44:26 2016
       Checksum : 6a7750d8 - correct
         Events : 412

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : ..AA ('A' == active, '.' == missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13d20dae:40e86bdf:437f8b51:bf2b4dd8
           Name : zippy:0  (local to host zippy)
  Creation Time : Thu Oct  1 15:37:52 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 11720779776 (5588.90 GiB 6001.04 GB)
     Array Size : 17581168128 (16766.71 GiB 18003.12 GB)
  Used Dev Size : 11720778752 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 60905555:5d6adfcc:0200168e:5bec3d80

    Update Time : Fri Jun 10 11:44:26 2016
       Checksum : 240c7d4f - correct
         Events : 412

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : ..AA ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13d20dae:40e86bdf:437f8b51:bf2b4dd8
           Name : zippy:0  (local to host zippy)
  Creation Time : Thu Oct  1 15:37:52 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 11720779776 (5588.90 GiB 6001.04 GB)
     Array Size : 17581168128 (16766.71 GiB 18003.12 GB)
  Used Dev Size : 11720778752 (5588.90 GiB 6001.04 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d97144c5:35daac52:2ed50f5a:56b2a67d

    Update Time : Fri Jun 10 11:44:26 2016
       Checksum : e32b69c8 - correct
         Events : 412

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : ..AA ('A' == active, '.' == missing)
