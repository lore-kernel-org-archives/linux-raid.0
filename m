From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Fri, 06 Jan 2006 12:28:50 -0700
Message-ID: <1136575730.3670.19.camel@x1-6-00-0d-60-fd-e8-4c>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	 <fd8d0180601050106s5f5b4306o@mail.gmail.com> <87oe2r2d93.fsf@rimspace.net>
	 <fd8d0180601050321k19f12f53r@mail.gmail.com> <43BE3C99.4050706@ieee.org>
	 <fd8d0180601060250te7a07c7s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hxIpspokPB7aTvmopM9n"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601060250te7a07c7s@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-hxIpspokPB7aTvmopM9n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2006-01-06 at 11:50 +0100, Francois Barre wrote:
> >  AFAIK, ext3 volume cannot be bigger than 4TB on a 32 bits system.
> > I think it is important you know that in case it could be a concern
> > for you.
>=20
> What ? What ? .... What ?
> <dased_and_confused>Are you sure ? I may search for it more
> extensively... Anyway, the total size cannot be more than sizeof(block
> size) * block size, and with 32bits systems and 4k pages, that makes
> 16TB. Are you sure ?</dased_and_confused>

I agree with you, Francois, 16TB should be the limit with 4k pages.  The
maximum file size should be 4TB, though.

Forrest

--=-hxIpspokPB7aTvmopM9n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBDvsTyaUnzBifbsNQRAr0FAJ9c8KNkkbmmES8pjjzdp+6prOpjOQCgrRTk
ex9nyWJy68C0Sqrs0DShH0A=
=pyZq
-----END PGP SIGNATURE-----

--=-hxIpspokPB7aTvmopM9n--

