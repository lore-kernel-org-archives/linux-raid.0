From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 2/6] md: Fix a bug in super_1_sync().
Date: Mon, 25 May 2009 15:40:46 +0200
Message-ID: <20090525134046.GT11504@skl-net.de>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org> <1243243657-21855-3-git-send-email-maan@systemlinux.org> <0fe21d52863495891c4d62bbbe61a36c.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a6Ri6/t33sscKOaw"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0fe21d52863495891c4d62bbbe61a36c.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--a6Ri6/t33sscKOaw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:49, NeilBrown wrote:
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 48bdbdf..66e32e4 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -1402,7 +1402,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev=
_t
> > *rdev)
> >  		sb->new_layout =3D cpu_to_le32(mddev->new_layout);
> >  		sb->delta_disks =3D cpu_to_le32(mddev->delta_disks);
> >  		sb->new_level =3D cpu_to_le32(mddev->new_level);
> > -		sb->new_chunk =3D cpu_to_le32(mddev->new_chunk>>9);
> > +		sb->new_chunk =3D cpu_to_le32(mddev->new_chunk);
>=20
> I think the current code is correct.
> For v1.x metadata, the chunk size (both chunksize and new_chunk) is
> stored in sectors.  in 0.90 it is stored in bytes.

Oops you're right, I got confused by the comment in md_p.h that says
new_chunk is in bytes, even for v1.x metadata. So please drop this
second patch.

Note that the corresponding hunk in the third patch needs to be
changed as well:

-           sb->new_chunk =3D cpu_to_le32(mddev->new_chunk);
+           sb->new_chunk =3D cpu_to_le32(mddev->new_chunk_sectors << 9);

must become

-           sb->new_chunk =3D cpu_to_le32(mddev->new_chunk>>9);
+           sb->new_chunk =3D cpu_to_le32(mddev->new_chunk_sectors);

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--a6Ri6/t33sscKOaw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKGp/eWto1QDEAkw8RAtfxAJ0SLFeCUGGv9gvq872S0GGlwx4PHQCgkvhZ
Vv5/S3fDnjVSLkXI4O0T9eU=
=7ywP
-----END PGP SIGNATURE-----

--a6Ri6/t33sscKOaw--
