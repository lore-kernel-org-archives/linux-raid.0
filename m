From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Manually fail a disk?
Date: Sun, 19 Jan 2003 08:29:53 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030119132953.GA18651@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



  I've got a disk that's starting to fail hard.  It's generating alot of
errors in dmesg and /var/log/messages.  If the raid disk gets any usage
it'll lock up the box it's spewing errors so fast.  I can't get out to
physically yank the disk until Tues but need it off-lined now.  Is there
a way to tell mdtools (version 0.42-33) to mark a disk faulty and not
use it?

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


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+KqhQPvY/pfyW1AURArK0AJ48BFN3/TI0s0NWhCRjKxxaBVD3GgCbBnMG
Nkv8tBn/dV0f3K2VjCxnKig=
=ZPIU
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
