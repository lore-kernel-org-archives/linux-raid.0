From: Paul Menzel <pm.debian@googlemail.com>
Subject: RE: [PATCH] md: Add ability for disable bad block management
Date: Thu, 24 Nov 2011 13:48:03 +0100
Message-ID: <1322138883.3391.36.camel@mattotaupa>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
	 <1322137392.3391.29.camel@mattotaupa>
	 <79556383A0E1384DB3A3903742AAC04A054292@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-nhyihRcfOPBLp8HzOx4B"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A054292@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids


--=-nhyihRcfOPBLp8HzOx4B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 24.11.2011, 12:28 +0000 schrieb Kwolek, Adam:
> > -----Original Message-----
> > From: Paul Menzel [mailto:pm.debian@googlemail.com]
> > Sent: Thursday, November 24, 2011 1:23 PM
> > To: Kwolek, Adam
> > Cc: neilb@suse.de; linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun,
> > Marcin; Williams, Dan J
> > Subject: Re: [PATCH] md: Add ability for disable bad block management
> >=20
> > Dear Adam,
> >=20
> >=20
> > Am Donnerstag, den 24.11.2011, 13:19 +0100 schrieb Adam Kwolek:
> > > When external metadata doesn't support BBM, mdadm cannot answer
> > > correctly for BBM requests. It causes reshape process being stopped.
> > >
> > > Add ability for external metadata /mdadm/ to disable BBM via sysfs.
> > > md will ignore bad blocks as it is for metadata v0.90.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  drivers/md/md.c |   11 ++++++++++-
> > >  1 files changed, 10 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c index 266e82e..6591108
> > > 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -2935,7 +2935,16 @@ static ssize_t bb_show(struct md_rdev *rdev,
> > > char *page)  }  static ssize_t bb_store(struct md_rdev *rdev, const
> > > char *page, size_t len)  {
> > > -	int rv =3D badblocks_store(&rdev->badblocks, page, len, 0);
> > > +	int rv;
> > > +
> > > +	/* disable bad blocks managment
> >=20
> > manag*e*ment
> >=20
> > > +	 */
> > > +	if (strstr(page, "disable") =3D=3D page) {
> > > +		bb->shift =3D -1;
> > > +		return len;
> > > +	}
> > > +
> > > +	rv =3D badblocks_store(&rdev->badblocks, page, len, 0);
> > >  	/* Maybe that ack was all we needed */
> > >  	if (test_and_clear_bit(BlockedBadBlocks, &rdev->flags))
> > >  		wake_up(&rdev->blocked_wait);
> >=20
> > Also this seems to collide with PATCH 11/11, does not it?

> In my opinion it doesn't.
> Patch 11/11 in mdadm allows for disabling BBM per rdev by setting 'disabl=
e' word in sysfs.
> This patch interprets in md this action and disables BBM (per rdev also) =
.
>=20
> Do you agree?

Yes. Thank you for your explanation. I just saw the same typo. So please
correct that typo in 11/11 also.


Thanks,

Paul

--=-nhyihRcfOPBLp8HzOx4B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7OPQQACgkQPX1aK2wOHVhwLgCfdhtbcry8L2DzypWC8+8Y+Vki
FLcAn1nMfIss+4dQzHTxdMou6Sct7aR+
=ggoz
-----END PGP SIGNATURE-----

--=-nhyihRcfOPBLp8HzOx4B--

