From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md:array cannot be opened again after 'md_set_readonly'
Date: Wed, 29 Mar 2017 08:13:36 +1100
Message-ID: <87efxh6r5r.fsf@notabene.neil.brown.name>
References: <1490601145-5865-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1490601145-5865-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27 2017, Zhilong Liu wrote:

> This is a bug about array cannot be opened again after 'md_set_readonly',
> because the MD_CLOSING bit is still waiting for clear.
> MD_CLOSING should only be set for a short period or time to avoid certain
> races. After the operation that set it completes, it should be cleared.
>
> Reviewed-by: NeilBrown <neilb@suse.com>

No I didn't.  I never reviewed this patch.  I don't agree with this
patch. This patch is wrong.
The flag is set in md_ioctl(), and it should be cleared in md_ioctl().

NeilBrown

> Cc: Guoqing Jiang <gqjiang@suse.com>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  drivers/md/md.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6ae1d6..7f2db7c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5588,6 +5588,7 @@ static int md_set_readonly(struct mddev *mddev, str=
uct block_device *bdev)
>  	int err =3D 0;
>  	int did_freeze =3D 0;
>=20=20
> +	test_and_clear_bit(MD_CLOSING, &mddev->flags);
>  	if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
>  		did_freeze =3D 1;
>  		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> --=20
> 2.6.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlja0gAACgkQOeye3VZi
gbkrBg/+L0PJtlGixnty4Sg6MrCUlSTnVIx2LfssQoS+RPtNCYFIcet83D0W0ERa
HPJrPZQEe1RY3PaenBoOskBaOvd/BJLkaRGACDQ2vOPupHPNtBElbq6YwKWl5puN
IEvxnsvbPgs09o2/K9aLOi/6+6YwFw3/KeLUPC6kZNREbVZUxgVXZCfHYREBK12h
3Yqx3YxCgI8mT0DG6eCygdGZrXJXqyvdnaVlnziMHXBRo1GSL70w/vAoNW1s9y1L
BQVU6L6g81CUVsrrDSuEmhtxGRC8Wq3R7ZVdgDRGHnC2TXAcVKtGprK60MzhX0MS
fVIq/KCsYmML4mIhkZc4NfCkaa4nffElZCJB/0uNxFpPGcK1DWknlW009KkMLxcw
xg9wAxeTE69myfaVXJztA6EVdMf4gErdNJkzB2O+4I4DzRxnc23MydAawKRm2OzT
yY8tDevtcyCcnKACg+jnek14F+VF4vRsCqDjEN2jN7hehQZdYhSIYB32neSY7BLx
UihvDuhdDwng94NJdJi4cKi79NMWhkrTaWb42Y1wIT0gSwrouEV5TXDsSJXa4Swx
nFHNMO4FK0WbVS211OjOZ95U/qyg6TvMTTqKvKeoulyJj2RY7AUVt/ztMx0Rr6CG
L/9nh49xo3rtjKvgw11DbAmCV+sOMZdmZ1VA4Vxtp0A/wR+FJB0=
=aPKX
-----END PGP SIGNATURE-----
--=-=-=--
