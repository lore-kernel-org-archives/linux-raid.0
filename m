From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] Work around gcc-4.7's strict aliasing checks
Date: Thu, 12 Jan 2012 10:43:20 +1100
Message-ID: <20120112104320.471910db@notabene.brown>
References: <1325762201-23949-1-git-send-email-Jes.Sorensen@redhat.com>
	<1325762201-23949-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yAEDM8Yuv+K+nQUfNy/RLEB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1325762201-23949-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

--Sig_/yAEDM8Yuv+K+nQUfNy/RLEB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  5 Jan 2012 12:16:41 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  sha1.c      |    8 +++++---
>  super-ddf.c |   22 ++++++++++++++--------
>  2 files changed, 19 insertions(+), 11 deletions(-)
>=20
> diff --git a/sha1.c b/sha1.c
> index 556d9ca..0258515 100644
> --- a/sha1.c
> +++ b/sha1.c
> @@ -101,6 +101,7 @@ sha1_finish_ctx (struct sha1_ctx *ctx, void *resbuf)
>    /* Take yet unprocessed bytes into account.  */
>    md5_uint32 bytes =3D ctx->buflen;
>    size_t pad;
> +  md5_uint32 *ptr;
> =20
>    /* Now count remaining bytes.  */
>    ctx->total[0] +=3D bytes;
> @@ -111,9 +112,10 @@ sha1_finish_ctx (struct sha1_ctx *ctx, void *resbuf)
>    memcpy (&ctx->buffer[bytes], fillbuf, pad);
> =20
>    /* Put the 64-bit file length in *bits* at the end of the buffer.  */
> -  *(md5_uint32 *) &ctx->buffer[bytes + pad + 4] =3D SWAP (ctx->total[0] =
<< 3);
> -  *(md5_uint32 *) &ctx->buffer[bytes + pad] =3D SWAP ((ctx->total[1] << =
3) |
> -						    (ctx->total[0] >> 29));
> +  ptr =3D (md5_uint32 *) &ctx->buffer[bytes + pad + 4];
> +  *ptr =3D SWAP (ctx->total[0] << 3);
> +  ptr =3D (md5_uint32 *) &ctx->buffer[bytes + pad];
> +  *ptr =3D SWAP ((ctx->total[1] << 3) | (ctx->total[0] >> 29));
> =20
>    /* Process last bytes.  */
>    sha1_process_block (ctx->buffer, bytes + pad + 8, ctx);
> diff --git a/super-ddf.c b/super-ddf.c
> index b5b0b42..abd6793 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1336,6 +1336,7 @@ static void getinfo_super_ddf(struct supertype *st,=
 struct mdinfo *info, char *m
>  {
>  	struct ddf_super *ddf =3D st->sb;
>  	int map_disks =3D info->array.raid_disks;
> +	__u32 *cptr;
> =20
>  	if (ddf->currentconf) {
>  		getinfo_super_ddf_bvd(st, info, map);
> @@ -1347,8 +1348,9 @@ static void getinfo_super_ddf(struct supertype *st,=
 struct mdinfo *info, char *m
>  	info->array.level	  =3D LEVEL_CONTAINER;
>  	info->array.layout	  =3D 0;
>  	info->array.md_minor	  =3D -1;
> -	info->array.ctime	  =3D DECADE + __be32_to_cpu(*(__u32*)
> -							 (ddf->anchor.guid+16));
> +	cptr =3D (__u32 *)(ddf->anchor.guid + 16);
> +	info->array.ctime	  =3D DECADE + __be32_to_cpu(*cptr);
> +
>  	info->array.utime	  =3D 0;
>  	info->array.chunk_size	  =3D 0;
>  	info->container_enough	  =3D 1;
> @@ -1407,6 +1409,7 @@ static void getinfo_super_ddf_bvd(struct supertype =
*st, struct mdinfo *info, cha
>  	int j;
>  	struct dl *dl;
>  	int map_disks =3D info->array.raid_disks;
> +	__u32 *cptr;
> =20
>  	memset(info, 0, sizeof(*info));
>  	/* FIXME this returns BVD info - what if we want SVD ?? */
> @@ -1416,8 +1419,8 @@ static void getinfo_super_ddf_bvd(struct supertype =
*st, struct mdinfo *info, cha
>  	info->array.layout	  =3D rlq_to_layout(vc->conf.rlq, vc->conf.prl,
>  						  info->array.raid_disks);
>  	info->array.md_minor	  =3D -1;
> -	info->array.ctime	  =3D DECADE +
> -		__be32_to_cpu(*(__u32*)(vc->conf.guid+16));
> +	cptr =3D (__u32 *)(vc->conf.guid + 16);
> +	info->array.ctime	  =3D DECADE + __be32_to_cpu(*cptr);
>  	info->array.utime	  =3D DECADE + __be32_to_cpu(vc->conf.timestamp);
>  	info->array.chunk_size	  =3D 512 << vc->conf.chunk_shift;
>  	info->custom_array_size	  =3D 0;
> @@ -2192,6 +2195,7 @@ static int add_to_super_ddf(struct supertype *st,
>  	struct phys_disk_entry *pde;
>  	unsigned int n, i;
>  	struct stat stb;
> +	__u32 *tptr;
> =20
>  	if (ddf->currentconf) {
>  		add_to_super_ddf_bvd(st, dk, fd, devname);
> @@ -2220,8 +2224,9 @@ static int add_to_super_ddf(struct supertype *st,
>  	tm =3D localtime(&now);
>  	sprintf(dd->disk.guid, "%8s%04d%02d%02d",
>  		T10, tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday);
> -	*(__u32*)(dd->disk.guid + 16) =3D random32();
> -	*(__u32*)(dd->disk.guid + 20) =3D random32();
> +	tptr =3D (__u32 *)(dd->disk.guid + 16);
> +	*tptr++ =3D random32();
> +	*tptr =3D random32();
> =20
>  	do {
>  		/* Cannot be bothered finding a CRC of some irrelevant details*/
> @@ -2967,6 +2972,7 @@ static struct mdinfo *container_content_ddf(struct =
supertype *st, char *subarray
>  		unsigned int j;
>  		struct mdinfo *this;
>  		char *ep;
> +		__u32 *cptr;
> =20
>  		if (subarray &&
>  		    (strtoul(subarray, &ep, 10) !=3D vc->vcnum ||
> @@ -2986,8 +2992,8 @@ static struct mdinfo *container_content_ddf(struct =
supertype *st, char *subarray
>  		this->array.md_minor      =3D -1;
>  		this->array.major_version =3D -1;
>  		this->array.minor_version =3D -2;
> -		this->array.ctime         =3D DECADE +
> -			__be32_to_cpu(*(__u32*)(vc->conf.guid+16));
> +		cptr =3D (__u32 *)(vc->conf.guid + 16);
> +		this->array.ctime         =3D DECADE + __be32_to_cpu(*cptr);
>  		this->array.utime	  =3D DECADE +
>  			__be32_to_cpu(vc->conf.timestamp);
>  		this->array.chunk_size	  =3D 512 << vc->conf.chunk_shift;


Applied - thanks...

Do you understand this stuff?  If this really "fixing" anything, or is it
still doing something bad, but is now hiding it from gcc's warning so we ju=
st
don't get told how naughty we are?

Should these things be changed to use unions ??

Thanks,
NeilBrown

--Sig_/yAEDM8Yuv+K+nQUfNy/RLEB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTw4emDnsnt1WYoG5AQK12g/9FGxDgm9E5Q7dvcXq7hmCecFyV7Z1l5Sb
3EjhlnukPdif+N8CjU0yyR0ZzNsZMogRxMn9/N/xt7UoxqVDlobnKrykMQmhlYbM
30Ut2UnbyzO1R+7s08aP4PQvcT0MQlIC/5WPZhNKk+IltmZu1GGsc7hfXgzlaUoo
fM9t/yRh+zPV/mekKmqaXUL1C8PUYJDP+mhyiFdK3sRvvBDOdBt0ibYsc4yxqq63
SOrLu30DnmMhuqbHuYryCza13IYYsKv99Jgo0CVRGqU7sI7shxnseNqZNtLDcleb
cCmDQfUeOj7oyN+yAyoF5ai9m5ZbzlhCt6c6/5t65ljANXkyqynhlOjFb0eTktmQ
ofF1n5xUz3LjEIfPMxexRd9RxG5hJ+9/ifCRLF1nGf+oU5VH2Qz0TBbY7PDmb9MD
hyLfHQ7PO23iT9plTwQxDwtIzn/BiasNiiW1LrAU9AyYyYyZI9PEhpJaOVbWvNLy
RMvNh6ac0acfwTtEnxOC3iIsbWrs83nW1uKSk6QawUDAeZi31VCgEEQwxZ/JYGQM
BPY8sBgpv9AwQ5fDqCdXfzjBvMyUepuJx1JeQBUvaZbd5NNAP2vZLfIyiDOj7XTc
0+Upz6KXuouiJQmU7BBHed5FHUnlfmL374/1kAcxpXajIED/lCXki3FQjCwRqXIK
E1ZbVIBC6zo=
=E2Tb
-----END PGP SIGNATURE-----

--Sig_/yAEDM8Yuv+K+nQUfNy/RLEB--
