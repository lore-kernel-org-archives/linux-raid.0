From: Roman Mamedov <rm@romanrm.net>
Subject: RAID5/6 slow due to a member device -- how to diagnose?
Date: Thu, 3 Mar 2016 19:30:26 +0500
Message-ID: <20160303193026.7d08e64b@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/KE/kxrd7f0HEM5fHdj.xQgf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/KE/kxrd7f0HEM5fHdj.xQgf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Let's suppose I am seeing slow write performance on a RAID5 or RAID6, and I=
 am
suspecting that it's because of one of its devices operating slower than
others (maybe a soft-failing or just low-performing hard drive, in case with
non-identical member drives). Nothing in dmesg, no timeouts or ATA errors or
anything like that.

How would I go about diagnosing which device that is (if any) is slowing do=
wn
the array, aside from performance-testing each individual device (which see=
ms
rather difficult if it's only slow on writes, not reads).

In 'top' there's of course high iowait, 50-70% all the time during writes. =
But
is that broken down somewhere to show which particular block device is being
the most 'waited for'?

--=20
With respect,
Roman

--Sig_/KE/kxrd7f0HEM5fHdj.xQgf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbYSoUACgkQTLKSvz+PZwjzNgCfVHcbogGpnixFDU1S3bKuWrVg
nHwAn36WyXNDJqpOL3d5CB3K40b3niE5
=+M1h
-----END PGP SIGNATURE-----

--Sig_/KE/kxrd7f0HEM5fHdj.xQgf--
