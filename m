From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: why didn't the RAID fail?
Date: Fri, 25 Jul 2003 12:11:12 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030725161112.GV32585@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9hshNW4m6zn79FF/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--9hshNW4m6zn79FF/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



I have the following:

root@rharris:~# cat /proc/mdstat=20
Personalities : [linear] [raid0] [raid1] [raid5]=20
read_ahead 1024 sectors
md0 : active raid1 lvmb[0] lvm-vg2/lvm2[1](F)
      35413952 blocks [2/1] [U_]
     =20
md1 : active raid1 scsi/host0/bus0/target1/lun0/part1[0]
scsi/host0/bus0/target0/lun0/part1[1]
      208768 blocks [2/2] [UU]
     =20
unused devices: <none>
root@rharris:~# uname -a
Linux rharris-build2.acs.internap.com 2.4.21-ac3 #15 SMP Wed Jul 2
12:13:51 EDT 2003 i686 unknown


sda1 and sdb1 are 200Meg partitions for /
lvm-vg1/lvm1 is a stripe of sda2+sdc2=20
lvm-vg2/lvm2 is a stripe of sdb2+sdd2

  I physically hot pulled sdb out of the machine expecting
lvm-vg2/lvm2(md0) and the second mirror of md1 to fail.  The md0 mirror
broke within seconds while the md1 mirror stayed intact for over 30 mins
even with me writing 50Meg and 100Meg files to /.  It didn't mark sdb1=20
failed until I did a "pvscan".

  This just strikes me as a bit odd that it wouldn't fail much sooner as
well.  It would make sense if the root partition was 100% idle however I
did extensive reads and writes to / directly.

Robert



:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | GPG Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--9hshNW4m6zn79FF/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD4DBQE/IVag8+1vMONE2jsRAl3WAJIDSpWts8PXB3OGG1FpRMXo2EXDAJ97deOn
FZpceHGto+9dDm48NSiqyw==
=Mdxi
-----END PGP SIGNATURE-----

--9hshNW4m6zn79FF/--
