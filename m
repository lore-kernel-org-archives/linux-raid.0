From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 06/11] Convert a bitmap=none device to clustered
Date: Mon, 25 May 2015 14:40:59 +1000
Message-ID: <20150525144059.45b52f48@notabene.brown>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
	<1432092043-24220-7-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/uacTLK6.QKsn7TZLLjjn348"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-7-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--Sig_/uacTLK6.QKsn7TZLLjjn348
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 11:20:38 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:

> This adds the ability to convert a regular md without bitmap
> (--bitmap=3Dnone) to a clustered device (--bitmap=3Dclustered).
>=20
> To convert a device with --bitmap=3Dinternal or --bitmap=3Dexternal,
> you have to convert to --bitmap=3Dnone and then re-execute the
> command with --bitmap=3Dclustered.
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Grow.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 9a573fd..1122cec 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -330,9 +330,16 @@ int Grow_addbitmap(char *devname, int fd, struct con=
text *c, struct shape *s)
>  			}
>  			return 0;
>  		}
> -		pr_err("Internal bitmap already present on %s\n",
> -			devname);
> -		return 1;
> +		if ((strcmp(s->bitmap_file, "clustered")=3D=3D0) && (array.state & (1<=
<MD_SB_CLUSTERED))) {
> +			pr_err("Clustered bitmap already present on %s\n",
> +					devname);
> +			return 1;
> +		}
> +		if ((strcmp(s->bitmap_file, "internal")=3D=3D0) && (!(array.state & (1=
<<MD_SB_CLUSTERED)))) {
> +			pr_err("Internal bitmap already present on %s\n",
> +					devname);
> +			return 1;
> +		}

You shouldn't be checking the value of s->bitmap_file here.  No matter what
value it has, there is some sort of bitmap present and you should report wh=
at
sort and return.


>  	}
> =20
>  	if (strcmp(s->bitmap_file, "none") =3D=3D 0) {
> @@ -375,7 +382,8 @@ int Grow_addbitmap(char *devname, int fd, struct cont=
ext *c, struct shape *s)
>  		free(st);
>  		return 1;
>  	}
> -	if (strcmp(s->bitmap_file, "internal") =3D=3D 0) {
> +	if ((strcmp(s->bitmap_file, "internal") =3D=3D 0) ||
> +		(strcmp(s->bitmap_file, "clustered") =3D=3D 0)) {

Indentation is wrong.  It should be:

   if ((strcmp(......) =3D=3D 0) ||
       (strcmp(......) =3D=3D 0)) {

except that the extra parentheses are not needed. so

   if (strcmp(......) =3D=3D 0 ||
       strcmp(......) =3D=3D 0) {


Thanks,
NeilBrown

>  		int rv;
>  		int d;
>  		int offset_setable =3D 0;
> @@ -384,6 +392,8 @@ int Grow_addbitmap(char *devname, int fd, struct cont=
ext *c, struct shape *s)
>  			pr_err("Internal bitmaps not supported with %s metadata\n", st->ss->n=
ame);
>  			return 1;
>  		}
> +		st->nodes =3D c->nodes;
> +		st->cluster_name =3D c->homecluster;
>  		mdi =3D sysfs_read(fd, NULL, GET_BITMAP_LOCATION);
>  		if (mdi)
>  			offset_setable =3D 1;
> @@ -426,6 +436,8 @@ int Grow_addbitmap(char *devname, int fd, struct cont=
ext *c, struct shape *s)
>  			rv =3D sysfs_set_num_signed(mdi, NULL, "bitmap/location",
>  						  mdi->bitmap_offset);
>  		} else {
> +			if (strcmp(s->bitmap_file, "clustered") =3D=3D 0)
> +				array.state |=3D (1<<MD_SB_CLUSTERED);
>  			array.state |=3D (1<<MD_SB_BITMAP_PRESENT);
>  			rv =3D ioctl(fd, SET_ARRAY_INFO, &array);
>  		}


--Sig_/uacTLK6.QKsn7TZLLjjn348
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKn3Dnsnt1WYoG5AQIE6w/9Ga7bh52fWV4tVL34FAyq7NhBmaj8nsyJ
4RDv+kv9yBC6KCsDXkupzioEGFEzLnU4PH9XY8jLsLCF+ycVKyghY8i9pJznb4k0
NZQcjozxpNdx5hFqG0xCRv860s4jGtRJONm8LVgwHc86n5OJb59XwULxUMf9+C0b
SZauokzHXBvtNcSZ2kghEvoKdQMx+AckHwoLtmBumpdcAG5pLgmEytnpL89sD6Ev
PT/TBiNaugNN1OB3umvkHAlj1rW2cmD3zcYTBditmkF/N2NbfHZ5DuApRgi6wFnO
ciDYX6WLIL/LdLiY7WEkz4BGI7zNVK6LbRU8bO1kjz+c33xFsgelpG1J3EnFw9wX
jm24gQoEJvm/K77ddE+rv59+yecl8OUoN77QMFcbJt46oZvK4FgeM4MT4dFKUe+2
8d5fcdKX5CZJCVeQwWWzx50heH/gtXEc2OMv9lF8RBu5fXg685E8H7OJUzR9D72K
cL01yrf5OhVAs6l9JimfWgOE2y+dwpYfrAP3fCRwpFRy+0acAa0/aU/zC1GfA+Xr
KAfCxdV0vpKKH33y7VD3EEyVGi59LOs6ZdTUrPSidmiLAVcq5FTTxokQK8dAe2qI
qB94JEWHNkiwmhCgZa0CV5oDJu9ek7axKMbg1OBWhz6ftV5rGs88R6y3GUhyAbdo
z0oK5IauGl0=
=ezDV
-----END PGP SIGNATURE-----

--Sig_/uacTLK6.QKsn7TZLLjjn348--
