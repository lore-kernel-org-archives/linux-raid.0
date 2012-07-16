From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] raid5: For write performance, remove REQ_SYNC when
 write was odirect.
Date: Mon, 16 Jul 2012 15:40:10 +1000
Message-ID: <20120716154010.0ef12c57@notabene.brown>
References: <201207160931507187344@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XfakAjU8drn8uip2d/QlaGO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207160931507187344@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@ZenIV.linux.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/XfakAjU8drn8uip2d/QlaGO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 09:31:55 +0800 majianpeng <majianpeng@gmail.com> wrote:

> In commit e9c7469bb4f502dafc092166201bea1ad5fc0fbf:
> Tejun Heo introduced "implment REQ_FLUSH/FUA support".
> But for direct-write-blocks, it maybe for other purpose which like the
> regular file.
> And this flag will set STRIPE_PREREAD_ACTIVE which decreaed the change
> to full write.
>=20
> But this patch remove REQ_SYNC only judging the WRITE_ODIRECT,it will
> contail regular file.So it maybe not correctly.
> How can difference odriect_write between regular file or block file?

Hi,
 I think you are saying the when REQ_SYNC is used with O_DIRECT writes it is
 having a negative effect on throughput because it allows the stripe to be
 processed immediately without waiting for more requests to be added to the
 stripe.

 Normal 'sync' requests use WRITE_SYNC which includes "REQ_NOIDLE" which me=
ans
   /* don't anticipate more IO after this one */
 O_DIRECT request use WRITE_ODIRECT which does not include this flag.

 So maybe we should simply change raid5 to only set STRIPE_PREREAD_ACTIVE if
 REQ_NOIDLE is set on the bio.  I think this would have the same effect as
 what you are trying to achieve.

 Could you please try that and see if it has the desired effect on
 performance?

Thanks,
NeilBrown

i.e. something like this:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d56d74d..2d72a57 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4178,7 +4178,7 @@ static void make_request(struct mddev *mddev, struct =
bio * bi)
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if ((bi->bi_rw & REQ_SYNC) &&
+			if ((bi->bi_rw & REQ_NOIDLE) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);


>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 04348d7..8d2d4d1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4010,6 +4010,9 @@ static void make_request(struct mddev *mddev, struc=
t bio * bi)
>  	     chunk_aligned_read(mddev,bi))
>  		return;
> =20
> +	if (bi->bi_rw & WRITE_ODIRECT)
> +		bi->bi_rw &=3D ~REQ_SYNC;
> +
>  	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
>  	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
>  	bi->bi_next =3D NULL;


--Sig_/XfakAjU8drn8uip2d/QlaGO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAOpOjnsnt1WYoG5AQJYWA//Se07R+Hb0+LDAOl5wu+9Eyg70IvQy0tg
F9sD7+C7b/fmR0nGKy3H+PU1hMmu89QhNNWnPy5SohO6To9KORYHe3hcdyK+lwF/
BAogK/ZzTwttSec2ItT2ruz9VXHSlQWZ4iaShAao4XH0qTaM3qvQ/iPqHFUN4Ldn
THdV9WYUAB8GDTUT4LsYIQJ/plHG+55n83xqrGdWB5rTE50AiKjv8sdlFoC2Ycfq
oqZwQx9CaOy6d9zWq0Sm26iPqVLEwc5hIdABbobmrOfcIG+gGz2Qrp1P4kntt5Gv
VOiyPvDJFQzGo8hfEpz5zc4GLAY2McWisAxTYsQDQxY5eVN+tTrmOrVqCsyHVTr0
lkydrn95ZmT3rf/iULkRdyppp3ytb7ne2RoHuE5jng4c6LKg0gCYgmAIl6HzzA1G
8z/HmfIeSGnvYfAjFgftBLrcHl/oRsaDehT654w6Of3QrQbUzX8sRpaan4v0/tpT
6Y5zNDBW7q+OZnW3MVV6Tz/W8/85pqrq4x0UbUbvus+tZjHE5Zc1p0RvQYPQ/Y/L
QBjrD5HzivWbdZe0Drho/aD+c079wP5D1wlecFLvDeuSrB18Ir7YEwRQWsJbkMDf
SdWofzFDOkx8GfVpyWW6PQcy/g4BMXuCgxRz3ygaVL4q7kwlYlzMC3ZtgFsrbgFT
anloD/nYspw=
=gdTh
-----END PGP SIGNATURE-----

--Sig_/XfakAjU8drn8uip2d/QlaGO--
