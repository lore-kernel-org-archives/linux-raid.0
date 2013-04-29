From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] prevent double open(O_RDWR) on raid creation
Date: Mon, 29 Apr 2013 10:57:20 +1000
Message-ID: <20130429105720.593fe99b@notabene.brown>
References: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com>
	<1365686313-30833-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fUlQTOfDJvHGXBt5uPM6LI."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1365686313-30833-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: harald@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fUlQTOfDJvHGXBt5uPM6LI.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Apr 2013 15:18:33 +0200 Jes.Sorensen@redhat.com wrote:

> From: Harald Hoyer <harald@redhat.com>
>=20
> This does not trigger the udev inotify twice and saves a lot of blk I/O
> for the raid members.
>=20
> Also fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D947815
>=20
> Signed-off-by: Harald Hoyer <harald@redhat.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

(Sorry for delays.  Thanks for reminders).

That patch seems to make sense, but the description above is awfully thin.

Why is double-open a problem exactly?  What does it make udev do?  And how
does that related to ID_FS_TYPE being wrong as mentioned in the bugzilla
entry.

NeilBrown


> ---
>  Kill.c        | 28 +++++++++++++++++-----------
>  Manage.c      |  2 +-
>  mdadm.c       |  4 ++--
>  mdadm.h       |  2 +-
>  super-ddf.c   |  2 +-
>  super-intel.c |  2 +-
>  super0.c      |  2 +-
>  super1.c      |  2 +-
>  8 files changed, 25 insertions(+), 19 deletions(-)
>=20
> diff --git a/Kill.c b/Kill.c
> index f2fdb85..b5c93ae 100644
> --- a/Kill.c
> +++ b/Kill.c
> @@ -29,7 +29,7 @@
>  #include	"md_u.h"
>  #include	"md_p.h"
> =20
> -int Kill(char *dev, struct supertype *st, int force, int verbose, int no=
excl)
> +int Kill(char *dev, int oldfd, struct supertype *st, int force, int verb=
ose, int noexcl)
>  {
>  	/*
>  	 * Nothing fancy about Kill.  It just zeroes out a superblock
> @@ -42,21 +42,26 @@ int Kill(char *dev, struct supertype *st, int force, =
int verbose, int noexcl)
> =20
>  	int fd, rv =3D 0;
> =20
> -	if (force)
> -		noexcl =3D 1;
> -	fd =3D open(dev, O_RDWR|(noexcl ? 0 : O_EXCL));
> -	if (fd < 0) {
> -		if (verbose >=3D 0)
> -			pr_err("Couldn't open %s for write - not zeroing\n",
> -				dev);
> -		return 2;
> +	if (oldfd !=3D -1) {
> +		fd =3D oldfd;
> +	} else {
> +		if (force)
> +			noexcl =3D 1;
> +		fd =3D open(dev, O_RDWR|(noexcl ? 0 : O_EXCL));
> +		if (fd < 0) {
> +			if (verbose >=3D 0)
> +				pr_err("Couldn't open %s for write - not zeroing\n",
> +					dev);
> +			return 2;
> +		}
>  	}
>  	if (st =3D=3D NULL)
>  		st =3D guess_super(fd);
>  	if (st =3D=3D NULL || st->ss->init_super =3D=3D NULL) {
>  		if (verbose >=3D 0)
>  			pr_err("Unrecognised md component device - %s\n", dev);
> -		close(fd);
> +		if (oldfd =3D=3D -1)
> +			close(fd);
>  		return 2;
>  	}
>  	st->ignore_hw_compat =3D 1;
> @@ -76,7 +81,8 @@ int Kill(char *dev, struct supertype *st, int force, in=
t verbose, int noexcl)
>  			rv =3D 0;
>  		}
>  	}
> -	close(fd);
> +	if (oldfd =3D=3D -1)
> +		close(fd);
>  	return rv;
>  }
> =20
> diff --git a/Manage.c b/Manage.c
> index 6267c0c..509e921 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -785,7 +785,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			return -1;
>  		}
> =20
> -		Kill(dv->devname, NULL, 0, -1, 0);
> +		Kill(dv->devname, -1, NULL, 0, -1, 0);
>  		dfd =3D dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
>  		if (mdmon_running(tst->container_devnm))
>  			tst->update_tail =3D &tst->updates;
> diff --git a/mdadm.c b/mdadm.c
> index 214afa3..d68ee96 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1739,11 +1739,11 @@ static int misc_list(struct mddev_dev *devlist,
>  			continue;
>  		case KillOpt: /* Zero superblock */
>  			if (ss)
> -				rv |=3D Kill(dv->devname, ss, c->force, c->verbose,0);
> +				rv |=3D Kill(dv->devname, -1, ss, c->force, c->verbose, 0);
>  			else {
>  				int v =3D c->verbose;
>  				do {
> -					rv |=3D Kill(dv->devname, NULL, c->force, v, 0);
> +					rv |=3D Kill(dv->devname, -1, NULL, c->force, v, 0);
>  					v =3D -1;
>  				} while (rv =3D=3D 0);
>  				rv &=3D ~2;
> diff --git a/mdadm.h b/mdadm.h
> index c7b5183..e55dec5 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1156,7 +1156,7 @@ extern int Monitor(struct mddev_dev *devlist,
>  		   int dosyslog, char *pidfile, int increments,
>  		   int share);
> =20
> -extern int Kill(char *dev, struct supertype *st, int force, int verbose,=
 int noexcl);
> +extern int Kill(char *dev, int oldfd, struct supertype *st, int force, i=
nt verbose, int noexcl);
>  extern int Kill_subarray(char *dev, char *subarray, int verbose);
>  extern int Update_subarray(char *dev, char *subarray, char *update, stru=
ct mddev_ident *ident, int quiet);
>  extern int Wait(char *dev);
> diff --git a/super-ddf.c b/super-ddf.c
> index c5f6f5c..a88699c 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -2597,7 +2597,7 @@ static int write_init_super_ddf(struct supertype *s=
t)
>  	} else {
>  		struct dl *d;
>  		for (d =3D ddf->dlist; d; d=3Dd->next)
> -			while (Kill(d->devname, NULL, 0, -1, 1) =3D=3D 0);
> +			while (Kill(d->devname, d->fd, NULL, 0, -1, 1) =3D=3D 0);
>  		return __write_init_super_ddf(st);
>  	}
>  }
> diff --git a/super-intel.c b/super-intel.c
> index 24016b7..743a7fc 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5221,7 +5221,7 @@ static int write_init_super_imsm(struct supertype *=
st)
>  	} else {
>  		struct dl *d;
>  		for (d =3D super->disks; d; d =3D d->next)
> -			Kill(d->devname, NULL, 0, -1, 1);
> +			Kill(d->devname, d->fd, NULL, 0, -1, 1);
>  		return write_super_imsm(st, 1);
>  	}
>  }
> diff --git a/super0.c b/super0.c
> index 1f4dc75..57b549e 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -779,7 +779,7 @@ static int write_init_super0(struct supertype *st)
>  			continue;
>  		if (di->fd =3D=3D -1)
>  			continue;
> -		while (Kill(di->devname, NULL, 0, -1, 1) =3D=3D 0)
> +		while (Kill(di->devname, di->fd, NULL, 0, -1, 1) =3D=3D 0)
>  			;
> =20
>  		sb->disks[di->disk.number].state &=3D ~(1<<MD_DISK_FAULTY);
> diff --git a/super1.c b/super1.c
> index d0f1d5f..e3eeb80 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1333,7 +1333,7 @@ static int write_init_super1(struct supertype *st)
>  		if (di->fd < 0)
>  			continue;
> =20
> -		while (Kill(di->devname, NULL, 0, -1, 1) =3D=3D 0)
> +		while (Kill(di->devname, di->fd, NULL, 0, -1, 1) =3D=3D 0)
>  			;
> =20
>  		sb->dev_number =3D __cpu_to_le32(di->disk.number);


