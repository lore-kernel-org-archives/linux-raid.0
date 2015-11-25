From: Semyon Enskiy <semyon.enskiy@yandex.ru>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Wed, 25 Nov 2015 15:12:43 +0300
Message-ID: <3822301448453563@web17m.yandex.ru>
References: <189791448292518@web28m.yandex.ru> <565359F6.3020201@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <565359F6.3020201@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil.

Thanks for your suggestions, I have followed them, but RAID5 at md3 not
recovered at yet, maybe you will find time to suggest anything else.

Exactly, power and data connections of SATA disks was not reliable, fix=
ed
this and after boot get no errors in kernel logs.
md3 was replaced with "<ingore>" in mdadm.conf and commented in fstab b=
efore
poweroff, things returned back after boot.

    # mdadm --assemble --update=3Drevert-reshape /dev/md3
    # mdadm --assemble --scan -vv
mdadm: looking for devices for /dev/md1
mdadm: no recogniseable superblock on /dev/dm-1
mdadm: no recogniseable superblock on /dev/dm-0
mdadm: no recogniseable superblock on /dev/sdj4
mdadm: /dev/sdj3 has wrong uuid.
mdadm: /dev/sdj2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdj1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdj
mdadm: no recogniseable superblock on /dev/sdi4
mdadm: /dev/sdi3 has wrong uuid.
mdadm: /dev/sdi2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdi1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdi
mdadm: no recogniseable superblock on /dev/sdh4
mdadm: /dev/sdh3 has wrong uuid.
mdadm: /dev/sdh2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdh1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdh
mdadm: no recogniseable superblock on /dev/md/2
mdadm: no recogniseable superblock on /dev/md1
mdadm: no recogniseable superblock on /dev/sdg4
mdadm: /dev/sdg3 has wrong uuid.
mdadm: /dev/sdg2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdg1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdg
mdadm: no recogniseable superblock on /dev/sdb4
mdadm: /dev/sdb3 has wrong uuid.
mdadm: /dev/sdb2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdb1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: no recogniseable superblock on /dev/sdf4
mdadm: /dev/sdf3 has wrong uuid.
mdadm: /dev/sdf2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdf1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdf
mdadm: no recogniseable superblock on /dev/sde4
mdadm: /dev/sde3 has wrong uuid.
mdadm: /dev/sde2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sde1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sde
mdadm: no recogniseable superblock on /dev/sdd4
mdadm: /dev/sdd3 has wrong uuid.
mdadm: /dev/sdd2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdd1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdd
mdadm: no recogniseable superblock on /dev/sdc4
mdadm: /dev/sdc3 has wrong uuid.
mdadm: /dev/sdc2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdc1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: no recogniseable superblock on /dev/sda4
mdadm: /dev/sda3 has wrong uuid.
mdadm: /dev/sda2 has wrong uuid.
mdadm: UUID differs from /dev/md/2.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sda1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sda
mdadm: looking for devices for /dev/md/2
mdadm: no RAID superblock on /dev/dm-1
mdadm: no RAID superblock on /dev/dm-0
mdadm: no RAID superblock on /dev/sdj4
mdadm: /dev/sdj3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdj2 is busy - skipping
mdadm: no RAID superblock on /dev/sdj1
mdadm: no RAID superblock on /dev/sdj
mdadm: no RAID superblock on /dev/sdi4
mdadm: /dev/sdi3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdi2 is busy - skipping
mdadm: no RAID superblock on /dev/sdi1
mdadm: no RAID superblock on /dev/sdi
mdadm: no RAID superblock on /dev/sdh4
mdadm: /dev/sdh3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdh2 is busy - skipping
mdadm: no RAID superblock on /dev/sdh1
mdadm: no RAID superblock on /dev/sdh
mdadm: no RAID superblock on /dev/md/2
mdadm: no RAID superblock on /dev/md1
mdadm: no RAID superblock on /dev/sdg4
mdadm: /dev/sdg3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdg2 is busy - skipping
mdadm: no RAID superblock on /dev/sdg1
mdadm: no RAID superblock on /dev/sdg
mdadm: no RAID superblock on /dev/sdb4
mdadm: /dev/sdb3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdb2 is busy - skipping
mdadm: no RAID superblock on /dev/sdb1
mdadm: no RAID superblock on /dev/sdb
mdadm: no RAID superblock on /dev/sdf4
mdadm: /dev/sdf3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdf2 is busy - skipping
mdadm: no RAID superblock on /dev/sdf1
mdadm: no RAID superblock on /dev/sdf
mdadm: no RAID superblock on /dev/sde4
mdadm: /dev/sde3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sde2 is busy - skipping
mdadm: no RAID superblock on /dev/sde1
mdadm: no RAID superblock on /dev/sde
mdadm: no RAID superblock on /dev/sdd4
mdadm: /dev/sdd3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdd2 is busy - skipping
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdd
mdadm: no RAID superblock on /dev/sdc4
mdadm: /dev/sdc3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sdc2 is busy - skipping
mdadm: no RAID superblock on /dev/sdc1
mdadm: no RAID superblock on /dev/sdc
mdadm: no RAID superblock on /dev/sda4
mdadm: /dev/sda3 has wrong uuid.
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/3.
mdadm: /dev/sda2 is busy - skipping
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda
mdadm: looking for devices for /dev/md/3
mdadm: no RAID superblock on /dev/dm-1
mdadm: no RAID superblock on /dev/dm-0
mdadm: no RAID superblock on /dev/sdj4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sdj3 is busy - skipping
mdadm: /dev/sdj2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdj1
mdadm: no RAID superblock on /dev/sdj
mdadm: no RAID superblock on /dev/sdi4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sdi3 is busy - skipping
mdadm: /dev/sdi2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdi1
mdadm: no RAID superblock on /dev/sdi
mdadm: no RAID superblock on /dev/sdh4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sdh3 is busy - skipping
mdadm: /dev/sdh2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdh1
mdadm: no RAID superblock on /dev/sdh
mdadm: no RAID superblock on /dev/md/2
mdadm: no RAID superblock on /dev/md1
mdadm: no RAID superblock on /dev/sdg4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sdg3 is busy - skipping
mdadm: /dev/sdg2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg1
mdadm: no RAID superblock on /dev/sdg
mdadm: no RAID superblock on /dev/sdb4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sdb3 is busy - skipping
mdadm: /dev/sdb2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb1
mdadm: no RAID superblock on /dev/sdb
mdadm: no RAID superblock on /dev/sdf4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sdf3 is busy - skipping
mdadm: /dev/sdf2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf1
mdadm: no RAID superblock on /dev/sdf
mdadm: no RAID superblock on /dev/sde4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sde3 is busy - skipping
mdadm: /dev/sde2 has wrong uuid.
mdadm: no RAID superblock on /dev/sde1
mdadm: no RAID superblock on /dev/sde
mdadm: no RAID superblock on /dev/sdd4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sdd3 is busy - skipping
mdadm: /dev/sdd2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdd
mdadm: no RAID superblock on /dev/sdc4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sdc3 is busy - skipping
mdadm: /dev/sdc2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc1
mdadm: no RAID superblock on /dev/sdc
mdadm: no RAID superblock on /dev/sda4
mdadm: UUID differs from /dev/md1.
mdadm: UUID differs from /dev/md/2.
mdadm: /dev/sda3 is busy - skipping
mdadm: /dev/sda2 has wrong uuid.
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda



