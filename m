From: Roger Gammans <roger@computer-surgery.co.uk>
Subject: [patch] raidstart problem -  weakness or bug
Date: Fri, 14 Nov 2003 00:07:37 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031114000736.GA26329@computer-surgery.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--xXmbgvnjoT4axfJE
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I'v decided to build a raid set for on one of my machines here=20
and while setting I did a simulated fail test so I knew what to expect
out of the fail/recovery process.

In the course of this I discover that raidstart (I used debian stable
to start with but reproduced and patched on raidtools 1.00-3)=20
won't start and array where the  first drive listed in /etc/raidtab
has failed - or more accurately whose superblock is not readable.

An afternoons read through the code has led me to suggest this
patch as a fix. No doubt the more experienced raid hands will tell
me this is wrong for some subtle reason i can't see. ;_)

So what have I got wrong ?

TTFN
--=20
Roger. 	                        Home| http://www.sandman.uklinux.net/
Master of Peng Shui.      (Ancient oriental art of Penguin Arranging)
Work|Independent Systems Consultant | http://www.firstdatabase.co.uk/
So what are the eigenvalues and eigenvectors of 'The Matrix'? --anon

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="raidtools.diff"
Content-Transfer-Encoding: quoted-printable

diff -urN raidtools-1.00.3/raidlib.c raidtools-1.00.3-rgg/raidlib.c
--- raidtools-1.00.3/raidlib.c	Wed Jan 15 08:58:25 2003
+++ raidtools-1.00.3-rgg/raidlib.c	Thu Nov 13 16:51:37 2003
@@ -460,11 +460,19 @@
       case raidstart:
       {
 	struct stat s;
+	int i=3D0;
+	for ( i=3D0; i< MD_SB_DISKS; ++i) {
+	=09
+		if (!cfg->device_name[i][0]) {
+			rc++;
+			break;
+		}
+		stat (cfg->device_name[i], &s);
=20
-	stat (cfg->device_name[0], &s);
-
-	fd =3D open_or_die(cfg->md_name);
-	if (do_mdstart (fd, cfg->md_name, s.st_rdev)) rc++;
+		fd =3D open_or_die(cfg->md_name);
+		if ( ! do_mdstart (fd, cfg->md_name, s.st_rdev))
+			break;
+	}
 	break;
       }
=20

--cWoXeonUoKmBZSoM--

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tBzIfoGIUoF6+3sRApKOAKDPAXuNl5i4R3dB7JdgKkkuec6g5QCfV9pA
6LkR6ArZCPGW43r5vYvXuT4=
=Mz3K
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
