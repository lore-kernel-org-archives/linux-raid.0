From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2 V1] [PATCH] fs/block-dev.c:fix performance
 regression in O_DIRECT writes to md block devices
Date: Tue, 17 Jul 2012 13:04:34 +1000
Message-ID: <20120717130434.670e51e9@notabene.brown>
References: <201207161422001403795@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KzRnd.dcY4FNz7.S683e_9T"; protocol="application/pgp-signature"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201207161422001403795@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@ZenIV.linux.org.uk>, axboe <axboe@fusionio.com>, linux-raid <linux-raid@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/KzRnd.dcY4FNz7.S683e_9T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 14:22:03 +0800 majianpeng <majianpeng@gmail.com> wrote:

> For regular file, write operaion used blk_plug function.But for block
> file,write operation did not use blk_plug.
> This patch is also for write-cache mode for block-device.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>

Reviewed-by: NeilBrown <neilb@suse.de>

Will you take this Jens?  Though mail to you seem to be bouncing:

<axboe@fusionio.com>: host mail.fusionio.com[10.101.1.19] said: 554 5.4.6 H=
op
    count exceeded - possible mail loop (in reply to end of DATA command)

so I'm not sure you'll even see this :-(

NeilBrown

> ---
>  fs/block_dev.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index c2bbe1f..cf10778 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1579,9 +1579,11 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const=
 struct iovec *iov,
>  {
>  	struct file *file =3D iocb->ki_filp;
>  	ssize_t ret;
> +	struct blk_plug plug;
> =20
>  	BUG_ON(iocb->ki_pos !=3D pos);
> =20
> +	blk_start_plug(&plug);
>  	ret =3D __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>  	if (ret > 0 || ret =3D=3D -EIOCBQUEUED) {
>  		ssize_t err;
> @@ -1590,6 +1592,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const =
struct iovec *iov,
>  		if (err < 0 && ret > 0)
>  			ret =3D err;
>  	}
> +	blk_finish_plug(&plug);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(blkdev_aio_write);


--Sig_/KzRnd.dcY4FNz7.S683e_9T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUATWQjnsnt1WYoG5AQJULg/+Ogi25oQYiAfWEqjTw+vEh3Vp1GKZ552h
7t4gE7XzIzPdPpTMSbtmPHAuAOwC0qn6v3nEywYAcHmy7Z32h2gcdJlIt98biuAp
bLs1CCyC+qJ7PuqSzep3KS8BJJLwk3ARyjGMWRoV9SMHMufkPh/Em90l/Ofd75fh
QfFuij5arkLuTo6l8NjmIwRHMVylWFDQzEuTEk3cmv/sTogwPETyqKnVtGKx85Ay
vll70dovAArC4h/ah1KAFBBoSdiwzixISE/c2JoXFHpN8B5ksN+vI4LklCwUeEae
32v98ErXqlqea8KGYdEogRlf0VwEO2dxA1xyId5a9tfsRTRu0VTPdjqmEWnOw0EZ
8dv7Vj522GJo/dkJQZPnVlIWImyxmHpHB2BIzSfOWKecQPdqeMA0G5Uv/7IXrC+g
zWi0CFuJbgR8BwmhDu5iqMM+6vM9XEhxlbXepAZ9b6l6+JmhmyfU54V3zLXYfoLv
myd7DWeRcBTqU+q74ATDmKv7T8pku7X89v7Vtw1qDh76oW3x+jnvjT1dZJiCt25s
QCmMPzrC1UePmGjtOZjgTH703qXeehuTackOTswY4nfezRRXHjgOu/G9ttx2H5kH
tfr9Bz017ALR933ALxYFpf3NE8V0RZ8tX7/smama/r68HnugwrTs70438mHFYEh0
zFDR/w5pKVk=
=YPx6
-----END PGP SIGNATURE-----

--Sig_/KzRnd.dcY4FNz7.S683e_9T--
