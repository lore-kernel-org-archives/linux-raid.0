From: Davide Guarisco <guarisco@sbcglobal.net>
Subject: Re: Recovering RAID set after OS disk failed
Date: Mon, 2 Jun 2014 22:49:36 -0700
Message-ID: <A2FAF98E-1CEC-41C5-8AA4-9CE707A477F6@sbcglobal.net>
References: <7C19F7E4-7354-4C2C-A53E-DA546B569201@sbcglobal.net> <000801cf7e5f$53ffce20$fbff6a60$@kovari.priv.hu>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C8B50CF9-BE36-4D99-8FF4-AAB50A1256E5"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000801cf7e5f$53ffce20$fbff6a60$@kovari.priv.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_C8B50CF9-BE36-4D99-8FF4-AAB50A1256E5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Peter, thanks for your help. Below are the answers.


On Jun 2, 2014, at 05:36, K=C5=91v=C3=A1ri P=C3=A9ter =
<peter@kovari.priv.hu> wrote:

> Hi Davide,
>=20
> Open / ssh a console on your NAS box, and issue the following command =
and send us the results:=20
> $ cat /proc/mdstat


Personalities :
unused devices: <none>



>=20
> Please also issue the following commands
>=20
> mdadm --examine /dev/sdX[Y]

$ mdadm =E2=80=94examine /dev/sdb
mdadm: cannot open /dev/sdb: Permission denied


$ sudo mdadm =E2=80=94examine /dev/sdb
/dev/sdb:
	MBR Magic : aa55
Partition[0] : 1953520002 sectors at       63 (type fd)


$ sudo mdadm =E2=80=94examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to host =
gecko)
  Creation Time : Tue Mar  3 23:27:50 2009
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed May 28 21:52:54 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 2d5185d8 - correct
         Events : 46

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1


> mdadm --examine /dev/sdc1

/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f8a943c7:2ffa13d0:9770de34:eca2e81c (local to host =
gecko)
  Creation Time : Tue Mar  3 23:27:50 2009
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed May 28 21:52:54 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 2d5185ea - correct
         Events : 46

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1


=E2=80=A6etc. So it seems to me that we are OK, with the RAID 5 set =
setup on /dev/sdb1, /dev/sdc1, /dev/sdd1, /dev/sde1.

>=20
> Where X is one of the raid drive's name and Y is the partition number, =
if you created the raid set on partitions. (If not, then leave the =
number.) So, for example (assuming that your OS drive is /dev/sda, so =
your raid drives are /dev/sdb, /dev/sdc and so on) issue the following =
commands:
>=20
> $ mdadm --examine /dev/sdb
> or
> $ mdadm --examine /dev/sdb1
>=20
> and so on for all 4 drives. And send back the results.
>=20
> p.s.
> Before everything else,  you might try  auto assembling th eset by:
> $ mdadm -v --assemble =E2=80=94scan

Trying this holding my breath=E2=80=A6.

> mdadm -v --assemble --scan

mdadm: looking for devices for /dev/md0
mdadm: no recogniseable superblock on /dev/dm-1
mdadm: no recogniseable superblock on /dev/dm-0
mdadm: no RAID superblock on /dev/sde
mdadm: no RAID superblock on /dev/sdd
mdadm: no RAID superblock on /dev/sdb
mdadm: no RAID superblock on /dev/sdc
mdadm: no RAID superblock on /dev/sda5
mdadm: no RAID superblock on /dev/sda2
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
mdadm: added /dev/sdc1 to /dev/md0 as 1
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: added /dev/sdb1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 4 drives.


OK, this seems successful as well. My RAID is /dev/md0.=20




>=20
> It might assemble your raid set for you successfully out of the box.  =
(If not, send here the output.)
> If this assembles your set successfully, then you just need to save =
your config in /etc/mdam/mdadm.conf, do an initramfs update and you are =
good to go.
> So to save the config issue:
> $ mdadm --examine --scan >> /etc/mdadm/mdadm.conf

> cat /etc/mdadm/mdadm.conf

ARRAY /dev/md0 UUID=3Df8a943c7:2ffa13d0:9770de34:eca2e81c



>=20
> then update initramfs so th eset will auto assmble on next boot:
> $ update-initramfs -k all -u

> update-initramfs -k all -u

update-initramfs: Generating /boot/initrd.img-3.13.0-24-generic



But now:

> sudo fdisk -l

Disk /dev/md0: 3000.6 GB, 3000606523392 bytes
2 heads, 4 sectors/track, 732569952 cylinders, total 5860559616 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 131072 bytes / 393216 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn=E2=80=99t contain a valid partition table



How do I fix this and how to I gain access to /dev/md0?

Thanks,
	Davide







--Apple-Mail=_C8B50CF9-BE36-4D99-8FF4-AAB50A1256E5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJTjWHwAAoJEOP6S0R9UICWM/EP/1+ZKqxTkF0cN9CDBzuVgdDY
xxQQByxw26BHVXJo0d8wqSwU/shS+m5sRai+IlRz39e0dHczWZJGR5CkCd2OKy/m
uqGsSf4xM4N7GehEFAktrQm86N8FReNNPm0//De1n3zUIGDdWfdNyeqvItgUFxjw
WJkuOyXhrXGtXiv9gU4Dtb4yess8mBYbV4nWufPFk9DtkzSLkB8YnrD4tHOk+I5W
j7sVLq6/oMgAqRUZ+/1CtRPB/Rq5S/NzxnG2k1hkdzOuG3v8mC3H490m8ve4CBLs
i2oNtXmKlpOYwP2FFw354b38W/GZYwM/mcBmqnEaUGPHcvsR1Ryv6eXdhlI8XqEc
p2HVM/lmm4mFp+3lq++SHKcHuAK3VLYAiitc5Wd0r8sbYXmzk/hBuqHQNxP0BY1O
GJPXOTgUUbIYpi0Xvo9uB3S96jFLSIicM5QocioBU2b4aqfeECWS0818UKp0O6An
ur9hP1a4We0y3AemzNuofhFcaH0fZne6n9hCPkmno6aDc7HEvwct3pE8TOcMET7Z
lyisKDRTYiKTRH08CFJLT1zITyFDLrUhLBPWf1ns9U29/hOMI35PImXN4D70mg2c
tLXrD0Zkt5905eLHoxGh+3iY8BEe82VxiQW06pYa0ZGuhDsT0vv0fEFLoReiIswF
Tq6dMgKVqB1HQxsFf6up
=g/d8
-----END PGP SIGNATURE-----

--Apple-Mail=_C8B50CF9-BE36-4D99-8FF4-AAB50A1256E5--
