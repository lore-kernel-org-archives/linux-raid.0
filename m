From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Use posix_memalign() for memory used to write bitmaps
Date: Thu, 16 Feb 2012 14:17:35 +1100
Message-ID: <20120216141735.4065bf8a@notabene.brown>
References: <1329216733-7081-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N/ztLC+NA.vxid4.Dnnh4Sh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1329216733-7081-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: alexandermurashkin@msn.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/N/ztLC+NA.vxid4.Dnnh4Sh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Feb 2012 11:52:13 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> This makes super[01].c properly align buffers used for the bitmap
> using posix_memalign() to make sure the writes don't fail in case the
> bitmap is opened using O_DIRECT.
>=20
> This is based on https://bugzilla.redhat.com/show_bug.cgi?id=3D789898
> and an initial patch by Alexander Murashkin.

hi Jes,

I suspect that

http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D6ef89052d85b8137b8a=
7100f761d896ae6f61001

is the fix you want.  But I'll probably apply yours as well.

Thanks,
NeilBrown


>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  super0.c |    8 +++++---
>  super1.c |    7 +++++--
>  2 files changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/super0.c b/super0.c
> index dab85db..d53f025 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -1065,13 +1065,11 @@ static int write_bitmap0(struct supertype *st, in=
t fd)
>  	int rv =3D 0;
> =20
>  	int towrite, n;
> -	char abuf[4096+4096];
> -	char *buf =3D (char*)(((long)(abuf+4096))&~4095L);
> +	void *buf;
> =20
>  	if (!get_dev_size(fd, NULL, &dsize))
>  		return 1;
> =20
> -
>  	if (dsize < MD_RESERVED_SECTORS*512)
>  		return -1;
> =20
> @@ -1082,6 +1080,9 @@ static int write_bitmap0(struct supertype *st, int =
fd)
>  	if (lseek64(fd, offset + 4096, 0)< 0LL)
>  		return 3;
> =20
> +	if (posix_memalign(&buf, 4096, 4096))
> +		return -ENOMEM;
> +
>  	memset(buf, 0xff, 4096);
>  	memcpy(buf,  ((char*)sb)+MD_SB_BYTES, sizeof(bitmap_super_t));
>  	towrite =3D 60*1024;
> @@ -1100,6 +1101,7 @@ static int write_bitmap0(struct supertype *st, int =
fd)
>  	if (towrite)
>  		rv =3D -2;
> =20
> +	free(buf);
>  	return rv;
>  }
> =20
> diff --git a/super1.c b/super1.c
> index cfa237a..a18952a 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1641,12 +1641,14 @@ static int write_bitmap1(struct supertype *st, in=
t fd)
>  	struct mdp_superblock_1 *sb =3D st->sb;
>  	bitmap_super_t *bms =3D (bitmap_super_t*)(((char*)sb)+1024);
>  	int rv =3D 0;
> -
> +	void *buf;
>  	int towrite, n;
> -	char buf[4096];
> =20
>  	locate_bitmap1(st, fd);
> =20
> +	if (posix_memalign(&buf, 4096, 4096))
> +		return -ENOMEM;
> +
>  	memset(buf, 0xff, 4096);
>  	memcpy(buf, ((char*)sb)+1024, sizeof(bitmap_super_t));
> =20
> @@ -1669,6 +1671,7 @@ static int write_bitmap1(struct supertype *st, int =
fd)
>  	if (towrite)
>  		rv =3D -2;
> =20
> +	free(buf);
>  	return rv;
>  }
> =20


--Sig_/N/ztLC+NA.vxid4.Dnnh4Sh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzx1Tznsnt1WYoG5AQKwsg/+MA1lkyhfxLd26G5iGIAl8JsXX5x2xTgl
9vRLPRHCB1dcXJ8pKhgTidBEbkx66XtOSi9SjtGpT0dgFv4ml8svXLroXNt6ZK/X
X6pn8USzWfl/FgUJiyy2DzCnli+TzzeRNwyO/5ZYu7NkTkMyf67DTLa2XSB5tf7s
q0SvxJqFRaqfTb9BMZSt8IvQMiDnfhhotlwXHStocW+rUD67Y19bt1atTMwhs76B
7G+WFfMqigBwVIpDsSoVMCZqcqKf/7cnXGekQCIQKPikMJc1ci3X2hADr9NlI56g
exLuvBJCjhMATVsObCn2ZcynFI01wAUWxwufcee0ht03EzAFpr0ui1ccNThbALk7
fSsWfuOr+KfuMrViIxJOCmBQ5pUALkfI6wtUa7NCYuL1ji8VMWS99T+3WWxxo1rG
g0VoAO4PQAq3h5WZI9mxW0u6WX/RkKx1JHnJTkeO2dCx8aDSgwxgosCnDpL3vhhb
T5XFJvevivBcmBGv7lhQuLpOWZLyJpQ0L/4fXEr2fO9TqvMyzjmiWMDjcrEn3R28
RX5cYdkjkOaHP1ek9GTqiVYBMBuorXQN1t7aXj7QUDSFkxJ76XCRQyjCY5ELSoXf
FKmP1InGoa5X+v+6JFDSXHQ54saggan/Jz+nv5FhhR9BIIgbF1goyuG6EsiQz4qy
OH8jR0BzJ8c=
=P1UT
-----END PGP SIGNATURE-----

--Sig_/N/ztLC+NA.vxid4.Dnnh4Sh--
