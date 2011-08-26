From: Michael-John Turner <mj@mjturner.net>
Subject: Help - power failure during RAID6 grow
Date: Fri, 26 Aug 2011 16:18:03 +0100
Message-ID: <20110826151803.GA7595@majestic.pimp.org.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Yesterday I added three more disks to an existing five disk mdadm RAID6
array and left it reshaping overnight. Unfortunately, there was a power
outage this afternoon and due to a UPS error, my server restarted.

Due to a problem with my one disk chassis (containing the three new disks),
after the reboot the new disks weren't visible, which I think caused some
problems with the array. I've since corrected the problem with the chassis,
but now get the following on boot:
[   64.868206] md: md20 stopped.
[   64.872415] md: bind<sde1>
[   64.872585] md: bind<sdf1>
[   64.872720] md: bind<sdg1>
[   64.873081] md: bind<sdh1>
[   64.873198] md: bind<sdc1>
[   64.875280] md: bind<sdb1>
[   64.875395] md: bind<sda1>
[   64.875532] md: bind<sdd1>
[   64.875544] md: kicking non-fresh sda1 from array!
[   64.875548] md: unbind<sda1>
[   64.880544] md: export_rdev(sda1)
[   64.880548] md: kicking non-fresh sdb1 from array!
[   64.880553] md: unbind<sdb1>
[   64.892007] md: export_rdev(sdb1)
[   64.892031] md: kicking non-fresh sdc1 from array!
[   64.892034] md: unbind<sdc1>
[   64.904007] md: export_rdev(sdc1)
[   64.904823] raid5: reshape will continue
[   64.904829] raid5: device sdd1 operational as raid disk 0
[   64.904831] raid5: device sdh1 operational as raid disk 4
[   64.904832] raid5: device sdg1 operational as raid disk 3
[   64.904833] raid5: device sdf1 operational as raid disk 2
[   64.904835] raid5: device sde1 operational as raid disk 1
[   64.905253] raid5: allocated 8490kB for md20
[   64.905271] 0: w=1 pa=2 pr=5 m=2 a=2 r=8 op1=0 op2=0
[   64.905273] 4: w=2 pa=2 pr=5 m=2 a=2 r=8 op1=0 op2=0
[   64.905275] 3: w=3 pa=2 pr=5 m=2 a=2 r=8 op1=0 op2=0
[   64.905277] 2: w=4 pa=2 pr=5 m=2 a=2 r=8 op1=0 op2=0
[   64.905278] 1: w=5 pa=2 pr=5 m=2 a=2 r=8 op1=0 op2=0
[   64.905280] raid5: not enough operational devices for md20 (3/8 failed)

md20 is the array in question and sda1, sdb1 and sdc1 are the partitions on
the three new disks (sd[defgh]1 are the five original members of md20,
before the grow).

I tried stopping and re-assembling by hand, but get the following:
# mdadm --assemble /dev/md20 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
mdadm: /dev/md20 assembled from 5 drives and 1 spare - not enough to start the array.

# uname -a
Linux majestic 2.6.32-5-amd64 #1 SMP Tue Jun 14 09:42:28 UTC 2011 x86_64 GNU/Linux

# mdadm -V
mdadm - v3.1.4 - 31st August 2010

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] 
md20 : inactive sdd1[0](S) sda1[8](S) sdb1[6](S) sdc1[7](S) sdh1[4](S) sdg1[3](S) sdf1[2](S) sde1[1](S)
      15609328616 blocks super 1.2
The above is after attempting the manual --assemble above.

# mdadm --detail /dev/md20
mdadm: md device /dev/md20 does not appear to be active.

Help!! Should I force a re-assemble (I haven't tried that as I don't want
to do anything risky)? mdadm -E output for all the disks pasted below.

-mj
-- 
 Michael-John Turner
 mj@mjturner.net      <>     http://mjturner.net/


#######################################################################

