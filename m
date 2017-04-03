From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH] blk: reset 'bi_next' when bio is done inside request
Date: Tue, 04 Apr 2017 07:25:45 +1000
Message-ID: <877f31kwti.fsf@notabene.neil.brown.name>
References: <9505ff12-7307-7dec-76b5-2a233a592634@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <9505ff12-7307-7dec-76b5-2a233a592634@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03 2017, Michael Wang wrote:

> blk_attempt_plug_merge() try to merge bio into request and chain them
> by 'bi_next', while after the bio is done inside request, we forgot to
> reset the 'bi_next'.
>
> This lead into BUG while removing all the underlying devices from md-raid=
1,
> the bio once go through:
>
>   md_do_sync()
>     sync_request()
>       generic_make_request()

This is a read request from the "first" device.

>         blk_queue_bio()
>           blk_attempt_plug_merge()
>             CHAINED HERE
>
> will keep chained and reused by:
>
>   raid1d()
>     sync_request_write()
>       generic_make_request()

This is a write request to some other device, isn't it?

If sync_request_write() is using a bio that has already been used, it
should call bio_reset() and fill in the details again.
However I don't see how that would happen.
Can you give specific details on the situation that triggers the bug?

Thanks,
NeilBrown


>         BUG_ON(bio->bi_next)
>
> After reset the 'bi_next' this can no longer happen.
>
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> ---
>  block/blk-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 43b7d06..91223b2 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2619,8 +2619,10 @@ bool blk_update_request(struct request *req, int e=
rror, unsigned int nr_bytes)
>                 struct bio *bio =3D req->bio;
>                 unsigned bio_bytes =3D min(bio->bi_iter.bi_size, nr_bytes=
);
>
> -               if (bio_bytes =3D=3D bio->bi_iter.bi_size)
> +               if (bio_bytes =3D=3D bio->bi_iter.bi_size) {
>                         req->bio =3D bio->bi_next;
> +                       bio->bi_next =3D NULL;
> +               }
>
>                 req_bio_endio(req, bio, bio_bytes, error);
>
> --=20
> 2.5.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljivdkACgkQOeye3VZi
gbkbVw/7ByPfk1neLYOLUeO+tqybXB82stMV64ClsnR1jkOoTxc57veJB3KDM9vJ
b28QS+7Gb9B5EzYkswOpptcLjDeZoEAxYBAFRtjwXCR4iR6pMmeuMPMbK0LuxAxF
USdfMvWEeZG3+rhYBj3IlOVu+krWNAe/WbLHgL2QTnNFsOzFD1qUmpPTS2AiPzjg
WSYla/B4oHNkTt4APrwP6bFsI3g63e0gC8XItMv/qrRVeBqSxb+YsH24eUm+3Ogy
bgFP0Th/ZwhW9Xr8n3rgdFjiJd2Bdtj4THFI4yY2LcMrMusl62ClJgnd48M5t+mh
hz3RtfJmJxmSXgCyZeA22mybF7ZyCPNN/YAibbJeqcRoC9IQ2RRAkAzTlXV1kzUN
3pZYpvXSzv5rgBwy3OXTLK7bxa9MyguDR+g8E6KOLGPxInxogny7SJT5VkP/+ClF
jRIBzMvKhoeC/0WrRY6pyGoM9kEEUc2kJFSWMAdK5GB+Ncc8/J8Ivn0w7JZFISFQ
+/zOhELFlK63WOoJs34+I66wATsndOsmzdJ+iuE1AFgSqb4wjfE5AHr1p9XZGKpU
Ymttr6Ehaf67DUffO1OWqkb+fxU/YHlMuXu/ponk6/MudWjOgDk0NJzmCKbXaukp
r8rhEmRDpyfofJ561U+yjHGRf9Mug0tXq5g2Zjw1lcqctLZuMsQ=
=I6Ea
-----END PGP SIGNATURE-----
--=-=-=--
