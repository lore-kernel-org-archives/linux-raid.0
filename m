From: Steven Haigh <netwiz@crc.id.au>
Subject: RAID6 - whole disk vs partitions
Date: Sun, 20 Dec 2015 01:34:25 +1100
Message-ID: <56756AF1.7050005@crc.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MQCbQwASFkFObX6dcagWFjiwbndl3DmqQ"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MQCbQwASFkFObX6dcagWFjiwbndl3DmqQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

I'm revisiting this topic after a few years - so excuse me if I'm a
little behind the times on this questioning.

I'm just starting to replace some 5 year old disks in a RAID6 (5 disks)
due to one having started to throw uncorrectable / reallocated sectors.
As such, it seems a good time to go to 3Tb drives - which are only $20
more than 2Tb drives.

The array is created as follows:
md2 : active raid6 sdf[0] sde[6] sdg[7] sdd[5] sdc[8]
      5860150272 blocks super 1.2 level 6, 128k chunk, algorithm 2 [5/5]
[UUUUU]

I've always used the whole disk for the RAID6 - as from what I
understand, this gives the best layout for various drives - no matter if
they're 512 or 4096 byte sectors.

Is this still the case?

I've noticed that my resync speeds on this RAID6 hover around 60Mb/sec -
which I was expecting to be a bit quicker (although I haven't tested
speeds on this array for years).

Currently using kernel 4.1.15 on an EL6 install.

Would be grateful for any input people may have on these topics.

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--MQCbQwASFkFObX6dcagWFjiwbndl3DmqQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWdWrzAAoJEEGvNdV6fTHczqoP/2syRO3xRQlnyzypUhsYOvLs
0IEPOtfsNJbXWu5fkJEjmvH2CB9pqUqfB1TboPFnaBG6DtQZDFad/OEdfDSudnl1
53xo8LQ3gOsCuvAViMnXiXXdWm3RTnw+UVq+grdxjXIjkFxfbMDJCf9X6Z+VzwcG
umrw0/d1S4dkPZpCso6SVMTu0xskqlEaRoNpZfm9ZKIx2RiFJMl5fwsdcj9fDsQe
sqhNpma0l2FAe3gKwc6BE9XUVcPxFamgOaTy/AiMi4CQxyXjFsbvF7EULad+711I
CrvuaBlKkDNlGPMg4fFYrF1zPXzkb+rtwcrb/vCwGE/uQs9tovqa+HF9sOaZACSM
yenjcWig6FqBIKAiJ0Nwn2ILI0tKZklLwpWvU0mKuhM7JfQyefDSnPw8ap1yIjaj
uvI+OGTzoB/dcjzn6vOhP4y4NdRf0DQui3nN2Ndc0vcXoXRId83CuECF6+331Fx7
brX63lna0Aq3A5GjHnmNkMBkqAYeYTaFmtWcN/v53IHdLpLKdBsKzOp/vEj0E8Ki
kfrbQVfWGlF02eu2Hl8JzaKfensqjW6pO3mVBI43WN/pWKqY7+bnhrymKZjcLXzf
DihTZ4kNkdvcPri24LVtQOMA8dQgP0OyXwhKM/AaAnXMOlWHhenzneMrugjactor
lGb7iNUvT/1LSWK6VIeP
=pcFa
-----END PGP SIGNATURE-----

--MQCbQwASFkFObX6dcagWFjiwbndl3DmqQ--
