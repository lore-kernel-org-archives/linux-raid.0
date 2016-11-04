From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] Change the option from NoUpdate to NodeNumUpdate
Date: Fri, 04 Nov 2016 16:35:24 +1100
Message-ID: <87bmxvq02r.fsf@notabene.neil.brown.name>
References: <1458813635-14175-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1458813635-14175-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 24 2016, Guoqing Jiang wrote:

> Actually, we need to use NodeNumUpdate here to
> ensure there are enough spaces for those nodes.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Grow.c   | 2 +-
>  super1.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index 5953db2..f58c753 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -425,7 +425,7 @@ int Grow_addbitmap(char *devname, int fd, struct cont=
ext *c, struct shape *s)
>  						    bitmapsize, offset_setable,
>  						    major)
>  						)
> -						st->ss->write_bitmap(st, fd2, NoUpdate);
> +						st->ss->write_bitmap(st, fd2, NodeNumUpdate);
>  					else {
>  						pr_err("failed to create internal bitmap - chunksize problem.\n");
>  						close(fd2);
> diff --git a/super1.c b/super1.c
> index baa9a96..d6f3c93 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1867,7 +1867,7 @@ static int write_init_super1(struct supertype *st)
>  		}
>=20=20
>  		if (rv =3D=3D 0 && (__le32_to_cpu(sb->feature_map) & 1))
> -			rv =3D st->ss->write_bitmap(st, di->fd, NoUpdate);
> +			rv =3D st->ss->write_bitmap(st, di->fd, NodeNumUpdate);

This is wrong.
It might be correct for a clustered array, but it caused failure for
non-clustered arrays.
If you run the mdadm self tests, several will fail with errors like

mdadm: Warning: cluster md only works with superblock 1.2
mdadm: Warning: cluster md only works with superblock 1.2
mdadm: failed to set internal bitmap.

Reverting this commit made the errors go away.

NeilBrown


>  		close(di->fd);
>  		di->fd =3D -1;
>  		if (rv)
> --=20
> 2.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYHB4dAAoJEDnsnt1WYoG54tQP/2JGdR/aVXhyhq8fKsjgABG/
k6e0kJuz3NPa7eIn0LBnLpR6wkYUV+G8qb5YiLZv4hNva27dp+aiME6cDCZlyGfP
7p//Li2xq+9/HrQ9AEpJCGJcxJb1cDl+dpOYGzc8DT4DGKvIqslU0vcoUFBLxqhg
J4Cysh4jTLS1BTu/bc4nedRW6Ufdt54YI0+Bxhwy/w5s0gIu07IGCp14+H7JbS+u
AudrHTLMRV0iUl5O5ZUykb8R6FfvYXwvxlMtL1O/n5r6N1kp9s5UtllAKqr0j5SL
1T0rpvOU1h/M69a9pnCTh3dEzUCN4g0RrGoJoTTkHfPL7Hrwqc9nKAJAazmHgEs8
VmOcIOS68FXhTaIDCz52sPySg/tgHGd976Y+Hp9IoyPtShppbdn6n0n00Jc6+SMt
9eXlplu4talatq7TyZ8AIwndyZW36TaLjuQ4KC6aQ7WwpeFIxOPXosla1KgS5b5r
8ZVJveUk0iLqq7k56twEddZyza7THvsFHCP0iYh+aUKKtPJ0zyt21U9CZpYh4rlO
2FYj9+9y6eaj4pyqZnl/+2kxR+W7ttYpIpMw2M+UbPMe0eI/gIyc4AHwlWQzB5ck
ZE+R8uI2MKlNVOE4BMFewA4IWQWE+fjY8Lr1pj222oQ/DGo5NQhtEXdXJJHOvOku
XvuX0FgNdS2nKPWuYdje
=HuQx
-----END PGP SIGNATURE-----
--=-=-=--
