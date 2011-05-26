From: =?ISO-8859-1?Q?Torbj=F8rn?= Skagestad <torbjorn@itpas.no>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 13:52:19 +0200
Message-ID: <1306410739.9437.124.camel@torbjorn>
References: <4DDDC301.7090608@turmel.org>
	 <1306403130.9437.109.camel@torbjorn>  <4DDE3BF1.7030105@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gxjlM4t6zjJuKSaepG9n"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE3BF1.7030105@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, CoolCold <coolthecold@gmail.com>
List-Id: linux-raid.ids


--=-gxjlM4t6zjJuKSaepG9n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-05-26 at 07:39 -0400, Phil Turmel wrote:
> Thanks Torbj=C3=B8rn !
>=20
> I tend to short the error-checking when I'm putting something together...=
  Clearly, this script was less baked than I thought.
>=20
> On 05/26/2011 05:45 AM, Torbj=C3=B8rn Skagestad wrote:
> > @@ -166,9 +171,12 @@
> >  	devpath =3D os.path.realpath(devpathlink)
> >  	if devpath in phydevs:
> >  		return phydevs[devpath]
> > -	phy =3D Struct(dpath=3Ddevpath, node=3Dnodestr,
> > -		vendor=3Dio.FileIO(devpath+'/vendor').read().split("\n",1)[0].strip(=
),
> > -		model=3Dio.FileIO(devpath+'/model').read().split("\n",1)[0].strip())
> > +	try:
> > +		phy =3D Struct(dpath=3Ddevpath, node=3Dnodestr,
> > +			vendor=3Dio.FileIO(devpath+'/vendor').read().split("\n",1)[0].strip=
(),
> > +			model=3Dio.FileIO(devpath+'/model').read().split("\n",1)[0].strip()=
)
> > +	except IOError:
> > +		return None
> >  	if os.path.exists(devpath+'/unique_id'):
> >  		phy.serial =3D io.FileIO(devpath+'/unique_id').read().split("\n",1)[=
0].strip()
> >  	if not phy.serial:
>=20
> This hunk will have to be done differently.  "phy" needs to be set withou=
t vendor & model if they can't be read.  I'll make a helper function to rea=
d the first line of a file, or return None.

That makes sense.
Guess I was too trigger happy here and ignored some devices in the
process.
>=20
> On 05/26/2011 04:11 AM, CoolCold wrote:
> > May be setup some github repo for this?
> >=20
>=20
> Yes, I'll do this later today.  Obviously needed. :(
>=20
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Torbj=C3=B8rn Skagestad
Id=C3=A9 Til Produkt AS
torborn@itpas.no

--=-gxjlM4t6zjJuKSaepG9n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk3ePvMACgkQ4RjLWGFqSIYrbgCdEBNhPP9YgsjpQYzG3vw8y3cR
6X8An0C04vpr/LiaqlnBJ53yRN/Ngj79
=/lQZ
-----END PGP SIGNATURE-----

--=-gxjlM4t6zjJuKSaepG9n--

