From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/4] md/raid5: Tune judgements order.
Date: Mon, 4 Mar 2013 12:49:40 +1100
Message-ID: <20130304124940.398eda52@notabene.brown>
References: <201302281550441221244@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UwbHw_Y.4nBUnt4GraG.TBF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201302281550441221244@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/UwbHw_Y.4nBUnt4GraG.TBF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Feb 2013 15:50:47 +0800 majianpeng <majianpeng@gmail.com> wrote:

> To reduce the unnecessary function call in certain condtitions,it should
> tune judgements order.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 59c0569..bd49623 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4665,9 +4665,10 @@ static inline sector_t sync_request(struct mddev *=
mddev, sector_t sector_nr, int
>  		*skipped =3D 1;
>  		return rv;
>  	}
> -	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
> -	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
> -	    !conf->fullsync && sync_blocks >=3D STRIPE_SECTORS) {
> +	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
> +		!conf->fullsync &&
> +		!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
> +		sync_blocks >=3D STRIPE_SECTORS) {
>  		/* we can skip this block, and probably more */
>  		sync_blocks /=3D STRIPE_SECTORS;
>  		*skipped =3D 1;

applied, thanks (after fixing up the formatting).

NeilBrown

--Sig_/UwbHw_Y.4nBUnt4GraG.TBF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTP9tDnsnt1WYoG5AQKC+w/+J73cR9hYhXkTZJLwhULnL9dt9T2EEitU
v60FQ2TQQwbmt6tneuL1pSkNlRRUHYwqd1YMOO7WpDmLa3r+0kyautqyVMr+c19W
cBWqdz7uPSLOWNp5ngSAKMBnrWjilFDdnC3nm2Dh1bhv2VGgANJkyyutX8dE87/c
YaHdq34Pa0/8DoBluSWCV11kH5Qm6f2MfKGjX0u7DnBohvS3NgM35OIp1JWemvRD
ctEpw+3THRipIacuVcdKCDBZ4vG8W8l4A8H55L//Bqxyp97iiOh5nJsTFDg/hPn/
JsfQWoYFcT9m/l7EMUJwSpb7i5Mf1txC/7u0I4Pfl/s2/UWKvI5rrCwbGmrZKPI9
m7T4C/nAaSAf306YbSiRdWGFPP799zmtB6BwV9mga5myBoqrr9y3Ztscv4B3pOTF
Sj2fAhGkraIkH8bf4RwrnQLzGCy8A9tkWlhKNf6sBiQB5vcmdnVcv4jOpGLFdlCu
G7OsHzJhRMPR0EfGjnOW+tWmlL/YQfui+qLGdVZQ38QQd0KzbgDMkF6xf8i0H+hW
svwu0nMWoI38264XVh0Q3K37Mqb+Jgsm+SCVGrNZCURaYfLbCOQo5y+Mtv9lJu9Q
ja50TslT75oIkzlKaXZRXVMNQwWVcDFUxggC5F7/dXuOaKD4H1ESblYZm8c8vJs/
vop/yTfjHSo=
=OKXV
-----END PGP SIGNATURE-----

--Sig_/UwbHw_Y.4nBUnt4GraG.TBF--
