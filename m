From: martin f krafft <madduck@madduck.net>
Subject: RAID10 copies and missing devices on init
Date: Sun, 30 Sep 2012 09:15:27 +0200
Message-ID: <20120930071527.GA8519@albatross.gern.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear list,

just a quick question to void a concern I had last night:

If I set up a RAID10 with offset=3D3 layout across 4 disks, but I only
provide 3 of them at array creation, MD will not just put a copy of
each data block onto each of the three disks, right?

Only every 4th block will be stored 3 times on the 3 disks, the
other 3 blocks will get stored twice only, until the fourth disk is
added into the array.

If this weren't the case, then setting up a system RAID10 system
with missing devices would mean that the initial system setup would
not be redundantly stored and the disks initially present would
become points of failure that the other redundant disks could not
prevent.

Is this correct?

Thanks,

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
philosophy: unintelligible answers to insoluble problems.
=20
spamtraps: madduck.bogus@madduck.net

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQLvBAEBCgDZBQJQZ/GOwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xOQ6
D/4sdU8SHef1Q+bKCCi+oT/KIx4KSHnjILerRHYTEdbx1tb/vJQ1/bBoi3TstNms
pq7JprFS3xPRvrIKptMRevjQamT+7PhZVTbblNgtxGipmid1IhaJSZAF4GQX+wnm
tjPm2ud+TTBgbBG4Pd02r8AqVc3bEGfRdh4TfM3YF3XIbISBv41E+oNMxsRtNWCR
KIPjYQNjTMotWBNDnw5hxGLyINbUDU6J91qLYzzYGySESVLdoeHRgiifjuI1DVZE
UAaN1oYqATphScwR8DKUcs2flnq4RHYcTKptB0YLwR0pJsO5FWYLyNuudd14PrxN
GdXB9VxBLEk2eUYKbJYP0Fg9HjRlydCelTgWFgngmblyB0Ia7LIYK2NCUm3uQLzo
uCzbR1Ka53H5wrIBlvKR0Ql3azDfcXR6N98cf825KxYS5j203xDUh/aavQMevbnL
Z4PMJLPGWt/hAcaaAPo8AFIFBGhF3GNo7FOpWnZB9brohnqBs/nIP8CJTRVGOnSJ
6NSP2totszvIfMwdaxdWg18zP8qFhBgLtdLE+baMLSUMo6N8+aAQkKmDnxDZ0joj
BpDnD/R6D7X/V7hLYHALj4fwOyp+M1l8FEqELAIjKULerTRY+e6E/u+VigiMo229
DzQrRhyLsgYsrnXB2G2TShb1gQAqVpxchRpZQ2TN5xbugw==
=+tVQ
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--

