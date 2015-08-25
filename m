From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH stable] md/bitmap: return an error when bitmap superblock
 is corrupt.
Date: Tue, 25 Aug 2015 11:19:45 +0100
Message-ID: <20150825101945.GB14096@ares>
References: <20150814170421.60d40eb0@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150814170421.60d40eb0@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: stable@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, GuoQing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 14, 2015 at 05:04:21PM +1000, NeilBrown wrote:
>=20
> commit b97e92574c0bf335db1cd2ec491d8ff5cd5d0b49 upstream
>     Use separate bitmaps for each nodes in the cluster
>=20
> bitmap_read_sb() validates the bitmap superblock that it reads in.
> If it finds an inconsistency like a bad magic number or out-of-range
> version number, it prints an error and returns, but it incorrectly
> returns zero, so the array is still assembled with the (invalid) bitm=
ap.
>=20
> This means it could try to use a bitmap with a new version number whi=
ch
> it therefore does not understand.
>=20
> This bug was introduced in 3.5 and fix as part of a larger patch in 4=
=2E1.
> So the patch is suitable for any -stable kernel in that range.
>=20
> Fixes: 27581e5ae01f ("md/bitmap: centralise allocation of bitmap file=
 pages.")
> Cc: stable@vger.kernel.org (v3.5..v4.1)

Thanks!  Queuing it for the 3.16 kernel.

Cheers,
--
Lu=EDs

> Signed-off-by: NeilBrown <neilb@suse.com>
> Reported-by: GuoQing Jiang <gqjiang@suse.com>
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 3a5767968ba0..894fd58f75f1 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -577,6 +577,8 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>  	if (err)
>  		return err;
> =20
> +	err =3D -EINVAL;
> +
>  	sb =3D kmap_atomic(sb_page);
> =20
>  	chunksize =3D le32_to_cpu(sb->chunksize);
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
