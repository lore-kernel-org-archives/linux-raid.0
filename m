From: NeilBrown <nfbrown@novell.com>
Subject: Re: [PATCH] mdadm: check bitmap first when reshape raid1 to raid0
Date: Mon, 21 Dec 2015 13:47:09 +1100
Message-ID: <87y4co4ixe.fsf@notabene.neil.brown.name>
References: <1446510328-22917-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446510328-22917-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 03 2015, Xiao Ni wrote:

> One raid1 with bitmap is composed by 4 disks. It'll fail when rashape
> to raid0 and lose 3 disks. It should check bitmap first when reshape
> raid1 to raid0.
>
> And need to free subarray, close cfd in Grow_reshape.
>
> It can't remove bitmap in Grow_reshape, because it's already frozen. I
> think it should not unfreeze in the process of the function. So I just
> test the bitmap.

I don't find this acceptable, sorry.
If mdadm it asked the change the level from raid1 to raid0 it should do
that, unless it is dangerous or impossible.
Removing a bitmap is neither dangerous nor impossible.  To just do it.

I would probably put a test in before freezing the array.
 if array has a bitmap and a request was made to change the level to
 raid0, then remove the bitmap.

It that so hard?

Also you patch does multiple different things, some of which weren't
explained at all in the comment above.

In particlar, the change to mdadm.c is completely pointless.
It seems to just be adding a 'close' call before 'exit'.
As 'exit' implicitly closes all file descriptors there is nothing to be
gained by closing anything immediately before calling exit.

Thanks,
NeilBrown


