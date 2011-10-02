From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] FIX: Remove error message during reshape restart
 (v2)
Date: Mon, 3 Oct 2011 10:57:15 +1100
Message-ID: <20111003105715.3a44923a@notabene.brown>
References: <20110929154756.22854.13187.stgit@gklab-128-013.igk.intel.com>
	<20110929155353.22854.5948.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0p8TyACR9Ikv3VbWDm5_S_e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929155353.22854.5948.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/0p8TyACR9Ikv3VbWDm5_S_e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Sep 2011 17:53:54 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When reshape is started in container on single array, all other container
> members are blocked from monitoring also. After container reassembly
> we have to construct the same situation.
> Currently array under reshape is blocked only.
>=20
> To block whole container during reshape we have 2 cases:
>   1. first assembled array is not reshaped and second is under reshape
>   2. first assembled array not reshaped and second is not under reshape
>=20
> This patch addresses second case.
>   First assembled array is not reshaped and not blocked. Second reshaped
>   array is under reshape and it is blocked. When all reshaped array
>   parameters are verified and set in reshape continue freeze_container()
>   function block all other present in container and not blocked array(s).
>=20
> This call to freeze_container() serves for native metadata case also.
>=20
> This patch replaces its previous version that hides error message only.

I won't apply this one just now as it relates to the previous patch that I
want changed.
If you still think this is appropriate, please resubmit with the other fixe=
s.

Thanks,

NeilBrown


>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   18 +++++++++---------
>  msg.c  |   10 +++++++---
>  msg.h  |    2 +-
>  3 files changed, 17 insertions(+), 13 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 3e13c8f..8f75ab8 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -566,8 +566,7 @@ int block_array_if_any_is_blocked(struct supertype *s=
t, struct mdinfo *content)
>  	return 1;
>  }
> =20
> -
> -static int freeze_container(struct supertype *st)
> +static int freeze_container(struct supertype *st, int restart)
>  {
>  	int container_dev =3D (st->container_dev !=3D NoMdDev
>  			     ? st->container_dev : st->devnum);
> @@ -575,11 +574,12 @@ static int freeze_container(struct supertype *st)
> =20
>  	if (!check_idle(st))
>  		return -1;
> -=09
> +
>  	fmt_devname(container, container_dev);
> =20
> -	if (block_monitor(container, 1)) {
> -		fprintf(stderr, Name ": failed to freeze container\n");
> +	if (block_monitor(container, 1, restart)) {
> +		if (!restart)
> +			fprintf(stderr, Name ": failed to freeze container\n");
>  		return -2;
>  	}
> =20
> @@ -597,7 +597,7 @@ static void unfreeze_container(struct supertype *st)
>  	unblock_monitor(container, 1);
>  }
> =20
> -static int freeze(struct supertype *st)
> +static int freeze(struct supertype *st, int restart)
>  {
>  	/* Try to freeze resync/rebuild on this array/container.
>  	 * Return -1 if the array is busy,
> @@ -606,7 +606,7 @@ static int freeze(struct supertype *st)
>  	 * return 1 if it worked.
>  	 */
>  	if (st->ss->external)
> -		return freeze_container(st);
> +		return freeze_container(st, restart);
>  	else {
>  		struct mdinfo *sra =3D sysfs_read(-1, st->devnum, GET_VERSION);
>  		int err;
> @@ -1522,7 +1522,7 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
>  			devname);
>  		return 1;
>  	}
> -	frozen =3D freeze(st);
> +	frozen =3D freeze(st, 0);
>  	if (frozen < -1) {
>  		/* freeze() already spewed the reason */
>  		return 1;
> @@ -3653,7 +3653,7 @@ int Grow_continue(int mdfd, struct supertype *st, s=
truct mdinfo *info,
>  	if (st->ss->external) {
>  		fmt_devname(buf, st->container_dev);
>  		container =3D buf;
> -		freeze(st);
> +		freeze(st, 1);
> =20
>  		if (!mdmon_running(st->container_dev))
>  			start_mdmon(st->container_dev);
> diff --git a/msg.c b/msg.c
> index f903afb..48a5bc3 100644
> --- a/msg.c
> +++ b/msg.c
> @@ -334,7 +334,7 @@ int check_mdmon_version(char *container)
>   * As older versions of mdmon (which might run from initrd) don't unders=
tand
>   * this, we first check that the running mdmon is new enough.
>   */
> -int block_monitor(char *container, const int freeze)
> +int block_monitor(char *container, const int freeze, const int restart)
>  {
>  	struct mdstat_ent *ent, *e, *e2;
>  	struct mdinfo *sra =3D NULL;
> @@ -364,8 +364,12 @@ int block_monitor(char *container, const int freeze)
>  			break;
>  		}
>  		/* can't reshape an array that we can't monitor */
> -		if (sra->text_version[0] =3D=3D '-')
> -			break;
> +		if (sra->text_version[0] =3D=3D '-') {
> +			if (restart)
> +				continue;
> +			else
> +				break;
> +		}
> =20
>  		if (freeze && sysfs_freeze_array(sra) < 1)
>  			break;
> diff --git a/msg.h b/msg.h
> index fb5815e..15aef2a 100644
> --- a/msg.h
> +++ b/msg.h
> @@ -30,7 +30,7 @@ extern int ping_monitor(char *devname);
>  extern int ping_monitor_by_id(int devnum);
>  extern int block_subarray(struct mdinfo *sra);
>  extern int unblock_subarray(struct mdinfo *sra, const int unfreeze);
> -extern int block_monitor(char *container, const int freeze);
> +extern int block_monitor(char *container, const int freeze, const int re=
start);
>  extern void unblock_monitor(char *container, const int unfreeze);
>  extern int check_blocked_monitor(char *container);
>  extern int fping_monitor(int sock);


--Sig_/0p8TyACR9Ikv3VbWDm5_S_e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiPpbG5fc6gV+Wb0RAv2JAKCPg5bup5in3tweh71E6Su2WjrbzwCggB9t
83N5ST+mtCF/LrwtOICE9dE=
=X88M
-----END PGP SIGNATURE-----

--Sig_/0p8TyACR9Ikv3VbWDm5_S_e--