--Sig_/fUlQTOfDJvHGXBt5uPM6LI.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUX3FcDnsnt1WYoG5AQIS9hAAtfXN1n7/a0/94TAYQlDUBMViPDkmv/3C
w7zG8CfLsu8gwSi/v1gSISRaQjjLFwfjLitg8TcxJ0YD5VMQBzo7AB5EFGhCTDQi
rjzw5eaHg4n9QD8s3MG+bpydypFvHlh001D0OMAoT2F58JtbsLzL2FJBRBAu6pNH
FcnaA1v8u50VI3ULWaVDb5uCKqoZFSB0wfvuXLCILOnDfbZ02QFK1hFDu5KhKCtU
qtC5GykIQUtVme9SiARYxlbLNsc2Q+lSbbQ3TmeedBKDq5HhUSS7aqy8AM5DfyRy
mHMO5llxIT28vs0Fe3fe5y/GRtNGfrFWQuSU8+4rWAvJXdXz7q4Emr0c/PH9sUw3
v1C/QZpwMxmzkIPArpuZH6CQBE/dwm4XYFhGlIbl1QNtdRDCBNibTScIHEBurYdO
UthR4b01DTT/ZN/AV+q1CAnuL1nunVmuRh8oZKXezBTyRjC/YAr+A/vLSHINOhJs
CbOTvh4spudR+YsfPF2lFgkMUtGSjcWT5o06vVPnrkWsffC+H5JsZAG0XGposKHs
fEtSVHcFUQjGB2C7LV9Ks6iTdX1Rf+YT9IDZhOVOcnSM48nLV2EoQLn3k0LNkD8N
1z/L/+BQSfPJo0xpK+UHiwvLzA58Oo5VdSjDlcUWvWQW+zzrQ0oKX3gp9fRNxqlL
Lsz15tECVqc=
=1Z2a
-----END PGP SIGNATURE-----

--Sig_/fUlQTOfDJvHGXBt5uPM6LI.--
