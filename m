From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: 2.6.31-rc5-git2 crash on a idle system.
Date: Thu, 06 Aug 2009 23:40:46 +1000
Message-ID: <1249566046.4800.178.camel@concordia>
References: <4A78292A.5000607@in.ibm.com>
	 <1249421223.18245.36.camel@pasglop> <4A794E26.8080207@in.ibm.com>
	 <1249465934.18245.54.camel@pasglop>  <4A7ADBB1.3050906@in.ibm.com>
Reply-To: michael@ellerman.id.au
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sY2mzGgcVxmEYJHgLlQX"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A7ADBB1.3050906@in.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, neilb@suse.de, linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-sY2mzGgcVxmEYJHgLlQX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-06 at 19:03 +0530, Sachin Sant wrote:
> Benjamin Herrenschmidt wrote:
> > Thanks. Since it's a memory corruption (or seems to be) however, it's
> > possible that the bisection will mislead you. IE. The culprit could be
> > somewhere else, and the commit you'll find via bisection just happens t=
o
> > move things around in the kernel in such a way that the corruption hits
> > that code path instead of another rarely used one.
> >
> > I would suggest using printk to print out the content of memory where
> > the code appears to have been smashed at different stages during boot
> > (maybe even in the initcalls loop in init/main.c) to try to point out
> > what appears to be causing the corruption.
> >  =20
> By the time machine is up and running the particular memory location
> in question is already overwritten. So seems like the corruption occurs
> during the boot.
>=20
> I added few printks in the initcall debug code patch. The o/p suggests
> that by the time first initicall debug message is printed the code is
> already corrupted. Further debug suggests, when start_kernel() is
> called the code at address(0xc000000000600000) is already corrupted.
> About 28 bytes of code starting from the above address is overwritten.=20
>=20
> I will try to add few more debug statements to find the place where
> this corruption might me happening.

Is it always the exact same pattern at the exact same address? Or does
it change and if so how?

cheers

--=-sY2mzGgcVxmEYJHgLlQX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp63V4ACgkQdSjSd0sB4dJ6bwCfVZDxUvTSHvekSmtpoYSE8KOf
I3cAoJYboxAdcfglEqfJPSyjxWPSg2/W
=5F/U
-----END PGP SIGNATURE-----

--=-sY2mzGgcVxmEYJHgLlQX--

