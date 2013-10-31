From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md/raid5: For stripe with R5_ReadNoMerge, we
 replace REQ_FLUSH with REQ_NOMERGE.
Date: Thu, 31 Oct 2013 14:10:56 +1100
Message-ID: <20131031141056.1525429a@notabene.brown>
References: <2013103010414134402615@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kdNGGVz9DkCi9_k/KL7srg."; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2013103010414134402615@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kdNGGVz9DkCi9_k/KL7srg.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Oct 2013 10:41:46 +0800 majianpeng <majianpeng@gmail.com> wrote:

> For R5_ReadNoMerge,it mean this bio can't merge with other bios or
> request.It used REQ_FLUSH to achieve this. But REQ_NOMERGE can do the
> same work.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f8b9068..8e0aeaa 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -772,7 +772,7 @@ static void ops_run_io(struct stripe_head *sh, struct=
 stripe_head_state *s)
>  				bi->bi_sector =3D (sh->sector
>  						 + rdev->data_offset);
>  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> -				bi->bi_rw |=3D REQ_FLUSH;
> +				bi->bi_rw |=3D REQ_NOMERGE;
> =20
>  			bi->bi_vcnt =3D 1;
>  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;

Thanks.

I've queued this up pending Jens' acceptance of the other patches.

By the way, your patch file has a carriage return as well as a newline at t=
he
end of each line.
"patch" can still handle them but "git am" doesn't like it.

If you are able to send the patches as plain text with just a NEWLINE at the
end of each line, rather than base64 encodes with carriage returns, it would
help a little.

Thanks,
NeilBrown

--Sig_/kdNGGVz9DkCi9_k/KL7srg.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnHKQDnsnt1WYoG5AQIw2Q//T8jXW7va5q3Ns8AXymwraVq+t6/Muw8+
ObhOkOiGZaoPtlsuUj7BCFV3WN18cAmkj00Vdsd7L8cGWsQKmvqwlyc2a6YRKzmv
JRH6c/h0ky6lyLen86pm4GrOmFAygNo01ZRbMsFN5IfJ+0gB44Q0XzSnrQp9SjtP
8pSdgQp/mG43PrxFXia3WlfvL8WgIo9CnNBiad6hsgAiWUplqHOJ+vQMHNTDPmu9
QVI55piGMYpdWK2bnFGDvfBbWMeMKxBfM5vXEndLKAOFTSQD5+R4lknSAGUdnr/U
zjF6LvTUH8dpdda+1VtPFUPiLK4eqwx7Jba9zbBICMy4CG0P+zojqoaHKgUoiocI
usohGrW+QeG0XdRAKs1lVYQ36zPXhFSIhn5wzNO6Ma0ecOtBOmkRG5BaulM6BAHF
lRnkiIMgtKC4cN2gZTdWjnEA0rjku7SGxjRbW3XccCSxADxHBo/AIUdRHEbIApMT
vSXy1XS7QQ1oC151HJHBK34VlDI2GiK0cpviXaEQFIvNu32yos4U5SrvbtzYb6Tn
9p3naTfD2v4Zp4pRv2Mi7NdPD89jxgU7bAEJJaS2KXWJ7CO4Nf+WR2bwKV/wUwo3
8OdzbdCNOJ0fVmDVaJIc3qM6ozzSOXsimekGWcn8y1ceMqrq5jXF9rMewElYTXAL
Up9dfDFga5g=
=eQFs
-----END PGP SIGNATURE-----

--Sig_/kdNGGVz9DkCi9_k/KL7srg.--
