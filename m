From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/bitmap:If bmap() failed,free buffers must check
 bitmap->pending_writes == 0.
Date: Mon, 21 May 2012 10:06:33 +1000
Message-ID: <20120521100633.538592ab@notabene.brown>
References: <201205181938310931047@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LvurlEXK32Va.okSPLwudRo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205181938310931047@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/LvurlEXK32Va.okSPLwudRo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 May 2012 19:38:34 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/bitmap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 17e2b47..74540d7 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -376,6 +376,8 @@ static struct page *read_page(struct file *file, unsi=
gned long index,
>  			bh->b_blocknr =3D bmap(inode, block);
>  			if (bh->b_blocknr =3D=3D 0) {
>  				/* Cannot use this file! */
> +				wait_event(bitmap->write_wait,
> +					atomic_read(&bitmap->pending_writes) =3D=3D 0);
>  				free_buffers(page);
>  				page =3D ERR_PTR(-EINVAL);
>  				goto out;

Hi,
 thanks for the patch.

However it doesn't apply against the current code in linux-next.
Some changes have been made which might make this fix unnecessary as the pa=
ge
is not freed until later.
Could you check the latest code and see if the problem still exists?

Thanks,
NeilBrown


--Sig_/LvurlEXK32Va.okSPLwudRo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7mHCjnsnt1WYoG5AQJk2BAAs/PEmenSghJHAVm2nbwDCirM4Cz68zy9
NZPl7dPdskaubiZJUu/RkNs/Q569wTz+KiLOvYAes2D4SEsoJ4yyAATEMZUmV/di
GT95h1uL/oLxCtMfUvBrIJ4PGiX4ruqnU0yse5MAkKxo/MsTVvVLg7fykLR8hC1y
3G3y6LjWWXk7fULUYrOBQAuoBu94FSAIQEDoEjSiuCPdfNPrOAZM9DJOOOPZfOvN
XOc4DgkWPubqZoFVNM0bu13uQZy07kdIh4WlznSy4ZVNzFMcShGgsyGVkS8nFTIN
ultqSDO+Uj6AnceC/IOSp9Ddr2FGqMSkGa9wuSEjx46CS2dFx+hE0Eze/N1rR4/2
kccnx094f0mp3z+uoRh9tq3meIuqHJapg1nTrLkqytn1Ln39uXHiV2WjDd/Skx0I
YESJQq5frOzoVU9wo7Owm3D2PfuV5fvDK1Llxo07Y55FVjih5yiIC3ZpNzsjk17k
U15uajgM/wlg09IGNW9YJeHn1AD8sBRySud1lhkSvmdH6VDxbjjrVzi+jdsAkBpN
VJNVpwn2CCh29Jp6Sb1DKMaclZt5ce2M43pDSAhckG9wVByYE159b2uyhV0oVgHy
+FfzZ9Qp/4ewyKa8KJ9zkvCZcyiS0XB4wdWdSrUUofQWrgqvfcqYaZS36xpoAuhV
j33AL3k7jgs=
=Z31x
-----END PGP SIGNATURE-----

--Sig_/LvurlEXK32Va.okSPLwudRo--
