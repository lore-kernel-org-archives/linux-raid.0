From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] md/raid5: Reduce one write-operation when handle
 badsector
Date: Mon, 4 Mar 2013 12:43:30 +1100
Message-ID: <20130304124330.7eb81dde@notabene.brown>
References: <201302281550584027165@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oIqD/tKa9Iz5prHcbxdsVL3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201302281550584027165@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/oIqD/tKa9Iz5prHcbxdsVL3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Feb 2013 15:51:01 +0800 majianpeng <majianpeng@gmail.com> wrote:

> For badsector,it took two steps:rewrite and reread.So for
> write-operation,it make no sense to rewrite after write-operation.

Please please please please please try to explain yourself better.

This patch doesn't make any sense.  The write succeeded.  We set the MadeGo=
od
flag so that later code will remove the block from the bad-block list.
There will be no re-read or re-write.

NeilBrown


>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 19d77a0..59c0569 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1921,8 +1921,10 @@ static void raid5_end_write_request(struct bio *bi=
, int error)
>  					&rdev->mddev->recovery);
>  		} else if (is_badblock(rdev, sh->sector,
>  				       STRIPE_SECTORS,
> -				       &first_bad, &bad_sectors))
> +				       &first_bad, &bad_sectors)) {
>  			set_bit(R5_MadeGood, &sh->dev[i].flags);
> +			set_bit(R5_ReWrite, &sh->dev[i].flags);
> +		}
>  	}
>  	rdev_dec_pending(rdev, conf->mddev);
> =20


--Sig_/oIqD/tKa9Iz5prHcbxdsVL3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTP8Qjnsnt1WYoG5AQKQDA/8DxE08LMqWAmeNVQg0OETkWYRbgso/VOT
aOWZuqXI5Tosu4x22aPvtb0NWTaZMys9kOnrxbEGjM3fLH5iZq6mqD+dedvd/8Lw
FFx1at6wy2AHLjAMj1pcu6mR3KAha3vohAQq4zL/xBk9E1UbGLzT+mxUATzsUIXf
BCypyOuqT9LRrtI683JJRwecI8opdnMFWYy2+xKS8awje6ghpeGWr1vlvZE+PSof
GP7rrAL01sDvxQMZQTe4zBZeUxsF3EQqPiKcaM/TpIYJsNFrgOmjsYltExA/WNGG
MBwGwSs9pP+lmbr5DfXgXo8BZnML0o5EkbpD1FhoTDdyDmqFeQW9ZJCf3/9Z6Ass
85pafv/e1qAN1tKnEgA19cW/zbwcWh6tIezJP1dzcaG33n+FBm2zBSSzSeJ3Iuxc
g7e8nYb44DB67fQ+K6YssTuvA6egA9b0HHdwXNRJAQ845YsLG/bhYdm/k4zCrI0Z
ZQTs/iTpE+nCkPz5+x1PpxBtQiSxDm7uGBMyfuYGkwhVJ+O2+psC9W4cYXemp0+e
b6TrCw069EBoPjy1wI4xz04qvwZPCL3uhWInyewzzar1+DGnWd2O5t+keEhSVogy
vEMb1c2vA+1sttEDf5PVa9SFmVMgQOrLG1x3KPNzFpezDHYeY5XYn4rQF4oKyoSM
xgGF73FYtmw=
=YtRZ
-----END PGP SIGNATURE-----

--Sig_/oIqD/tKa9Iz5prHcbxdsVL3--
