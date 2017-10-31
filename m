From: John Crisp <jcrisp@safeandsoundit.co.uk>
Subject: Raid 6 recovery
Date: Tue, 31 Oct 2017 16:42:27 +0100
Message-ID: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RLPuF8X6mXqCqwCqXurtOhmU4dPCuSgkq"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RLPuF8X6mXqCqwCqXurtOhmU4dPCuSgkq
Content-Type: multipart/mixed; boundary="Kr5xHWXpdNjLCkF5dS6Khq9FmCWhDwnfb";
 protected-headers="v1"
From: John Crisp <jcrisp@safeandsoundit.co.uk>
To: linux-raid@vger.kernel.org
Message-ID: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
Subject: Raid 6 recovery

--Kr5xHWXpdNjLCkF5dS6Khq9FmCWhDwnfb
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi,

Returning once again to this list for some help and advice.

Long story short I have a failed Raid 6 array that I would like to try
and recover. The data is not vitally important as I have most of it in a
number of other places, but I'd like to try and resurrect the array if
possible, as much to learn as anything.

The array had an issue some while ago, but as I had no space to store
any recovered data I left the machine off.

The OS is Xubuntu 14.04

The system consisted of a boot/OS array with two mirrored drives (which
is fine), and then a Raid 6 data array which consisted of 8 300Gb Ultra
Wide SCSI drives. 7 were in the array with a spare (if my memory serves
me correctly).

