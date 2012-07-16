From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] fs/block-dev.c:fix performance regression in
 O_DIRECT writes to md block devices.
Date: Mon, 16 Jul 2012 15:21:16 +1000
Message-ID: <20120716152116.725e5db6@notabene.brown>
References: <201207160930466402203@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xJy8UPN2f+oDycB+2e2KX8D"; protocol="application/pgp-signature"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201207160930466402203@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@ZenIV.linux.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, axboe@fusionio.com
List-Id: linux-raid.ids

--Sig_/xJy8UPN2f+oDycB+2e2KX8D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 09:30:50 +0800 majianpeng <majianpeng@gmail.com> wrote:

> For regular file, write operaion used blk_plug function.But for block
> file,write operation did not use blk_plug.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  fs/block_dev.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index c2bbe1f..22cd436 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -215,9 +215,14 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const s=
truct iovec *iov,
>  {
>  	struct file *file =3D iocb->ki_filp;
>  	struct inode *inode =3D file->f_mapping->host;
> +	struct blk_plug plug;
> +	ssize_t ret;
> =20
> -	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
> +	blk_start_plug(&plug);
> +	ret =3D  __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offs=
et,
>  				    nr_segs, blkdev_get_blocks, NULL, NULL, 0);
> +	blk_finish_plug(&plug);
> +	return ret;
>  }
> =20
>  int __sync_blockdev(struct block_device *bdev, int wait)

[cc:ing Jens Axboe]

I think we do need something like this, but I don't think this is the right
place for it.

For normal filesystem writes, the blk_{start,finish}_plug calls are in
generic_file_aio_write which is the "aio_write" function, or is called by i=
t.
aio_write calls generic_file_aio_write, calls blk_start_plug, call
__generic_file_aio_write.

For block devices we bypass the generic_file_aio_write:

aio_write calls blkdev_aio_write calls __generic_file_aio_write - without
calling blk_start_plug.
So I think the calls to blk_start_plug and blk_finish_plug should go in
blkdev_aio_write.  i.e. blkdev_aio_write should be made to look more like
generic_file_aio_write (just without the mutex_lock/unlock).

If you redo the patch like that and test it I'll happily add my Reviewed-by.

I suspect it should be merged through Jens' tree.

Thanks,
NeilBrown


--Sig_/xJy8UPN2f+oDycB+2e2KX8D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAOkzDnsnt1WYoG5AQLJJxAAsmkMjdOV6dMkzXhh3zDo/6ODS5qmV2E4
Lg2xSF6gYqV+KM5U0hxhAOhzOgfeaIv97v+KTUPDu+MU+KPDaGfNUiyjQ+KQ9xlD
PKgkotWb3uyA+J1zJ142OXb75AqzT/CFA0dP6/oM6/tRSBF+tl4iQolzMtSe/u4L
0zKMlCA6fuw7jmoC9ti/oGFdgej5296wTWb6DyH3SLJ9N14Cycao7yF3HQUwhahh
jeAfGySEKzS4OxgSbgGWzsqS/08r1HaAk65CjS1xL0mYEetvMfXpvk/VZ8QsIkLr
+ma7AUa7AU6V4oAQRKdRCuZ8RYy3pOS00uz1AgoSVZ539pxkuCQju65QSKuvPqAz
xgDe+Zi65oeIcC1qlCIocv+2sWy4at0hn3P/5NoEdwqEkjm6u/XuGZ7E4VwHpjWp
mat6ToKJDO++/c3UEUbUTWWVF25nu7+WKJsr9yfKikpJZYOBcYoeAO69mRB2VdNJ
efUCZylezessnnBkrjxbeNI9E6jg18liLeJ+qRYlRa3Les7Y395ewRd0lRgRpaN1
r6ZcSxAsgoT2k9JsdWcnX5KNG+wnJtRcmdOTgzVCs6OQhbR6sf/PEagzOjfnUQpM
8jcwueEbJoEbdM7u41b5hxIw17WY2uexPEKnJOjjULXOKwj+vi4vE5jXzY7mn8mq
Jz4uhcPnAQ8=
=7tNM
-----END PGP SIGNATURE-----

--Sig_/xJy8UPN2f+oDycB+2e2KX8D--
