From: Hans-Joachim Baader <hjb@pro-linux.de>
Subject: Using array without initializing
Date: Mon, 21 Oct 2013 18:37:12 +0200
Message-ID: <20131021163711.GA10854@kilauea.hjbaader.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have a problem that might be a bit unusual.

Using an Intel 82801, we create in the BIOS a RAID 5 with 3 disks,
spanning the whole disks. After that we boot Linux via the network
into an initial ramdisk (buildroot) to assemble and format the array.
Currently I use kernel 3.7.8, mdadm 3.2.6 and the following commands
to start the array:

    mdadm --assemble --scan -e imsm
    mdadm --incremental -e imsm /dev/md/imsm0

After the first command, /proc/mdstat looks like this:

Personalities : [raid6] [raid5] [raid4]=20
md127 : inactive sdc[2](S) sda[1](S) sdb[0](S)
      9459 blocks super external:imsm

After the second command, Linux starts to initialize the array:

Personalities : [raid6] [raid5] [raid4]=20
md126 : active raid5 sda[2] sdb[1] sdc[0]
      1953497088 blocks super external:/md127/0 level 5, 128k chunk, algori=
thm 0 [3/3] [UUU]
      [=3D>...................]  resync =3D  5.5% (54541952/976748672) fini=
sh=3D86.5min speed=3D177664K/sec
     =20
md127 : inactive sdc[2](S) sda[1](S) sdb[0](S)
      9459 blocks super external:imsm

Here is the complete output of mdadm -E /dev/sd*:

/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.02
    Orig Family : 04e27e25
         Family : 04e27e25
     Generation : 00000053
     Attributes : All supported
           UUID : 8d359434:ec976aca:274c42c2:0b38bc28
       Checksum : 9b719f6c correct
    MPB Sectors : 2
          Disks : 3
   RAID Devices : 1

  Disk00 Serial : Z1D4N2AZ
          State : active
             Id : 00000000
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

[Volume1]:
           UUID : 7dfa2a6f:6dc8e907:f0559321:3fab80ea
     RAID Level : 5 <-- 5
        Members : 3 <-- 3
          Slots : [UUU] <-- [UUU]
    Failed disk : none
      This Slot : 0
     Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
   Per Dev Size : 1953497352 (931.50 GiB 1000.19 GB)
  Sector Offset : 0
    Num Stripes : 7630848
     Chunk Size : 128 KiB <-- 128 KiB
       Reserved : 0
  Migrate State : initialize
      Map State : normal <-- uninitialized
     Checkpoint : 141111 (768)
    Dirty State : clean

  Disk01 Serial : Z1D4MN2C
          State : active
             Id : 00000001
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

  Disk02 Serial : Z1D4MNG0
          State : active
             Id : 00000002
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.02
    Orig Family : 04e27e25
         Family : 04e27e25
     Generation : 00000053
     Attributes : All supported
           UUID : 8d359434:ec976aca:274c42c2:0b38bc28
       Checksum : 9b719f6c correct
    MPB Sectors : 2
          Disks : 3
   RAID Devices : 1

  Disk01 Serial : Z1D4MN2C
          State : active
             Id : 00000001
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

[Volume1]:
           UUID : 7dfa2a6f:6dc8e907:f0559321:3fab80ea
     RAID Level : 5 <-- 5
        Members : 3 <-- 3
          Slots : [UUU] <-- [UUU]
    Failed disk : none
      This Slot : 1
     Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
   Per Dev Size : 1953497352 (931.50 GiB 1000.19 GB)
  Sector Offset : 0
    Num Stripes : 7630848
     Chunk Size : 128 KiB <-- 128 KiB
       Reserved : 0
  Migrate State : initialize
      Map State : normal <-- uninitialized
     Checkpoint : 141111 (768)
    Dirty State : clean

  Disk00 Serial : Z1D4N2AZ
          State : active
             Id : 00000000
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

  Disk02 Serial : Z1D4MNG0
          State : active
             Id : 00000002
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
/dev/sdc:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.02
    Orig Family : 04e27e25
         Family : 04e27e25
     Generation : 00000053
     Attributes : All supported
           UUID : 8d359434:ec976aca:274c42c2:0b38bc28
       Checksum : 9b719f6c correct
    MPB Sectors : 2
          Disks : 3
   RAID Devices : 1

  Disk02 Serial : Z1D4MNG0
          State : active
             Id : 00000002
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

[Volume1]:
           UUID : 7dfa2a6f:6dc8e907:f0559321:3fab80ea
     RAID Level : 5 <-- 5
        Members : 3 <-- 3
          Slots : [UUU] <-- [UUU]
    Failed disk : none
      This Slot : 2
     Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
   Per Dev Size : 1953497352 (931.50 GiB 1000.19 GB)
  Sector Offset : 0
    Num Stripes : 7630848
     Chunk Size : 128 KiB <-- 128 KiB
       Reserved : 0
  Migrate State : initialize
      Map State : normal <-- uninitialized
     Checkpoint : 141111 (768)
    Dirty State : clean

  Disk00 Serial : Z1D4N2AZ
          State : active
             Id : 00000000
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)

  Disk01 Serial : Z1D4MN2C
          State : active
             Id : 00000001
    Usable Size : 1953518862 (931.51 GiB 1000.20 GB)


This would all be perfect if we did use Linux on the machine. However, afte=
r dumping
a MS Windows image on it, the machine is shipped to customers, and it is re=
quested
that we don't initialize the array, so that the resync happens when the cus=
tomer
starts it. Apparently MS Windows has a mode to use the array without initia=
lizing it
until requested. (I guess it initializes only the parts of the array that a=
re
actually used, so that it never needs to be initialized explicitly.)

Is this possible with Linux too? Is it reasonable at all? Unfortunately, th=
e option
--assume-clean is not allowed in this mode, and I found no other option tha=
t could help.

Thanks
Hans-Joachim
--=20
Pro-Linux - Germany's largest volunteer Linux support site
http://www.pro-linux.de/          Public Key ID 0x3DDBDDEA

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iD8DBQFSZVg3LbySPj3b3eoRAlavAKCSOmKSoqmu68WB1UpUZIJ4zVE7nACfTpLb
f/ws5fdB8FvPM9+3zWJ0eaw=
=CXgU
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
