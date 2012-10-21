From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md faulty: use disk_stack_limits()
Date: Mon, 22 Oct 2012 10:45:56 +1100
Message-ID: <20121022104556.2ddcb2f3@notabene.brown>
References: <5081E5B1.3070903@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sZ5DClM.VKJQId/nca.4ege"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5081E5B1.3070903@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Mike Snitzer <msnitzer@redhat.com>, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

--Sig_/sZ5DClM.VKJQId/nca.4ege
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Oct 2012 18:43:45 -0500 Eric Sandeen <sandeen@redhat.com> wrote:

> in:
> fe86cdce block: do not artificially constrain max_sectors for stacking dr=
ivers
>=20
> max_sectors defaults to UINT_MAX.  md faulty wasn't using
> disk_stack_limits(), so inherited this large value as well.
> This triggered a bug in XFS when stressed over md_faulty, when
> a very large bio_alloc() failed.
>=20
> That was on an older kernel, and I can't reproduce exactly the
> same thing upstream, but I think the fix is appropriate in any
> case.
>=20
> Thanks to Mike Snitzer for pointing out the problem.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>=20
> diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
> index 45135f6..5e7dc77 100644
> --- a/drivers/md/faulty.c
> +++ b/drivers/md/faulty.c
> @@ -315,8 +315,11 @@ static int run(struct mddev *mddev)
>  	}
>  	conf->nfaults =3D 0;
> =20
> -	rdev_for_each(rdev, mddev)
> +	rdev_for_each(rdev, mddev) {
>  		conf->rdev =3D rdev;
> +		disk_stack_limits(mddev->gendisk, rdev->bdev,
> +				  rdev->data_offset << 9);
> +	}
> =20
>  	md_set_array_sectors(mddev, faulty_size(mddev, 0, 0));
>  	mddev->private =3D conf;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.

NeilBrown

--Sig_/sZ5DClM.VKJQId/nca.4ege
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUISJNDnsnt1WYoG5AQKvwg//Tq/WeWpHBgnd8ZyWHS7YRZPwzYnwDu7L
GOSJXZz5iOuOA/OgYYLCoPjxLGBNvUlGGy/HyZWgCOfXyZfrAPYf/79FrGNxlMz3
frpA/b57ritLdAObq09l2Z01+7yLttBAcvyjE+C98iebpn8VJ8nV/tR9LEOtWbT7
7rjY2YvjDBFV7kg6gE4lb6sIHBmEszKt7D6cueTkjVAif3Yicr7LcjxakjPJP1NB
ymBKZnhN+fPlV2YVoiYh2UedLrFUg+T0R8b4vZj7f3Afj3DSYNo9do6wOQDVhtin
ajfeAk+KONfPHDNO+dVISNRr9H+NrvvmNb+e97Bq12ed+wgQbtzBm0EXe+BNeg/B
2fkIpOpxHk4Lp/5qNMgpcT9VgwKET9Tvy1ZFtATwRtJGf60n1TZI+oARWl6R95cX
ntwV29Yy6NzhC8qpkpoEYLwapulFnhD8VMAI+ilvWNF8Jj7y2xe4ib4H31v+xLe3
oLt+q5G4y8xzph9+lpaUh4wpMmg3n1Y3wgSDAtOAQ0vtrjDsBbFGD4sqk0mH/qUc
q+EcRv8SiF31EEyOd1iwpd6BwuOeUQG/XhGuVvv6OPaDU9SIYDKxrl8Wl6zw/8ag
hkYlhAgRvCQDvd6kfeMq/OV2HGImrlqH7TK0Ka8zSQ5O9ePNjYjCtdzBzBvBOHiy
E+T4dCQHGXQ=
=rP36
-----END PGP SIGNATURE-----

--Sig_/sZ5DClM.VKJQId/nca.4ege--
