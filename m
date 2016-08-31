From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] raid5: guarantee enough stripes to avoid reshape hang
Date: Wed, 31 Aug 2016 18:05:23 +1000
Message-ID: <87shtlcqik.fsf@notabene.neil.brown.name>
References: <e855bdf2ccb11e440191e9512de460f3c5355dd2.1472578078.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e855bdf2ccb11e440191e9512de460f3c5355dd2.1472578078.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 31 2016, Shaohua Li wrote:

> If there aren't enough stripes, reshape will hang. We have a check for
> this in new reshape, but miss it for reshape resume, hence we could see
> hang in reshape resume. This patch forces enough stripes existed if
> reshape resumes.
>
> Signed-off-by: Shaohua Li <shli@fb.com>

I'm really surprised that this was missing, but it certainly appears
that it was.

 Reviewed-by: NeilBrown <neilb@suse.com>

thanks!


NeilBrown


> ---
>  drivers/md/raid5.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 62febe8..2fdb97b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6639,6 +6639,16 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>  	}
>=20=20
>  	conf->min_nr_stripes =3D NR_STRIPES;
> +	if (mddev->reshape_position !=3D MaxSector) {
> +		int stripes =3D max_t(int,
> +			((mddev->chunk_sectors << 9) / STRIPE_SIZE) * 4,
> +			((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4);
> +		conf->min_nr_stripes =3D max(NR_STRIPES, stripes);
> +		if (conf->min_nr_stripes !=3D NR_STRIPES)
> +			printk(KERN_INFO
> +				"md/raid:%s: force stripe size %d for reshape\n",
> +				mdname(mddev), conf->min_nr_stripes);
> +	}
>  	memory =3D conf->min_nr_stripes * (sizeof(struct stripe_head) +
>  		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
>  	atomic_set(&conf->empty_inactive_list_nr, NR_STRIPE_HASH_LOCKS);
> --=20
> 2.8.0.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXxo/DAAoJEDnsnt1WYoG5izsP/RPhoiYG1ojGJdp3WyDAhQLk
g0oCoh036lv1yfAR+vEQzJlljWlLcWkShcT7rJRdrNKkzTjxDmulwmhDL1CuLxCE
zl7vXVAXjxB0ZsNsoO/81oSG9J2818raQijUqsA5FBYdt1dpwWf92aOLbW1LiPBL
hmwK26b+D8hiG2WtbV6P1n6QwHUy0D4SMII4ljBplyYW3jrBlktf8zbeNNC4y7DT
wmWpgBCpSq38tAeagK1rxDexULabL8CByh2WwLtkct9ytjKholCjuCaemckuT3Ri
rrdRiaMp4vlIfQhW8Y1HsVe7gH531f4eYa2GyoIeT9Jk6/ZB+HrdeH8N1GuEvrlK
WgAfGrxFPiaSbQaWfHSAlIK3KfmYYOwBl2XJXs2Hh2blLxVdgrckzsTvnMk2R1y9
0L+UqSuZezl4PuvG/V6tTZ1Z9FTqUSEfr2NXrflCsF6EO0rFNF7pA3imiAi+rPeE
yr+4Kb8PGS/xPr0JRJIDXqKC5jreE4WTC+PYZZ0M8TG7u4erw2WHLGMhrBQui7Ns
1YoWC1cT4OzS2vRW0gcCbRMfrv2r2jqiyFCnNv2pFE1nx5Fft8Ry+QvVVCBlPsVw
hFGx2Kfr01ep7gi2Y7zHKU+MrffbqDJdCbWqt5TUKwNw4lpuOfqQVgcqJwrhM1QG
+KU6R8yR3zC3ZNM1dBqL
=Rh2J
-----END PGP SIGNATURE-----
--=-=-=--
