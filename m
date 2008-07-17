From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 4/5] md: Turn rdev->sb_offset into a sector-based quantity.
Date: Thu, 17 Jul 2008 11:40:08 +0200
Message-ID: <20080717094008.GW23944@skl-net.de>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org> <1215681338-32365-5-git-send-email-maan@systemlinux.org> <18551.16581.929399.413701@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="de1H0RjRxOSdb4we"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18551.16581.929399.413701@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--de1H0RjRxOSdb4we
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21:15, Neil Brown wrote:
> >  	if (minor_version
> > -	    && rdev->data_offset < sb_offset + (rdev->sb_size/512))
> > +	    && rdev->data_offset < sb_start / 2 + (rdev->sb_size/512))
> >  		return -EINVAL;
>=20
> That doesn't look right.
>   rdev->data_offset is in sectors.
>   rdev->sb_size/512 is in sectors.
>   sb_offset is in K.
> We had a bug there.  Better fix it by dropping the "/ 2".
>=20
> > @@ -3431,16 +3428,16 @@ static int do_md_run(mddev_t * mddev)
> >  		 * We don't want the data to overlap the metadata,
> >  		 * Internal Bitmap issues has handled elsewhere.
> >  		 */
> > -		if (rdev->data_offset < rdev->sb_offset) {
> > +		if (rdev->data_offset < rdev->sb_start / 2) {
>=20
> And another bug.  We don't want the "/ 2".  data_offset was always
> sectors, and now sb_offset is too.

It might be worth to get fixes for these two bugs into -stable.

Here's a patch against mainline. Please forward to stable@... if
you agree.

Andre

commit c1be9a2d52dd2db1cf284e62d5e1cb8423482fb4
Author: Andre Noll <maan@systemlinux.org>
Date:   Thu Jul 17 11:33:40 2008 +0200

    md: Fix two bugs in md.c
   =20
    sb_offset is kilobytes while data_offset and sb_size/512 are in
    sectors.
   =20
    Spotted by Neil while reviewing the sector_t conversion patches.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2580ac1..0c7aeb9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1113,7 +1113,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t =
*refdev, int minor_version)
 		rdev->sb_size =3D (rdev->sb_size | bmask) + 1;
=20
 	if (minor_version
-	    && rdev->data_offset < sb_offset + (rdev->sb_size/512))
+	    && rdev->data_offset < sb_offset * 2 + (rdev->sb_size/512))
 		return -EINVAL;
=20
 	if (sb->level =3D=3D cpu_to_le32(LEVEL_MULTIPATH))
@@ -3432,7 +3432,7 @@ static int do_md_run(mddev_t * mddev)
 		 * We don't want the data to overlap the metadata,
 		 * Internal Bitmap issues has handled elsewhere.
 		 */
-		if (rdev->data_offset < rdev->sb_offset) {
+		if (rdev->data_offset < rdev->sb_offset * 2) {
 			if (mddev->size &&
 			    rdev->data_offset + mddev->size*2
 			    > rdev->sb_offset*2) {
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--de1H0RjRxOSdb4we
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIfxN3Wto1QDEAkw8RAvOGAJ98fdH965tBqY9GlDWez4NV17ZKHwCffdFM
oN/qtirGXmnm43otxqWaA/E=
=ujpI
-----END PGP SIGNATURE-----

--de1H0RjRxOSdb4we--
