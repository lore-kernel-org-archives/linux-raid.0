From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid1: Initialize conf->raid_disks before using it.
Date: Thu, 25 Oct 2012 09:56:57 +1100
Message-ID: <20121025095657.7c3b6e5f@notabene.brown>
References: <201210241600489486705@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BfQllrtfJ0N4VirilUs0_6X"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210241600489486705@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/BfQllrtfJ0N4VirilUs0_6X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Oct 2012 16:00:53 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Because the conf->raid_disks is zero at first,so if there is a
> replacement disk, func setup_conf will abort.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 8034fbd..4eec567 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2703,6 +2703,7 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
> =20
>  	err =3D -EINVAL;
>  	spin_lock_init(&conf->device_lock);
> +	conf->raid_disks =3D mddev->raid_disks;
>  	rdev_for_each(rdev, mddev) {
>  		struct request_queue *q;
>  		int disk_idx =3D rdev->raid_disk;
> @@ -2724,7 +2725,6 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>  		disk->head_position =3D 0;
>  		disk->seq_start =3D MaxSector;
>  	}
> -	conf->raid_disks =3D mddev->raid_disks;
>  	conf->mddev =3D mddev;
>  	INIT_LIST_HEAD(&conf->retry_list);
> =20

Thanks.  I had already discovered that bug and have a fix in my tree.  I ju=
st
haven't pushed it out yet.

NeilBrown

--Sig_/BfQllrtfJ0N4VirilUs0_6X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIhyOjnsnt1WYoG5AQJ4QA/+KVScFcz6Ycpm1AzrrYnO3BqtZZ0SRYY9
Ow/Dsm2p6RX1BlKrS2AVJzJhM0O63QYRqVtVua9ps8S6l0tcvrcpl6z0Id6qSK3Y
e8GmsC4h0C2LP9XRctKqvc5651l9BGNWGsQLBkYFWfCreNXZVk5sQPBci7BZIle/
znvuDk7S1ekZtIu7/LaiJMsolkrxoAgeg4xdhbi7h6wraw+QvlNgjpzv3DqB/snl
ammhqUlcchkFslH7DPVK7mX0N/MyleuN87AdzTBUCNkoB6eQGThNVhXZqfko93yY
D+189WC0O6d3jd2xw/loeK6iBHT/mGTwsvHJVxQL3r2VkV+9uhBHDisz4xtuMk/9
378bM+MohyepZsd7Qfuk7yIN6m8nudYdZ61XF1KN62WkRMHx0u0PBsRrxl9vTGIg
0am/g77+OBW+/0QACq/9sdFIc5+Dffr+draJgIjsvMJtPREbJj5JHgNNHxVvGN1v
p8PySdLq7VOjeJi+wlBh36Yq7fqLMRm0EiE/jgVnc0DeH2Jyae9LwBLgNiZjgHA6
Dh+2tyeFPGpA+DVrGvYFneEXVEeqggEA7wor9c0pkCPdQ9XyiNyx7aZVgD/yBm38
J7yEg2qmMNL140RJp0NDfq0AzpJ0qMwMpJOHoJ1FGJnPftXhx/8RB0KcCYAQTeuL
DIZNVKiXgRQ=
=DZvx
-----END PGP SIGNATURE-----

--Sig_/BfQllrtfJ0N4VirilUs0_6X--