Note the difference in --display and --examine outputs (see below) abou=
t
total and delta device numbers, 10 in detail and 11 in examine.

Also note, that sda3 is marked as "spare" device, I am wrote before in =
first
message, that some useless commands was executed.
    # mdadm --add /dev/md3 --re-add /dev/sda3
mdadm: Cannot get array info for /dev/md3
# This is because array is not started?



    # cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md2 : active raid10 sdd2[8] sdg2[6] sdh2[4] sdj2[5] sdi2[11] sdb2[1] sd=
c2[10] sdf2[0] sde2[9] sda2[12]
      35653120 blocks super 1.2 512K chunks 2 near-copies [10/10] [UUUU=
UUUUUU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md3 : inactive sdg3[3](S) sdh3[2](S) sdj3[10](S) sdi3[12](S) sdb3[6](S)=
 sdc3[11](S) sdf3[0](S) sdd3[4](S) sde3[5](S) sda3[14](S)
      38995474635 blocks super 1.2
      =20
md1 : active raid1 sdd1[4] sdg1[3] sdh1[2] sdj1[8] sdi1[1] sdb1[6] sdc1=
[7] sdf1[0] sde1[5] sda1[9]
      203712 blocks [10/10] [UUUUUUUUUU]
      bitmap: 0/1 pages [0KB], 65536KB chunk



    # mdadm --detail /dev/md3
/dev/md3:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 10
    Persistence : Superblock is persistent

          State : inactive

  Delta Devices : 1, (-1->0)
      New Level : raid5
     New Layout : left-symmetric
  New Chunksize : 512K

           Name : ubuntu:3
           UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
         Events : 21586

    Number   Major   Minor   RaidDevice

       -       8        3        -        /dev/sda3
       -       8       19        -        /dev/sdb3
       -       8       35        -        /dev/sdc3
       -       8       51        -        /dev/sdd3
       -       8       67        -        /dev/sde3
       -       8       83        -        /dev/sdf3
       -       8       99        -        /dev/sdg3
       -       8      115        -        /dev/sdh3
       -       8      131        -        /dev/sdi3
       -       8      147        -        /dev/sdj3



    # mdadm --examine /dev/sd?3
/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c0155214:a9c8e378:d368b6f6:735048a8

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 952a55f2 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 375d85e2:9077dd68:bc1327af:8fee4112

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 75b99505 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 67cd2bfa:affa578c:e0c1286a:bd4d2627

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 80c895f3 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sdd3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4490843e:d2c5c2e7:d222fa0a:f98b277c

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 1656c2d2 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sde3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1d41056f:88149b1a:48e939e5:8c775e23

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : fb26746a - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sdf3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fa7c541d:a25babd8:14ffe1c0:c6c1578c

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : ac275763 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sdg3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a4b8b425:b0307fe5:9eb8e3ac:ae985311

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 3258f890 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sdh3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 345b0212:6c3a0ae8:d8ed9273:ecc53573

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 49c30753 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sdi3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 70afdaad:b0979fb1:1b99ef18:dd58cc3a

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1c2bf759 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)
/dev/sdj3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
           Name : ubuntu:3
  Creation Time : Thu Jul 24 16:06:32 2014
     Raid Level : raid5
   Raid Devices : 11

 Avail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
     Array Size : 38995471360 (37188.98 GiB 39931.36 GB)
  Used Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
    Data Offset : 262144 sectors
     New Offset : 251904 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a5f2cea8:a89c88a0:0dd3900c:624f0491

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : 1 (10->11)

    Update Time : Fri Nov  6 16:53:06 2015
       Checksum : 4fda6fb3 - correct
         Events : 21586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 9
   Array State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R=
