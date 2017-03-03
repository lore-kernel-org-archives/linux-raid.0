From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/3] md/raid5-cache: bump flush stripe batch size
Date: Fri, 03 Mar 2017 14:03:31 +1100
Message-ID: <87mvd3m58c.fsf@notabene.neil.brown.name>
References: <cover.1487373517.git.shli@fb.com> <52a5e6f8924b9a19d4ec4ad73f6e7087f36f139d.1487373517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52a5e6f8924b9a19d4ec4ad73f6e7087f36f139d.1487373517.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17 2017, Shaohua Li wrote:

> Bump the flush stripe batch size to 2048. For my 12 disks raid
> array, the stripes takes:
> 12 * 4k * 2048 =3D 96MB
>
> This is still quite small. A hardware raid card generally has 1GB size,
> which we suggest the raid5-cache has similar cache size.
>
> The advantage of a big batch size is we can dispatch a lot of IO in the
> same time, then we can do some scheduling to make better IO pattern.
>
> Last patch prioritizes stripes, so we don't worry about a big flush
> stripe batch will starve normal stripes.
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 3f307be..b25512c 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -43,7 +43,7 @@
>  /* wake up reclaim thread periodically */
>  #define R5C_RECLAIM_WAKEUP_INTERVAL (30 * HZ)
>  /* start flush with these full stripes */
> -#define R5C_FULL_STRIPE_FLUSH_BATCH 256
> +#define R5C_FULL_STRIPE_FLUSH_BATCH 2048

Fixed numbers are warning signs... I wonder if there is something better
we could do?   "conf->max_nr_stripes / 4" maybe?  We use that sort of
number elsewhere.
Would that make sense?

Thanks,
NeilBrown

>  /* reclaim stripes in groups */
>  #define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2)
>=20=20
> --=20
> 2.9.3

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli43QQACgkQOeye3VZi
gblxXw/9EB+FYsB69OeR/zUpuzjdk6gmrq+7VOmVZDrBqYCCdwoqdjmdps/3Varw
42nriSMZ8pI1F09JUoYN9MO/BrIHgwX4CiIuc6PtQKXeocONNEE8fb46e9JrGRL6
NoocPVR89Fh8dTs1RL334rPvLZBc6eCHJHa1H/MK3fVrDTshUZKx9CyQXuEarBC6
fI7WGn2dHYfE2j/cfGOzF+vIatpHJ6QqaWesbWLWqGcOV4QOqnUCGh6/gLVNs61S
mf2a3L0oJa7GmuFszZ9uagTNPQKReaBlsI3eWPka7swUSHQfDpM0Xv+V/+eWNnQG
/uEWVmP0BZ8aov6GOH1zYFqj5LG+pELGn1w82wAC+s1s1jVaE1eHg1Fuo9UdUxsC
q5NEsfWEkCRcII/4ISKmR9b4tukFeYxxgvg5tvluO7wAF/JL/l1nn706lbDj698F
WEnEnwON7/wOrkIFVnYjMeyGtWAQ6rZYf24u/LULAoLOqhD7jGYXToEDf2KzKEAy
JZFuRDs8fq7DF5YvfEGNryNRt8V32YDbaHTga342L68AJ2TY8qz9BnMrBoGT+7Az
TIZqkn5lvJ15PvoUb8S9ZRBr5IUJwf0FRWvNMPXDC/VQGS+jcPyM0bkX7m2AYPGx
GN/q6aMGLttZna01juFDpQM4za0usFRLLHIvyALmA66mGezVo90=
=LvO3
-----END PGP SIGNATURE-----
--=-=-=--
