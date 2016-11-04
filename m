From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] mdadm: raid10.c Remove near atomic break
Date: Fri, 04 Nov 2016 15:01:58 +1100
Message-ID: <87k2cjq4eh.fsf@notabene.neil.brown.name>
References: <20161103234508.12641-1-robert@leblancnet.us> <20161103234508.12641-3-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161103234508.12641-3-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04 2016, Robert LeBlanc wrote:

> This is always triggered for small reads preventing spreading the reads
> across all available drives. The comments are also confusing as it is
> supposed to apply only to 'far' layouts, but really only applies to 'near'
> layouts. Since there isn't problems with 'far' layouts, there shouldn't
> be a problem for 'near' layouts either. This change fairly distributes
> reads across all drives where before only came from the first drive.

Why is "fairness" an issue?
The current code will use a device if it finds that it is completely
idle. i.e. if nr_pending is 0.
Why is that ever the wrong thing to do?

Does your testing show that overall performance is improved?  If so,
that would certainly be useful.
But it isn't clear (to me) that simply spreading the load more "fairly"
is a worthy goal.

Thanks,
NeilBrown


>
> Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
> ---
>  drivers/md/raid10.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index be1a9fc..8d83802 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -777,13 +777,6 @@ static struct md_rdev *read_balance(struct r10conf *=
conf,
>  		if (!do_balance)
>  			break;
>=20=20
> -		/* This optimisation is debatable, and completely destroys
> -		 * sequential read speed for 'far copies' arrays.  So only
> -		 * keep it for 'near' arrays, and review those later.
> -		 */
> -		if (geo->near_copies > 1 && !atomic_read(&rdev->nr_pending))
> -			break;
> -
>  		/* for far > 1 always use the lowest address */
>  		if (geo->far_copies > 1)
>  			new_distance =3D r10_bio->devs[slot].addr;
> --=20
> 2.10.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYHAg2AAoJEDnsnt1WYoG5ZwAP/0rW1MeZQLrTB0yzHBrEoLlJ
8wjpc5GDapPgVmjlo/5VsVebfjRlozq3BKA0Rj2dpKZqYRPqNOFUvfWGHApHh+ph
qONxvMcgmjvcfuAry9X5d5OGD9IbPVsqVrPQ5NzTx2mCiJ5XIMB0Ya3fqx3bif9B
KccJ+w8mentVPDPhKnHWAVgiMEzBLNpXk7QwhK01HN1ERsx1MaDKpxIZ9/+ht/aE
xcDl8cpj4lgsnrRUDEiuj0wJKUQ02WXd6yYvspFEF6rGkLJPYpOv06NxFs1m/QCm
MaJL7dY4rzCZX5XZszJLNF6oGDnuGTkUIDYQobhDyxNSW8cahnRX9kYJ9lOhcp+E
7KM+AczFoZRlKnGJAygOUOkLyVX0cFma1Ww3OMwaIzqhTO7Tfbo5xBjAacKx5tna
RGbZ20Ej8WZ8gqgyP3CeqX5ktJbo7WaF+bEPoVv4cYT04eYOvHfy1AtpfZftu1hv
PIpK3N8Y91iRstWiQnwbB8EYhkr6SgTkNc6Hfd1gN1qIx9/SzzbF+F2vcGTVjuVW
c4rrQOUFP9VxoWZVCqY8Ch+4fQbYGLOycmnUXYWbPnrshty6J57iu+9a2+kzyxOv
ugku+vzZOy89ultXiguJM4xqkWGf/1HMFzfdBo306pSA/5b87HeNGzVoCEBfzqNR
VzyRrSfWOPf/aPJorB4L
=/Zq7
-----END PGP SIGNATURE-----
--=-=-=--
