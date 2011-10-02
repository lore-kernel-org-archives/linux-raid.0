From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] FIX: Block array monitoring if any array is under
 reshape in container
Date: Mon, 3 Oct 2011 10:54:20 +1100
Message-ID: <20111003105420.44ed77c4@notabene.brown>
References: <20110929154756.22854.13187.stgit@gklab-128-013.igk.intel.com>
	<20110929155345.22854.96027.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YR1=WaAv5k0l3sHuDZ.NnAq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929155345.22854.96027.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/YR1=WaAv5k0l3sHuDZ.NnAq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Sep 2011 17:53:45 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
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
> This patch addresses first case.
>   If current array is under reshape, block it. Second not reshaped array
>   will be blocked if container has any blocked array.

This feels like the wrong approach.

The metadata for the container should "know" if a reshape is pending and so
rebuilt monitoring should be disabled.

So I think we could just arrange that "struct mdinfo" has some flag which
says "recovery-blocked".  And we block based on that.=20
That feels a lot more robust that looking through /sys for the other parts =
of
the array.

Could you try that please?

Thanks,
NeilBrown


>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Assemble.c |   19 +++++++++++++++++--
>  Grow.c     |   28 ++++++++++++++++++++++++++++
>  mdadm.h    |    2 ++
>  msg.c      |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  msg.h      |    1 +
>  5 files changed, 100 insertions(+), 2 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index c6aad20..59ce650 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1526,8 +1526,23 @@ int assemble_container_content(struct supertype *s=
t, int mdfd,
>  		if (sysfs_set_array(content, md_get_version(mdfd)) !=3D 0)
>  			return 1;
> =20
> -	if (content->reshape_active)
> -		block_subarray(content);
> +
> +	if (st->ss->external) {
> +		if (content->reshape_active) {
> +			/* Current array in container is under reshape
> +			 * block it from monitoring
> +			 */
> +			block_subarray(content);
> +		} else {
> +			/* If any previously assembled array is under reshape
> +			 * currently assembled array have to be blocked before
> +			 * array activation also.
> +			 * Check if any array in container is blocked
> +			 * and do the same for this one.
> +			 */
> +			block_array_if_any_is_blocked(st, content);
> +		}
> +	}
> =20
>  	if (sra)
>  		sysfs_free(sra);
> diff --git a/Grow.c b/Grow.c
> index 4a25165..3e13c8f 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -539,6 +539,34 @@ static int check_idle(struct supertype *st)
>  	return is_idle;
>  }
> =20
> +/* Block currently assembed array if any array in container
> + * is blocked.
> + * Function has to be used during container assembly
> + * to make sure that all arrays in container are blocked
> + * if one is under reshape.
> + * This restores situation when reshape is started when
> + * all container components are blocked.
> + */
> +int block_array_if_any_is_blocked(struct supertype *st, struct mdinfo *c=
ontent)
> +{
> +	int container_dev =3D (st->container_dev !=3D NoMdDev
> +			     ? st->container_dev : st->devnum);
> +	char buf[1024];
> +
> +	fmt_devname(buf, container_dev);
> +
> +	if (check_blocked_monitor(buf) > 0) {
> +		if (sysfs_get_str(content, NULL, "metadata_version",
> +				  buf, 1024) > 0) {
> +			buf[9] =3D '-';
> +			sysfs_set_str(content, NULL, "metadata_version", buf);
> +		}
> +	}
> +
> +	return 1;
> +}
> +
> +
>  static int freeze_container(struct supertype *st)
>  {
>  	int container_dev =3D (st->container_dev !=3D NoMdDev
> diff --git a/mdadm.h b/mdadm.h
> index 8dd37d9..d0ffd4d 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -477,6 +477,8 @@ extern int sysfs_add_disk(struct mdinfo *sra, struct =
mdinfo *sd, int resume);
>  extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
>  extern int sysfs_unique_holder(int devnum, long rdev);
>  extern int sysfs_freeze_array(struct mdinfo *sra);
> +extern int block_array_if_any_is_blocked(struct supertype *st,
> +					 struct mdinfo *content);
>  extern int load_sys(char *path, char *buf);
>  extern int reshape_prepare_fdlist(char *devname,
>  				  struct mdinfo *sra,
> diff --git a/msg.c b/msg.c
> index 98d6d13..f903afb 100644
> --- a/msg.c
> +++ b/msg.c
> @@ -424,6 +424,58 @@ int block_monitor(char *container, const int freeze)
>  	return rv;
>  }
> =20
> +/* Function checks if any container member or container itself
> + * is blocked (mdmon is blocked).
> + * It can occur that during assembly process first array in container
> + * is under reshape, this means that any activated array
> + * has to be blocked also, to keep whole container blocked
> + * Returns:
> + * -1: error
> + *  0: not blocked
> + *  1: something is blocked
> + */
> +int check_blocked_monitor(char *container)
> +{
> +	struct mdstat_ent *ent, *e;
> +	struct mdinfo *sra =3D NULL;
> +	int rv =3D 0;
> +
> +	if (check_mdmon_version(container))
> +		return -1;
> +
> +	ent =3D mdstat_read(0, 0);
> +	if (!ent) {
> +		fprintf(stderr, Name
> +			": failed to read /proc/mdstat while checking"
> +			" if mdmon is disabled\n");
> +		return -1;
> +	}
> +
> +	/* check if any container member is frozen */
> +	for (e =3D ent; e; e =3D e->next) {
> +		if (!is_container_member(e, container))
> +			continue;
> +		sysfs_free(sra);
> +		sra =3D sysfs_read(-1, e->devnum, GET_VERSION);
> +		if (!sra) {
> +			fprintf(stderr, Name
> +				": failed to read sysfs for subarray%s\n",
> +				to_subarray(e, container));
> +			break;
> +		}
> +		/* check frozen state */
> +		if (sra->text_version[0] =3D=3D '-') {
> +			rv =3D 1;
> +			break;
> +		}
> +	 }
> +
> +	sysfs_free(sra);
> +	free_mdstat(ent);
> +
> +	return rv;
> +}
> +
>  void unblock_monitor(char *container, const int unfreeze)
>  {
>  	struct mdstat_ent *ent, *e;
> diff --git a/msg.h b/msg.h
> index c6d037d..fb5815e 100644
> --- a/msg.h
> +++ b/msg.h
> @@ -32,6 +32,7 @@ extern int block_subarray(struct mdinfo *sra);
>  extern int unblock_subarray(struct mdinfo *sra, const int unfreeze);
>  extern int block_monitor(char *container, const int freeze);
>  extern void unblock_monitor(char *container, const int unfreeze);
> +extern int check_blocked_monitor(char *container);
>  extern int fping_monitor(int sock);
>  extern int ping_manager(char *devname);
> =20


--Sig_/YR1=WaAv5k0l3sHuDZ.NnAq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiPmsG5fc6gV+Wb0RAkQnAJ4oV08LPiFflUwGSEfiZ3prOwaIjgCeL4YX
CG0xL951pIGI0kOmIzL2fIA=
=bQOl
-----END PGP SIGNATURE-----

--Sig_/YR1=WaAv5k0l3sHuDZ.NnAq--
