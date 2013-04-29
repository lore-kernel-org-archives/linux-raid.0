From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]MD: ignore discard request for hard disks of hybid
 raid1/raid10 array
Date: Mon, 29 Apr 2013 11:03:12 +1000
Message-ID: <20130429110312.5d329824@notabene.brown>
References: <20130428102638.GB1753@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jYjW5vGn4PKAQJbSpsu2e04"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130428102638.GB1753@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, M4rkusXXL@web.de
List-Id: linux-raid.ids

--Sig_/jYjW5vGn4PKAQJbSpsu2e04
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Apr 2013 18:26:38 +0800 Shaohua Li <shli@kernel.org> wrote:

> In SSD/hard disk hybid storage, discard request should be ignored for hard
> disk. We used to be doing this way, but the unplug path forgets it.
>=20
> This is suitable for stable tree since v3.6.
>=20
> Reported-and-tested-by: Markus <M4rkusXXL@web.de>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid1.c  |    7 ++++++-
>  drivers/md/raid10.c |    7 ++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
>=20
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c	2013-03-07 14:14:05.950824173 +0800
> +++ linux/drivers/md/raid1.c	2013-04-28 08:57:17.874058434 +0800
> @@ -981,7 +981,12 @@ static void raid1_unplug(struct blk_plug
>  	while (bio) { /* submit pending writes */
>  		struct bio *next =3D bio->bi_next;
>  		bio->bi_next =3D NULL;
> -		generic_make_request(bio);
> +		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> +		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
> +			/* Just ignore it */
> +			bio_endio(bio, 0);
> +		else
> +			generic_make_request(bio);
>  		bio =3D next;
>  	}
>  	kfree(plug);
> Index: linux/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid10.c	2013-03-07 14:14:05.950824173 +0800
> +++ linux/drivers/md/raid10.c	2013-04-28 08:57:44.765719067 +0800
> @@ -1133,7 +1133,12 @@ static void raid10_unplug(struct blk_plu
>  	while (bio) { /* submit pending writes */
>  		struct bio *next =3D bio->bi_next;
>  		bio->bi_next =3D NULL;
> -		generic_make_request(bio);
> +		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> +		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
> +			/* Just ignore it */
> +			bio_endio(bio, 0);
> +		else
> +			generic_make_request(bio);
>  		bio =3D next;
>  	}
>  	kfree(plug);


Applied, thanks.

NeilBrown

--Sig_/jYjW5vGn4PKAQJbSpsu2e04
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUX3G0Dnsnt1WYoG5AQKlCw/9FPlZ9DNOZi8Ja4NBJwvnR+p9fBf8Bhjo
z7aBoltJk2Od+PajkDqLh2DoGbpvhzsLETU48UUTac3VuhlebDAzNPeZUPP7Exn6
3VUuxfhzv4MG49OGvzwm+z0tdeJ0hP+DGbkd8jpgbXzl5UGLs1NCB2fWSdKdYFFk
HYr195mfoOr7RrhPAqE9lAK/EN0u9Z/I7AZP/gHol3W/590TJPI7AewNuQC2UZyx
j00DSrzDVbUiZS7aJ1T/6xlNr8PvFWTE9tJgPKavqG3wFBmLu5blnislIVUeD0Bi
VCBlp5dxvWswKM64EiAwA+oQaZ+g0TUYJ5ApMy8FiSlO1Cq9PfQnTdAawL42Jsnv
xt4pZ20G5tNB9RPetNePDVC6oI6IXsMoHjkIFqtPSgSQSmUQop/hrIeQ9qbgysEi
Qfc7Rtg6hkUMchJIDw83lsO+EjaVkcZaQA0wSxLuG6MIFGUhpPbYq83+ikDI3tWf
IwxvQqJ/k8fMbwibziZM91z4QDD9Fdctom/B4nhi1epanCrP/PbNthhIhMJEh8DP
RMQivhmh7PypcnmxYJsPi+Wyg7gKsmjnrOBgiiYgq/Kun/GnA2FHvl9YtJxJJAAc
Xv7ARHxzMjIMn++myQZvuAEdCtk1n8wTq3F+l00b+Ib+ypmkXtZOIMw8SRRG5I6+
C1YRYka4bXU=
=+Qw6
-----END PGP SIGNATURE-----

--Sig_/jYjW5vGn4PKAQJbSpsu2e04--
