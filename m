From: Jared Mauch <jared@puck.nether.net>
Subject: (R) in mdstat output, clean && degraded
Date: Tue, 23 Jun 2015 14:56:09 -0400
Message-ID: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I=E2=80=99ve been searching high and low the past few days and have bee=
n unable to diagnose what this (R) is in my raid1 mdstat output indicat=
es.

It seems something is =E2=80=98stuck=E2=80=99 somehow as I=E2=80=99m no=
t sure how the array is both clean and degraded at the same time.

Some insights are welcome.

kernel 4.0.5-300.fc22 (fedora 22)

/proc/mdstat

md127 : active raid1 sdg1[2](R) sdd1[3]
      976630464 blocks super 1.2 [2/1] [U_]
      bitmap: 8/8 pages [32KB], 65536KB chunk


# mdadm -D /dev/md127 ; mdadm -E /dev/sdg1 ; mdadm -E /dev/sdd1
/dev/md127:
        Version : 1.2
  Creation Time : Sat Jan 24 10:22:05 2015
     Raid Level : raid1
     Array Size : 976630464 (931.39 GiB 1000.07 GB)
  Used Dev Size : 976630464 (931.39 GiB 1000.07 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Jun 23 14:53:50 2015
          State : clean, degraded=20
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : jail-lnx:ssd-array
           UUID : a6277db4:da27d506:916a2c7a:d144aed6
         Events : 9594760

    Number   Major   Minor   RaidDevice State
       2       8       97        0      active sync   /dev/sdg1
       3       8       49        0      active sync   /dev/sdd1
       2       0        0        2      removed
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x11
     Array UUID : a6277db4:da27d506:916a2c7a:d144aed6
           Name : jail-lnx:ssd-array
  Creation Time : Sat Jan 24 10:22:05 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1953261038 (931.39 GiB 1000.07 GB)
     Array Size : 976630464 (931.39 GiB 1000.07 GB)
  Used Dev Size : 1953260928 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D110 sectors
          State : clean
    Device UUID : d5fd7437:1fd04c64:a9327851:b22e8008

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Jun 23 14:53:50 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : fa563013 - correct
         Events : 9594760


   Device Role : Replacement device 0
   Array State : R. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a6277db4:da27d506:916a2c7a:d144aed6
           Name : jail-lnx:ssd-array
  Creation Time : Sat Jan 24 10:22:05 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1953261038 (931.39 GiB 1000.07 GB)
     Array Size : 976630464 (931.39 GiB 1000.07 GB)
  Used Dev Size : 1953260928 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D110 sectors
          State : clean
    Device UUID : fa65731c:d8c703be:bbf05cfe:c89740f2

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Jun 23 14:53:50 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : cfb0b70c - correct
         Events : 9594760


   Device Role : Active device 0
   Array State : R. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