>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c  | 45 ++++++++++++++++++++++++++++-----------------
>  mdadm.c | 16 ++++++++++++----
>  2 files changed, 40 insertions(+), 21 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index 80d7b22..c4ea2a5 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1600,15 +1600,14 @@ int Grow_reshape(char *devname, int fd,
>  			cfd =3D open_dev_excl(st->container_devnm);
>  		} else {
>  			container =3D st->devnm;
> -			close(fd);
>  			cfd =3D open_dev_excl(st->devnm);
>  			fd =3D cfd;
>  		}
>  		if (cfd < 0) {
>  			pr_err("Unable to open container for %s\n",
>  				devname);
> -			free(subarray);
> -			return 1;
> +			rv =3D 1;
> +			goto release;
>  		}
>=20=20
>  		rv =3D st->ss->load_container(st, cfd, NULL);
> @@ -1616,8 +1615,8 @@ int Grow_reshape(char *devname, int fd,
>  		if (rv) {
>  			pr_err("Cannot read superblock for %s\n",
>  				devname);
> -			free(subarray);
> -			return 1;
> +			rv =3D 1;
> +			goto release;
>  		}
>=20=20
>  		/* check if operation is supported for metadata handler */
> @@ -1641,8 +1640,8 @@ int Grow_reshape(char *devname, int fd,
>  					pr_err("cannot reshape arrays in container with unsupported metadat=
a: %s(%s)\n",
>  					       devname, container);
>  					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> +					rv =3D 1;
> +					goto release;
>  				}
>  			}
>  			sysfs_free(cc);
> @@ -1662,7 +1661,8 @@ int Grow_reshape(char *devname, int fd,
>  		       s->raiddisks - array.raid_disks,
>  		       s->raiddisks - array.raid_disks =3D=3D 1 ? "" : "s",
>  		       array.spare_disks + added_disks);
> -		return 1;
> +		rv =3D 1;
> +		goto release;
>  	}
>=20=20
>  	sra =3D sysfs_read(fd, NULL, GET_LEVEL | GET_DISKS | GET_DEVS
> @@ -1675,17 +1675,18 @@ int Grow_reshape(char *devname, int fd,
>  	} else {
>  		pr_err("failed to read sysfs parameters for %s\n",
>  			devname);
> -		return 1;
> +		rv =3D 1;
> +		goto release;
>  	}
>  	frozen =3D freeze(st);
>  	if (frozen < -1) {
>  		/* freeze() already spewed the reason */
> -		sysfs_free(sra);
> -		return 1;
> +		rv =3D 1;
> +		goto release;
>  	} else if (frozen < 0) {
>  		pr_err("%s is performing resync/recovery and cannot be reshaped\n", de=
vname);
> -		sysfs_free(sra);
> -		return 1;
> +		rv =3D 1;
> +		goto release;
>  	}
>=20=20
>  	/* =3D=3D=3D=3D=3D=3D=3D=3D=3D set size =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D */
> @@ -1898,11 +1899,16 @@ size_change_error:
>  	     array.layout =3D=3D ((1 << 8) + 2) && !(array.raid_disks & 1)) ||
>  	    (s->level =3D=3D 0 && array.level =3D=3D 1 && sra)) {
>  		int err;
> +=09=09
> +		if (array.state & (1<<MD_SB_BITMAP_PRESENT)) {
> +		        pr_err("Bitmap must be removed before level can be changed\n");
> +		        rv =3D 1;
> +		        goto release;
> +		}
> +
>  		err =3D remove_disks_for_takeover(st, sra, array.layout);
>  		if (err) {
> -			dprintf("Array cannot be reshaped\n");
> -			if (cfd > -1)
> -				close(cfd);
> +			pr_err("Array cannot be reshaped\n");
>  			rv =3D 1;
>  			goto release;
>  		}
> @@ -2078,9 +2084,14 @@ size_change_error:
>  		frozen =3D 0;
>  	}
>  release:
> -	sysfs_free(sra);
>  	if (frozen > 0)
>  		unfreeze(st);
> +	if (sra)
> +		sysfs_free(sra);
> +	if (cfd > -1)
> +		close(cfd);
> +	if (subarray)
> +		free(subarray);
>  	return rv;
>  }
>=20=20
> diff --git a/mdadm.c b/mdadm.c
> index f56a8cf..95db2a0 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1299,7 +1299,8 @@ int main(int argc, char *argv[])
>  			pr_err("'1' is an unusual number of drives for an array, so it is pro=
bably\n"
>  				"     a mistake.  If you really mean it you will need to specify --f=
orce before\n"
>  				"     setting the number of drives.\n");
> -			exit(2);
> +			rv =3D 2;
> +			goto release;
>  		}
>  	}
>=20=20
> @@ -1326,13 +1327,15 @@ int main(int argc, char *argv[])
>  			rv =3D get_cluster_name(&c.homecluster);
>  		if (rv) {
>  			pr_err("The md can't get cluster name\n");
> -			exit(1);
> +			rv =3D 1;
> +			goto release;
>  		}
>  	}
>=20=20
>  	if (c.backup_file && data_offset !=3D INVALID_SECTORS) {
>  		pr_err("--backup-file and --data-offset are incompatible\n");
> -		exit(2);
> +		rv =3D 2;
> +		goto release;
>  	}
>=20=20
>  	if ((mode =3D=3D MISC && devmode =3D=3D 'E')
> @@ -1340,7 +1343,8 @@ int main(int argc, char *argv[])
>  		/* Anyone may try this */;
>  	else if (geteuid() !=3D 0) {
>  		pr_err("must be super-user to perform this action\n");
> -		exit(1);
> +		rv =3D 1;
> +		goto release;
>  	}
>=20=20
>  	ident.autof =3D c.autof;
> @@ -1640,6 +1644,10 @@ int main(int argc, char *argv[])
>  		autodetect();
>  		break;
>  	}
> +
> +release:
> +	if (mdfd > -1)
> +		close(mdfd);
>  	exit(rv);
>  }
>=20=20
> --=20
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd2gtAAoJEDnsnt1WYoG5QhgP/0CcNYFBuFcyyMmbIQmwfWkn
gKJaEGMY+g3o/nsNxrlTO7jyBj7gHwxHdr7VYWOD05TcLm1IfYxMpxGOfLTEePC0
ZHw1qI+Sc/D9m3sLL+otfxNxmm4pQsKfLArFZCAEUtKYpJ+IhDypWLSKD1K9gxTG
dITtS1IZubta0LRUkc3PzhaCweIBgGL6xPdSKn7gUmT/Gr5+vrTrKrR3GT/sGh4Z
PFuAGNxpa1LfedBW1BZXn3PlFehY7TvC5MVZPoDuih9sxEzzM98YylbbyzmIU8X3
z4cJ+JV72vJ7TvLN8MRSnsg+FPoTP2DDDS/PCNd3leg5GGz9cx5jh5uUxIT5PIKv
4FcQbpozSaLYhhN6H0UMfPUadNgk2RnxYv4rirrE0a2aGtPBmZ+G8xp2zYPRugh/
y/e5wphZ1QesfWdvkqWr+VfzNNxvIgGotHklLkh9DHejtSUQ6Up9Y0Ju8KvuMkzm
RcTG0xiI0OAH9IJ2kL5UqV8RV/ylFeumqSLLHKI5A2U+hRir02tNdYPStl5U6MXz
uem8UsYNdeRexwAUuRogY2Y557QifdjA2FUY+6u63vzmoMMbpwt1Ry1XTViQwlKD
9KulX9Vr6ZJGKEQFN82cU7kCQoc+TN78zs4dJQjlPi1Zn5xKXLPXktHuXHNzdbbd
uWFFlw1yPWS1nv4w6YkN
=4Y+h
-----END PGP SIGNATURE-----
--=-=-=--
