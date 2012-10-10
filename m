From: GuoZhong Han <hanguozhong@meganovo.com>
Subject: hotunpluged a disk, raid5 disappeared after reboot
Date: Wed, 10 Oct 2012 19:15:54 +0800
Message-ID: <CACY-59dzS4937Ou2Cv+JYm73GoEeAg-GteGKfQX5jWvgASXmsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello, every one:
I had a 4*2T (sdh, sdi, sdj,sdk)raid5 with 128K chuck size and 2048
strip_cache_size. The mdadm 3.2.2, kernel 2.6.38 were used. I wrote a
program to test the write performance for the raid5. While the program
was writing data to the raid5, I unplugged sdk, then I rebooted the
machine. After that, I used =93mdadm =96assemble --scan=94 to scan the
array. The output was =93not enough to start the array while not clean =
-
consider --force=94. The array was seemed disappeared. Then I used
=93mdadm =96E /dev/sd[ijh]=94 to check the superblocks of sdi,sdj and s=
dh,
the outputs were the following:

# mdadm -E /dev/sd[ijh]
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c2e5a470:4a7e42c3:96273d8c:1c8ad2b7
           Name : localhost:RAID5  (local to host localhost)
  Creation Time : Mon Sep 10 20:17:15 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 310344694 (147.98 GiB 158.90 GB)
     Array Size : 931031040 (443.95 GiB 476.69 GB)
  Used Dev Size : 310343680 (147.98 GiB 158.90 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 2d86ad25:16130eaf:6da00473:60ba7143

    Update Time : Tue Sep 11 12:18:55 2012
       Checksum : 878b469a - correct
         Events : 108

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c2e5a470:4a7e42c3:96273d8c:1c8ad2b7
           Name : localhost:RAID5  (local to host localhost)
  Creation Time : Mon Sep 10 20:17:15 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 310344844 (147.98 GiB 158.90 GB)
     Array Size : 931031040 (443.95 GiB 476.69 GB)
  Used Dev Size : 310343680 (147.98 GiB 158.90 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 7f74fb29:1b2c5c03:1e2b8de1:e25c9e39

    Update Time : Tue Sep 11 12:18:55 2012
       Checksum : 44dc7bbb - correct
         Events : 108

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c2e5a470:4a7e42c3:96273d8c:1c8ad2b7
           Name : localhost:RAID5  (local to host localhost)
  Creation Time : Mon Sep 10 20:17:15 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 310344346 (147.98 GiB 158.90 GB)
     Array Size : 931031040 (443.95 GiB 476.69 GB)
  Used Dev Size : 310343680 (147.98 GiB 158.90 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 5c58dcec:d03b6bd0:738bc5ea:e0c75d33

    Update Time : Tue Sep 11 12:18:55 2012
       Checksum : d7c438b0 - correct
         Events : 108

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)

As the output of =93mdadm --assemble --scan =94 suggested, I used =93md=
adm
=96assemble =96scan --force=94 to scan the array again. It did work. Ag=
ain I
used =93mdadm =96E /dev/sd[ijh]=94 to see the superblocks of sdi,sdj an=
d
sdh, the outputs were the following:

# mdadm -E /dev/sd[ijh]
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c2e5a470:4a7e42c3:96273d8c:1c8ad2b7
           Name : localhost:RAID5  (local to host localhost)
  Creation Time : Mon Sep 10 20:17:15 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 310344694 (147.98 GiB 158.90 GB)
     Array Size : 931031040 (443.95 GiB 476.69 GB)
  Used Dev Size : 310343680 (147.98 GiB 158.90 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2d86ad25:16130eaf:6da00473:60ba7143

    Update Time : Tue Sep 11 12:18:55 2012
       Checksum : 878b469a - correct
         Events : 108

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c2e5a470:4a7e42c3:96273d8c:1c8ad2b7
           Name : localhost:RAID5  (local to host localhost)
  Creation Time : Mon Sep 10 20:17:15 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 310344844 (147.98 GiB 158.90 GB)
     Array Size : 931031040 (443.95 GiB 476.69 GB)
  Used Dev Size : 310343680 (147.98 GiB 158.90 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 7f74fb29:1b2c5c03:1e2b8de1:e25c9e39

    Update Time : Tue Sep 11 12:18:55 2012
       Checksum : 44dc7bbb - correct
         Events : 108

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c2e5a470:4a7e42c3:96273d8c:1c8ad2b7
           Name : localhost:RAID5  (local to host localhost)
  Creation Time : Mon Sep 10 20:17:15 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 310344346 (147.98 GiB 158.90 GB)
     Array Size : 931031040 (443.95 GiB 476.69 GB)
  Used Dev Size : 310343680 (147.98 GiB 158.90 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 5c58dcec:d03b6bd0:738bc5ea:e0c75d33

    Update Time : Tue Sep 11 12:18:55 2012
       Checksum : d7c438b0 - correct
         Events : 108

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)

There was basically nothing inconsistent between the two outputs,
except that the state of =93sdh=94 in the former output was =93active=94=
,
while in the latter was =93clean=94.
What was the problem? Can any one help me?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
