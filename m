From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: does not allow to use invalid chunk size
Date: Wed, 7 Dec 2011 12:16:54 +1100
Message-ID: <20111207121654.0aee00dc@notabene.brown>
References: <20111125121204.662.4111.stgit@linux.site>
	<20111206115613.77736d93@notabene.brown>
	<74AAB12B538EC94087A0D16AFDFC24F405507F@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H_FXUfkU.slyjf6NR6SX_at"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <74AAB12B538EC94087A0D16AFDFC24F405507F@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

--Sig_/H_FXUfkU.slyjf6NR6SX_at
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2011 15:49:48 +0000 "Hawrylewicz Czarnowski, Przemyslaw"
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Tuesday, December 06, 2011 1:56 AM
> > To: Hawrylewicz Czarnowski, Przemyslaw
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Labun, Marcin;
> > Ciechanowski, Ed
> > Subject: Re: [PATCH] imsm: fix: does not allow to use invalid chunk size
> >=20
> > On Fri, 25 Nov 2011 13:12:04 +0100 Przemyslaw Czarnowski
> > <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> >=20
> > > Only least significant bit of chunk size provided by user has been
> > > used in test with OROM capabilities. This way user could pass value
> > > which is not a power of 2.
> > >
> > > Signed-off-by: Przemyslaw Czarnowski
> > > <przemyslaw.hawrylewicz.czarnowski@intel.com>
> > > ---
> > >  platform-intel.h |    4 +++-
> > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/platform-intel.h b/platform-intel.h index
> > > 6c094d7..99450ba 100644
> > > --- a/platform-intel.h
> > > +++ b/platform-intel.h
> > > @@ -124,11 +124,13 @@ static inline int imsm_orom_has_raid5(const
> > > struct imsm_orom *orom)  static inline int imsm_orom_has_chunk(const
> > > struct imsm_orom *orom, int chunk)  {
> > >  	int fs =3D ffs(chunk);
> > > +	int orom_chunk_bit;
> > >
> > >  	if (!fs)
> > >  		return 0;
> > >  	fs--; /* bit num to bit index */
> > > -	return !!(orom->sss & (1 << (fs - 1)));
> > > +	orom_chunk_bit =3D (orom->sss & (1 << (fs - 1)));
> > > +	return orom_chunk_bit && 1 << orom_chunk_bit =3D=3D chunk;
> > >  }
> > >
> > >
> >=20
> > applied, thanks.
> >=20
> > However it feels a bit clumsy, though maybe that is just me.
> > I would use a separate explicit test for "is a power of 2".
> > ie.
> >=20
> >   if (chunk & (chunk-1))
> >         return 0; /* not a power of 2 */
> >   fs =3D ffs(chunk);
> >   return !!(orom->sss & (1 << (fs-2)));
> >=20
> You're right,
>=20
> Please get the one from the bottom of this email then... It is based on y=
our input (~90%) so sign it up and ship:)
> Moreover previous one is not the right one I wanted to send out...

Applied, thanks.

NeilBrown


--Sig_/H_FXUfkU.slyjf6NR6SX_at
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt6+hjnsnt1WYoG5AQJ3QRAAoXRpVpNLkIRjDSxU7Utv/955evqaL6lO
lM1ccDM+MeW6z9D93ZlCW2/XqBnibQbe4ZYuyZHBBa2hPMZKJGgpzDf5qrfkotrq
ybEUdPZR03cVvuW5XKEbOCwrlK2ms3dEwUsKDYnkCX1uQksvq7T8FA62shJ8qGbI
XcYkoceGEjxijwHbtHpEWDNg/5fyxu8e3+uPT1fXgJj42AOwDQcXbKhFKwZ50/NO
Nl83EbwouHOY/JwdgG7YsKDHkUqfW39W4LdJ7cOnRwJirV4tEvIiqO5r/7kKaq6C
AtY5KHMgp3XDhBxlX69CsUSBve71yyrZRXdlj3t3TYv/nF0bjntA8l/8f4+L1oVr
xL1t9EiKOiu92Go3pkP6+KiTM/7Ig0jLdZHW5FsAD/LBvJpBBCPQid5vIXA/giv9
v57HelgJqXaHvVv7pyQJWwzqNB6qPZeI3N+cr2H8vt7HYH8ikR2xMiJHHnjh51Vw
4OgC7uusvF3S40zCoGOBGDcQqg134qlOW2zBR5dTPlUtsNTT06x+8hmo8+ASYm1O
lx7sqgfaPNUA2w+bwGFgTsuMmIXWV7DotPj81F1N8uKgxu0EY4agx6HwwDFALz4E
8ZKUyX1ip+pT/9dr/O4WFOs43/7w+ij1WesUbFJTkmT+uAtgnShusIk6A6UdDZdZ
wtjjyeXLQpI=
=YZQ2
-----END PGP SIGNATURE-----

--Sig_/H_FXUfkU.slyjf6NR6SX_at--
