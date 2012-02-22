From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Print error message if failing to write super for 1.x
 metadata
Date: Thu, 23 Feb 2012 08:58:02 +1100
Message-ID: <20120223085802.57586d60@notabene.brown>
References: <1329908516-17822-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//UxIrtrHfCaVimnzQk_l+RH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1329908516-17822-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: meyering@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//UxIrtrHfCaVimnzQk_l+RH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Feb 2012 12:01:56 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> In addition remove attempt to print an error message if
> write_init_super() fails, as this is handled in the various
> write_init_super() functions. This avoids a segfault on error.
>=20
> Reported by Jim Meyering in
> https://bugzilla.redhat.com/show_bug.cgi?id=3D795461
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Applied, thanks.

Though there was already a case which printed an error which you left
unchanged so now in some cases it would print the same message twice.
So I removed the old printf.

Thanks,
NeilBrown


> ---
>  Create.c |    3 ---
>  super1.c |   20 ++++++++++++++++----
>  2 files changed, 16 insertions(+), 7 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 90ff3ed..e5c6b05 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -924,9 +924,6 @@ int Create(struct supertype *st, char *mddev,
>  			}
> =20
>  			if (st->ss->write_init_super(st)) {
> -				fprintf(stderr,
> -					Name ": Failed to write metadata to %s\n",
> -					dv->devname);
>  				st->ss->free_super(st);
>  				goto abort_locked;
>  			}
> diff --git a/super1.c b/super1.c
> index a18952a..1db4de6 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1106,13 +1106,16 @@ static int write_init_super1(struct supertype *st)
>  		}
>  		free(refst);
> =20
> -		if (!get_dev_size(di->fd, NULL, &dsize))
> -			return 1;
> +		if (!get_dev_size(di->fd, NULL, &dsize)) {
> +			rv =3D 1;
> +			goto error_out;
> +		}
>  		dsize >>=3D 9;
> =20
>  		if (dsize < 24) {
>  			close(di->fd);
> -			return 2;
> +			rv =3D 2;
> +			goto error_out;
>  		}
> =20
> =20
> @@ -1176,7 +1179,11 @@ static int write_init_super1(struct supertype *st)
>  			sb->data_size =3D __cpu_to_le64(dsize - reserved);
>  			break;
>  		default:
> -			return -EINVAL;
> +			fprintf(stderr,	Name ": Failed to write invalid "
> +				"metadata format 1.%i to %s\n",
> +				st->minor_version, di->devname);
> +			rv =3D -EINVAL;
> +			goto out;
>  		}
> =20
> =20
> @@ -1192,6 +1199,11 @@ static int write_init_super1(struct supertype *st)
>  		close(di->fd);
>  		di->fd =3D -1;
>  	}
> +error_out:
> +	if (rv)
> +		fprintf(stderr,	Name ": Failed to write metadata to %s\n",
> +			di->devname);
> +out:
>  	return rv;
>  }
>  #endif


--Sig_//UxIrtrHfCaVimnzQk_l+RH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0Vk6jnsnt1WYoG5AQIA/A//cjlgRX7fZlBd4xOxu2dUG8iXLVr1ClUB
WVLcud3UDLmNrOPMEJNTvaj6o6y5BTSujAesKBLf1T/jy6dPmI0UlwKW0Ip18jIu
aRgeXlxjCcn9Sfdgsi9qSCRgtC+hCWflkChRiR/QTGwqO/Ygh/VFkcd1ZdoYUa/V
pqsmjGu75dqyaagfBWKgdcsvcq+TEHB0FlIgwxNH6KSbj1lwWqxJOIqAzp/zJDh2
TdW+TGEsBByjjAg8VyDcRVeOhJVmRyLpZRMSrwzlWZZQfzjL9MpU0eAbQ8lGMHe2
PlKCl2usZhQZBvIKuelzs+9XsVrXSb8nLVDVxYGO7MsTlWSQZ0RkvACuIRrnBnNE
oM86Jz5Np4vZrMdDjRkjaVARng+Ckbxn77Gv7cw6pRkwfa7pPo0K8s1uYDjSZmhB
/7M4iIPQQfd1Y+2f/PXiyy8KgZRoTYVEkXtRgazw0ivRF1N44l5BMgCdAWMzamsy
hjnzzEmLGxn/ep2YhR2thAv5yN5OKibRUGvPUjcbwozCr/tHS/6VhP7jTcZa14Xa
uTlIALtxOR8YhATg8WPzMtFxQ4coW2RMV17ElpxTbgqq+7sVnOX51cuedSkJZaza
cghX93dvKpYzDMSRmmae/AYcFfOKLgs1ZhzkJcwCTbVANlqHRmyZ4eoLQ4cpZzi9
mjdupTeBXHQ=
=HSeL
-----END PGP SIGNATURE-----

--Sig_//UxIrtrHfCaVimnzQk_l+RH--
