From: martin f krafft <madduck@madduck.net>
Subject: Extending a =?iso-8859-1?Q?4=D73Tb?= RAID10
Date: Tue, 9 Jul 2013 20:22:22 +0200
Message-ID: <20130709182222.GA3952@fishbowl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

We have a RAID10 across 4 3TB drives (metadata version 1.2,
2 offset-copies, bitmaps), with LVM on top. We are running out of
space, but we don't really want to invest in 4 new 4TB drives right
now.

Is it possible to replace only two of the 3TB drives with 4TB drives
and get an extra terrabyte into the array somehow?

Anything I tried so far on a test system didn't work. I can add the
new devices to the RAID, but if I try to grow the array to the new
size, I get:

  mdadm: component size of /dev/md2 unchanged at X

Do I have to fail two drives, create a new RAID10, add a new LVM PV
on it, and pvmove the data over, all the while hoping that none of
the four disks die =E2=80=94 even though there is a backup (the two failed
drives), that's a one-shot backup and that is too risky.

That said, it isn't even possible to have a RAID10 across 2x2 pairs
of disks with different sizes, is it? Why not? I'd really rather
avoid pulling two RAID1s together with LVM, although I guess that is
essentially the same as RAID10.

Thanks,

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"the pure and simple truth is rarely pure and never simple."
                                                      -- oscar wilde
=20
spamtraps: madduck.bogus@madduck.net

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQLvBAEBCgDZBQJR3FTcwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xPFz
EADF3Un7xVhWbgx4V9ag5fc2iO0dFldooHr0olrvwwx4Jy+ojWu7oVb6ASaoHoZG
9OYEfsuqi9Y52pqFZlpQJy4wmhrRjOAx9n4hzpvRLj8yNKWBHdTSFGqQ4IVBNczy
hoko9y+69IxdIX/hgQaCUeNBt6MOqE4C4Bb3YeN4xrYpV/v3c8+78aQCiydnFRYL
0SGHEoAOo1f+p58IawapP1IhrLgRXmX5Sn6lm+37s8pfRoGiei0C0BJgid71j3AD
kPBu+bVbZzYzuogHmsBNCJ3Fkh3TVBiJHVFTrxYgdRqtXUvpsQbeDCw8/atypYtT
mIqBIpSWtDCu1WFZt/ByVyR2ydmczrt2wpKTpFx2VgcONPYAeUdft4eYeMPMpJv+
tAGXYN+QmCHrzhMlYZHwI894T0mBWj8xcQGnjmDoHflFTJfPaGal9krWXQjlPadg
1Pb4uEgV8Z2eMBuufeNuA4mHnbAv1vKBXE3YZJIHTjdWTY0i+yiMZ3B603ITvgyq
6t6REELcSayigzBSQ1MThqkiY7LXTyB00onk6ZWOIiePJzKAQVytkDzjp4T+DSxz
u3JCAKaDyRHz7/VBDCQ+FwB+6ezsUL6B/pMArqoD5+CT9JwLCmNwXjD5BjLIEaY1
fol/TmFxnYB9qSF0euuc9kd+3JUDzOuNfV1mLa55fXSnFA==
=ddxc
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--

