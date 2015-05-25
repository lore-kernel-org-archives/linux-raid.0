From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 11/11] Reuse the write_bitmap for update uuid
Date: Mon, 25 May 2015 14:59:40 +1000
Message-ID: <20150525145940.06fcb638@notabene.brown>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
	<1432092043-24220-12-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dRS/J=GhFSdBjEHbXCVVjkV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-12-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--Sig_/dRS/J=GhFSdBjEHbXCVVjkV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 11:20:43 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:

> Since write_bitmap is extended for handle different sistuations,
> then it also could possible to support change the uuid of bitmap,
> and remove bitmap_update_uuid accordingly.
>=20
> Q: is the write_bitmap0 also impacted?

Yes.  You would need to add UUIDUpdate handling to write_bitmap0 too.

Thanks,
NeilBrown



>=20
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Assemble.c |  5 ++---
>  bitmap.c   | 20 --------------------
>  mdadm.h    |  2 +-
>  super1.c   |  4 ++++
>  4 files changed, 7 insertions(+), 24 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 9ff546b..fabca5c 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -664,9 +664,8 @@ static int load_devices(struct devs *devices, char *d=
evmap,
> =20
>  			if (strcmp(c->update, "uuid")=3D=3D0 &&
>  			    ident->bitmap_fd >=3D 0 && !bitmap_done) {
> -				if (bitmap_update_uuid(ident->bitmap_fd,
> -						       content->uuid,
> -						       tst->ss->swapuuid) !=3D 0)
> +				copy_uuid(tst->devs->uuid, content->uuid, tst->ss->swapuuid);
> +				if (tst->ss->write_bitmap(tst, dfd, UUIDUpdate))
>  					pr_err("Could not update uuid on external bitmap.\n");
>  				else
>  					bitmap_done =3D 1;
> diff --git a/bitmap.c b/bitmap.c
> index bccc67c..7df296e 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -462,23 +462,3 @@ out:
>  		unlink(filename); /* possibly corrupted, better get rid of it */
>  	return rv;
>  }
> -
> -int bitmap_update_uuid(int fd, int *uuid, int swap)
> -{
> -	struct bitmap_super_s bm;
> -	if (lseek(fd, 0, 0) !=3D 0)
> -		return 1;
> -	if (read(fd, &bm, sizeof(bm)) !=3D sizeof(bm))
> -		return 1;
> -	if (bm.magic !=3D __cpu_to_le32(BITMAP_MAGIC))
> -		return 1;
> -	copy_uuid(bm.uuid, uuid, swap);
> -	if (lseek(fd, 0, 0) !=3D 0)
> -		return 2;
> -	if (write(fd, &bm, sizeof(bm)) !=3D sizeof(bm)) {
> -		lseek(fd, 0, 0);
> -		return 2;
> -	}
> -	lseek(fd, 0, 0);
> -	return 0;
> -}
> diff --git a/mdadm.h b/mdadm.h
> index 97892e6..7b9bb28 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -358,6 +358,7 @@ enum bitmap_update {
>      NoUpdate,
>      NameUpdate,
>      NodeNumUpdate,
> +    UUIDUpdate,
>  };
> =20
>  /* structures read from config file */
> @@ -1273,7 +1274,6 @@ extern int CreateBitmap(char *filename, int force, =
char uuid[16],
>  			int major);
>  extern int ExamineBitmap(char *filename, int brief, struct supertype *st=
);
>  extern int Write_rules(char *rule_name);
> -extern int bitmap_update_uuid(int fd, int *uuid, int swap);
>  extern unsigned long bitmap_sectors(struct bitmap_super_s *bsb);
>  extern int Dump_metadata(char *dev, char *dir, struct context *c,
>  			 struct supertype *st);
> diff --git a/super1.c b/super1.c
> index b36b702..75e1081 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2250,6 +2250,10 @@ static int write_bitmap1(struct supertype *st, int=
 fd, enum bitmap_update update
> =20
>  	    bms->nodes =3D __cpu_to_le32(st->nodes);
>  	    break;
> +	case UUIDUpdate:
> +	    memset((char *)bms->uuid, 0, sizeof(bms->uuid));
> +	    strncpy((char *)bms->uuid, (char *)st->devs->uuid, sizeof(bms->uuid=
));
> +	    break;
>  	case NoUpdate:
>  	default:
>  	    break;


--Sig_/dRS/J=GhFSdBjEHbXCVVjkV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKsPTnsnt1WYoG5AQIp0w//eF3HK7BvldpVCI75bFeqO7ZN9LIri36R
FQYr5frn2DJfp2CwO2wr9B89XuvXHy0KGS7tlJRw5+2z+/e6w8varl/W2/J2mDse
BpMFaG1lLAFYZII6UcfVLfXInXkzTfwmnDEC3tR2Cb5z6p2wRGm4my1kOJRXoQ0w
05KZkZ+tQAjdlzYGBgoUzxlSEiy0Zn+09+CYCbKqZD7apXDhfA7L+pA/OyMdaz84
+kM9KaKE+m/lxNPgAAOmoyzMpoQrcoDcZQbncGHWzOl2bp0QhxTaAEbUtamafdFC
g91sRLJefCqxhOsnVA8vk2PbnSX3jmCor2gEWruvTveb/qEEtRK/4u9WFOB6yVbL
xhdD8C66adbMISA9lE3S+J5gtVdY+0F4VEq4TaRc2ZkxZp5akvJ23XTGC/AUeJKL
7riLkK+j3TaWTkuESRMvtppQZibaNmnlrbsHS0JdcpTuDlC1VhGP2qHowChHxjEj
VvF00g4yUzt6DsUreFkD3/JZfFtPmYk5RWB8WhK6susErxZJw+Bui8FATVvMCG81
d7480L6hfCPQp0SV3M92xk8GVW7Aav6ZK+yTEz8Txcqvp3Sj+0gt9/ajDmdWS2tl
e1V2ddFGrf1BzI17p+BtRRXvgZK0VpX1v1QLcWtKEsKUfeEhV6i4TFkGzoyFUzNR
t8ZugvgAwTg=
=gIpw
-----END PGP SIGNATURE-----

--Sig_/dRS/J=GhFSdBjEHbXCVVjkV--
