From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix serious memory leak
Date: Mon, 19 Sep 2011 13:27:22 +1000
Message-ID: <20110919132722.04d35708@notabene.brown>
References: <20110916111913.20840.13403.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h=_NNOX8K8rBu4FWkephqge"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916111913.20840.13403.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/h=_NNOX8K8rBu4FWkephqge
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:19:14 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> During reshape function restore_stripes is called periodically
> and every time the buffer stripe_buf (of size raid_disks*chunk_size)
> is allocated but is not freed. It happens also upon successful completion.
> In case of huge arrays it can lead to the seizure of the entire
> system memory (even of the order of gigabytes).
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>

Thanks.

I changed that patch a bit:
 - There were two places that freed everything and returned.  I changed the
   first one to just set 'rv' and 'goto' the last one.
 - You set 'rv =3D 0' twice.  Once is enough.  I removed the first one.

Thanks,

NeilBrown


> ---
>  restripe.c |   43 +++++++++++++++++++++++++++++++------------
>  1 files changed, 31 insertions(+), 12 deletions(-)
>=20
> diff --git a/restripe.c b/restripe.c
> index 9c83e2e..7cabbd0 100644
> --- a/restripe.c
> +++ b/restripe.c
> @@ -687,6 +687,7 @@ int restore_stripes(int *dest, unsigned long long *of=
fsets,
>  	char **stripes =3D malloc(raid_disks * sizeof(char*));
>  	char **blocks =3D malloc(raid_disks * sizeof(char*));
>  	int i;
> +	int rv =3D 0;
> =20
>  	int data_disks =3D raid_disks - (level =3D=3D 0 ? 0 : level <=3D 5 ? 1 =
: 2);
> =20
> @@ -717,20 +718,26 @@ int restore_stripes(int *dest, unsigned long long *=
offsets,
>  		unsigned long long offset;
>  		int disk, qdisk;
>  		int syndrome_disks;
> -		if (length < len)
> -			return -3;
> +		if (length < len) {
> +			rv =3D -3;
> +			goto abort;
> +		}
>  		for (i =3D 0; i < data_disks; i++) {
>  			int disk =3D geo_map(i, start/chunk_size/data_disks,
>  					   raid_disks, level, layout);
>  			if (src_buf =3D=3D NULL) {
>  				/* read from file */
> -				if (lseek64(source,
> -					read_offset, 0) !=3D (off64_t)read_offset)
> -					return -1;
> +				if (lseek64(source, read_offset, 0) !=3D
> +					 (off64_t)read_offset) {
> +					rv =3D -1;
> +					goto abort;
> +				}
>  				if (read(source,
>  					 stripes[disk],
> -					 chunk_size) !=3D chunk_size)
> -					return -1;
> +					 chunk_size) !=3D chunk_size) {
> +					rv =3D -1;
> +					goto abort;
> +				}
>  			} else {
>  				/* read from input buffer */
>  				memcpy(stripes[disk],
> @@ -782,15 +789,27 @@ int restore_stripes(int *dest, unsigned long long *=
offsets,
>  		}
>  		for (i=3D0; i < raid_disks ; i++)
>  			if (dest[i] >=3D 0) {
> -				if (lseek64(dest[i], offsets[i]+offset, 0) < 0)
> -					return -1;
> -				if (write(dest[i], stripes[i], chunk_size) !=3D chunk_size)
> -					return -1;
> +				if (lseek64(dest[i],
> +					 offsets[i]+offset, 0) < 0) {
> +					rv =3D -1;
> +					goto abort;
> +				}
> +				if (write(dest[i], stripes[i],
> +					 chunk_size) !=3D chunk_size) {
> +					rv =3D -1;
> +					goto abort;
> +				}
>  			}
>  		length -=3D len;
>  		start +=3D len;
>  	}
> -	return 0;
> +	rv =3D 0;
> +
> +abort:
> +	free(stripe_buf);
> +	free(stripes);
> +	free(blocks);
> +	return rv;
>  }
> =20
>  #ifdef MAIN
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/h=_NNOX8K8rBu4FWkephqge
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOdraaG5fc6gV+Wb0RAhaKAJ0eZ6TutANU1Dh+6QG52W4kLQP+fACgsyGP
F9WdyYCfQ1+XVK8Qevm4X0c=
=b7Hp
-----END PGP SIGNATURE-----

--Sig_/h=_NNOX8K8rBu4FWkephqge--
