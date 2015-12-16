From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 4/4] mdadm: do not display bitmap info if it is cleared
Date: Wed, 16 Dec 2015 13:24:38 +1100
Message-ID: <87a8pbb061.fsf@notabene.neil.brown.name>
References: <1448987412-3932-1-git-send-email-gqjiang@suse.com> <1448987412-3932-4-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448987412-3932-4-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: rgoldwyn@suse.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 02 2015, Guoqing Jiang wrote:

> "mdadm -X DISK" is used to report information about a bitmap
> file, it is better to not display all the related infos if
> bitmap is cleared with "--bitmap=3Dnone" under grow mode.
>
> To do that, the locate_bitmap is changed a little to have a
> return value based on MD_FEATURE_BITMAP_OFFSET.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  bitmap.c |  8 ++++++--
>  mdadm.h  |  2 +-
>  super0.c |  7 ++++---
>  super1.c | 12 +++++++++---
>  4 files changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/bitmap.c b/bitmap.c
> index 803eda3..dab674b 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -221,8 +221,12 @@ int bitmap_file_open(char *filename, struct supertyp=
e **stp)
>  			pr_err("No bitmap possible with %s metadata\n",
>  				st->ss->name);
>  			return -1;
> -		} else
> -			st->ss->locate_bitmap(st, fd);
> +		} else {
> +			if (st->ss->locate_bitmap(st, fd)) {
> +				pr_err("%s doesn't have bitmap\n", filename);
> +				fd =3D -1;
> +			}
> +		}
>=20=20
>  		*stp =3D st;
>  	} else {
> diff --git a/mdadm.h b/mdadm.h
> index 5d5e97f..aad0fa8 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -873,7 +873,7 @@ extern struct superswitch {
>  	/* Seek 'fd' to start of write-intent-bitmap.  Must be an
>  	 * md-native format bitmap
>  	 */
> -	void (*locate_bitmap)(struct supertype *st, int fd);
> +	int (*locate_bitmap)(struct supertype *st, int fd);
>  	/* if add_internal_bitmap succeeded for existing array, this
>  	 * writes it out.
>  	 */
> diff --git a/super0.c b/super0.c
> index 6ad9d39..7f80014 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -1155,16 +1155,16 @@ static int add_internal_bitmap0(struct supertype =
*st, int *chunkp,
>  	return 1;
>  }
>=20=20
> -static void locate_bitmap0(struct supertype *st, int fd)
> +static int locate_bitmap0(struct supertype *st, int fd)
>  {
>  	unsigned long long dsize;
>  	unsigned long long offset;
>=20=20
>  	if (!get_dev_size(fd, NULL, &dsize))
> -		return;
> +		return -1;
>=20=20
>  	if (dsize < MD_RESERVED_SECTORS*512)
> -		return;
> +		return -1;
>=20=20
>  	offset =3D MD_NEW_SIZE_SECTORS(dsize>>9);
>=20=20
> @@ -1173,6 +1173,7 @@ static void locate_bitmap0(struct supertype *st, in=
t fd)
>  	offset +=3D MD_SB_BYTES;
>=20=20
>  	lseek64(fd, offset, 0);
> +	return 0;
>  }
>=20=20
>  static int write_bitmap0(struct supertype *st, int fd, enum bitmap_updat=
e update)
> diff --git a/super1.c b/super1.c
> index 062d9e7..7a1156d 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1520,7 +1520,7 @@ static int add_to_super1(struct supertype *st, mdu_=
disk_info_t *dk,
>  }
>  #endif
>=20=20
> -static void locate_bitmap1(struct supertype *st, int fd);
> +static int locate_bitmap1(struct supertype *st, int fd);
>=20=20
>  static int store_super1(struct supertype *st, int fd)
>  {
> @@ -2304,24 +2304,30 @@ add_internal_bitmap1(struct supertype *st,
>  	return 1;
>  }
>=20=20
> -static void locate_bitmap1(struct supertype *st, int fd)
> +static int locate_bitmap1(struct supertype *st, int fd)
>  {
>  	unsigned long long offset;
>  	struct mdp_superblock_1 *sb;
>  	int mustfree =3D 0;
> +	int ret;
>=20=20
>  	if (!st->sb) {
>  		if (st->ss->load_super(st, fd, NULL))
> -			return; /* no error I hope... */
> +			return -1; /* no error I hope... */
>  		mustfree =3D 1;
>  	}
>  	sb =3D st->sb;
>=20=20
> +	if ((__le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET))
> +		ret =3D 0;
> +	else
> +		ret =3D -1;
>  	offset =3D __le64_to_cpu(sb->super_offset);
>  	offset +=3D (int32_t) __le32_to_cpu(sb->bitmap_offset);
>  	if (mustfree)
>  		free(sb);
>  	lseek64(fd, offset<<9, 0);
> +	return ret;
>  }
>=20=20
>  static int write_bitmap1(struct supertype *st, int fd, enum bitmap_updat=
e update)
> --=20
> 2.1.4

All 4 applied,
thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcMtmAAoJEDnsnt1WYoG5sJsQAJzNeZTkLMDXCwD8S+xuiDlh
ZuS92tkPCaVfHHYmZLMbEhnPS2J2RfuLT1q96hq3748mku5K0mUhqkbP9ZKr5yC0
c5oYi0dA4Mak++s/TK8eQcXKBrcDeQgwtyKyGMhgSrERewXOGi3FEkk/KOs7A/fF
uUajOoY6nFPCuBCl0Ypy0sR09zuV2auIAvUr+hiXvtWHvkHC9L+MocFVWCL9sCgr
5yeeGu4pkrNHg1E0PIGWvRbcN8H4xk7KUyAYD5PJSZPNEQ4DEIhYIe6mslbvfZPM
AagikWPiV3hkX/DzRFEGukKPYKyEj5pBo6qDB/XeweihxLY4GxBN0cTjdCuCcPCe
JmUNeFtA1AG1iT47p8+6lSa+l9/PCTg/PbFMK+ntCqIgnRj0tjbkF40LLhgiP67s
Rs9ukzuRsDHXTg9Zyy8oLnHblUJByXIkfmFyRgWtqgBHETihvVIkocecITfrSV2O
fQt4Hk8yADem4kV9vKChEbQDtVZUYV7leBPHNskWhbn6z3f6awAGgClhoDuopyUl
3L0uVnEQmZRUiQpsfj+DAjfkfwDiWv346ZvwRd4jvRO8en1xNae0o4fnkyUF4CTY
ja269KkoZqT2Wn16YYf6Cgzxbw+cWcP5fG9461tLa0k1y9+rJ543YDQeEldAxtOx
lG7KNPn8epClehA0mijP
=05LJ
-----END PGP SIGNATURE-----
--=-=-=--
