From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH] md raid10: fix NULL deference in handle_write_completed()
Date: Mon, 05 Feb 2018 16:29:35 +1100
Message-ID: <87d11kovgg.fsf@notabene.neil.brown.name>
References: <20180205042343.17235-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180205042343.17235-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 05 2018, Yufen Yu wrote:

> When an io error in recovery, end_sync_write will set R10BIO_WriteError.
> After reschedule_retry(), this r10_bio will be inserted to retry_list,
> and progressed by handle_write_completed(), which will traverse all=20
> r10_bio->devs[]. If devs[m].repl_bio !=3D NULL, it thinks=20
> conf->mirrors[dev].replacement is also not NULL.
> In fact, it is not true, resulting in replacement NULL deference.
>
> For example,
> in raid10, only rdev[1] has replacement, rdev[0], rdev[2] and rdev[3]
> don't have replacement. And, r10buf_pool_alloc() will allocate=20
> repl_bio for every r10bio. raid10_sync_request() gets a r10bio from
> the pool. But, it doesn't pay attention to repl_bio for=20
> read bio(r10bio->devs[0], rdev[2]), or sets repl_bio=3DNULL in=20
> write bio(r10bio->devs[1], rdev[3]), if replacement =3D=3D NULL.
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>

Thanks for this.  You're analysis is correct.
This bug was introduced when replacement support for raid10 was added
in Linux 3.3, so

Fixes: 9ad1aefc8ae8 ("md/raid10:  Handle replacement devices during resync.=
")

I'm not sure you patch is correct though.  Just because rdev is not NULL
and bio is not NULL, that doesn't mean we tried to write - particularly
in the 'recover' case.

Elsewhere the determination of "is this device part of the
resync/recovery" is made by resting bio->bi_end_io.
If this is end_sync_write, then we tried to write here.
If it is NULL, then we didn't try to write.

So I think a correct patch would be more like.

 if (r10_bio->devs[m].bio =3D=3D NULL ||
     r10_bio->devs[m].bio->bi_end_io =3D=3D NULL)
         continue;

Thanks,
NeilBrown


> ---
>  drivers/md/raid10.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 99c9207899a7..9cbc1a193c8e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2655,7 +2655,7 @@ static void handle_write_completed(struct r10conf *=
conf, struct r10bio *r10_bio)
>  		for (m =3D 0; m < conf->copies; m++) {
>  			int dev =3D r10_bio->devs[m].devnum;
>  			rdev =3D conf->mirrors[dev].rdev;
> -			if (r10_bio->devs[m].bio =3D=3D NULL)
> +			if (rdev =3D=3D NULL || r10_bio->devs[m].bio =3D=3D NULL)
>  				continue;
>  			if (!r10_bio->devs[m].bio->bi_status) {
>  				rdev_clear_badblocks(
> @@ -2670,7 +2670,7 @@ static void handle_write_completed(struct r10conf *=
conf, struct r10bio *r10_bio)
>  					md_error(conf->mddev, rdev);
>  			}
>  			rdev =3D conf->mirrors[dev].replacement;
> -			if (r10_bio->devs[m].repl_bio =3D=3D NULL)
> +			if (rdev =3D=3D NULL || r10_bio->devs[m].repl_bio =3D=3D NULL)
>  				continue;
>=20=20
>  			if (!r10_bio->devs[m].repl_bio->bi_status) {
> --=20
> 2.13.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlp3678ACgkQOeye3VZi
gblBSRAAsjENyKMBKxMD0Q9/gxYbG13AAIh1eIW3wHp1I3njbdYRUbr9cB7cI0Ta
Eo4Uiz4TPlBV7IVoG6x/kgJHhtH43MPIT3D7L9ylvgVYjwQrxVojH6z74vZ4PWqk
CG1bOUatP2peuB1d2E/GkxhcJgx0W6uthV+CAQm6lkzNrYeVgbtrSjMU6W5qv+fC
Do0rWkX+qJ3eZZFtrEviI14qaCA3xiQKqhHPqcxe8SN8v9qvOqmoYicH32XPhzOB
ATYHRK1fcrc9cY8I3qozv2UaNXs2NyzjtT5vhtySwCqGl4TbfXbN8TRXw6psmnMe
c3QcLqqejHt86c7HFi3wryajapPkcLslr9Wj0n4PhU18w/Or+suz1oNE998f1rdJ
FO+Zooz00mc3uJkzgR0zJeiaBkDP+7PTIbkuIzoaX/qsfggeDW3a44nC27RPJwKI
iuEtAk/qSLLWp+HMHvw1LyTJL66ikExaDxearhw+zRLklN/ywUXzfKBYLyHCs0n6
5oULmdCiBrWOuH4Ehedmex5lefsbES767qkpNI5bYA2nH9lAAJzG6cQMgYJQYGTf
qxajbhhmdKXzUYjE+hVGM0HVQrddIf0ugt2lsaAYcNVEqparCOWzBWDeh+1dC1N6
1QIyVYKqqZxDhVrhL5LpwNF6UTTVkxU6sGGy9HOZ9jFYM4kiu+Q=
=YV6j
-----END PGP SIGNATURE-----
--=-=-=--
