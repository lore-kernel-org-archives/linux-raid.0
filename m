From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: raidtab -> mdadm conf file?
Date: Wed, 19 Feb 2003 15:25:16 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030219202516.GC13439@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



  I currently have about 30 machines using raidtools and /etc/raidtab. =20
Does anyone have a script that will generate a complete mdadm conf
file based on a raidtab or output from mdadm --detail?  While mdadm may
not need need the conf file once it's built etc I like to keep them
around in the event we have to rebuild an array that's destroyed (2+
disks out of a RAID5 Array)) to an identicle, standard format.

Robert


:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | PGP Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.
FYI:
 perl -e 'print $i=3Dpack(c5,(41*2),sqrt(7056),(unpack(c,H)-2),oct(115),10)=
;'


--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+U+gs8+1vMONE2jsRAs6/AKCqUJDJlcT+UfRUn0NVzuCMMps5FACfYCUs
71UT54r59GggxyvW1GcqIjo=
=tZU0
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
