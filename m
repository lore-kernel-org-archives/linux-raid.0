From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: Add ability for disable bad block management
Date: Wed, 30 Nov 2011 11:14:03 +1100
Message-ID: <20111130111403.7efd3875@notabene.brown>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+90My9rDqI2YZClTEcan=Qs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/+90My9rDqI2YZClTEcan=Qs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Nov 2011 13:19:53 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When external metadata doesn't support BBM, mdadm cannot answer correctly
> for BBM requests. It causes reshape process being stopped.
>=20
> Add ability for external metadata /mdadm/ to disable BBM via sysfs.
> md will ignore bad blocks as it is for metadata v0.90.

This should not be necessary.

The intention is that a device with a bad block looks exactly like a device
with a failed device.  i.e. 'faulty' and 'blocked' appear in the 'state'
file.

If the metadata doesn't support a bad-block list, it will record that the
device has failed and will unblock the device.  At that point the failure is
forced.
If the metadata does support a bad block list it will just record the bad
blocks and acknowledge them, and the unblock the device.  At that point the
device won't be failed, the 'faulty' state will disappear, and it will
continue to be used with the known bad blocks.

What exactly is going wrong that makes you think you need this patch?

NeilBrown



--Sig_/+90My9rDqI2YZClTEcan=Qs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtV1Sznsnt1WYoG5AQIe9w//XSUfsa/YOjQszMlClE5EEFVqPcWQo/Jr
AeNzjsi7pCkEO2xBYYaI4LRH49rfD2kiN+GQp/76zQxTKoe9ASW3IhCVVjBDiMeI
3sSHmJyDs31znxcMkpoUT61l6LPLsaOXJ2ivIntPDkRKBBu2+u0VgL1E1KwsbOXF
POpFbbQHQuUYszhlps8RQMHwZv7jVpjYXJMWQXruazAyEfWJetswno5unU2DO9CC
67nk01ssVi3LIF4H+KULsnzxHbz3CmLHi0w6LEZi82S8oxM5mZ2FCBEMxni/XMH2
kqkCXgmP7Khitr08kTLa/IwR6QZdkJPjEARAHSu2LXDLtc1MwgNKC72vVO9AkTIJ
lDS/MaAgbickd4UIP7N8ZEi93BfJYyKIDHcKdLnMnKahPtIp3FTha5rK9vnP7Yq2
4WYf+HZBwbu2a0M/AMdVA1MZLmEzAlzrD/BNLuk86i1QflA+2XPctghS+JWf2CoX
yCLV6NcYEOFjyuxlrWJ69CbBGemFm1jaVyt0szKhI7YL4d6xc0RNQfgW23L95e7t
yuk9rRdMFZkAoSCHgdGeShXr0LpiQVcR34dDHQvargtsZkt3jKTmGacHwPJczaqq
RSNLhkrnPhPBwBjtdexC+Hxfub9GJwVZEYvE9wiaqKHixRqf3tY/q1AVqGm/Xb7T
ltRMU3I5Ojs=
=QFIA
-----END PGP SIGNATURE-----

--Sig_/+90My9rDqI2YZClTEcan=Qs--
