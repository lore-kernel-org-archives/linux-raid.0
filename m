From: George Rapp <george.rapp@gmail.com>
Subject: RAID 5 --assemble doesn't recognize all overlays as component devices
 (was: RAID 5 reshape stalled at 77.5% - next steps??)
Date: Sat, 11 Feb 2017 19:32:37 -0500
Message-ID: <CAF-Kpgaso8cZAwd7cbyb4mAQGEPebG85Drj7FJ8mrhBTJMpsDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
Cc: Matthew Krumwiede <matt.krumwiede@me.com>
List-Id: linux-raid.ids

Previous thread: http://marc.info/?l=linux-raid&m=148564798430138&w=2
-- to summarize, while adding two drives to a RAID 5 array, one of the
existing RAID 5 component drives failed, causing the reshape progress
to stall at 77.5%. I removed the previous thread from this message to
conserve space -- before resolving that situation, another problem has
arisen.

We have cloned and replaced the failed /dev/sdg with "ddrescue --force
-r3 -n /dev/sdh /dev/sde c/sdh-sde-recovery.log"; copied in below, or
viewable via https://app.box.com/v/sdh-sde-recovery . The failing
device was removed from the server, and the RAID component partition
on the cloned drive is now /dev/sdg4.

I've also created and run a script to create overlay files per
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID.
The script name is make_RAID_overlays, and it's also copied in below,
or viewable via https://app.box.com/v/make-RAID-overlays

When trying to assemble the array using the overlays, I now get the
following output:

# export MDADM_GROW_ALLOW_OLD=1
# mdadm --assemble /dev/md4
--backup-file=/home/gwr/2017/2017-01/md4_backup__2017-01-25
/dev/mapper/sde4 /dev/mapper/sdf4 /dev/mapper/sdh4 /dev/mapper/sdl4
/dev/mapper/sdg4 /dev/mapper/sdk4 /dev/mapper/sdi4 /dev/mapper/sdj4
/dev/mapper/sdb4 /dev/mapper/sdd4
mdadm: accepting backup with timestamp 1485366772 for array with
timestamp 1485439616
mdadm: /dev/md4 assembled from 9 drives - not enough to start the
array while not clean - consider --force.

As you can count, there are ten devices (mapping to overlay files) but
mdadm is only recognizing 9 of them as drives. By process of
elimination, I determined that /dev/mapper/sdg4 can be removed from
that command without changing the result:

# mdadm --assemble /dev/md4
--backup-file=/home/gwr/2017/2017-01/md4_backup__2017-01-25
/dev/mapper/sde4 /dev/mapper/sdf4 /dev/mapper/sdh4 /dev/mapper/sdl4
/dev/mapper/sdk4 /dev/mapper/sdi4 /dev/mapper/sdj4 /dev/mapper/sdb4
/dev/mapper/sdd4
mdadm: accepting backup with timestamp 1485366772 for array with
timestamp 1485439616
mdadm: /dev/md4 assembled from 9 drives - not enough to start the
array while not clean - consider --force.

The output of mdadm --examine (in file raid_status_2017-02-11, copied
in below or viewable via https://app.box.com/v/raid-status-2017-02-11)
doesn't show anything obvious that I can see that would cause
/dev/mapper/sdg4 not to be recognized as a RAID component. The only
discrepancy is that /dev/mapper/sdg4 is showing a State: value of
clean, while all other devices are showing State: active, and the
Array State is different (AAAARAAAA. vs. AAAAAAAAA.)

Any thoughts? Am I creating overlays incorrectly?

-=-=- sdh-sde-recovery.log

# Command line: ddrescue --force -r3 -n /dev/sdh /dev/sde c/sdh-sde-recovery.log
# Start time:   2017-01-29 18:43:17
# Current time: 2017-01-30 02:20:21
# Finished
# current_pos  current_status
0x1D1C1115E00     +
#      pos        size  status
0x00000000  0x1D099900000  +
0x1D099900000  0x00000200  -
0x1D099900200  0x0001FC00  /
0x1D09991FE00  0x00000200  -
0x1D099920000  0x00020000  +
0x1D099940000  0x00000200  -
0x1D099940200  0x1277D5C00  /
0x1D1C1115E00  0x00000200  -


-=-=- make_RAID_overlays

#/usr/bin/sh

UUID=359d41dc:a2e506e3:5e802a49:a84ef89c
DEVICES=$(cat /proc/partitions | parallel --tagstring {5} --colsep '
+' mdadm -E /dev/{5} |grep $UUID | grep -v "dm-" | parallel --colsep
'\t' echo /dev/{1})
parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b 7 {#}'
::: $DEVICES
parallel truncate -s8G overlay-{/} ::: $DEVICES
parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f --show --
overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup create {/}'
::: $DEVICES
OVERLAYS=$(parallel echo /dev/mapper/{/} ::: $DEVICES)
dmsetup status
echo export DEVICES=\"$DEVICES\"
echo export OVERLAYS=\"$OVERLAYS\"

-=-=- raid_status_2017-02-11

/dev/sdb4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844265615 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
  Used Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1968 sectors, after=1679 sectors
          State : active
    Device UUID : af5226e3:757f9f97:55728ff9:197fc03d

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c1a3ed5b - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 8
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x16
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844265615 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
  Used Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
Recovery Offset : 2980597760 sectors
   Unused Space : before=1968 sectors, after=1679 sectors
          State : active
    Device UUID : 87bc1358:efcfbf2a:226a9241:dcd1c54e

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d462424f - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Replacement device 4
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=0 sectors
          State : active
    Device UUID : 4340ee15:6ab2d65a:bc21b9b0:9b285385

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
       Checksum : b6575fe9 - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=0 sectors
          State : active
    Device UUID : 8aea344d:3d8180a3:7762f06b:ca3d5957

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
       Checksum : c3852eee - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0xc
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1968 sectors, after=0 sectors
          State : clean
    Device UUID : 00e5ef75:50fc5750:a4ea2e21:13757690

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 07:49:59 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : 877a6050 - correct
         Events : 3957772

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAARAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=0 sectors
          State : active
    Device UUID : 25472a02:7ad445e8:2aae650f:783346f7

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
       Checksum : a22029 - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844264112 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
  Used Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=176 sectors
          State : active
    Device UUID : c06c4647:8e9bf793:db91ea2b:2f6313b6

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
       Checksum : ccc220f5 - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844264112 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
  Used Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=176 sectors
          State : active
    Device UUID : c05f73af:10ae7c6f:d8ce6da0:ea06dfe6

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
       Checksum : b5c3072f - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdk4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844264112 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
  Used Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1968 sectors, after=176 sectors
          State : active
    Device UUID : d0daf993:42ee5ab3:a32fb0c2:471e06bb

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d4993ae5 - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdl4:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
           Name : localhost.localdomain:4
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
   Raid Devices : 10

 Avail Dev Size : 3844264112 (1833.09 GiB 1968.26 GB)
     Array Size : 17299187712 (16497.79 GiB 17714.37 GB)
  Used Dev Size : 3844263936 (1833.09 GiB 1968.26 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
   Unused Space : before=1976 sectors, after=176 sectors
          State : active
    Device UUID : dc42a9bd:400f4d25:8e2d74b5:25ee7478

  Reshape pos'n : 13412689920 (12791.34 GiB 13734.59 GB)
  Delta Devices : 2 (8->10)

    Update Time : Thu Jan 26 08:06:56 2017
       Checksum : 2065916e - correct
         Events : 3957775

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)



-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
