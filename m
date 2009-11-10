From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: md0: unknown partition table - should I worry?
Date: Tue, 10 Nov 2009 23:24:44 +0100
Message-ID: <200911102324.47474.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3010034.5QVFQQK2M2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart3010034.5QVFQQK2M2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Today md0 degraded (debian 5.0 i386, raid5, 5x500 samsung sata) so I checke=
d=20
the logs and noticed on each rebootI got this in /var/log/messages:

md0: unknown partition table

md0 is all LVM2 and volumes mount fine, so is this normal?=20


=2D-=20
=2D----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
=2D-----END GEEK CODE BLOCK------

--nextPart3010034.5QVFQQK2M2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBK+egvm6TdMk9WhQ0RAhugAJ0SYLDPPmRahQE54iVrYH/M61v41ACgpXhR
OlVE/dy5TfCo9UfL6+eO3gY=
=D4ry
-----END PGP SIGNATURE-----

--nextPart3010034.5QVFQQK2M2--
