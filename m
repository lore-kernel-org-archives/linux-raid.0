From: NeilBrown <neilb@suse.com>
Subject: Re: [MDADM PATCH] Check and remove bitmap first when reshape to raid0
Date: Tue, 22 Dec 2015 08:06:51 +1100
Message-ID: <8760zr4il0.fsf@notabene.neil.brown.name>
References: <1450686229-6157-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450686229-6157-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 21 2015, Xiao Ni wrote:

> If reshape one raid device with bitmap to raid0, the reshape progress will
> start. But it'll fail and lose some components. So it should remove bitma=
p=20
> first.=20
>
> And it shouldn't close fd when try to call open_dev_excl. Because it's an
> input argument. It should be closed in the function who open it.

I thought I mentioned this before, but please don't include two very
different things in the same patch.  It is sometimes OK if one is just
a line or two.  But most of this patch has got nothing to do with the
subject line.

So this has to be two patches.  Except that you have have to try rather
hard to convince me that the second patch actually has any value.  I
cannot see that it improves the code in any important way.


>
> There are some places that return(1) directly but don't free subarray and
> close cfd in Grow_reshape. So add fallback: to do free(subarray) and=20
> close(cfd).
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 37 ++++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 9 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index 6dfb9c9..f892023 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1591,6 +1591,17 @@ int Grow_reshape(char *devname, int fd,
>  		return 1;
>  	}
>=20=20
> +	if (s->level =3D=3D 0 && array.state & (1<<MD_SB_BITMAP_PRESENT)) {
> +                array.state &=3D ~(1<<MD_SB_BITMAP_PRESENT);
> +                if (ioctl(fd, SET_ARRAY_INFO, &array)!=3D 0) {
> +                        if (array.state & (1<<MD_SB_CLUSTERED))
> +                                pr_err("failed to remove clustered bitma=
p.\n");
> +                        else
> +                                pr_err("failed to remove internal bitmap=
.\n");
> +                        return 1;
> +                }
> +        }

Removing an internal bitmap for conversion to RAID0 is sensible.
Removing the clustered bitmap isn't so sensible (I'm glad you noted that
difference).  Disabling cluster support is a much bigger change than
just removing an internal bitmap which is really just an optimisation.

So please only auto-remove the bitmap when it is a regular internal
bitmap.

Thanks,
NeilBrown



> +
>  	/* in the external case we need to check that the requested reshape is
>  	 * supported, and perform an initial check that the container holds the
>  	 * pre-requisite spare devices (mdmon owns final validation)
> @@ -1603,7 +1614,6 @@ int Grow_reshape(char *devname, int fd,
>  			cfd =3D open_dev_excl(st->container_devnm);
>  		} else {
>  			container =3D st->devnm;
> -			close(fd);
>  			cfd =3D open_dev_excl(st->devnm);
>  			fd =3D cfd;
>  		}
> @@ -1619,8 +1629,8 @@ int Grow_reshape(char *devname, int fd,
>  		if (rv) {
>  			pr_err("Cannot read superblock for %s\n",
>  				devname);
> -			free(subarray);
> -			return 1;
> +			rv =3D 1;
> +			goto fallback;
>  		}
>=20=20
>  		/* check if operation is supported for metadata handler */
> @@ -1644,8 +1654,8 @@ int Grow_reshape(char *devname, int fd,
>  					pr_err("cannot reshape arrays in container with unsupported metadat=
a: %s(%s)\n",
>  					       devname, container);
>  					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> +					rv =3D 1;
> +					goto fallback;
>  				}
>  			}
>  			sysfs_free(cc);
> @@ -1665,7 +1675,8 @@ int Grow_reshape(char *devname, int fd,
>  		       s->raiddisks - array.raid_disks,
>  		       s->raiddisks - array.raid_disks =3D=3D 1 ? "" : "s",
>  		       array.spare_disks + added_disks);
> -		return 1;
> +		rv =3D 1;
> +		goto fallback;
>  	}
>=20=20
>  	sra =3D sysfs_read(fd, NULL, GET_LEVEL | GET_DISKS | GET_DEVS
> @@ -1678,17 +1689,20 @@ int Grow_reshape(char *devname, int fd,
>  	} else {
>  		pr_err("failed to read sysfs parameters for %s\n",
>  			devname);
> -		return 1;
> +		rv =3D 1;
> +		goto fallback;
>  	}
>  	frozen =3D freeze(st);
>  	if (frozen < -1) {
>  		/* freeze() already spewed the reason */
>  		sysfs_free(sra);
> -		return 1;
> +		rv =3D 1;
> +		goto fallback;
>  	} else if (frozen < 0) {
>  		pr_err("%s is performing resync/recovery and cannot be reshaped\n", de=
vname);
>  		sysfs_free(sra);
> -		return 1;
> +		rv =3D 1;
> +		goto fallback;
>  	}
>=20=20
>  	/* =3D=3D=3D=3D=3D=3D=3D=3D=3D set size =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D */
> @@ -2084,6 +2098,11 @@ release:
>  	sysfs_free(sra);
>  	if (frozen > 0)
>  		unfreeze(st);
> +fallback:
> +	if (cfd > -1)
> +		close(cfd);
> +	if (subarray)
> +		free(subarray);
>  	return rv;
>  }
>=20=20
> --=20
> 2.4.3

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeGnrAAoJEDnsnt1WYoG5Z4EP/0+Tp3pbkuq3heN6ZQAWkXpH
VHxnUSr+aUEPJtgJz9rzuYuxcADnFM6D4eY5+mHNeMATZKuK67zNgvKEUzLCmezY
vse46zZLj4bnncb6oUsign6SKdEUYRFivXLWmhTHFizGB+75iOtDWNsF+2unZZER
skl9pekEEPNSYqC77Afb+DT9/FLTWshGMLB0om7FR9q64tPUmwOROSnMzlWKjtIw
oLHq3YACbpVhUpGBxK36etwIstvJyNzl0K+7JEdDDsSRLx0ObpK2bK6+kRyYBChY
FVL28psWQ605JQvcwOXHAOlZZNSHk8jQM3/5HAyxq6f0TDeeqAdrPOjXn236p+Ea
YCPgp/FImj3tBeBJK4MG/QT03yDaUHkcbWN4iFixRVOemz+/hj5GvgFcHf+OEP4i
LZm8NzOh0stR3gEMFyJIQZJu/0+zfN2AEuowOGxP1WWszSa41eMZd6RGWlTfjtT6
XYeUUuSIQriNC75W4Vk3f5xcFHnZ+EwwuTeD/pSio0f0RK/ceIAj7hIRT1jYlG1L
AF8UE+2RSCO1bjY9wSSSGMQoxqn4s/kogwn9hlJfOhxbgVWG9BZnwg3zzPRh4+LO
kMmTlzWuO64LiNTceb4ItmOSn+JCZOJlKi7M9tz0A8iLUpeigh2oNJERtNX7vM9C
jhG1LJJm46fJBdcIdjKX
=zGnH
-----END PGP SIGNATURE-----
--=-=-=--
