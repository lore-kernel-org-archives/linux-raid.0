From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: "failed-disk" ?
Date: Thu, 20 Mar 2003 16:22:50 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030320212250.GO13201@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w6U88vdWm8UqIXvc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--w6U88vdWm8UqIXvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



I'm trying to "mkraid /dev/md1" with the following:

raiddev /dev/md1
  raid-level 1
  nr-raid-disks 2
  nr-spare-disks 0
  chunk-size 16
  persistent-superblock 1
  device failed-disk
  raid-disk 0
  device /dev/sdb1
  raid-disk 1

I'm trying to convert this machine to raid1 on root.  Don't ask about
the md1, long story.  At any rate when I do the mkraid I get this:

root@rharris-build2:~# mkraid /dev/md1
handling MD device /dev/md1
analyzing super-block
couldn't call stat() on device failed-disk -- No such file or directory
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

root@rharris-build2.acs:~# mkraid -V
mkraid version 0.90.0

Thoughts?

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--w6U88vdWm8UqIXvc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+ejEq8+1vMONE2jsRAnglAJ9l87WKXUxkqVtwdOrfOw7bIH7uggCeKyXk
BN6f0l2wlDRh4MZohO3bC5U=
=GMhV
-----END PGP SIGNATURE-----

--w6U88vdWm8UqIXvc--
