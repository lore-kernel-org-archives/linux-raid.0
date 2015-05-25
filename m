From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 04/11] Show all bitmaps while examining bitmap
Date: Mon, 25 May 2015 14:23:40 +1000
Message-ID: <20150525142340.44811827@notabene.brown>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
	<1432092043-24220-5-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+=dqArkT/V=fU5q.ExRCjQd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-5-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--Sig_/+=dqArkT/V=fU5q.ExRCjQd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 11:20:36 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:

> This adds capability of exmining bitmaps corresponding to all
> nodes/slots on the device.
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  bitmap.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++----------=
------
>  1 file changed, 54 insertions(+), 18 deletions(-)
>=20
> diff --git a/bitmap.c b/bitmap.c
> index 920033a..bccc67c 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -260,7 +260,7 @@ int ExamineBitmap(char *filename, int brief, struct s=
upertype *st)
>  	int rv =3D 1;
>  	char buf[64];
>  	int swap;
> -	int fd;
> +	int fd, i;
>  	__u32 uuid32[4];
> =20
>  	fd =3D bitmap_file_open(filename, &st);
> @@ -317,23 +317,59 @@ int ExamineBitmap(char *filename, int brief, struct=
 supertype *st)
>  		       uuid32[2],
>  		       uuid32[3]);
> =20
> -	printf("          Events : %llu\n", (unsigned long long)sb->events);
> -	printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_clea=
red);
> -	printf("           State : %s\n", bitmap_state(sb->state));
> -	printf("       Chunksize : %s\n", human_chunksize(sb->chunksize));
> -	printf("          Daemon : %ds flush period\n", sb->daemon_sleep);
> -	if (sb->write_behind)
> -		sprintf(buf, "Allow write behind, max %d", sb->write_behind);
> -	else
> -		sprintf(buf, "Normal");
> -	printf("      Write Mode : %s\n", buf);
> -	printf("       Sync Size : %llu%s\n", (unsigned long long)sb->sync_size=
/2,
> -					human_size(sb->sync_size * 512));
> -	if (brief)
> -		goto free_info;
> -	printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
> -			info->total_bits, info->dirty_bits,
> -			100.0 * info->dirty_bits / (info->total_bits?:1));
> +	if (sb->nodes =3D=3D 0) {
> +		printf("          Events : %llu\n", (unsigned long long)sb->events);
> +		printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_cle=
ared);
> +		printf("           State : %s\n", bitmap_state(sb->state));
> +		printf("       Chunksize : %s\n", human_chunksize(sb->chunksize));
> +		printf("          Daemon : %ds flush period\n", sb->daemon_sleep);
> +		if (sb->write_behind)
> +			sprintf(buf, "Allow write behind, max %d", sb->write_behind);
> +		else
> +			sprintf(buf, "Normal");
> +		printf("      Write Mode : %s\n", buf);
> +		printf("       Sync Size : %llu%s\n", (unsigned long long)sb->sync_siz=
e/2,
> +						human_size(sb->sync_size * 512));
> +		if (brief)
> +			goto free_info;
> +		printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
> +				info->total_bits, info->dirty_bits,
> +				100.0 * info->dirty_bits / (info->total_bits?:1));
> +	} else {
> +		printf("       Chunksize : %s\n", human_chunksize(sb->chunksize));
> +		printf("          Daemon : %ds flush period\n", sb->daemon_sleep);
> +		if (sb->write_behind)
> +			sprintf(buf, "Allow write behind, max %d", sb->write_behind);
> +		else
> +			sprintf(buf, "Normal");
> +		printf("      Write Mode : %s\n", buf);
> +		printf("       Sync Size : %llu%s\n", (unsigned long long)sb->sync_siz=
e/2,
> +						human_size(sb->sync_size * 512));

This is too much duplication.  Duplicate code leads to maintenance errors.

if (sb->nodes =3D=3D 0)
    print Events/ Events cleared / state

print chunksuze, daemon flush period, write mode sync size

if (sb->nodes > 0) {
   print Events/ Events cleared etc for each bitmap=20
}


> +		printf("   Cluster nodes : %d\n", sb->nodes);
> +		printf("    Cluster name : %s\n", sb->cluster_name);

sb->cluster_name is not nul terminated if it is exactly 64 bytes long.
You need "%64s" ... and you need to test that case.


> +		i =3D 0;
> +		do {

Please make this a regular
   for(i =3D 0; i < nodes; i++)
loop.  do/while should  only be used when some non-trivial computation is
needed before the condition can be tested.


> +			if (i) {
> +				free(info);
> +				info =3D bitmap_fd_read(fd, brief);
> +				sb =3D &info->sb;
> +			}
> +			if (sb->magic !=3D BITMAP_MAGIC)
> +				pr_err("invalid bitmap magic 0x%x, the bitmap file appears to be cor=
rupted\n", sb->magic);
> +
> +			printf("       Node Slot : %d\n", i);
> +			printf("          Events : %llu\n", (unsigned long long)sb->events);
> +			printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_cl=
eared);
> +			printf("           State : %s\n", bitmap_state(sb->state));
> +			if (brief)
> +				continue;
> +			printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n=
",
> +					info->total_bits, info->dirty_bits,
> +					100.0 * info->dirty_bits / (info->total_bits?:1));
> +
> +		} while (++i < (int)sb->nodes);
> +	}
> +
>  free_info:
>  	free(info);
>  	return rv;

Thanks,
NeilBrown


--Sig_/+=dqArkT/V=fU5q.ExRCjQd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIUAwUBVWKjzTnsnt1WYoG5AQIPMQ/4q4pvAx3DJN0R7i5+3UYPOi9GN/zLpCJ3
TFgA9tP/jw43rqSFWt+a6HjDNEMMaGEroRpLkriNr4nSfeW7GQHpYBlBYAxTO5QG
2odPunkF86PRJdSLLcqctER3ThM5/HwVPS4Ih9tItO1yNTNUc5K5yhgz9o0Jvlio
NDeZR7YFo6zDIrCs3CnaYCleFN+V0A2jbb76K0arjYfKulswpXdLVwJfqP5yTwk+
/0LujbaP9ZN/F1ZDpTdo9VodpILNsP5ldadsMn3d+isvR2uEhmh3zsH2vx+qrwFH
qh4IyNe8YNN96kpHxyEN36RgKi0hygu8aLWZqapSN4Y/FKAC+0f57hRRCIzElPxS
LhR14YkIq1nMT96FZMeDr4F69d+koTQE7mUOGbw6i+3SEkkdSttnjeVcTXad6bY7
nFXHUU2NQWVfQ9IJ1rKRpMCZECWfMef5lTGhANIWSO3sSYmH0VZEynkhXm7Gju2U
PYijZ15TkxQpelZhB01ccJidP7cUfPhR5oshzwBdxrp6f63VMdhU4QPjjFCQT+rG
1aHfurDVmsshWa7ygK7F0BoIxCqbYWfuiFdTyQeCf5fYOQ2SXjte96I2HNrJd9p3
UURjxFe4iGi+yw+pk2WuhW6MptTPvqt4PN9Qvi7+FyqyMRNBL8xUkSxLMeKlSumN
7sdy3niqaA==
=WdeI
-----END PGP SIGNATURE-----

--Sig_/+=dqArkT/V=fU5q.ExRCjQd--
