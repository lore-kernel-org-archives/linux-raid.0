From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 04/10] Show all bitmaps while examining bitmap
Date: Wed, 29 Apr 2015 11:41:40 +1000
Message-ID: <20150429114140.07b20a08@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-5-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//1CVe3JN2xocTAaK7bHpZ+6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-5-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_//1CVe3JN2xocTAaK7bHpZ+6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 15:30:35 +0800 gqjiang@suse.com wrote:

> From: Guoqing Jiang <gqjiang@suse.com>
>=20
> This adds capability of exmining bitmaps corresponding to all
> nodes/slots on the device.
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  bitmap.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
>=20
> diff --git a/bitmap.c b/bitmap.c
> index b1d54a6..ab83f4e 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -258,7 +258,7 @@ int ExamineBitmap(char *filename, int brief, struct s=
upertype *st)
>  	int rv =3D 1;
>  	char buf[64];
>  	int swap;
> -	int fd;
> +	int fd, i;
>  	__u32 uuid32[4];
> =20
>  	fd =3D bitmap_file_open(filename, &st);
> @@ -315,9 +315,6 @@ int ExamineBitmap(char *filename, int brief, struct s=
upertype *st)
>  		       uuid32[2],
>  		       uuid32[3]);
> =20
> -	printf("          Events : %llu\n", (unsigned long long)sb->events);
> -	printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_clea=
red);
> -	printf("           State : %s\n", bitmap_state(sb->state));

Can we please leave this where it is in the case where there is only one no=
de?
Only move it down if there are multiple nodes to report on.

NeilBrown


>  	printf("       Chunksize : %s\n", human_chunksize(sb->chunksize));
>  	printf("          Daemon : %ds flush period\n", sb->daemon_sleep);
>  	if (sb->write_behind)
> @@ -327,11 +324,31 @@ int ExamineBitmap(char *filename, int brief, struct=
 supertype *st)
>  	printf("      Write Mode : %s\n", buf);
>  	printf("       Sync Size : %llu%s\n", (unsigned long long)sb->sync_size=
/2,
>  					human_size(sb->sync_size * 512));
> -	if (brief)
> -		goto free_info;
> -	printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
> -			info->total_bits, info->dirty_bits,
> -			100.0 * info->dirty_bits / (info->total_bits?:1));
> +	if (sb->nodes > 0) {
> +		printf("   Cluster nodes : %d\n", sb->nodes);
> +		printf("    Cluster name : %s\n", sb->cluster_name);
> +	}
> +	i =3D 0;
> +	do {
> +		if (i) {
> +			free(info);
> +			info =3D bitmap_fd_read(fd, brief);
> +			sb =3D &info->sb;
> +		}
> +		if (sb->magic !=3D BITMAP_MAGIC) {
> +			pr_err("invalid bitmap magic 0x%x, the bitmap file appears to be corr=
upted\n", sb->magic);
> +		}
> +		printf("       Node Slot : %d\n", i);
> +		printf("          Events : %llu\n", (unsigned long long)sb->events);
> +		printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_cle=
ared);
> +		printf("           State : %s\n", bitmap_state(sb->state));
> +		if (brief)
> +			continue;
> +		printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
> +				info->total_bits, info->dirty_bits,
> +				100.0 * info->dirty_bits / (info->total_bits?:1));
> +	} while (++i < (int)sb->nodes);
> +
>  free_info:
>  	free(info);
>  	return rv;


--Sig_//1CVe3JN2xocTAaK7bHpZ+6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUA21Dnsnt1WYoG5AQLeFA/+NzkGGhMesss+KTVq6jdlVOku5818KUxD
oYcl+KDrhDn/OM6P6Y/qBg4dZnAJvU394b2VQFlspt+nBHc48i9vzGz/azt6nOqJ
MwOPQkPDy0HG/6UPtFWTYpvmtLVVvIRcq5Bgqh7BdyYvUHtviUe7OHwm4oJbfcxV
4DFT42Q8v9l3jN7IrJ5GsXowCaWCWa4AhLvT9aX4w4dy66k9b1K7F1vGKtKXLc8G
xGplIg3A3p2/mo7gP81orZgeIL1HhDEoH2cfDEVWpBRH4mDkzCBMBPuUtjYgd8a2
syuKnw9AYUJ5ZVLo37uoVsvoxrDdnaS9eHWX3mkSDWHUQ0OuNUTfyBBZHtcA1vZt
lNHxASd9uc6S8BZd4Vum8oEUIGVlLGJOSI7kpTkG+Ofq/tzsgK7YcP+3xva8GhTq
Ms6anV2V8AV0zVD/RS76lv+P6uU2yLxTs/L5I1Y2g4t2/RDo2Xzw+j+b4gMv2rc2
zLuAQE08IqmEWA/vv1jR0dmLUnZy+I511Y3cxV//N8avWVTl+Ho1Gun0C4DCF6Pl
5sX+1kHUT44vTgMVFadJVHaD+mExkreEFVQUwLvhCH0+oLUgucg9he2xr8twAtGc
IUG+vSQnJJNKrfmdDBmrbBp7BC6f9VqNqb43KrRQg1hXyxj/yiukOUU14e4S+K3q
mYdnSFskt5E=
=G4+u
-----END PGP SIGNATURE-----

--Sig_//1CVe3JN2xocTAaK7bHpZ+6--
