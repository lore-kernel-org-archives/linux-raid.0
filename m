From: Roman Mamedov <rm@romanrm.ru>
Subject: Few questions about TRIM/discard
Date: Sun, 19 Aug 2012 01:35:27 +0600
Message-ID: <20120819013527.55c1a55f@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BvbOeIlzDrvDp_d8lmxIyYO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/BvbOeIlzDrvDp_d8lmxIyYO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Setting up a new array and have a couple of questions, maybe someone can
clarify. Thanks in advance.

- Does md in the 3.4.8 kernel support passing discard to SSDs in RAID1?

- Will it still work if a RAID1 has not only SSD members, but also an HDD?

- How to verify that TRIM works properly (i.e. actually being issued)?

- Is TRIM usage generally recommended and not known to cause problems on an
older generation SandForce controller (in a Corsair F60-A)? And on a newer
SandForce (Adata S511)?

Feel free to ignore some (or all) of these questions. :)

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/BvbOeIlzDrvDp_d8lmxIyYO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAv7n8ACgkQTLKSvz+PZwhX+wCfU5DMBGJNai3KaqulfccMUtOB
o4YAniYCnwGEpppOUfPJ74tP1OIIS7Jn
=Nd6y
-----END PGP SIGNATURE-----

--Sig_/BvbOeIlzDrvDp_d8lmxIyYO--
