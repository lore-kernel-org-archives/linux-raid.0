From: Andre Noll <maan@systemlinux.org>
Subject: Re: Proposal: make RAID6 code optional
Date: Thu, 23 Apr 2009 10:07:29 +0200
Message-ID: <20090423080729.GA11504@skl-net.de>
References: <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com> <20090422180051.GD13280@skl-net.de> <49EF6457.90505@zytor.com> <20090422185703.GF13280@skl-net.de> <49EFC5DD.9090201@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49EFC5DD.9090201@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:35, H. Peter Anvin wrote:
> Andre Noll wrote:
> > On 11:39, H. Peter Anvin wrote:
> >> Yes, I believe it would be easier than having dynamically allocated=20
> >> arrays.  Dynamically generated arrays using static memory allocations=
=20
> >> (bss) is one thing, but that would only reduce size of the module on=
=20
> >> disk, which I don't think anyone considers a problem.
> >=20
> > We would save 64K of RAM in the raid5-only case if we'd defer the
> > allocation of the multiplication table until the first raid6 array
> > is about to be started.
>=20
> Yes, and we'd have to access it through a pointer for the rest of eternit=
y.

True. You put a lot of effort into raid6 to make it fast, so you know
best how much that would slow down the code. If using a pointer instead
of an array would have a measurable impact on the raid6 performance,
then we should indeed avoid using dynamically allocated memory for
the table.

As this slowdown likely depends on the arch, it is not easy to measure.
So I guess the best way to decrease memory usage for the raid5-only
case is to put the raid6-specific code into a separate module as you
suggested earlier.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ8CHBWto1QDEAkw8RAu7BAJwPq5oS8Z30I26UNivvzOx8bEF/xwCfcY2W
Rvh5eT1BTEipBSoeT95Tsoo=
=6VR5
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