/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ba21b41c:4e89d27a:be416498:12763c48
           Name : majestic:20  (local to host majestic)
  Creation Time : Sun Jul  4 19:54:16 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3902331909 (1860.78 GiB 1997.99 GB)
     Array Size : 23413991424 (11164.66 GiB 11987.96 GB)
  Used Dev Size : 3902331904 (1860.78 GiB 1997.99 GB)
    Data Offset : 664 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 84dc8ff5:2f9c8735:d42328fc:cc5549a8

  Reshape pos'n : 3213327360 (3064.47 GiB 3290.45 GB)
  Delta Devices : 3 (5->8)

    Update Time : Fri Aug 26 14:25:13 2011
       Checksum : a4a9dc2e - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : spare
   Array State : AAAAA... ('A' == active, '.' == missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ba21b41c:4e89d27a:be416498:12763c48
           Name : majestic:20  (local to host majestic)
  Creation Time : Sun Jul  4 19:54:16 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3902331909 (1860.78 GiB 1997.99 GB)
     Array Size : 23413991424 (11164.66 GiB 11987.96 GB)
  Used Dev Size : 3902331904 (1860.78 GiB 1997.99 GB)
    Data Offset : 664 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6748c837:b1e86725:edf2184d:81d55fd6

  Reshape pos'n : 3213327360 (3064.47 GiB 3290.45 GB)
  Delta Devices : 3 (5->8)

    Update Time : Fri Aug 26 14:11:11 2011
       Checksum : 55d90bc0 - correct
         Events : 11174

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 6
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ba21b41c:4e89d27a:be416498:12763c48
           Name : majestic:20  (local to host majestic)
  Creation Time : Sun Jul  4 19:54:16 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3902331909 (1860.78 GiB 1997.99 GB)
     Array Size : 23413991424 (11164.66 GiB 11987.96 GB)
  Used Dev Size : 3902331904 (1860.78 GiB 1997.99 GB)
    Data Offset : 664 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 47f47246:55da1b0e:831ab899:ac2d1eed

  Reshape pos'n : 3213327360 (3064.47 GiB 3290.45 GB)
  Delta Devices : 3 (5->8)

    Update Time : Fri Aug 26 14:11:11 2011
       Checksum : b0952906 - correct
         Events : 11174

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 5
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ba21b41c:4e89d27a:be416498:12763c48
           Name : majestic:20  (local to host majestic)
  Creation Time : Sun Jul  4 19:54:16 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3902332301 (1860.78 GiB 1997.99 GB)
     Array Size : 23413991424 (11164.66 GiB 11987.96 GB)
  Used Dev Size : 3902331904 (1860.78 GiB 1997.99 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c3bc9bf5:16baaa20:811b93f7:bb61b63a

  Reshape pos'n : 3213327360 (3064.47 GiB 3290.45 GB)
  Delta Devices : 3 (5->8)

    Update Time : Fri Aug 26 14:25:13 2011
       Checksum : 1db10998 - correct
         Events : 11184

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 0
   Array State : AAAAA... ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ba21b41c:4e89d27a:be416498:12763c48
           Name : majestic:20  (local to host majestic)
  Creation Time : Sun Jul  4 19:54:16 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3902332301 (1860.78 GiB 1997.99 GB)
     Array Size : 23413991424 (11164.66 GiB 11987.96 GB)
  Used Dev Size : 3902331904 (1860.78 GiB 1997.99 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3f60aea4:00a038c8:844ead69:d9591383

  Reshape pos'n : 3213327360 (3064.47 GiB 3290.45 GB)
  Delta Devices : 3 (5->8)

    Update Time : Fri Aug 26 14:25:13 2011
       Checksum : 2ec8be20 - correct
         Events : 11184

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 1
   Array State : AAAAA... ('A' == active, '.' == missing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ba21b41c:4e89d27a:be416498:12763c48
           Name : majestic:20  (local to host majestic)
  Creation Time : Sun Jul  4 19:54:16 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3902332301 (1860.78 GiB 1997.99 GB)
     Array Size : 23413991424 (11164.66 GiB 11987.96 GB)
  Used Dev Size : 3902331904 (1860.78 GiB 1997.99 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b70e9161:e73c145f:2bcfe99a:c061ef73

  Reshape pos'n : 3213327360 (3064.47 GiB 3290.45 GB)
  Delta Devices : 3 (5->8)

    Update Time : Fri Aug 26 14:25:13 2011
       Checksum : a49f920d - correct
         Events : 11184

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 2
   Array State : AAAAA... ('A' == active, '.' == missing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ba21b41c:4e89d27a:be416498:12763c48
           Name : majestic:20  (local to host majestic)
  Creation Time : Sun Jul  4 19:54:16 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3902332301 (1860.78 GiB 1997.99 GB)
     Array Size : 23413991424 (11164.66 GiB 11987.96 GB)
  Used Dev Size : 3902331904 (1860.78 GiB 1997.99 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c7c739f0:d1421fdb:136e8eb7:431bd0ec

  Reshape pos'n : 3213327360 (3064.47 GiB 3290.45 GB)
  Delta Devices : 3 (5->8)

    Update Time : Fri Aug 26 14:25:13 2011
       Checksum : 44d8a975 - correct
         Events : 11184

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 3
   Array State : AAAAA... ('A' == active, '.' == missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : ba21b41c:4e89d27a:be416498:12763c48
           Name : majestic:20  (local to host majestic)
  Creation Time : Sun Jul  4 19:54:16 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3902332301 (1860.78 GiB 1997.99 GB)
     Array Size : 23413991424 (11164.66 GiB 11987.96 GB)
  Used Dev Size : 3902331904 (1860.78 GiB 1997.99 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 24c8066f:b85de6c5:9382acd4:6e8b8f6e

  Reshape pos'n : 3213327360 (3064.47 GiB 3290.45 GB)
  Delta Devices : 3 (5->8)

    Update Time : Fri Aug 26 14:25:13 2011
       Checksum : 4d4a4964 - correct
         Events : 11184

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 4
   Array State : AAAAA... ('A' == active, '.' == missing)

#######################################################################