' =3D=3D replacing)



    # for x in /dev/sd[a-z] ; do echo $x ; smartctl -i -A $x ; done
/dev/sda
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1657399
LU WWN Device Id: 5 0014ee 2b4caa93a
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   179   179   021    Pre-fail  Alway=
s       -       8033
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       9
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   089   089   000    Old_age   Alway=
s       -       8756
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       9
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       3
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       66
194 Temperature_Celsius     0x0022   117   102   000    Old_age   Alway=
s       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age   Offli=
ne      -       0

/dev/sdb
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1643332
LU WWN Device Id: 5 0014ee 25f74cf3c
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   182   181   021    Pre-fail  Alway=
s       -       7866
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       19
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   084   084   000    Old_age   Alway=
s       -       11724
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       19
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       5
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       106
194 Temperature_Celsius     0x0022   117   102   000    Old_age   Alway=
s       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

/dev/sdc
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1649141
LU WWN Device Id: 5 0014ee 25f74a7c9
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   185   183   021    Pre-fail  Alway=
s       -       7741
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       14
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   085   085   000    Old_age   Alway=
s       -       11439
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       14
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       3
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       84
194 Temperature_Celsius     0x0022   118   105   000    Old_age   Alway=
s       -       34
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age   Offli=
ne      -       0

/dev/sdd
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E0340253
LU WWN Device Id: 5 0014ee 20921e030
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   175   173   021    Pre-fail  Alway=
s       -       8241
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       28
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   081   081   000    Old_age   Alway=
s       -       14575
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       28
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       9
193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Alway=
s       -       1496402
194 Temperature_Celsius     0x0022   114   108   000    Old_age   Alway=
s       -       38
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

/dev/sde
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1658818
LU WWN Device Id: 5 0014ee 20a1fca11
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   185   183   021    Pre-fail  Alway=
s       -       7733
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       15
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   084   084   000    Old_age   Alway=
s       -       11700
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       15
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       3
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       101
194 Temperature_Celsius     0x0022   116   109   000    Old_age   Alway=
s       -       36
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

/dev/sdf
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1349511
LU WWN Device Id: 5 0014ee 2b4a00452
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   178   176   021    Pre-fail  Alway=
s       -       8100
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       27
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   082   082   000    Old_age   Alway=
s       -       13576
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       27
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       8
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       120
194 Temperature_Celsius     0x0022   117   110   000    Old_age   Alway=
s       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

/dev/sdg
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1265787
LU WWN Device Id: 5 0014ee 25f483dfb
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       55
  3 Spin_Up_Time            0x0027   177   175   021    Pre-fail  Alway=
s       -       8141
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       23
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   084   084   000    Old_age   Alway=
s       -       11746
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       23
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       9
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       104
194 Temperature_Celsius     0x0022   115   107   000    Old_age   Alway=
s       -       37
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

/dev/sdh
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1639809
LU WWN Device Id: 5 0014ee 25f7425d2
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   180   179   021    Pre-fail  Alway=
s       -       7958
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       17
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   084   084   000    Old_age   Alway=
s       -       11722
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       17
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       3
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       103
194 Temperature_Celsius     0x0022   115   107   000    Old_age   Alway=
s       -       37
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

/dev/sdi
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1639009
LU WWN Device Id: 5 0014ee 25f752df3
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:50 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   179   177   021    Pre-fail  Alway=
s       -       8016
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       12
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   085   085   000    Old_age   Alway=
s       -       11393
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       12
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       3
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       83
194 Temperature_Celsius     0x0022   117   105   000    Old_age   Alway=
s       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age   Offli=
ne      -       0

/dev/sdj
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-57-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E1228884
LU WWN Device Id: 5 0014ee 209e58132
=46irmware Version: 80.00A80
User Capacity:    4=9A000=9A787=9A030=9A016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Nov 25 14:25:51 2015 MSK
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   175   174   021    Pre-fail  Alway=
s       -       8208
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       27
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   082   082   000    Old_age   Alway=
s       -       13598
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       27
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       8
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       120
194 Temperature_Celsius     0x0022   117   102   000    Old_age   Alway=
s       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0



END OF MESSAGE
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
