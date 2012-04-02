From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1:Remove unnecessary
 rcu_dereference(conf->mirrors[i].rdev). Because  rde->nr_pending > 0,so can
 not remove this disk.
Date: Mon, 2 Apr 2012 11:03:40 +1000
Message-ID: <20120402110340.1683d697@notabene.brown>
References: <201203281935226256403@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2Sd/HhG53e2gmkL7=zSBPA6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203281935226256403@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/2Sd/HhG53e2gmkL7=zSBPA6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 19:46:56 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 2d433ec2d351119afac6b57caa6cdec2197c0396 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Wed, 28 Mar 2012 19:30:36 +0800
> Subject: [PATCH] md/raid1:Remove unnecessary  rcu_dereference(conf->mirro=
rs[i].rdev). Because

Also, could you try to find a way to send the patches so that all the heade=
rs
aren't duplicated.  It means I have to go in and edit the patch description
of each patch to remove the duplication.


>  rde->nr_pending > 0,so can not remove this disk.
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..f112782 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2386,8 +2386,7 @@ static sector_t sync_request(struct mddev *mddev, s=
ector_t sector_nr, int *skipp
>  		int ok =3D 1;
>  		for (i =3D 0 ; i < conf->raid_disks * 2 ; i++)
>  			if (r1_bio->bios[i]->bi_end_io =3D=3D end_sync_write) {
> -				struct md_rdev *rdev =3D
> -					rcu_dereference(conf->mirrors[i].rdev);
> +				struct md_rdev *rdev =3D conf->mirrors[i].rdev;
>  				ok =3D rdev_set_badblocks(rdev, sector_nr,
>  							min_bad, 0
>  					) && ok;

Correct, this rcu_dereference() isn't needed and is wrong.
I've applied your patch,
Thanks,
NeilBrown

--Sig_/2Sd/HhG53e2gmkL7=zSBPA6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3j67Dnsnt1WYoG5AQJSpQ/+OY/sp3H1tHO7gDrwTj6iTIh6DhU6G5e4
Zbo4TohSVv6oQpFfYfpQ2cWGUCtsdL9uFjVAJ8tAbAw1UX/FkYMIK2HJ/cqPL99V
FYo7JevTtDG+2QYq65iPmGDmPtVkD/y+5bj/vCXKXvcziEgyqAV2u0/MS1cJqO4H
3dK4Yf7br3tR9JknJBcx0J74WD1e/MVndNXMEveU84TC+uB1VMLRN6dRxjFgqv7Y
GwgUNYKIkkojJVka5nX5hoX6j0i2Up8oVj9y3sP4gG0V4FeSryBlCF2vQAV2YnHo
HQIUYgHgU5T4sjFcf4oU1VdXHQqpYG1dcw8lyeAuPES6ZXfD831UJ+Mo/pC2jRoU
3VGpjw/wq9QDlwA4g5DbkhsY4Wn1Xp8ZsbRAI0TCXWU8CDCJp1o51p/MDDwdGP5Y
o6nQadjwHWzEHJ4iYlUCsm7co2de8WXwPf3cjXVsa14ixufNCDxRLVpvkERTkIJR
yqofaSL3tdlGLOhzmNpwCUJNHl44OzrslDsxXNGQeoHtTecKJQKUuBe6niGdj/uk
838YqQRJM7wcTwNu9zWIWFwmYKsONmkKGS6Hn1n0AQ8UXKGppwKzu0jnWQX0Jq/g
VR5dPyDjqYZziatGSOydW3TgHb4QIIe7wlI8U0BFuqGz5Iuc0tebmK8zIuLteyO1
/ciyhzhmvTs=
=YYgv
-----END PGP SIGNATURE-----

--Sig_/2Sd/HhG53e2gmkL7=zSBPA6--
