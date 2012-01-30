From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] FIX: Takeover mdmon when grow is continued from
 command line
Date: Mon, 30 Jan 2012 11:24:17 +1100
Message-ID: <20120130112417.3a30e18e@notabene.brown>
References: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
	<20120112071231.5168.62971.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+YQPE92DZtodVKiW5Mz4L1B"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120112071231.5168.62971.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/+YQPE92DZtodVKiW5Mz4L1B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jan 2012 08:12:31 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When reshape with '--continue' option is executed mdadm doesn't know,
> if mdmon is switched to using '--takeover' option to current file system
> context. To resolve this, on reshape continuation when mdmon is run,
> execute mdmon takeover.
>=20
> Lack of takeovered mdmon can cause e.g.:
> - multivolume reshape is broken when reshaped volume is changed
> - size of reshaped volume dowsn't increase

I don't think this is right.

In particular, the way we seem to be going with systemd means that we might
not end up using '--takeover' at all.  So performing a --takeover
transparently without being explicitly asked to is not a good idea.

--continue is only used once the final root is mounted and all the early bo=
ot
complications are out of the way.
So can't we simple require that --takeover - if it is being used - be
performed before any --continue??

i.e. is there a reason we cannot ensure this works properly simply by making
sure boot scripts do the right things in the right order.

NeilBrown


>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c  |    2 ++
>  mdadm.h |    1 +
>  util.c  |   53 ++++++++++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 47 insertions(+), 9 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index b2c1360..f0422d2 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3876,6 +3876,8 @@ int Grow_continue_command(char *devname, int fd,
>  		 */
>  		if (!mdmon_running(container_dev))
>  			start_mdmon(container_dev);
> +		else
> +			takeover_mdmon(container_dev);
>  		ping_monitor(buf);
> =20
>  		if (mdmon_running(container_dev))
> diff --git a/mdadm.h b/mdadm.h
> index 381ef86..f274ae7 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1223,6 +1223,7 @@ extern int mdmon_pid(int devnum);
>  extern int check_env(char *name);
>  extern __u32 random32(void);
>  extern int start_mdmon(int devnum);
> +extern int takeover_mdmon(int devnum);
> =20
>  extern int child_monitor(int afd, struct mdinfo *sra, struct reshape *re=
shape,
>  			 struct supertype *st, unsigned long stripes,
> diff --git a/util.c b/util.c
> index 6985a70..e95a366 100644
> --- a/util.c
> +++ b/util.c
> @@ -1581,11 +1581,13 @@ int mdmon_running(int devnum)
>  	return 0;
>  }
> =20
> -int start_mdmon(int devnum)
> +#define MDMON_TAKEOVER_WAIT_COUNTER 15
> +int execute_mdmon(int devnum, int takeover)
>  {
>  	int i, skipped;
>  	int len;
> -	pid_t pid;=09
> +	pid_t pid;
> +	pid_t pid_org;
>  	int status;
>  	char pathbuf[1024];
>  	char *paths[4] =3D {
> @@ -1611,6 +1613,12 @@ int start_mdmon(int devnum)
>  	} else
>  		pathbuf[0] =3D '\0';
> =20
> +	if (takeover) {
> +		pid_org =3D mdmon_pid(devnum);
> +		if (pid_org < 0)
> +			takeover =3D 0;
> +	}
> +
>  	switch(fork()) {
>  	case 0:
>  		/* FIXME yuk. CLOSE_EXEC?? */
> @@ -1620,24 +1628,51 @@ int start_mdmon(int devnum)
>  				skipped++;
>  			else
>  				skipped =3D 0;
> -
> -		for (i=3D0; paths[i]; i++)
> -			if (paths[i][0])
> -				execl(paths[i], "mdmon",
> -				      devnum2devname(devnum),
> -				      NULL);
> +		for (i =3D 0; paths[i]; i++) {
> +			if (paths[i][0]) {
> +				if (!takeover)
> +					execl(paths[i], "mdmon",
> +					      devnum2devname(devnum),
> +					      NULL);
> +				else
> +					execl(paths[i], "mdmon",
> +					      "--takeover",
> +					      devnum2devname(devnum),
> +					      NULL);
> +			}
> +		}
>  		exit(1);
>  	case -1: fprintf(stderr, Name ": cannot run mdmon. "
>  			 "Array remains readonly\n");
>  		return -1;
>  	default: /* parent - good */
> -		pid =3D wait(&status);
> +		i =3D 0;
> +		do {
> +			if (i)
> +				sleep(1);
> +			pid =3D wait(&status);
> +			if (takeover && (pid =3D=3D pid_org))
> +				pid =3D -1;
> +			i++;
> +		} while (takeover &&
> +			 (i < MDMON_TAKEOVER_WAIT_COUNTER) &&
> +			 (pid < 0));
>  		if (pid < 0 || status !=3D 0)
>  			return -1;
>  	}
>  	return 0;
>  }
> =20
> +int start_mdmon(int devnum)
> +{
> +	return execute_mdmon(devnum, 0);
> +}
> +
> +int takeover_mdmon(int devnum)
> +{
> +	return execute_mdmon(devnum, 1);
> +}
> +
>  int check_env(char *name)
>  {
>  	char *val =3D getenv(name);


--Sig_/+YQPE92DZtodVKiW5Mz4L1B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyXjMTnsnt1WYoG5AQJzSg//X9XHdmHZ4Y/OCA5iU5iaCof3T/At/bGR
jr+oonrKGVveovTBndNPI+Ph8QFK46pIiW2VkbyovBo3b7kOP3oMoUxDDwjuTVBS
pKWVbR9TdDAdGy4QMraMNGT7XKdL83M3RWdkJsSOl03rySAnvy9QeqQ27gl5gdPg
E3BOoQ9qiovJNVUfbRtsQEloLGd5U+CQ4xvoqIrIeq6i0phpUWiedlLNy307j/Rf
XhShn3wrnPmorYKMSeS6kTevV0O2+pKQrOHK724M7x6jqLujEU+2VCW91tNM8zvv
Fz+4eQZ+0P2eyX3ZFHNKBUf3dH93i2G6zhLOXH6yiAbC+7PA91i9bXhU0Elrv0py
1C6cQKIeQnwaQ/QJOxDo7YvwCAb5ZSma6VhJcZeJ3H7twHnlyIGwxejnYj5aTaLj
DGwRC+yagHl8QjYCFegI84Hq9najb5lq2YgaANTfaOvVbclY6uxCoSNwUOCgKZ20
xOz8z4S04P28iCjwNd4ar4fvzwgzCgde9R2C2VoMzkty2pFR6J0id0xHD4VGKshw
EPyCVeIdSZcG7/KjP4BgGlzFb7OxuL+ih4lJLJ21gb2MkB3noLqhy28+i5tBXSam
afKQK6w8y/MsQUv5YPzpZ5oEbUXCkGS1Rf15deAhyJVCFpkxJEpYUwA0x3oKsh1S
hToFQi7wyUs=
=uU1q
-----END PGP SIGNATURE-----

--Sig_/+YQPE92DZtodVKiW5Mz4L1B--
