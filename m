From: NeilBrown <neilb@suse.de>
Subject: Re: Bug#763917: mdadm: rounding errors in human_size()
Date: Thu, 18 Dec 2014 17:00:59 +1100
Message-ID: <20141218170059.5be02ac2@notabene.brown>
References: <20141003182454.GA9120@goneko.de>
	<20141003182454.GA9120@goneko.de>
	<548188B0.6000309@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/daJoe1/9M.CfnTnA6+Xw+79"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <548188B0.6000309@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: 763917@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/daJoe1/9M.CfnTnA6+Xw+79
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Dec 2014 13:28:00 +0300 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Neil, will you take the patch in this bugreport for the next version?
>=20
> http://bugs.debian.org/763917.
>=20
> Thanks,
>=20
> /mjt
>=20
> On Fri, 3 Oct 2014 20:24:54 +0200 Jan Echternach <jan@goneko.de> wrote:
> > Package: mdadm
> > Version: 3.3.2-1
> > Severity: minor
> > Tags: patch
> >=20
> >=20
> > While setting up a new system, I noticed an incorrect value in the outp=
ut
> > of mdadm --examine:
> >=20
> >  Avail Dev Size : 2095080 (1023.16 MiB 1072.68 MB)
> >=20
> > The 1023.16 MiB were quite irritating because the underlying partition =
has
> > a size of exactly 1023 MiB.
> >=20
> > The number of sectors seems plausible: 2095080 sectors * 512 bytes/sect=
or
> > are 1022.988 MiB or 1072.681 MB. I looked into the code and found an
> > inaccuracy in human_size() and human_size_brief(). The formula used for
> > the MiB value is essentially
> >=20
> >   long cMiB =3D (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> >=20
> > but (1LL<<20) / 200LL is not an integer. It's rounded down and cMiB bec=
omes
> > too large. The quick fix would have been multiplying by 200 before divi=
ding
> > by 1<<20, but that might cause integer overflows in the GiB case.

Given that we are doing 64bit arithmetic, we would  need about 56bits of
bytes for there to be a rounding problem.  That's 64 petabytes.

I decide to just do the simple transformation.  If we get arrays close to
petabytes I would want to make other changes, like reporting the number of
terabytes for larger arrays.

Thanks,
NeilBrown

> >=20
> > The following patch uses a more complicated formula that computes the
> > fractional portion separately from the integer portion. It also changes=
 some
> > longs to long longs to eliminate a different cause of integer overflows.
> >=20
> >=20
> > --- mdadm-3.3.2/util.c	2014-10-03 19:06:51.000000000 +0200
> > +++ mdadm-3.3.2/util.c	2014-10-03 19:08:06.000000000 +0200
> > @@ -671,15 +671,17 @@
> >  	if (bytes < 5000*1024)
> >  		buf[0] =3D 0;
> >  	else if (bytes < 2*1024LL*1024LL*1024LL) {
> > -		long cMiB =3D (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> > +		long cMiB =3D bytes / (1LL<<20) * 100
> > +			    + ((bytes % (1LL<<20)) * 200 / (1LL<<20) +1) /2;
> >  		long cMB  =3D (bytes / ( 1000000LL / 200LL ) +1) /2;
> >  		snprintf(buf, sizeof(buf), " (%ld.%02ld MiB %ld.%02ld MB)",
> >  			cMiB/100 , cMiB % 100,
> >  			cMB/100, cMB % 100);
> >  	} else {
> > -		long cGiB =3D (bytes / ( (1LL<<30) / 200LL ) +1) /2;
> > -		long cGB  =3D (bytes / (1000000000LL/200LL ) +1) /2;
> > -		snprintf(buf, sizeof(buf), " (%ld.%02ld GiB %ld.%02ld GB)",
> > +		long long cGiB =3D bytes / (1LL<<30) * 100
> > +				 + ((bytes % (1LL<<30)) * 200 / (1LL<<30) +1) /2;
> > +		long long cGB  =3D (bytes / (1000000000LL/200LL ) +1) /2;
> > +		snprintf(buf, sizeof(buf), " (%lld.%02lld GiB %lld.%02lld GB)",
> >  			cGiB/100 , cGiB % 100,
> >  			cGB/100, cGB % 100);
> >  	}
> > @@ -706,12 +708,14 @@
> >  		buf[0] =3D 0;
> >  	else if (prefix =3D=3D IEC) {
> >  		if (bytes < 2*1024LL*1024LL*1024LL) {
> > -			long cMiB =3D (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> > +			long cMiB =3D bytes / (1LL<<20) * 100
>=20
> _______________________________________________
> pkg-mdadm-devel mailing list
> pkg-mdadm-devel@lists.alioth.debian.org
> http://lists.alioth.debian.org/cgi-bin/mailman/listinfo/pkg-mdadm-devel


--Sig_/daJoe1/9M.CfnTnA6+Xw+79
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJJtmznsnt1WYoG5AQJtQA//WinqlEwZUviLzuNDkOANxe8CIuMlDyc3
vgEe4Z8Te49jdhq4Y4YElzlbM6KLdQ4hBPZx8hrXp4Y3VfP9iJCrRDjgzVoKuWEY
2ZV9XONj9vOnGpU/SQF49pK/Ig9eNCF6NdRl2c0NkT9OXIgPWKsL79ujPfWwrMZh
pKZsBGLo37peUPrOLEM4cRFXhXXPt797TWhPe6kPBBKwuaPKcSNBHQvkw2cbPMy6
r/SLPoTSE4GqXvMyctt6XDBrjRCiq/18uDcDTdhcYzmtiGv7JHIbdCIT7TgEjQDI
nfnCIZEl/AsonK69mSXr5ozyRNst4XxX4loWKahT5OZpVdZWRerZDGaqv/Q2Gxcz
hWsVoDZvgF2A0VMoGeBmsF+qx1DIE7V8qQYD8ILIJLENULHxpQ6IBrdcNEPMVYra
wN9ETIrKawtunx06aImAIjasX57C5yPpXJ5Kyzpsw0tqu5yzXSI3TzTCgtIWplTr
FhQutJ9w9py5yIqXpINWTlmjxIWCm5joDQd4EOKisMP8MvoDd3gAySEgIO7qYHnq
VTZ1cMY3pBYZH9l/zlEoCRLaKRCPddMPSt83HqxLdFQOimImbJ1ABT9S5d0LCAQA
6e1ICT/O9CIKS5oEJZyjJeIAJ7gCRikn/09jYKRsoTeaeJBgn+TwklRYL+92T82Q
XPaEAHNBrEI=
=DrG/
-----END PGP SIGNATURE-----

--Sig_/daJoe1/9M.CfnTnA6+Xw+79--