As far as I remember the machine suffered a power failure. When it
powered up again, the system tried to restore/rebuild the array. During
this I think the power failed again (don't ask.....) It suffered at lest
one disk failure. I then left it off to try another day.

Drive layout is as follows:

RAID 1 mirror /dev/sda + b

RAID 6 array /dev/sd[cdefghij]

/dev/sdd was dead and has been replaced.

As far as I remember I created the array, then added a partition and
then LVM (possibly not a good idea in hindsight). So none of the
individual drives show a partition......

I had a good read here and created some of the scripts.

https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID

Here is some of the output I have got so far. Any advice appreciated.

B. Rgds
John



root@garage:~# sed -e '/^[[:space:]]*$/d' -e '/^[[:space:]]*#/d'
/etc/mdadm/mdadm.conf
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
HOMEHOST <system>
MAILADDR root
DEVICE partitions
ARRAY /dev/md0 metadata=3D1.2 name=3Dgarage:0
UUID=3D90624393:3b638ad8:9aeb81ca:fa3caafc
ARRAY /dev/md1 metadata=3D1.2 name=3Dgarage:1
UUID=3Df624610a:b711ff4b:3b126550:a8f78732
ARRAY /dev/md/Data metadata=3D1.2 name=3Dgarage:Data
UUID=3D1a2f92b0:d7c1a540:165b9ab7:0baed449


cat /proc/mdstat

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : inactive sdf[3](S) sdh[5](S)
      585675356 blocks super 1.2

md1 : active raid1 sda5[2] sdb5[3]
      292674368 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sda1[2] sdb1[3]
      248640 blocks super 1.2 [2/2] [UU]

unused devices: <none>

mdadm --stop /dev/md127


Notice the following will not work with /dev/sdc1 as there is no
partition on the drive. Have to use /dev/sdc :

UUID=3D$(mdadm -E /dev/sdc|perl -ne '/Array UUID : (\S+)/ and print $1')
echo $UUID
1a2f92b0:d7c1a540:165b9ab7:0baed449

DEVICES=3D$(cat /proc/partitions | parallel --tagstring {5} --colsep ' +'=

mdadm -E /dev/{5} |grep $UUID | parallel --colsep '\t' echo /dev/{1})

echo $DEVICES
/dev/sdc /dev/sde /dev/sdf /dev/sdh /dev/sdi


Create overlays:

root@garage:~# ./overlayoptions.sh create
Currently set device are
/dev/sdc /dev/sde /dev/sdf /dev/sdh /dev/sdi
Input is create
Creating Overlay
free 235071M
Clear any old overlays
Removing Overlay
/dev/sdc 286102M /dev/loop0 /dev/mapper/sdc
/dev/sde 286102M /dev/loop1 /dev/mapper/sde
/dev/sdf 286102M /dev/loop2 /dev/mapper/sdf
/dev/sdh 286102M /dev/loop3 /dev/mapper/sdh
/dev/sdi 286102M /dev/loop4 /dev/mapper/sdi


root@garage:~# mdadm --assemble --force /dev/md127 $OVERLAYS
mdadm: clearing FAULTY flag for device 3 in /dev/md127 for /dev/mapper/sd=
h
mdadm: Marking array /dev/md127 as 'clean'
mdadm: failed to add /dev/mapper/sde to /dev/md127: Invalid argument
mdadm: failed to add /dev/mapper/sdi to /dev/md127: Invalid argument
mdadm: /dev/md127 assembled from 2 drives and  1 rebuilding - not enough
to start the array.



root@garage:~# mdadm --examine /dev/sd[cdefghij] |grep Event
         Events : 1911
         Events : 1911
         Events : 1910
         Events : 1910
         Events : 1911

(Two drives have older Events)




root@garage:~# mdadm --examine /dev/sd[cdefghij]
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1a2f92b0:d7c1a540:165b9ab7:0baed449
           Name : garage:Data  (local to host garage)
  Creation Time : Mon Sep  8 16:44:06 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 585675356 (279.27 GiB 299.87 GB)
     Array Size : 1464186880 (1396.36 GiB 1499.33 GB)
  Used Dev Size : 585674752 (279.27 GiB 299.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 9b89d817:36633ebf:6d30d5ea:5bba21a0

    Update Time : Sun Jan  8 13:47:20 2017
       Checksum : 448c93b2 - expected 448c93b1
         Events : 1911

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd:
   MBR Magic : aa55
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1a2f92b0:d7c1a540:165b9ab7:0baed449
           Name : garage:Data  (local to host garage)
  Creation Time : Mon Sep  8 16:44:06 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 585675356 (279.27 GiB 299.87 GB)
     Array Size : 1464186880 (1396.36 GiB 1499.33 GB)
  Used Dev Size : 585674752 (279.27 GiB 299.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 3ee17acf:73dabec5:22dd87f5:981b904f

    Update Time : Sun Jan  8 13:47:20 2017
       Checksum : bcd07086 - expected bcd07085
         Events : 1911

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1a2f92b0:d7c1a540:165b9ab7:0baed449
           Name : garage:Data  (local to host garage)
  Creation Time : Mon Sep  8 16:44:06 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 585675356 (279.27 GiB 299.87 GB)
     Array Size : 1464186880 (1396.36 GiB 1499.33 GB)
  Used Dev Size : 585674752 (279.27 GiB 299.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6b8031bd:2a03c716:c2633b9f:f3b0a1d1

    Update Time : Sun Jan  8 13:42:11 2017
       Checksum : 2757532f - correct
         Events : 1910

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdg:
   MBR Magic : aa55
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x12
     Array UUID : 1a2f92b0:d7c1a540:165b9ab7:0baed449
           Name : garage:Data  (local to host garage)
  Creation Time : Mon Sep  8 16:44:06 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 585675356 (279.27 GiB 299.87 GB)
     Array Size : 1464186880 (1396.36 GiB 1499.33 GB)
  Used Dev Size : 585674752 (279.27 GiB 299.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 0 sectors
          State : clean
    Device UUID : 03670c0d:342627ae:391927a0:d8ba78d4

    Update Time : Sun Jan  8 13:42:11 2017
       Checksum : 12551c41 - correct
         Events : 1910

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1a2f92b0:d7c1a540:165b9ab7:0baed449
           Name : garage:Data  (local to host garage)
  Creation Time : Mon Sep  8 16:44:06 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 585675356 (279.27 GiB 299.87 GB)
     Array Size : 1464186880 (1396.36 GiB 1499.33 GB)
  Used Dev Size : 585674752 (279.27 GiB 299.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e8587c1b:e9c60b00:18e20a16:1b145b10

    Update Time : Sun Jan  8 13:47:20 2017
       Checksum : 246cd221 - expected 246ad21f
         Events : 1911

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : A.AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj:
   MBR Magic : aa55


--Kr5xHWXpdNjLCkF5dS6Khq9FmCWhDwnfb--

--RLPuF8X6mXqCqwCqXurtOhmU4dPCuSgkq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJZ+JnjAAoJEE8bo8Tv0FrJ0K4H/ivbrgHBG3eIt+Zfk52Aqrlc
p92T5r44R9D5fquemYtHH/qlLWoB/A8WvjV4kjPaSqFrJLWEy3LNoMKNJiqHjuax
cFbKaL4lEq41JLlLW3OKu7KzHv7DE6J5HhvY4M/o2vbtMjd2PPmFo+GTOfq96dvz
nFoeBJcEjlMCEWsVi1ORRd7E8gRlGaG+z76c3Q8GC5aAIZPEx15Ag01YtW4SE00e
DqJRECTKVW2AZwamCInemhxNqwEuoRBjt3e1IR5NxFGFd2soGpcdvOUKWGpZlWIh
CFV3SadyytHDvJG01U9V2wqa6nk93U3IthM64OvwOUerK9Z99Ly0g3xQopnyXbk=
=/6sB
-----END PGP SIGNATURE-----

--RLPuF8X6mXqCqwCqXurtOhmU4dPCuSgkq--
