From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 3/4] md: Make mddev->array_size sector-based.
Date: Mon, 21 Jul 2008 17:42:35 +0200
Message-ID: <20080721154235.GX23944@skl-net.de>
References: <1216382419-2560-1-git-send-email-maan@systemlinux.org> <1216382419-2560-4-git-send-email-maan@systemlinux.org> <18564.25857.90818.972326@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brdEIFGMNIjz5YJG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18564.25857.90818.972326@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--brdEIFGMNIjz5YJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:29, Neil Brown wrote:
> On Friday July 18, maan@systemlinux.org wrote:
> > index 8f4c70a..1e1a217 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -4413,8 +4413,8 @@ static int raid5_resize(mddev_t *mddev, sector_t =
sectors)
> >  	raid5_conf_t *conf =3D mddev_to_conf(mddev);
> > =20
> >  	sectors &=3D ~((sector_t)mddev->chunk_size/512 - 1);
> > -	mddev->array_size =3D (sectors * (mddev->raid_disks-conf->max_degrade=
d))>>1;
> > -	set_capacity(mddev->gendisk, mddev->array_size << 1);
> > +	mddev->array_sectors =3D sectors * mddev->raid_disks-conf->max_degrad=
ed;
> > +	set_capacity(mddev->gendisk, mddev->array_sectors);
> >  	mddev->changed =3D 1;
> >  	if (sectors/2  > mddev->size && mddev->recovery_cp =3D=3D MaxSector) {
> >  		mddev->recovery_cp =3D mddev->size << 1;
>=20
> Can you spot the bug in this chunk?
>=20
> There is a subtraction in there which is no longer inside parentheses,
> so the multiplication takes precedence.

Uhuhu.. Such bugs are hard to spot for the human eye.

> I've fixed it and put spaces around the '-' to make it more obvious.

Thanks.

> The rest are OK.

Glad to hear that.

> For future patches, could you please:
>=20
> 1/ run ./scripts/checkpatch.pl on them and fix the warnings, mostly
>    line length issues in this case.
> 2/ run the mdadm test suite on a kernel with the patches applied.

Will do that before sending the next batch (probably tomorrow).

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--brdEIFGMNIjz5YJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIhK5rWto1QDEAkw8RAtUtAJ4yX1qaFen2y0nAuQ3kj56/xOoqBwCbB/IT
oGWNBD4pWJsucaSjRPIXBPc=
=Blnr
-----END PGP SIGNATURE-----

--brdEIFGMNIjz5YJG--
