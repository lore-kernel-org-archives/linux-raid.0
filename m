From: NeilBrown <neilb@suse.de>
Subject: Re: ISW fakeraid: fail to add back a disk previously removed
Date: Sat, 9 Nov 2013 08:16:23 +1100
Message-ID: <20131109081623.25c6bfc4@notabene.brown>
References: <CAC9WiBj5UO76MN3s0TgTLVKVAXJzY+eBxCMCYJWTp0JgdYogaQ@mail.gmail.com>
	<CAC9WiBiz+PTNQtv00RZUoBS30CaZwST+9W9K1SiPsVuze2MEcA@mail.gmail.com>
	<CAC9WiBjdLKmZ5koOr7R6yuYUiOYdVLDGjiRGssg8kK5RQ1fr0A@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1A67F5CF@IRSMSX105.ger.corp.intel.com>
	<CAC9WiBjSh_OYb0k6zyWgeMdbkYzKxrpg9n2VD5RTgdOTNwcudg@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1A67FFF9@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9/TCBPZowK=C6V3Ee3pu+BM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A67FFF9@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: Francis Moreau <francis.moro@gmail.com>, "Williams, Dan J" <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/9/TCBPZowK=C6V3Ee3pu+BM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Nov 2013 14:33:24 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.com>
wrote:

> On Friday, November 08, 2013 2:46 PM Francis Moreau <francis.moro@gmail.c=
om> wrote:
> > > If you created a RAID array with mdadm, it would work correctly - rec=
overy would
> > > start.
> >=20
> > Nope, I've got an identical behaviour if the array is created by mdadm =
(v3.3).
> >=20
>=20
> I have checked it twice with Fedora 19 and mdadm v3.3 and it works.
> What OS are you running?
>=20
> > As you can see, I'm confused about ISW vs IMSM.
> >=20
> > Are those 2 formats the same thing ?
> >=20
>=20
> ISW is a name of Intel metadata used by dmraid and IMSM is a name of Inte=
l metadata used by mdadm, but ISW in dmraid has not been supported and deve=
loped for a couple of years, so ISW might be called an old version of IMSM.
>=20
> Lukasz

Unless we identify something in the metadata the dmraid writes which clearly
contravene the specification, we must assume there is a bug in mdadm.  I
haven't had a change to look at this properly yet but I hope to next week.

NeilBrown

--Sig_/9/TCBPZowK=C6V3Ee3pu+BM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUn1Upznsnt1WYoG5AQKIHBAAlTvLUKwtL52CvyQB7pb0ARlNXQHDAGSV
NgMjmokNLvH7LmXbEyL3MtZb8swLJfjQs53vIH3o/umq/DMIy4/ReJ8JO/YOEEHK
zlFmGLKJO8kfex6ue9h/6ta0JjNojx9VO2+AZUFDBPxtvqFy0GK4b0ncUElDPdXa
MYCWcN0/JLWZ1Jp0Jol6d84yUN26Oyc5COJKpkuZAfcxHB9OY7HXFEnEONegURZC
Ne9P78J2LI/SaFF6VjHTfb7NSzL4aSbH2WgkGXxYnydwbXHfuU5lLK4jb1Avbbii
mxifdkpcBChwoiG154lkuW3AkSspnzcRu6sv3t+10igw7NJAKXwAsBbQEFvhFbsq
DJ8sptMl80zFgpbwPCJEYpqSAHKNeuXaYJDiyWtsVtOzfxJ1TsCL97U6gXKtdM+g
uy+hq+v11TtqEgxWbKtsgwJbDIOF8Jq1UuSatgAblDVDppETyQhUV1TFHvO6c40l
fYwp1mPVEQwOGQ8SSyfhn1Sp5lnT99fhNEQ0Tsec4sTCGAddWChY3BWOKmH0nKrW
iMG2Dh/Ckgi6BvWb4TkzbzTlV2wp6M88iMhOaBpoo1vvjk5D7c9Ch+95EvP0bcm7
VaG8U+jBGhu1HEZ5qIQcfEpVfvSGsCRSofvFc/GlSFAabICdCFPR9P8t7ox98F0Q
vFwSZjgGIcE=
=TPOY
-----END PGP SIGNATURE-----

--Sig_/9/TCBPZowK=C6V3Ee3pu+BM--
