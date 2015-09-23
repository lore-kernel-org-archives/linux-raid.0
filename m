From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/1] md/raid1: Avoid raid1 resync getting stuck
Date: Wed, 23 Sep 2015 16:49:57 +1000
Message-ID: <871tdpy6i2.fsf@notabene.neil.brown.name>
References: <1442413205-9593-1-git-send-email-Jes.Sorensen@redhat.com> <1442413205-9593-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442413205-9593-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, nate.dailey@stratus.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> close_sync() needs to set conf->next_resync to a large, but safe value
> below MaxSector and use it to determine whether or not to set
> start_next_window in wait_barrier()
>
> Solution suggested by Neil Brown.
>
> Reported-by: Nate Dailey <nate.dailey@stratus.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/md/raid1.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4517f06..763a0a8 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -881,8 +881,7 @@ static sector_t wait_barrier(struct r1conf *conf, str=
uct bio *bio)
>  	}
>=20=20
>  	if (bio && bio_data_dir(bio) =3D=3D WRITE) {
> -		if (bio->bi_iter.bi_sector >=3D
> -		    conf->mddev->curr_resync_completed) {
> +		if (bio->bi_iter.bi_sector >=3D conf->next_resync) {
>  			if (conf->start_next_window =3D=3D MaxSector)
>  				conf->start_next_window =3D
>  					conf->next_resync +
> @@ -1516,7 +1515,7 @@ static void close_sync(struct r1conf *conf)
>  	conf->r1buf_pool =3D NULL;
>=20=20
>  	spin_lock_irq(&conf->resync_lock);
> -	conf->next_resync =3D 0;
> +	conf->next_resync =3D MaxSector - 2 * NEXT_NORMALIO_DISTANCE;
>  	conf->start_next_window =3D MaxSector;
>  	conf->current_window_requests +=3D
>  		conf->next_window_requests;
> --=20
> 2.4.3
Applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWAkuVAAoJEDnsnt1WYoG53ogP/1O+IrlBGjSjmjVfLtOyUr+S
bxmspyIbRuolxXE2QCaptpptrZcvHSh/H+6e99yUqGL240v/FlJGzdq3FuTssDsP
S7KLq7MQ0Tzs6aaSAECcGQ8rmtrj+cai+VfhT1z0mc6wj/4DaZuIEXCTZAt7vfsH
FAE/+cLejQNYm2/veoazmvEM+qAtvQGO7is4yO/z0eSDB5y00bIkzmt0iw1IbLi5
Z5NdfZKDsJraIoHvhePc3TMAgPn9N9QHj771Qkkavke+m+IEnATYYzbRjiGkA/BM
yCvDjx7+3VxxbzucyoZTRvCuNHm7saLVxtVUvSgiRLfRA2RCiIx+6IYo99bIVDYR
0cpNORKRt5FlYT4CpFX9nIO215JXy/3ZM48OWJZQXHLxAsLJsJ8TkXEalGRMYdNK
zPUoz/kvB8ZI8r1wOESn7fUCQKB1eidaLg9dbCinp06GEmP8DWSGBGQh/xHS+4tP
cvo41esNgbFSiaZWkHKBHxrKq1H8P98OPi6qOJKLkIO8PFEbqBew85W+rXvJz5Dm
WSAevoQS8DPjT1aEUAJvzfHliRW3H2iku5b6agb6+W9KeIasBIVSLnEvP4mabFuW
q5DXWHSeAcDTXM2jhGEGy2Zwhch9WfnYYYw8yKfZEwbte5L2qxuFhP0QxQBaPI4Q
9fISp6/qQli1CEYUIMXZ
=RWLF
-----END PGP SIGNATURE-----
--=-=-=--
