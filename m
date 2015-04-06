From: Mike <mboulter@gmail.com>
Subject: Recovery of RAID 6 after three rapid disk events (disks are still
 working)
Date: Mon, 06 Apr 2015 18:28:55 -0500
Message-ID: <104310d53affd63c6e13088daa8dd5f2@zeus.bigmiketrading.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

mdadm 3.2.5, 14 disk RAID 6

Had a drive failure Friday.  Two more today in rapid succession.  All 
drives seem fully operational.

This is roughly 40TB array, I could use your help please to rescue the 
array.

All members are on partition 2 of each physical disk.

# mdadm --assemble --scan
mdadm: /dev/md/media:0 assembled from 11 drives - not enough to start 
the array.
mdadm: No arrays found in config file or automatically

# mdadm --assemble --scan --verbose
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/loop0
mdadm: Cannot assemble mbr metadata on /dev/sdo1
mdadm: Cannot assemble mbr metadata on /dev/sdo
mdadm: no RAID superblock on /dev/sdm1
mdadm: no RAID superblock on /dev/sdm
mdadm: no RAID superblock on /dev/sdn1
mdadm: no RAID superblock on /dev/sdn
mdadm: no RAID superblock on /dev/sdj1
mdadm: no RAID superblock on /dev/sdj
mdadm: no RAID superblock on /dev/sdk1
mdadm: no RAID superblock on /dev/sdk
mdadm: no RAID superblock on /dev/sdl1
mdadm: no RAID superblock on /dev/sdl
mdadm: no RAID superblock on /dev/sdi1
mdadm: no RAID superblock on /dev/sdi
mdadm: no RAID superblock on /dev/sdh1
mdadm: no RAID superblock on /dev/sdh
mdadm: no RAID superblock on /dev/sdb1
mdadm: no RAID superblock on /dev/sdb
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda
mdadm: no RAID superblock on /dev/sdf1
mdadm: no RAID superblock on /dev/sdf
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdd
mdadm: no RAID superblock on /dev/sdc1
mdadm: no RAID superblock on /dev/sdc
mdadm: no RAID superblock on /dev/sdg1
mdadm: no RAID superblock on /dev/sdg
mdadm: no RAID superblock on /dev/sde1
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sdm2 is identified as a member of /dev/md/media:0, slot 3.
mdadm: /dev/sdn2 is identified as a member of /dev/md/media:0, slot 8.
mdadm: /dev/sdj2 is identified as a member of /dev/md/media:0, slot 5.
mdadm: /dev/sdk2 is identified as a member of /dev/md/media:0, slot 11.
mdadm: /dev/sdl2 is identified as a member of /dev/md/media:0, slot 4.
mdadm: /dev/sdi2 is identified as a member of /dev/md/media:0, slot 7.
mdadm: /dev/sdh2 is identified as a member of /dev/md/media:0, slot 1.
mdadm: /dev/sdb2 is identified as a member of /dev/md/media:0, slot 6.
mdadm: /dev/sda2 is identified as a member of /dev/md/media:0, slot 13.
mdadm: /dev/sdf2 is identified as a member of /dev/md/media:0, slot 2.
mdadm: /dev/sdd2 is identified as a member of /dev/md/media:0, slot 9.
mdadm: /dev/sdc2 is identified as a member of /dev/md/media:0, slot 6.
mdadm: /dev/sdg2 is identified as a member of /dev/md/media:0, slot 12.
mdadm: /dev/sde2 is identified as a member of /dev/md/media:0, slot 0.
mdadm: added /dev/sdh2 to /dev/md/media:0 as 1
mdadm: added /dev/sdf2 to /dev/md/media:0 as 2
mdadm: added /dev/sdm2 to /dev/md/media:0 as 3
mdadm: added /dev/sdl2 to /dev/md/media:0 as 4
mdadm: added /dev/sdj2 to /dev/md/media:0 as 5
mdadm: added /dev/sdc2 to /dev/md/media:0 as 6 (possibly out of date)
mdadm: added /dev/sdi2 to /dev/md/media:0 as 7
mdadm: added /dev/sdn2 to /dev/md/media:0 as 8
mdadm: added /dev/sdd2 to /dev/md/media:0 as 9 (possibly out of date)
mdadm: no uptodate device for slot 10 of /dev/md/media:0
mdadm: added /dev/sdk2 to /dev/md/media:0 as 11
mdadm: added /dev/sdg2 to /dev/md/media:0 as 12
mdadm: added /dev/sda2 to /dev/md/media:0 as 13
mdadm: added /dev/sde2 to /dev/md/media:0 as 0
mdadm: /dev/md/media:0 assembled from 11 drives - not enough to start 
the array.
mdadm: looking for devices for further assembly
mdadm: No arrays found in config file or automatically


# mdadm --examine /dev/sd?2 --verbose
/dev/sda2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 822fd02b:454da94c:57f68535:964996b1

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : 8e7a48ab - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 13
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdb2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x2
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
Recovery Offset : 0 sectors
           State : clean
     Device UUID : 5c4a1046:c232402c:45f1c604:569f6896

     Update Time : Mon Apr  6 16:12:05 2015
        Checksum : 3c7663c2 - correct
          Events : 2382358

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : AAAAAAAAAA.AAA ('A' == active, '.' == missing)
/dev/sdc2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x2
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
Recovery Offset : 0 sectors
           State : clean
     Device UUID : e211f88d:5c355522:fbeb7134:16b17684

     Update Time : Mon Apr  6 16:28:09 2015
        Checksum : 982c3e96 - correct
          Events : 2382480

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : AAAAAAAAAA.AAA ('A' == active, '.' == missing)
/dev/sdd2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : de3f41b8:3016870c:344f2a92:c08e1085

     Update Time : Mon Apr  6 19:19:34 2015
        Checksum : af2bfdb - correct
          Events : 2384965

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 9
    Array State : AAAAAA.AAA.AAA ('A' == active, '.' == missing)
/dev/sde2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 071afb12:f78f4f15:f65aa629:8eadcfa7

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : 28a53e70 - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdf2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : e319bdaa:22bc1153:c43b4878:8a9c1832

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : d7143a42 - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdg2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : f5477580:94357948:6e97fe82:c8805bcd

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : 482d21b8 - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 12
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdh2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 3dd1df1b:203c6453:0964ebad:245b1670

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : bc2a587a - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdi2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 4a013330:37c565f9:cb761d35:7ce4ddb4

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : 4278adbb - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 7
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdj2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : d5521994:6c4f04f9:f7ca0dd9:dff3c6cd

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : 62d6ed06 - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdk2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : c1514b9f:24616fed:324a50fb:9469043a

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : f0f3f2a5 - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 11
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdl2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 6c33c472:af1ffd8f:22d10ea3:9edc75bb

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : 902a8ccd - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdm2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : b750b4e4:2b1bac5f:cbd3bde5:eab657e7

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : 405a828f - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)
/dev/sdn2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1c40379:914e5d18:dddb893b:4dc5a28f
            Name : media:0
   Creation Time : Wed Nov  7 22:06:02 2012
      Raid Level : raid6
    Raid Devices : 14

  Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
      Array Size : 35160446976 (33531.62 GiB 36004.30 GB)
   Used Dev Size : 5860074496 (2794.30 GiB 3000.36 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 4670b36c:07cbe661:20e3d314:f7c3fd42

     Update Time : Mon Apr  6 19:19:53 2015
        Checksum : 55506e59 - correct
          Events : 2384973

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 8
    Array State : AAAAAA.AA..AAA ('A' == active, '.' == missing)



-- 
Mike
