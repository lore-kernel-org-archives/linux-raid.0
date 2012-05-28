From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: Fix Segmentation fault.
Date: Tue, 29 May 2012 09:23:30 +1000
Message-ID: <20120529092330.1b7c611f@notabene.brown>
References: <201205251949358900592@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZpoBY1UOg5VRxH+t.k9E47X"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205251949358900592@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ZpoBY1UOg5VRxH+t.k9E47X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 May 2012 19:49:40 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> In function write_init_super1():
> If "rv =3D store_super1(st, di->fd)" return error and the di is the last.
> Then the di =3D NULL && rv > 0, so exec:
> if (rv)
>     fprintf(stderr, Name ": Failed to write metadata to%s\n",
>      	 di->devname);
> will be segmentation fault.
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  super1.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/super1.c b/super1.c
> index 4f20cc3..37b7a90 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1242,6 +1242,8 @@ static int write_init_super1(struct supertype *st)
>  			rv =3D st->ss->write_bitmap(st, di->fd);
>  		close(di->fd);
>  		di->fd =3D -1;
> +		if (rv)
> +			goto error_out;
>  	}
>  error_out:
>  	if (rv)

Thanks.
This doesn't only go wrong when di is the last.  If di is not the last it
will not crash, but it will report an error for the wrong device.

So thanks for finding this - I've applied you patch and also remove the
'&& ! rv' test from the 'for' loop as it is now pointless.

NeilBrown

--Sig_/ZpoBY1UOg5VRxH+t.k9E47X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8QI8jnsnt1WYoG5AQJOCQ/8DIsggw3hSyPuJU3mvnz6mDwkH6JQXfd/
qH5wed78hSDwDhjAfbvUj0NOZybdWaBbGhkD+urRzVPaXI/jIo9ji/mrd9D7nJL2
DvAMt+FHD0H6FF972B1rBW35Qgma8dCs+JmkGkHbJ/yxk8q9pib3wz2CQ4zg7mBW
2IuLj4qaj7FNjNsdh4uvv9ingrFf3HZ/mVUXur1CygaF2x0QXH1HJJx2DM1M8VSf
d+ATSwUT7DbGOLt9Q9K/mLMZnXX7HGDlmd97353Cx/HlltC8VtXIBilaC+hagdi4
r2+9gRPWOYnGirQ2amqyDsejZSjKLd3tbKHB1yFBUkvDAfZcIIQMsHIGVOLkkgpf
gFNS+7dOBqDs2nNGLs3y2mb4xFxeqLZwWs/yU//BReeYLdtK8K7A9zpadf6DrZ6G
l3zWo0X4EUAQ0fWRD/Var14vOaVAWb61WSsJ/rHFX/9xYEzenGq1ykaseU8uFEPU
pHp9ayAmPmXgqHDD7Ha6wT0c1Jz8GzjdFIwsPkghRjoWzDGBof5g/rhdoZZA/x6U
HRa1YNGIzDCzQAhNG6WXtlSbIYMhMuPlIVnx3tEo3MPrkkDddKPgsxa2R+Tvay9T
ffV6crVIfltuLJgYLiA0JLco5q1NQjGGW9vRMZz+kd40LzbO52JH/yH751hNxMdw
mn1VB3pZHEg=
=NOMd
-----END PGP SIGNATURE-----

--Sig_/ZpoBY1UOg5VRxH+t.k9E47X--
