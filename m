From: Martin Senebald <martin@senebald.de>
Subject: raid5 missing disks during chunk size grow
Date: Mon, 22 Sep 2014 13:21:01 +0200
Message-ID: <374D34B3-E7F5-48AD-9A22-23C76AA0A60F@senebald.de>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_496132D2-E2E2-4ECF-B007-9AB832402329"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_496132D2-E2E2-4ECF-B007-9AB832402329
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hi,

i have a tricky problem. I have a 6disk raid5 setup and did a mdadm grow ch=
unk size.
Apparently 3 disk went missing (controller/kernel crash) and the raid faile=
d.  Disks are all ok. Backupfile for grow is there and raid config availabl=
e including status(examine) of all disks.

Problem =3D 3 disks where in a state like

/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 84bea3d7:7b697819:b8c1aa5a:a615e3b4
           Name : chenbro.han.daquan.eu:2  (local to host chenbro.han.daqua=
n.eu)
  Creation Time : Sat Sep 20 12:28:57 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5856270336 (2792.49 GiB 2998.41 GB)
     Array Size : 14640675840 (13962.44 GiB 14992.05 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 67cc689a:2cdf3d4d:0c7d03d4:c12c7475

  Reshape pos'n : 557547520 (531.72 GiB 570.93 GB)
  New Chunksize : 512K

    Update Time : Mon Sep 22 09:39:35 2014
       Checksum : 25acf25d - correct
         Events : 109099

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : ...AAA ('A' =3D=3D active, '.' =3D=3D missing)

and 3 in=20

/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 84bea3d7:7b697819:b8c1aa5a:a615e3b4
           Name : chenbro.han.daquan.eu:2  (local to host chenbro.han.daqua=
n.eu)
  Creation Time : Sat Sep 20 12:28:57 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5856270336 (2792.49 GiB 2998.41 GB)
     Array Size : 14640675840 (13962.44 GiB 14992.05 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f74a1585:93fb850b:64667d57:42c34e52

  Reshape pos'n : 557547520 (531.72 GiB 570.93 GB)
  New Chunksize : 512K

    Update Time : Mon Sep 22 09:02:59 2014
       Checksum : 2ef3049b - correct
         Events : 109096

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

My idea was, first bringing back the disks in the array then continue the g=
row (using the backup file)
add / re-add disk was not working, so i assumed recreate the array with =97=
assume-clean would bring me closer.=20

Question now ist, how to i get the array back to the grow process at the st=
ate of the failure?=20
I didnt find anything regarding this. (if even possible)

Someone any idea?
What would be the best way to tackle this problem?

Thanks

BR Martin


--Apple-Mail=_496132D2-E2E2-4ECF-B007-9AB832402329
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJUIAYdAAoJEHcuczTXL/spCUAQALJT2dTFIaSEXj38bZQiFLaa
JzqK/zoeiY9DD4dY4gVrs2txepOvajM9QGG1TWIbH6SVzgzyGSolSa8jKD35Ko8d
bfiSjnckvHGlyMBwcRjGrQdXeQmFbMbtvtsw1yCXcS4/eFRCNx5Utv21hpcSDTpg
d+yEmVCoUFFLaPKgJZlEdm/jo7dba312TeafrTKJrN1KzgPFIlVgCcsh7Y+nhSGj
sjQu6HBElhwbhKk3Q9Eeju1LIjk6Y6SLuRAAHxKXiuCUGS8C0/lAwmyMQm8pWDEa
eqOXq4vopnaH4Q5rdTbQhBxANGEGDLUenTXrLlJw2fYS5FZl8NLCdKIqdwknrN3x
+xKZycWyMTqXcdk64Lb/d2MGocwuSP0VCTzNWEivY3JB1qDgw1uYUg+PrTiOHxtM
GGiKUDmj3sCluBKO8Ouuql/rPYJI7gwZW0UtgadlJpNk2z6cS6nDY1fzPa+H0vwL
0UoHw9cj8f9xtBFApA+EZ05wpfdTIHZWHV50JgSLNvEW+qi9Rm3/1bdUHRkPlNpd
C4MlLIESOdI2aiWi/kd1SzePn2VVN3wiQcYncx7ywYd5GerICqlLmdt8ZJCLsdAk
96du/JEMPJnA0ts2yXFt6OmzKLC55lZX+96boOif+7QxwILEpNgG34cjBrvoZQdD
ekYlGLlugjsUKqukZWfw
=tKML
-----END PGP SIGNATURE-----

--Apple-Mail=_496132D2-E2E2-4ECF-B007-9AB832402329--

