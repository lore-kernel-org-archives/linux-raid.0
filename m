From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [PATCH] md: Add ability for disable bad block management
Date: Thu, 24 Nov 2011 13:23:12 +0100
Message-ID: <1322137392.3391.29.camel@mattotaupa>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ohWixq1424uEBgaA8d2M"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids


--=-ohWixq1424uEBgaA8d2M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Adam,


Am Donnerstag, den 24.11.2011, 13:19 +0100 schrieb Adam Kwolek:
> When external metadata doesn't support BBM, mdadm cannot answer correctly
> for BBM requests. It causes reshape process being stopped.
>=20
> Add ability for external metadata /mdadm/ to disable BBM via sysfs.
> md will ignore bad blocks as it is for metadata v0.90.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  drivers/md/md.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 266e82e..6591108 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2935,7 +2935,16 @@ static ssize_t bb_show(struct md_rdev *rdev, char =
*page)
>  }
>  static ssize_t bb_store(struct md_rdev *rdev, const char *page, size_t l=
en)
>  {
> -	int rv =3D badblocks_store(&rdev->badblocks, page, len, 0);
> +	int rv;
> +
> +	/* disable bad blocks managment

manag*e*ment

> +	 */
> +	if (strstr(page, "disable") =3D=3D page) {
> +		bb->shift =3D -1;
> +		return len;
> +	}
> +
> +	rv =3D badblocks_store(&rdev->badblocks, page, len, 0);
>  	/* Maybe that ack was all we needed */
>  	if (test_and_clear_bit(BlockedBadBlocks, &rdev->flags))
>  		wake_up(&rdev->blocked_wait);

Also this seems to collide with PATCH 11/11, does not it?


Thanks,

Paul

--=-ohWixq1424uEBgaA8d2M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7ONzAACgkQPX1aK2wOHVhY5QCfUNrE+tnsIfHc4xAgaATIyKRg
mcEAniMWMSMxCMDDTV9eBJnZC5TgzkPU
=3AD3
-----END PGP SIGNATURE-----

--=-ohWixq1424uEBgaA8d2M--

