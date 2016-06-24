From: Peter Gebhard <pgeb@seas.upenn.edu>
Subject: Recommendations needed for RAID5 recovery
Date: Fri, 24 Jun 2016 15:55:15 -0400
Message-ID: <B1389BE8-B7B5-4AB4-BE12-1636D4B91BB5@seas.upenn.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have been asked to attempt data recovery on a RAID5 array which appea=
rs to have had two disk failures (in an array of four disks). I am grat=
efully hoping that some on this list could offer recommendations for my=
 next steps. I have provided below the current state of the array per h=
ttps://raid.wiki.kernel.org/index.php/RAID_Recovery.=20

It appears from the output below that one of the disks (sdd1) failed la=
st year and the admin did not notice this. Now, it appears a second dis=
k (sdg1) has recently had read errors and was kicked out of the array.

Should I try to restore the array using the recreate_array.pl script pr=
ovided on the RAID_Recovery site? Should I then try to recreate the arr=
ay and/or perform =E2=80=98fsck=E2=80=99?

Thank you greatly in advance!

raid.status:

/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
           Name : <->:0
  Creation Time : Tue Nov 29 17:33:39 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ec1a6336:0a991298:5b409bf1:4585ccbe

    Update Time : Sun Jun  7 02:28:00 2015
       Checksum : f9323080 - correct
         Events : 96203

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
           Name : <->:0
  Creation Time : Tue Nov 29 17:33:39 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ed13b045:ca75ab96:83045f97:e4fd62cb

    Update Time : Sun Jun 19 19:43:31 2016
       Checksum : bb6a905f - correct
         Events : 344993

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .A.A ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
           Name : <->:0
  Creation Time : Tue Nov 29 17:33:39 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a1ea11e0:6465fe26:483f133d:680014b3

    Update Time : Sun Jun 19 19:43:31 2016
       Checksum : 738493f3 - correct
         Events : 344993

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : .A.A ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
           Name : <->:0
  Creation Time : Tue Nov 29 17:33:39 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : a9737439:17f81210:484d4f4c:c3d34a8a

    Update Time : Sun Jun 19 12:18:49 2016
       Checksum : 9c6d24bf - correct
         Events : 343949

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
