From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Explicitly turn off bad block support
Date: Mon, 22 Apr 2013 10:52:28 +1000
Message-ID: <20130422105228.3948c69f@notabene.brown>
References: <1366378224.14427.1.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GiNmZlb2oFe6UL+pPAx+=77"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1366378224.14427.1.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GiNmZlb2oFe6UL+pPAx+=77
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Apr 2013 08:30:24 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> DM RAID:  Explicitly turn off bad block support
>=20
> DM RAID does not currently use the bad block tracking available in
> MD.  'badblocks.shift' must be set to '-1' in order to explicitly
> tell MD not to perform bad block related functions, like
> narrow_write_error().
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -170,8 +170,10 @@ static struct raid_set *context_alloc(st
>  	rs->md.delta_disks =3D 0;
>  	rs->md.recovery_cp =3D 0;
> =20
> -	for (i =3D 0; i < raid_devs; i++)
> +	for (i =3D 0; i < raid_devs; i++) {
>  		md_rdev_init(&rs->dev[i].rdev);
> +		rs->dev[i].rdev.badblocks.shift =3D -1; /* No bad block support */
> +	}
> =20
>  	/*
>  	 * Remaining items to be initialized by further RAID params:
>=20

Thanks, but I don't think this is the right fix.
md_rdev_init really should set shift to -1, because we can only support
badblocks if the metadata explicitly supports it.

What do you think of this instead?

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41502cf..2166486 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1567,8 +1567,8 @@ static int super_1_load(struct md_rdev *rdev, struct =
md_rdev *refdev, int minor_
 					     sector, count, 1) =3D=3D 0)
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset =3D=3D 0)
-		rdev->badblocks.shift =3D -1;
+	} else if (sb->bblog_offset !=3D 0)
+		rdev->badblocks.shift =3D 0;
=20
 	if (!refdev) {
 		ret =3D 1;
@@ -3227,7 +3227,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	 * be used - I wonder if that matters
 	 */
 	rdev->badblocks.count =3D 0;
-	rdev->badblocks.shift =3D 0;
+	rdev->badblocks.shift =3D -1; /* disabled until explicitly enabled */
 	rdev->badblocks.page =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
 	seqlock_init(&rdev->badblocks.lock);
 	if (rdev->badblocks.page =3D=3D NULL)
@@ -3299,9 +3299,6 @@ static struct md_rdev *md_import_device(dev_t newdev,=
 int super_format, int supe
 			goto abort_free;
 		}
 	}
-	if (super_format =3D=3D -1)
-		/* hot-add for 0.90, or non-persistent: so no badblocks */
-		rdev->badblocks.shift =3D -1;
=20
 	return rdev;
=20

--Sig_/GiNmZlb2oFe6UL+pPAx+=77
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXSJzDnsnt1WYoG5AQKitBAArizT42Ag5DqlVISmuIVdxN7qPxMrkkLa
W6uEoJkOMtWz/IS3ZbYj13rg7HXlLsD18SvO2D8h9mSGp5lvUCSTcJ+mxUxkWjYq
FvzDdjMaa7tfJlSUhNqG4nmN4LQTxvjTqR0Tsl5890YakVQnTtM6VQwnqhKHK1Yz
64ys3Yt2aIDdjKYgkDP/kSOddeGQFZpZvykUdY2iEqNaiQpo3D1pQG8qEU9GRMyZ
hbfLBT+xihO/qXgnWlY1skHiKTV1bIhOkjct+Vpu5Ddlm3KCEBF213Dvj34RggDY
9OiVsZsTQRAYos1p1R2Dv4sU8P3aYakkURYuMoUbmXjrMtBCzniKYORfiaHcnffJ
DVUrul5AUO/gfu3z1vBjHIfzmfiwfIRxGmr88gkIJVvtevtAd8ceLPpjQcukcJU4
bgxTQgGifwwOjJvIl9jQtRwl5MlCkKbO2CnBcxIJX7qJyscTo1D1MF8pr8fZksHb
Nxjwkz4Lpn2ONcQivPLjbiqssnXdl5eH+MD8Jd/RNQ4s7WRBdhRnn4KNpPllgYnI
tuXH7+UkVFJ9c9BswYKoaNBGxUdGOCmkSGAoYg4SmxSq9B+ALedTOIeNrWopInx9
49k+GpJViDunu2UnegCVQEAfBSRRIGhasnDWOoX7I7lNGeplJUV9BNSfv+XM/rx1
6AHDCUZU1Bc=
=lPAs
-----END PGP SIGNATURE-----

--Sig_/GiNmZlb2oFe6UL+pPAx+=77--
