From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] md: raid1: use bio_rewind() before bio_copy_data()
Date: Tue, 9 Jul 2013 14:33:52 +1000
Message-ID: <20130709143352.4a5d616c@notabene.brown>
References: <20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
	<1373315114-16625-2-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Y8o/3glqqsl26m87Tl=JmHL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373315114-16625-2-git-send-email-joe.lawrence@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, kmo@daterainc.com
List-Id: linux-raid.ids

--Sig_/Y8o/3glqqsl26m87Tl=JmHL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  8 Jul 2013 16:25:14 -0400 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> bio_copy_data() cannot execute on a fully completed source (or
> destination) bio.  MD RAID1 is recycling a completed read bio for RAID
> repair purposes and needs to fix up the source and destination bios for
> bio_copy_data(): in particular, the io-vector index needs to be rewound
> and the bios unchained.
>=20
> Suggested-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>

Thanks Joe.

Jens:  are you happy with this?  If so is it OK for me to forward to Linus
and -stable for 3.10, or would you rather?
The follow-on patch which uses the so avoid a crash is=20

http://marc.info/?l=3Dlinux-raid&m=3D137331514131503&w=3D2

(This is sitting near the top of "git://neil.brown.name/md for-next" if you
want to cherry-pick it).

Thanks,
NeilBrown

> ---
>  drivers/md/raid1.c | 28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6e17f81..bb1e80f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1861,7 +1861,6 @@ static int process_checks(struct r1bio *r1_bio)
>  		int j;
>  		struct bio *pbio =3D r1_bio->bios[primary];
>  		struct bio *sbio =3D r1_bio->bios[i];
> -		int size;
> =20
>  		if (sbio->bi_end_io !=3D end_sync_read)
>  			continue;
> @@ -1887,28 +1886,11 @@ static int process_checks(struct r1bio *r1_bio)
>  			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>  			continue;
>  		}
> -		/* fixup the bio for reuse */
> -		bio_reset(sbio);
> -		sbio->bi_vcnt =3D vcnt;
> -		sbio->bi_size =3D r1_bio->sectors << 9;
> -		sbio->bi_sector =3D r1_bio->sector +
> -			conf->mirrors[i].rdev->data_offset;
> -		sbio->bi_bdev =3D conf->mirrors[i].rdev->bdev;
> -		sbio->bi_end_io =3D end_sync_read;
> -		sbio->bi_private =3D r1_bio;
> -
> -		size =3D sbio->bi_size;
> -		for (j =3D 0; j < vcnt ; j++) {
> -			struct bio_vec *bi;
> -			bi =3D &sbio->bi_io_vec[j];
> -			bi->bv_offset =3D 0;
> -			if (size > PAGE_SIZE)
> -				bi->bv_len =3D PAGE_SIZE;
> -			else
> -				bi->bv_len =3D size;
> -			size -=3D PAGE_SIZE;
> -		}
> -
> +		/* copy pbio io_vec data into sbio, but first reset io_vec
> +		 * index and unchain both */
> +		bio_rewind(pbio);
> +		bio_rewind(sbio);
> +		pbio->bi_next =3D sbio->bi_next =3D NULL;
>  		bio_copy_data(sbio, pbio);
>  	}
>  	return 0;


--Sig_/Y8o/3glqqsl26m87Tl=JmHL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUduSsDnsnt1WYoG5AQJz5Q//XexKDPm67x0+aoVZtjnVSxXrWo9BV1AA
6XSxRS6kqD3fm+Slo9xC2G2ODt398HWqAo2KQwitLdW8C09CcD5ZIqkjgQH7Zhps
lwFggIrNZFr8vBXO/NaiLiVK2k+Fc4v29ein8PD1MF0iiLKIC1ug9ABgKYiRcmTF
etM1mJ3TudMlAFGXrytuYVAgkgM7uliGlo04zQEx9Wh3qu3BSF233Fnr6MKjpJRT
OVhzeFoYXbh+vVXIxNdiFtX30IvLcLneGnJfKzW31KvkMST7Nlgq3ED1sSSlhM5b
B0BRHm8D3NeWJt/ImZnKZhRLawK7w8QBtSxGBNEGYkVJAzMYgQ3/fkj5ABHaEihu
dOMXjB/5rDRDyHGqQTr2WT1kQJmKBxOKvjZichoffmHK1gKdfGyr2pGoJvaGOWvB
W+GFbqXpnKJNzxAViuRfjDPoTLjNQt46CUB3bGKRoyhoostZSJxBgLeFZWUzUsbz
5kAnVjh+RwLgt++Ig4tNn34WOsPk/C8wZZRlBQx1z4nH8ya29A8TE8tjiKFUxO/d
N4TZMNL9oYCZf2dWD5ctogTUmbzjzYC2TWfx9cGz65CEBbq2WZLVOqHY4BLchlOt
gwgRcuGHu7PUXGmPYUcHg6MSw2PMXoT/9YG9XiDmY1O6ekbuGanztSUb8hF4wKlD
YrEl/xhUzjU=
=d3UR
-----END PGP SIGNATURE-----

--Sig_/Y8o/3glqqsl26m87Tl=JmHL--
