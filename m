From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: force a raid restart?
Date: Mon, 27 Jan 2003 09:44:57 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030127144457.GA8989@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Scenario:

  System has 2 3ware IDE raid controllers.  Controller 1 has 8 disks
installed built out as 2 software 4disk RAID5 arrays, built using
"raidtools" mkraid.

Disk 0 (first array) physically failed array running in degraded mode.
Disk 5 (second array) failed 2 days later but at this time generated
  enough IO to hang up the controller.  This appears to have caused the
  raid subsystem to mark disk1 (first array) bad also.  It's passed a
  number of disk tests and seems ok.

  As a result md0 is dead because of disk0 and disk1.  Is there a way to
force it to restart md0 since when it read disk1 dead it just stopped
the array?  The data should all be in tact, just degraded since disk0 is
physcially dead and off for RMA?  I've installed mdadm and am reading
the docs but I need this back quickly if it's possible.

  Also, we use devfs.  I've seen in the /etc/raidtab most of the time it's
built referencing /dev/hdX or /dev/sdX.  Since these move around alot is
there any reason other than length why we shouldn't use the
/dev/scsi/host...* devices?

Robert



:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: FC96D405
                              =20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.
FYI:
 perl -e 'print $i=3Dpack(c5,(41*2),sqrt(7056),(unpack(c,H)-2),oct(115),10)=
;'


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+NUXpPvY/pfyW1AURArxJAJ9NCR+z7/CQM5qfaeCEkC/pcPcmdACeJY8j
Z6s7MEFSvnYT+an8aVRer5E=
=kO/x
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
