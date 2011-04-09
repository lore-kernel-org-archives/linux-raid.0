From: Roman Mamedov <rm@romanrm.ru>
Subject: RAID0 as a member of RAID6
Date: Sun, 10 Apr 2011 02:22:29 +0600
Message-ID: <20110410022229.75557cf6@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YG/UUaDGXcu+Qj/B+niliyY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YG/UUaDGXcu+Qj/B+niliyY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

In the process of upgrading my RAID array(s), I got to a situation where I =
use
a RAID0 of two 1TB disks as a member in RAID6 made mostly of 2TB disks.

Since I use a 64KB chunk size on the RAID6, I thought that for performance
it'd be better to also use a 64KB chunk in the RAID0.

However:

Is there anything special that needs to be done, to ensure that the 64K chu=
nks
of the top-level array align right into the lower-level (RAID0) chunks one =
to
one, and without any kind of a shift?

The superblock versions are 1.2 on both RAID6 and RAID0.

--=20
With respect,
Roman

--Sig_/YG/UUaDGXcu+Qj/B+niliyY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2gwAUACgkQTLKSvz+PZwgj6QCfUHQyI5gtA3VDK4x4O2d18/hs
cOgAnjMONS34cjZxNIT6IkBp2+XXRfM0
=mE96
-----END PGP SIGNATURE-----

--Sig_/YG/UUaDGXcu+Qj/B+niliyY--
