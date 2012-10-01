From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --grow Hard Drive Size Puzzle
Date: Mon, 1 Oct 2012 12:55:10 +1000
Message-ID: <20121001125510.6cc0c2be@notabene.brown>
References: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r5h09Fma5v0.L9BIQAWttgy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Greenspan <aarong@thinkcomputer.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/r5h09Fma5v0.L9BIQAWttgy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Sep 2012 19:19:34 -0700 Aaron Greenspan <aarong@thinkcomputer.co=
m>
wrote:

> Hi Neil,
>=20
> I found your personal web site by doing a Google search on mdadm, so I'm =
not sure if you are the right person to ask this of, or if it's a dumb ques=
tion in the first place, but here's what I'm running into.

Yes, this is the right place to ask.
No, this is not a dumb question.


>=20
> I had a RAID 1 array on CentOS 6 (which comes with mdadm 3.2.3) of two 25=
0GB SATA Western Digital hard drives. It was finally time to upgrade their =
capacity, so I purchased two 2TB SATA Seagate hard drives. I replaced them =
one at a time, first by removing old drive B (slot 1), then copying over th=
e partitions from old drive A (slot 0) to new drive C (slot 1), and then sw=
apping the drives so that I could copy the partitions from new drive C (slo=
t 0) to drive D (slot 1).
>=20
> This generally worked fine, with one exception. As I said, the drives are=
 2TB each. Somehow I'm only being given 1TB to work with. Here's what mdadm=
 reports for the first new drive:

Should work.... what kernel are you running?  There was a bug between 2.6.30
and 2.6.37 which would have the effect.
A quick good search suggest that Centos 6 uses 2.6.32, which would be
affected until 2.6.32.27 which contains the fix.

If you reboot (or just stop the array and re-assemble it), md should get
itself sorted out and the --grow will work.

The commit that fixes the bug is  c26a44ed1e552aaa1d4ceb7

NeilBrown


--Sig_/r5h09Fma5v0.L9BIQAWttgy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGkGDjnsnt1WYoG5AQJZjQ//TiezPlJXuQKxK9PsG/U0uAHs2bDneva/
mWvNzbo12+y9ZSjcuJXeaeUtsFlsxovmn/ZMZPP/pp2cdRK45VQPG6z9sT7/3UVU
BpsYMTDpi/nCap6muZscXL5oaC5AsOh+mBz2q9kVyQWQBOt/xEXyZrnPHEqhiEfA
VDa4uRp75Whw5naz9CmDvZeOe1T4JVY435s1MXHOxGX6W0NKPwGx++yPI73dYKZv
K+ioqmy14F+wBn0SYUuZU6noRYdZOezjwXwcyDonpEugrF6xJazUe5WJneanobVr
ZZ7a4xs7xjnJXWpI1APczJzqs4fMsGCvyQSOhhV8FySjT5KZQmxcSMkUtysC7EG0
0Mo6yeMB3dLvlOPqY+bTGTvMi8l/iSuL7/OZXdglQ//SV7fCsU9BD/OKfcynLEzq
lTCnExcy/4jArP9tGusjbKn0quBTZmL4OPpyhZk6coEyKWgYyTwf29vc6/T/n0tm
Ja0Tilf/VP8rG8tRmy/UUZPJDkvHbZJnZyu3NtelUvjWr2pvbH2rvuk+8Qctg8OW
2zv1ucIwyxgkrdwdZY97dn3bDQlVMAMnktInSIj3XcV6TfQIsCVwtUIsretHumUb
dM7PTK06VCEy/k7CZopo8aH+5q+MzHySRjAE98HOgPjoV9CO6KsMPDPbR9PRlWCv
mFZ+poqlKTA=
=MRxR
-----END PGP SIGNATURE-----

--Sig_/r5h09Fma5v0.L9BIQAWttgy--
