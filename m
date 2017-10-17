From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: forbid a RAID5 from having both a bitmap and a journal.
Date: Wed, 18 Oct 2017 08:03:55 +1100
Message-ID: <8760bdjxl0.fsf@notabene.neil.brown.name>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com> <87bmldnjtq.fsf@notabene.neil.brown.name> <20171012173019.c2bbfyz3hgudjbhz@kernel.org> <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com> <87wp3zlj9q.fsf@notabene.neil.brown.name> <20171013195122.mi7gr4xxm77odx7t@kernel.org> <608CE47A-1C46-4087-B7D3-6FA5936C1DAF@fb.com> <877evulrpm.fsf@notabene.neil.brown.name> <20171016235609.mmo3vbqiekr4li5c@kernel.org> <87sheijw2u.fsf@notabene.neil.brown.name> <23014.27372.306872.143938@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23014.27372.306872.143938@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Shaohua Li <shli@kernel.org>, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17 2017, John Stoffel wrote:

>>>>>> "NeilBrown" =3D=3D NeilBrown  <neilb@suse.com> writes:
>
> NeilBrown> Having both a bitmap and a journal is pointless.
> NeilBrown> Attempting to do so can corrupt the bitmap if the journal
> NeilBrown> replay happens before the bitmap is initialized.
> NeilBrown> Rather than try to avoid this corruption, simply
> NeilBrown> refuse to allow arrays with both a bitmap and a journal.
> NeilBrown> So:
> NeilBrown>  - if raid5_run sees both are present, fail.
>
> So what happens if there's someone out there with an array setup with
> both already?  Should the journal or the bitmap be removed at this
> time?=20=20

If someone has an array like that they can assemble it with
  --update=3Dno-bitmap

I'd rather not automatically disable things.

Thanks,
NeilBrown


>
> NeilBrown>  - if adding a bitmap finds a journal is present, fail
> NeilBrown>  - if adding a journal finds a bitmap is present, fail.
>
> NeilBrown> Cc: stable@vger.kernel.org (4.10+)
> NeilBrown> Signed-off-by: NeilBrown <neilb@suse.com>
> NeilBrown> ---
>
> NeilBrown> This patch should replace 8031c3ddc70ab, which should be rever=
ted.
>
> NeilBrown> Thanks,
> NeilBrown> NeilBrown
>
>
> NeilBrown>  drivers/md/bitmap.c | 6 ++++++
> NeilBrown>  drivers/md/md.c     | 2 +-
> NeilBrown>  drivers/md/raid5.c  | 7 +++++++
> NeilBrown>  3 files changed, 14 insertions(+), 1 deletion(-)
>
> NeilBrown> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> NeilBrown> index cae57b5be817..f425905c97fa 100644
> NeilBrown> --- a/drivers/md/bitmap.c
> NeilBrown> +++ b/drivers/md/bitmap.c
> NeilBrown> @@ -1816,6 +1816,12 @@ struct bitmap *bitmap_create(struct mdd=
ev *mddev, int slot)
>=20=20
> NeilBrown>  	BUG_ON(file && mddev->bitmap_info.offset);
>=20=20
> NeilBrown> +	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
> NeilBrown> +		pr_notice("md/raid:%s: array with journal cannot have bitma=
p\n",
> NeilBrown> +			  mdname(mddev));
> NeilBrown> +		return ERR_PTR(-EBUSY);
> NeilBrown> +	}
> NeilBrown> +
> NeilBrown>  	bitmap =3D kzalloc(sizeof(*bitmap), GFP_KERNEL);
> NeilBrown>  	if (!bitmap)
> NeilBrown>  		return ERR_PTR(-ENOMEM);
> NeilBrown> diff --git a/drivers/md/md.c b/drivers/md/md.c
> NeilBrown> index 63ecfb063b76..bf06ff017eda 100644
> NeilBrown> --- a/drivers/md/md.c
> NeilBrown> +++ b/drivers/md/md.c
> NeilBrown> @@ -6384,7 +6384,7 @@ static int add_new_disk(struct mddev *md=
dev, mdu_disk_info_t *info)
> NeilBrown>  					break;
> NeilBrown>  				}
> NeilBrown>  			}
> NeilBrown> -			if (has_journal) {
> NeilBrown> +			if (has_journal || mddev->bitmap) {
> NeilBrown>  				export_rdev(rdev);
> NeilBrown>  				return -EBUSY;
> NeilBrown>  			}
> NeilBrown> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> NeilBrown> index 4f40ccd21cbb..e070e5c68801 100644
> NeilBrown> --- a/drivers/md/raid5.c
> NeilBrown> +++ b/drivers/md/raid5.c
> NeilBrown> @@ -7134,6 +7134,13 @@ static int raid5_run(struct mddev *mdde=
v)
> NeilBrown>  			min_offset_diff =3D diff;
> NeilBrown>  	}
>=20=20
> NeilBrown> +	if ((test_bit(MD_HAS_JOURNAL, &mddev->flags) || journal_dev)=
 &&
> NeilBrown> +	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
> NeilBrown> +		pr_notice("md/raid:%s: array cannot have both journal and b=
itmap\n",
> NeilBrown> +			  mdname(mddev));
> NeilBrown> +		return -EINVAL;
> NeilBrown> +	}
> NeilBrown> +
> NeilBrown>  	if (mddev->reshape_position !=3D MaxSector) {
> NeilBrown>  		/* Check that we can continue the reshape.
> NeilBrown>  		 * Difficulties arise if the stripe we would write to
> NeilBrown> --=20
> NeilBrown> 2.14.0.rc0.dirty
>
> NeilBrown> [DELETED ATTACHMENT signature.asc, application/pgp-signature]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnmcD0ACgkQOeye3VZi
gbnQrA/+IU93lUkdGqUG8gLiCSCY2ge5dGjC6aIRjNhjNlQjAQIPiT+YxV+9GNwn
jgcmJsz/MABVMwSUExLXUY/s3O7dCik1kDJCk5VczTg8KS69fhOHMPAaFcXxmx4n
MugmH4pALg3Td9FlYvF9fE0TwK6Vv6xNsM6UlnqIFv/ooVf9p9s6ZqH+Ft4nc1eK
sjdCEXUWPz/owppLBbXkFxibwR2B7Ed0U3WFd2KCMU1yoBVZOWri/EzPmer/lRvS
+YmoTCUC9s8wTp6jtpepScTnhotp34mxg0RrK7MRqyGyJ9RzVAV/BqjLXu3/Dow1
PurSb6jx5qHwhOxrh2PmSdJ/iSJerP3SlrD5I/vctLLDdNsJGvlLqYJJbFdWyQoH
+UYcCklL2vWzMyWRl2M7VNYgO9EG1skK6Mnw07Y531929IZ1gQ4D5RGZQy2Af65l
LdcfipQAxSz/2aM80r9tHqiWgjtrbiLrn4f2+gc9HCmRdt6NWoYWkwYsV1amybg4
jliwLpQ/QRwvrNgB4oLHAvG8K3OFSNO0ml7hu/+o8rko6VLeUgTvO1SKxfl/O5SI
Tqmgq8LBL4K/4+hkVSZiAsXuqjOHW6fVxKmlJICDCb3ZEdVpUcqo5bk/dU7K+8gF
0DhvIYtqSCcizJuDM3hHkDP1GlVI0YqwkIUiuJxCsM1fiqEiECA=
=xbZK
-----END PGP SIGNATURE-----
--=-=-=--
