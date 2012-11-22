From: NeilBrown <neilb@suse.de>
Subject: Re: want-replacement got stuck?
Date: Thu, 22 Nov 2012 16:47:51 +1100
Message-ID: <20121122164751.3eba2706@notabene.brown>
References: <20121122052757.26082.qmail@science.horizon.com>
	<20121122053903.28496.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wencI8z=Z_OABaI.bhExsDD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121122053903.28496.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: joystick@shiftmail.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wencI8z=Z_OABaI.bhExsDD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 22 Nov 2012 00:39:03 -0500 "George Spelvin" <linux@horizon.com> wrote:

> Oops!  My manual patch application forgot a few lines.  (I left the
> "if (!r10_bio->devs[i].repl_bio) continue;" code in place while adding
> its replacement.)
>=20
> Here's a corrected patch.  (Again, -b, then the real thing.)

Yes, that looks right.

NeilBrown


--Sig_/wencI8z=Z_OABaI.bhExsDD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK28hznsnt1WYoG5AQKUqxAAp+uy/oeS+b/Wcx9hJ6+Dyk6qg8lG7+tT
SHlXgNw4SBdWr8z+9KU4EBnu2xt+DcF7URD1/AkpCYUgHFWNhATd4sgMvqbM5j5u
j4Px7eBUpnDxSV3TycQBFtms2tCdIly5Th3iETHSUEWP6hnGXsyqlyQlorh88trG
ZlMqy1MH21bNrmPyXV6TIcgPrtPVML4+GtJ+EZUWEnBjjAefJStNTOmlsfcCwUnZ
7+JZul2PBPys10He1YVsX8CvvZ5w0xc3xkyextRQwv9FznzkGzRLxaCfbokBHg18
by6YwKsq4LH49mQLxgrQvEmqXzGw1oUZNzlyvG8ex60Kfwr+ljaqC7GRdLkQG/bH
AHU5spwQAPr09y5Oh6QV9DQ/dBnRVa3LwxwelnM8wbGAzAmabWsGkgABst+JL/pa
F82IQdAVVNUT13RkM+p0vZtjexN2sn9ZNt4cXSGMGfVKI/YAL/7kHyDX45/DjD1G
wVcYfrBo4Mkvi+F7YLKnvIY7dZfmagyGwW+3MYsJsqGYQHoG3K1X2k1mh4QOuE82
zWImvDT0SOeMCX2ehhXyyRDe5nej5tKc5ZAXAL9lYI2yx2Dl4HiyFGWCjmWzQLIl
jYEBM/6aTi4EHnl8AeL7pr4m7h1dhTup+E02D5CANrHc9V7HPr+aRX01J7JHveMB
gB77+GIJIcI=
=v/wX
-----END PGP SIGNATURE-----

--Sig_/wencI8z=Z_OABaI.bhExsDD--
