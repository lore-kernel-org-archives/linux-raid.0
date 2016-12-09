From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] md: takeover should clear unrelated bits
Date: Fri, 09 Dec 2016 15:41:59 +1100
Message-ID: <87oa0l1zoo.fsf@notabene.neil.brown.name>
References: <cover.1481240632.git.shli@fb.com> <8ba65915901de01043eb08cfadd07d65767776fb.1481240632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8ba65915901de01043eb08cfadd07d65767776fb.1481240632.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09 2016, Shaohua Li wrote:

> When we change level from raid1 to raid5, the MD_FAILFAST_SUPPORTED bit
> will be accidentally set, but raid5 doesn't support it. The same is true
> for the MD_HAS_JOURNAL bit.
>
> Fix: 46533ff (md: Use REQ_FAILFAST_* on metadata writes where appropriate)
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid0.c | 5 +++++
>  drivers/md/raid1.c | 5 ++++-
>  drivers/md/raid5.c | 6 +++++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index e628f18..a162fed 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -539,8 +539,11 @@ static void *raid0_takeover_raid45(struct mddev *mdd=
ev)
>  	mddev->delta_disks =3D -1;
>  	/* make sure it will be not marked as dirty */
>  	mddev->recovery_cp =3D MaxSector;
> +	clear_bit(MD_HAS_JOURNAL, &mddev->flags);
> +	clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
>=20=20
>  	create_strip_zones(mddev, &priv_conf);
> +
>  	return priv_conf;
>  }


This looks like a good fix, but it is a little fragile.
If a new bit is added, we would need to go through all the takeover
functions and check if it needs to be cleared, and we would forget.
It might be better if each personality defined a VALID_MD_FLAGS or
whatever, and the takeover function always did
 set_mask_bits(&mddev->flags, 0, VALID_MD_FLAGS);

??

But that can come later.

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown


>=20=20
> @@ -580,6 +583,7 @@ static void *raid0_takeover_raid10(struct mddev *mdde=
v)
>  	mddev->degraded =3D 0;
>  	/* make sure it will be not marked as dirty */
>  	mddev->recovery_cp =3D MaxSector;
> +	clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
>=20=20
>  	create_strip_zones(mddev, &priv_conf);
>  	return priv_conf;
> @@ -622,6 +626,7 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
>  	mddev->raid_disks =3D 1;
>  	/* make sure it will be not marked as dirty */
>  	mddev->recovery_cp =3D MaxSector;
> +	clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
>=20=20
>  	create_strip_zones(mddev, &priv_conf);
>  	return priv_conf;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 94e0afc..efc2e74 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3243,9 +3243,12 @@ static void *raid1_takeover(struct mddev *mddev)
>  		mddev->new_layout =3D 0;
>  		mddev->new_chunk_sectors =3D 0;
>  		conf =3D setup_conf(mddev);
> -		if (!IS_ERR(conf))
> +		if (!IS_ERR(conf)) {
>  			/* Array must appear to be quiesced */
>  			conf->array_frozen =3D 1;
> +			clear_bit(MD_HAS_JOURNAL, &mddev->flags);
> +			clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
> +		}
>  		return conf;
>  	}
>  	return ERR_PTR(-EINVAL);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6bf3c26..3e6a2a0 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7811,6 +7811,7 @@ static void *raid45_takeover_raid0(struct mddev *md=
dev, int level)
>  static void *raid5_takeover_raid1(struct mddev *mddev)
>  {
>  	int chunksect;
> +	void *ret;
>=20=20
>  	if (mddev->raid_disks !=3D 2 ||
>  	    mddev->degraded > 1)
> @@ -7832,7 +7833,10 @@ static void *raid5_takeover_raid1(struct mddev *md=
dev)
>  	mddev->new_layout =3D ALGORITHM_LEFT_SYMMETRIC;
>  	mddev->new_chunk_sectors =3D chunksect;
>=20=20
> -	return setup_conf(mddev);
> +	ret =3D setup_conf(mddev);
> +	if (!IS_ERR_VALUE(ret))
> +		clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
> +	return ret;
>  }
>=20=20
>  static void *raid5_takeover_raid6(struct mddev *mddev)
> --=20
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhKNhcACgkQOeye3VZi
gbmJChAAgm0i4MqAVjnKXAJhHlv5VPaqDHyuJkcUw58jZ30P8rmnv/EwdEI18EjT
3HkhdC3DTDfLjlXxX4boJTeSqaHNTh0nUwidOlvaXpNlt5RPQ9qMt3dY915EEBL7
TouNyiGUoFa1yYUH+0vvOFJBRtp+HLsUexQE+BxdsNY9IG/WVWQROL36IhgJpgMs
2vfYsUul1vi45/r8yJJVoZDzjCd6kueEr4tETBNQW3F/CMOZvYM09YIUtTdsjZwL
aZCzgI/NaCXeMK51p8J0BPQLv88Ia+lz60Zgir5Q28UbG2PLv328fVsbOzlu4rSv
+Ji57CXpTNtgvHZw0s2Og04Qe40IQGkQ1p/RsErn5BCpuyieVQDIFbijiYXBdr9h
aj887xo1Fsaz36Y5ZgBskKyeAlwNQU040Oo9Pec7NiihsoRjeF4q1ViyeTH6PG0a
gcM4KCm1LkvFghC7TpRQ01vp1Qd2Kc8Nm7IVtgBYZw3jiUDm9SuI9kgJI2fvvhBR
tETYaLSiRpEXWVmzJSmmMIvEk4Sk+s3Ty+YDSA2ZUF9J63sNuYYzVsVMXNY240yt
iVYrK9+MiPfUsVQ3wswIHCtJQ2B0be0lAeVXpxekBC8FQDYSaCAZUi910/W6QL1c
D0nnDWHw0DkJzCxnnuSLzMnZOv19UZUdYkE1klVHGyz2tHJa6SE=
=fC6J
-----END PGP SIGNATURE-----
--=-=-=--
