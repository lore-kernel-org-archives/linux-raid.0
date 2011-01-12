From: Roman Mamedov <rm@romanrm.ru>
Subject: Reshape RAID5 to a RAID6 with more (smaller) devices
Date: Wed, 12 Jan 2011 12:29:30 +0500
Message-ID: <20110112122930.6a17440f@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.wwkdEEC2opWGpJpQ8vm/Zf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.wwkdEEC2opWGpJpQ8vm/Zf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello!

I am considering to move my configuration in which I currently use two RAID5
arrays (3*2TB and 3*1TB) to one described in [1]. Specifically, make a 6*1TB
RAID6 plus 3*1TB RAID5 consisting of 2TB drives' "tails".

My question is: does mdadm support a simultaneous reshape, changing at once:
1) RAID5 to RAID6
2) number of devices from 3 to 6
3) individual device size from 2TB to 1TB

Note that the user-accessible space after this reshape does not change, and
remains at 4 TB. So is that supported? Will that require a backup file? Will
that proceed particularly inefficiently/slowly?

[1] http://www.linuxconfig.org/prouhd-raid-for-the-end-user

--=20
With respect,
Roman

--Sig_/.wwkdEEC2opWGpJpQ8vm/Zf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0tWFoACgkQTLKSvz+PZwieOQCePU8gUge4mYUkFuQ7kdfXVOoc
BuAAni7EiTjApn9o53SFgvOuVBlbMfri
=fte9
-----END PGP SIGNATURE-----

--Sig_/.wwkdEEC2opWGpJpQ8vm/Zf--
