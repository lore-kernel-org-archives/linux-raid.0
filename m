From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/bitmap:Don't use IS_ERR to judge alloc_page().
Date: Thu, 20 Sep 2012 12:54:40 +1000
Message-ID: <20120920125440.7f0fdea9@notabene.brown>
References: <2012091510425793786613@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N2Ig+/_FE+e7I36dNW8qVoO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012091510425793786613@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/N2Ig+/_FE+e7I36dNW8qVoO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Sep 2012 10:43:00 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/bitmap.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 94e7f6b..f03ad11 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -476,11 +476,8 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
>  	int err =3D -EINVAL;
> =20
>  	bitmap->storage.sb_page =3D alloc_page(GFP_KERNEL);
> -	if (IS_ERR(bitmap->storage.sb_page)) {
> -		err =3D PTR_ERR(bitmap->storage.sb_page);
> -		bitmap->storage.sb_page =3D NULL;
> -		return err;
> -	}
> +	if (bitmap->storage.sb_page =3D=3D NULL)
> +		return -ENOMEM;
>  	bitmap->storage.sb_page->index =3D 0;
> =20
>  	sb =3D kmap_atomic(bitmap->storage.sb_page);

Applied,
Thanks,
NeilBrown

--Sig_/N2Ig+/_FE+e7I36dNW8qVoO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqFcDnsnt1WYoG5AQLI2g/+O+1MHVaIl4vIbXlco4z02qAaJdZW0xeE
zqVlraRzYR9yRoxnpO/0L2rL9+MdZP0/L61m8bxeEYM09k7K0Pwx0GiR3RBQkJKU
3MUQy7JqK+M80xgzpLDXNGeckAd5m0iZEc0ewqAI09lxJExtA3HPXjLV2m01gNmp
Ig9o1FWfRUK2KlPKAni8Ux643++Zu1m44yCGgZzlvx3mw78FJV/hkmnf+lvbsDO1
BsVMyRNB57TVVnzO0dMmIbQlUH1PMTjRekQJY1yoBVu4KbZnbVjH18xyFOjt5QtG
seVb8C/taQ3ztc3KQAyiBZi9o768xSE4e/RTr02jzN/Ln2RzhJHUOUGuTCQzV1xG
cvvhZXe+ataVhP+oU65cRdE1/14gptPvoa6VrerJdct3wdsh0bn88CJ0TXIDkbvQ
ntxf+liJWU5sxyVCIw3eH7s7zht01QJKMl5O3YHXhI/Ts0/9L4WVrUgF2F2/Pm4S
cz53YEIqiR5cMR+79ac0YepadNNDL6VRJl08Hym4ck0dsSZsgkqkifCGt5CYNz7B
qXmXcj3V+XeCG0B4UeIpcF0F9IU35Vm+xUjoGeNhF53jHVLEQ90bV1oXzhN3Y2++
8f/RoHW6Snf48lPcU17/iyOprMqtaDVTigdXmyZML9hFIvFrfL8c6rfR65qSVKf4
/QJT21hStX4=
=pNVx
-----END PGP SIGNATURE-----

--Sig_/N2Ig+/_FE+e7I36dNW8qVoO--
