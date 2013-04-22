From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG][PATCH] Fix: raid1/raid10 md devices leak memory when
 stopping
Date: Mon, 22 Apr 2013 10:29:18 +1000
Message-ID: <20130422102918.7e9df194@notabene.brown>
References: <20130416.201507.1380418477042006122.taka@valinux.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/404f/mTHyx+lB.xcuFwjDQc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130416.201507.1380418477042006122.taka@valinux.co.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/404f/mTHyx+lB.xcuFwjDQc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Apr 2013 20:15:07 +0900 (JST) Hirokazu Takahashi
<taka@valinux.co.jp> wrote:

> Hi.
>=20
> Raid1 and raid10 devices leak memory every time they stop.
> This is a patch for linux-3.9.0-rc7 to fix this problem.
>=20
> Thanks,
> Hirokazu Takahashi.
>=20
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> ---
>  drivers/md/raid1.c  |    1 +
>  drivers/md/raid10.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index fd86b37..c055b92 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2901,6 +2901,7 @@ static int stop(struct mddev *mddev)
>  	if (conf->r1bio_pool)
>  		mempool_destroy(conf->r1bio_pool);
>  	kfree(conf->mirrors);
> +	safe_put_page(conf->tmppage);
>  	kfree(conf->poolinfo);
>  	kfree(conf);
>  	mddev->private =3D NULL;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 77b562d..5a1010d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3810,6 +3810,7 @@ static int stop(struct mddev *mddev)
> =20
>  	if (conf->r10bio_pool)
>  		mempool_destroy(conf->r10bio_pool);
> +	safe_put_page(conf->tmppage);
>  	kfree(conf->mirrors);
>  	kfree(conf);
>  	mddev->private =3D NULL;

Thanks for the patch!
I've queued it for 3.10-rc

NeilBrown

--Sig_/404f/mTHyx+lB.xcuFwjDQc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIUAwUBUXSEXjnsnt1WYoG5AQID/w/3d9v0TZEDf3+7GhvVKcx89tHSRuokXyTn
yL5w+b1NlgQJKcHBhhFEKofIugGmHtLoVBP5oYxwmP4WpQxhoIAQ3sr2vwQ4Vvlf
3OF9VZtmQA1oGOQY6hBMl+2qwZStq6UOf2D+DPCLh0D/HrsJA2EBHJv0DKnewFpY
3v+XGF0tmnVJuhV18JtQHVshE+o/Kf94ynwr8wgxFLf5WDN4PshsgHRyMhza9gOu
AcFYupAvftFnoJrDHeJaSIcpJKXRsy8zXa9v4HeR64x5vq2yf9GKjCa+YPNAY6hr
BpS8gUsFieRWbuVXk+7G+oHLDIjvn9XRYtT385hb0pLT6kTWCD4D9jAh3+U2fhVm
HEThCB9oqWJgr2xoW1vySnxP0KWS8vJ1ogUS5FexS5NkFfa02YF3Q/ByqbFL8JJ4
Zc7l8G+g8LNQjC47tgyVzs+ikI/+yvVJXULIbRLUoaejWRwVQaieaWZG5H7lZ3Cz
Sac0eG0x6vJSYerxkviaFqwO7UIxNUOC0eDnbbrMYQ0F878NiGdXy64ce3XhKW2c
2GRyQUWmH/+RmTxH7Hwk0FANK+85V4tDYf/y/uzQ2jKmhWRP3rZWKePkmfe1gndn
yXBgvgvH6oErAkWWR31NljLRq9izQJQIL1CLFPjEFx+GoAC8hmQWjSuktBqBFn16
6XewDi8+Iw==
=qsdn
-----END PGP SIGNATURE-----

--Sig_/404f/mTHyx+lB.xcuFwjDQc--
