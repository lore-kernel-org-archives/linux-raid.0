From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 6/6] md-cluster: Allow spare devices to be marked as faulty
Date: Tue, 10 Nov 2015 10:51:03 +1100
Message-ID: <878u66speg.fsf@notabene.neil.brown.name>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de> <1446781819-25571-6-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-6-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: rgoldwyn@suse.de, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 06 2015, rgoldwyn@suse.de wrote:

> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> If a spare device was marked faulty, it would not be reflected
> in receiving nodes because it would mark it as activated and continue.
> Continue the operation, so it may be set as faulty.

Yes, that makes sense.
Applied, thanks.

NeilBrown

>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4222285..b98cf04 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9013,7 +9013,6 @@ static void check_sb_changes(struct mddev *mddev, s=
truct md_rdev *rdev)
>  				ret =3D remove_and_add_spares(mddev, rdev2);
>  				pr_info("Activated spare: %s\n",
>  						bdevname(rdev2->bdev,b));
> -				continue;
>  			}
>  			/* device faulty
>  			 * We just want to do the minimum to mark the disk
> --=20
> 1.8.5.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWQTFnAAoJEDnsnt1WYoG5kvcP/ReSAHn6ZsOWmtXDokpWSuv5
gzOfVQRjbcEiAxvmDDn90e/WaLlEjFA2oKk0ED59PCGP9Jom63iwmMo0uH7M+fC+
TdZbeVmklsJjRObpLHuAkUhxQr7u3GGsPXKf0ulR/G3wDF2TYKH3bN3G1LIoGjVv
AtXTJ7H0RnwQLBwckD3/MussXlv/NbeYWMTylh/r8/sj0kqVOYqM1qV0HwWPWxhT
Pr/JecZ8/frIR1sBW7igu27+l38jaCjeGuG6nibzk6oSdlQxuA5Al+AeZZi0OzL5
lwlCosMXJCf+/QiaCMBRP7Nro18/v0VCFnXdScp9c5Pr4UwII+uaB0KWBJNuomCj
+GpX9BUsOmB+uLYCJvNZallV2vjKaQNgYM7kzHQyuDcPg8HZDFDx/37ZOGuI3tCo
B5DNpjMI9xKxMBjHd06GEhE24cos7wOqT8LGkeaFJBPreHJedIcFFWIGzVofOHvL
6X+jwBGeWD//TOe5VO3wT17qbVY2525gB0SvqBoVVB2O//BjVW31pMVS3ThSRsEo
TJeWXh3FPzuxak6stAQZC3Y1DFFx5x0JtBqxj5Fab96pVuxkzfcBnQNbkAxCksPs
8JCcrKMWnMQIKuRyp5Jg3zAFBMkHgW3E7hjhuGypGqDwT3mBffWCMfl+jfhv2IBI
LGS4HgPAgOzghkA45bjp
=hQU2
-----END PGP SIGNATURE-----
--=-=-=--
