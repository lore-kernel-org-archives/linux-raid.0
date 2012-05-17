From: NeilBrown <neilb@suse.de>
Subject: Re: [patch] md/raid10: unlock on error path in
 raid10_start_reshape()
Date: Thu, 17 May 2012 17:39:24 +1000
Message-ID: <20120517173924.186266d1@notabene.brown>
References: <20120517064911.GB14660@elgon.mountain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZcKJ0R5B.OaGNhHaEmzK7b2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120517064911.GB14660@elgon.mountain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ZcKJ0R5B.OaGNhHaEmzK7b2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 May 2012 09:49:11 +0300 Dan Carpenter <dan.carpenter@oracle.com>
wrote:

> We need to unlock and enable IRQs before returning here.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e8ed1d8..ba7290f 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3918,6 +3918,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>  	if (mddev->reshape_backwards) {
>  		sector_t size =3D raid10_size(mddev, 0, 0);
>  		if (size < mddev->array_sectors) {
> +			spin_unlock_irq(&conf->device_lock);
>  			printk(KERN_ERR "md/raid10:%s: array size must be reduce before numbe=
r of disks\n",
>  			       mdname(mddev));
>  			return -EINVAL;

Hi Dan,
 thanks heaps for this!!
I've merged the change into the original patch with suitable attribution.
The result should get into tomorrows linux-next.

Thanks,
NeilBrown

--Sig_/ZcKJ0R5B.OaGNhHaEmzK7b2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7SrLDnsnt1WYoG5AQLnRBAAmlelwAwI/jE7RMUPnPebw9CCFOX8q0ly
4spi2upEY+Gpij3hv69LsctCxDRn0HUhp4P2ky7qyk/lcL0bgz5g6uBRWhAV/DuT
nJ3ELfg+lxbZNGfbGJcxP9cvmmx0EOO5ej6fAckM1KnPqXHA6q/JIOWNGG5rr+UO
GNA0gX5BARhuODDkrKp1Z5YuJx1KWCxNxuLcCB8bx1VEZ7C1BeEOuIYxYwC32zGH
7yzRRiJq9+O1LQ20MxT9lypshJ/irA6id/F2mwlQx/krPCXW5i+DjSdNid9bRxuy
7b48IOqw6lY5mEdcvRVc6Pr0xuC8puB442+Tnmq9BMDaat8saOCcPvV48SvIxpeN
nPALu0mwmfAG8cynAKWj/bnf8LLSWWGDwjAJBZgHSR5y5kswdja9fj1HNYirQAAy
FYnYZ3yJEbdP6eO7kACJMCN8g5UmeWrOtOjlJOXGT2pJFMZOqq+cnYrMZFHPoc2D
OdiyLXMoyszfLbohSXTxf1bYHXodyr1IhfmqKDbqSjAOGjtsvzec2293dfYMyGLf
BJuWDaVXeL+MsUkRLOMaMhm8x2nGvL2qfQyCR0XeHL0dGEdWHxbTPkivkXcAfQBW
kSVxmEZRivx60vr2TShKoIrD6R1KXrFC0e+mZTj7T9J0vafBKak9OKm62MjkMuL3
ysgmsO5R780=
=4iYA
-----END PGP SIGNATURE-----

--Sig_/ZcKJ0R5B.OaGNhHaEmzK7b2--
