From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: What is needed?
Date: Wed, 19 Mar 2003 09:50:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030319145030.GD4955@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Scenario:
  Debian Woody Distro
  Kernel 2.4.16 with RAID compiled in
  System with 2 scsi disks, sda sdb

  root (/) is built out on /dev/md1 (dev/md0 is pre-allocated for
    something else)

  /dev/sda has a hardware failure and dies
    System should detach sda1 from md1 and continue on

  1) If the disks are hotswapable then sda should be able to be replaced
     and synced up normally correct?
  2) If for some reason the system has to be booted off of /dev/md1
     without /dev/sda would it be a matter of putting a floppy in the
     drive that has a kernel written to it with dd and then use rdev to tell
     it to boot /dev/sdb1 instead of sda1?

  Anyone have a good walkthrough of setting something like this up?  I'd
like to answer all the questions before I take it to my boss.

Robert


:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+eIO28+1vMONE2jsRAtQhAKDESZ7x05OYpU6zhtLMNx8C7zfaPwCfQ2kw
5Ge5kWibV2tNeye1vG/5H6w=
=5qmZ
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
