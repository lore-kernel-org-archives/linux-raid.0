From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 05/11] Add a new clustered disk
Date: Mon, 25 May 2015 14:35:34 +1000
Message-ID: <20150525143534.3faebbfb@notabene.brown>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
	<1432092043-24220-6-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/U/.2HsjZyhURe_43F_O84JK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-6-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--Sig_/U/.2HsjZyhURe_43F_O84JK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 11:20:37 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:

> A clustered disk is added by the traditional --add sequence.
> However, other nodes need to acknowledge that they can "see"
> the device. This is done by --cluster-confirm:
>=20
> --cluster-confirm SLOTNUM:/dev/whatever (if disk is found)
> or
> --cluster-confirm SLOTNUM:missing (if disk is not found)
>=20
> The node initiating the --add, has the disk state tagged with
> MD_DISK_CLUSTER_ADD and the one confirming tag the disk with
> MD_DISK_CANDIDATE.
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Manage.c   | 33 +++++++++++++++++++++++++++++----
>  ReadMe.c   |  1 +
>  md_p.h     |  7 +++++++
>  md_u.h     |  1 +
>  mdadm.8.in |  9 +++++++++
>  mdadm.c    |  4 ++++
>  mdadm.h    |  2 ++
>  util.c     | 10 ++++++++++
>  8 files changed, 63 insertions(+), 4 deletions(-)
>=20
> diff --git a/Manage.c b/Manage.c
> index d3cfb55..4c3d451 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -690,7 +690,8 @@ skip_re_add:
>  int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	       struct supertype *tst, mdu_array_info_t *array,
>  	       int force, int verbose, char *devname,
> -	       char *update, unsigned long rdev, unsigned long long array_size)
> +	       char *update, unsigned long rdev, unsigned long long array_size,
> +	       int raid_slot)
>  {
>  	unsigned long long ldsize;
>  	struct supertype *dev_st =3D NULL;
> @@ -879,7 +880,10 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	}
>  	disc.major =3D major(rdev);
>  	disc.minor =3D minor(rdev);
> -	disc.number =3Dj;
> +	if (raid_slot < 0)
> +		disc.number =3D j;
> +	else
> +		disc.number =3D raid_slot;
>  	disc.state =3D 0;
>  	if (array->not_persistent=3D=3D0) {
>  		int dfd;
> @@ -920,6 +924,14 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			}
>  		free(used);
>  	}
> +
> +	if (array->state & (1 << MD_SB_CLUSTERED)) {
> +		if (dv->disposition =3D=3D 'c')
> +			disc.state |=3D (1 << MD_DISK_CANDIDATE);
> +		else
> +			disc.state |=3D (1 << MD_DISK_CLUSTER_ADD);
> +	}
> +
>  	if (dv->writemostly =3D=3D 1)
>  		disc.state |=3D (1 << MD_DISK_WRITEMOSTLY);
>  	if (tst->ss->external) {
> @@ -1239,6 +1251,7 @@ int Manage_subdevs(char *devname, int fd,
>  	 *        variant on 'A'
>  	 *  'F' - Another variant of 'A', where the device was faulty
>  	 *        so must be removed from the array first.
> +	 *  'c' - confirm the device as found (for clustered environments)
>  	 *
>  	 * For 'f' and 'r', the device can also be a kernel-internal
>  	 * name such as 'sdb'.
> @@ -1254,6 +1267,7 @@ int Manage_subdevs(char *devname, int fd,
>  	struct mdinfo info;
>  	int frozen =3D 0;
>  	int busy =3D 0;
> +	int raid_slot =3D -1;
> =20
>  	if (ioctl(fd, GET_ARRAY_INFO, &array)) {
>  		pr_err("Cannot get array info for %s\n",
> @@ -1282,6 +1296,11 @@ int Manage_subdevs(char *devname, int fd,
>  		int rv;
>  		int mj,mn;
> =20
> +		raid_slot =3D -1;
> +		if (dv->disposition =3D=3D 'c')
> +			parse_cluster_confirm_arg(dv->devname, &dv->devname,
> +					&raid_slot);
> +

This function returns -1 if it couldn't successfully parse dv->devname, but
you aren't catching that error and reporting it.


NeilBrown


> =20
> +int parse_cluster_confirm_arg(char *input, char **devname, int *slot)
> +{
> +	char *dev;
> +	*slot =3D strtoul(input, &dev, 10);
> +	if (dev =3D=3D input || dev[0] !=3D ':')
> +		return -1;
> +	*devname =3D dev+1;
> +	return 0;
> +}
> +

--Sig_/U/.2HsjZyhURe_43F_O84JK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKmljnsnt1WYoG5AQLGHQ/+PjSLMJdTThzem1OTCnIg180ztlgao2p+
5mLpBtsnCD5qBvcWFR5qVXoHo/JWpH5K73S+uG8WSQzs48SuKyFLqvr41WRvmj8j
DDGi//bjDC3LUyQiYnAvyMyAgWORSQ2tusSkmU2Oir4wK+zUswj2HNJhahtvCDak
QsgLTXIv5vlIeriRiNqdQYKPQAXl30hUAJ5qwOCYEiCGNo3qwNOKgOn+emJWnKs2
59U/2WRiEMBhi28CpGM/wDuEaPtUG1qtQ8o8FPgUUeVLfJLQewloFzdTIXYLrjMG
2xSmQZMPIEeRlbBxw/gRAwtTh0NvSJagfhUKn58sIzq60lZ6PCcikJAy0RCpSIJw
Zm7r0j/zPg/9avWVHOPYhzqguV+YF53JViF+OT1At2nVK1HiG2fe/A7of8BREc/s
ElaewMC1OY/Ia55TLakyyibYLnon2vEyyQRI3apXImkmFg1Jg2wa8ITBVcajWnEl
Bx5074g4j7YqIVLbGERi7KBsOZnl86hcFikm9k8I32DnbstTqOttlLkwayd9ZTzh
pHrPpnavRG0Fog21sPsMruOOPMQZ9MhCdOwFU6kdjTsAmKYZxNQo0e9F0HNquGa7
6LN/DJO/wyT2eyH5eJ86/HQMk7vvhpZ4Vo9LXF9dYanOLo04kxrAafqLPT2iUGux
OFdQMIC+480=
=kpmN
-----END PGP SIGNATURE-----

--Sig_/U/.2HsjZyhURe_43F_O84JK--
