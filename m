From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5:Not add data_offset when call is_badblock in
 chunk_aligned_read().
Date: Wed, 27 Jun 2012 12:16:10 +1000
Message-ID: <20120627121610.7323cb5d@notabene.brown>
References: <201206121631060930170@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZYcIs3qs1ZeV/zqJI.f9jLD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206121631060930170@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ZYcIs3qs1ZeV/zqJI.f9jLD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Jun 2012 16:31:10 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d267672..940f3a7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3881,8 +3881,6 @@ static int chunk_aligned_read(struct mddev *mddev, =
struct bio * raid_bio)
>  		raid_bio->bi_next =3D (void*)rdev;
>  		align_bi->bi_bdev =3D  rdev->bdev;
>  		align_bi->bi_flags &=3D ~(1 << BIO_SEG_VALID);
> -		/* No reshape active, so we can trust rdev->data_offset */
> -		align_bi->bi_sector +=3D rdev->data_offset;
> =20
>  		if (!bio_fits_rdev(align_bi) ||
>  		    is_badblock(rdev, align_bi->bi_sector, align_bi->bi_size>>9,
> @@ -3893,6 +3891,9 @@ static int chunk_aligned_read(struct mddev *mddev, =
struct bio * raid_bio)
>  			return 0;
>  		}
> =20
> +		/* No reshape active, so we can trust rdev->data_offset */
> +		align_bi->bi_sector +=3D rdev->data_offset;
> +
>  		spin_lock_irq(&conf->device_lock);
>  		wait_event_lock_irq(conf->wait_for_stripe,
>  				    conf->quiesce =3D=3D 0,


Thanks for catching that!
Patch applied.

NeilBrown

--Sig_/ZYcIs3qs1ZeV/zqJI.f9jLD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+ps6jnsnt1WYoG5AQLumA/+K8w0EfOBRPphZSDmo6vcqMJ2QQE7u3sW
LW4Yfqn3O13u8LjMZ1/dGR3piVTu83N9PHzKQQyP5vvMVfmvQXjOmDVb1LHvMDNX
l/ppD87S6o9fqacVnCXfSC5ABZS4OrBum3Se6rOZUUCsWD75MPz84NiSBJUnc3u1
nA9SF8gldZRTPMIePAkIEiwJF2QU0wNUzT9yGaPqknfsLx6u0u+MA5hmvRB1F44b
PcY4h5/7ItQN0y/hJ5maFR9QdlxENQ4alPmhpMpptl11ZmjAHd3FHaVGpMbht6VG
mDq/gMCOzeG9wQISN9NqB3pYlwiUrDY1LfUC78s6QrypkRyup10oXGnkmNPTkQxJ
O7oFwfa+hADKTEV+z6KGp+39OkwkiwjaK5yU0qKsQdb65WfwKTdN5wNonMFZe6XG
TX/XMjU5kitzA0+eWPJq/j0bj75SHkVzH6BEhS6j38tSZ5iP0m6/bcidwdRpBC1B
eDRv6ep1BDm4dGVfSWZQRIhhj0Fmv3P5HjHmb+rEOK264+zZ9Kel4/DI5UV1x3M8
IKdsadqKieXiqyQo17x3EcSOVJuTd1+hLfXqEZM/MC8ItdLBEhGcK1HyPVPCJ/w4
S5dw05GkOPa0TldDWgZrhwV8NnwlK8lyiIX04PIUEAg7/hxaDrFvWzLLsGWFD68j
hUycSW2NOD4=
=swb0
-----END PGP SIGNATURE-----

--Sig_/ZYcIs3qs1ZeV/zqJI.f9jLD--
