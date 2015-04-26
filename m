From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid10: make sync_request_write() call
 bio_copy_data()
Date: Mon, 27 Apr 2015 09:49:11 +1000
Message-ID: <20150427094911.0f71b986@notabene.brown>
References: <1429915930-22449-1-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/t1Xz5wu9LvntnE8Z730WS7p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429915930-22449-1-git-send-email-mlin@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>
List-Id: linux-raid.ids

--Sig_/t1Xz5wu9LvntnE8Z730WS7p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 15:52:10 -0700 Ming Lin <mlin@kernel.org> wrote:

> From: Kent Overstreet <kent.overstreet@gmail.com>
>=20
> Refactor sync_request_write() of md/raid10 to use bio_copy_data()
> instead of open coding bio_vec iterations.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> [dpark: add more description in commit message]
> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
> Signed-off-by: Ming Lin <mlin@kernel.org>
> ---
>  drivers/md/raid10.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index a7196c4..02e33f1 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2097,18 +2097,11 @@ static void sync_request_write(struct mddev *mdde=
v, struct r10bio *r10_bio)
>  		tbio->bi_vcnt =3D vcnt;
>  		tbio->bi_iter.bi_size =3D r10_bio->sectors << 9;
>  		tbio->bi_rw =3D WRITE;
> -		tbio->bi_private =3D r10_bio;
>  		tbio->bi_iter.bi_sector =3D r10_bio->devs[i].addr;
> -
> -		for (j=3D0; j < vcnt ; j++) {
> -			tbio->bi_io_vec[j].bv_offset =3D 0;
> -			tbio->bi_io_vec[j].bv_len =3D PAGE_SIZE;
> -
> -			memcpy(page_address(tbio->bi_io_vec[j].bv_page),
> -			       page_address(fbio->bi_io_vec[j].bv_page),
> -			       PAGE_SIZE);
> -		}

You removed the resetting of bv_offset and bv_len.
So I assume this is being applied in a context where these things are now
immutable - is that correct?

>  		tbio->bi_end_io =3D end_sync_write;
> +		tbio->bi_private =3D r10_bio;

Any reason you are moving this assignment to bi_private?
It doesn't hurt, but it doesn't seem to be necessary.


> +
> +		bio_copy_data(tbio, fbio);
> =20
>  		d =3D r10_bio->devs[i].devnum;
>  		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> @@ -2124,17 +2117,14 @@ static void sync_request_write(struct mddev *mdde=
v, struct r10bio *r10_bio)
>  	 * that are active
>  	 */
>  	for (i =3D 0; i < conf->copies; i++) {
> -		int j, d;
> +		int d;
> =20
>  		tbio =3D r10_bio->devs[i].repl_bio;
>  		if (!tbio || !tbio->bi_end_io)
>  			continue;
>  		if (r10_bio->devs[i].bio->bi_end_io !=3D end_sync_write
>  		    && r10_bio->devs[i].bio !=3D fbio)
> -			for (j =3D 0; j < vcnt; j++)
> -				memcpy(page_address(tbio->bi_io_vec[j].bv_page),
> -				       page_address(fbio->bi_io_vec[j].bv_page),
> -				       PAGE_SIZE);
> +			bio_copy_data(tbio, fbio);
>  		d =3D r10_bio->devs[i].devnum;
>  		atomic_inc(&r10_bio->remaining);
>  		md_sync_acct(conf->mirrors[d].replacement->bdev,

Providing you are confident that bv_offset and bv_len don't need to be
updated:

 Acked-by: NeilBrown <neilb@suse.de>

though I'd prefer the bi_private assignment was left where it was.

Thanks,
NeilBrown


--Sig_/t1Xz5wu9LvntnE8Z730WS7p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT15eDnsnt1WYoG5AQLVFhAAwMVs0hoEW+Wt+m/8DN1Xqm67qU1vGcOG
bmYg103JPhjrf/gtRrHa3UmMtuNRJtkA2Z9uL5U3bhoTeG0Mnqp91kWqOkDXdz4l
x+wbIEiReSxc4TZfcPyL49FyC27f5Q75OEb+LXNRTvb+vAF1Vf+Rm5lRSLp0KhWL
lQ3fI33Nn9iimHP1T/lolYh0D/L57y+YlFsQezeRODytV6ewLhkW09rg8V/AJuQ5
lPIS7sIiLvpNdVAW0FAHYVl2pxOgTJu/0n4DuQUI5eQCZAGvWGwQ0yKmyvU96UBo
Wr4QDhEX5QMEwjej1mGcyHbOVktt6de+rLFSZLp7ByuTIgke8PcQO8Ll5jEfoGA8
WaDabz0RSawEu+iZzY2nN0zxOCZKteIk957AK23qFkEcVCzSJo34Yz7TD7Ubdkxa
nmRR4XSwdyS+KnmmP2cRftwebiX0vSLT11aG1M1eFi/LFNjxmgUuD+JxhpVrGnaa
tBtJ0Bkk98Da6B9IxycY9NPrVsCgIXxaDRxfyUQJC4oHdmwrXMM0Bu/iJRKiDDav
p8OLUHIpJ3f4IokAu/n+sedYfzWD4A4FHjijp3PAdPtyLbV1ZNEqJLSCErIHJBK+
CAerv2mI8kapoceWHV50cpbdZxFATazT3F6+GhooeB/GyKFtszVS8Pv18Gu8BFhr
jgpAMb4OSpw=
=I5/q
-----END PGP SIGNATURE-----

--Sig_/t1Xz5wu9LvntnE8Z730WS7p--
