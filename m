From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/8] Set correct reshape restart position
Date: Mon, 3 Oct 2011 09:56:49 +1100
Message-ID: <20111003095649.0d033943@notabene.brown>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
	<20110927120505.4890.95696.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cTHn6kssom1hbjWOGcfsszw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927120505.4890.95696.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/cTHn6kssom1hbjWOGcfsszw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 14:05:05 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> During initrd stage when, when array is assembled with '--freeze-reshape'
> option and before stopping reshape, reshape position has to be set to read
> from metadata checkpoint.
> This will allow later for restart point verification and user will be able
> to see in mdstat information about reshape process instead resync when
> reshape position is set to 0.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Hi,
 I think that this patch makes start_reshape rather messy and confusing.
I am tempted to say not do do this at all, and maybe fix the kernel so that
is reports better information.

However it might be reasonable to do something like this in mdadm.  If so
I would like it to go in the  "if (freeze_reshape)" branch in
reshape_array(), and just explicitly set "sync_max".  There should be no ne=
ed
to set sync_min - is there?

Thanks,
NeilBrown


> ---
>=20
>  Grow.c |   26 +++++++++++++++-----------
>  1 files changed, 15 insertions(+), 11 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index d9c2817..afe4c72 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -696,21 +696,24 @@ static int subarray_set_num(char *container, struct=
 mdinfo *sra, char *name, int
>  	return rc;
>  }
> =20
> -int start_reshape(struct mdinfo *sra, int already_running, int freeze_re=
shape)
> +int start_reshape(struct mdinfo *sra, int already_running,
> +		  int freeze_reshape, int data_disks)
>  {
>  	int err;
> +	unsigned long long position_to_set =3D 0;
> +	unsigned long long sync_max_to_set;
> =20
>  	/* do not block array as we not continue reshape this time
>  	 */
> -	if (freeze_reshape =3D=3D FREEZE_RESHAPE_NONE)
> -		sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
> -	else
> -		sysfs_set_num(sra, NULL, "suspend_lo", 0);
> -	err =3D sysfs_set_num(sra, NULL, "suspend_hi", 0);
> -	err =3D err ?: sysfs_set_num(sra, NULL, "suspend_lo", 0);
> +	if (freeze_reshape !=3D FREEZE_RESHAPE_NONE)
> +		position_to_set =3D sra->reshape_progress;
> +	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
> +	err =3D sysfs_set_num(sra, NULL, "suspend_hi", position_to_set);
> +	err =3D err ?: sysfs_set_num(sra, NULL, "suspend_lo", position_to_set);
> +	sync_max_to_set =3D position_to_set / data_disks;
>  	if (!already_running)
> -		sysfs_set_num(sra, NULL, "sync_min", 0);
> -	err =3D err ?: sysfs_set_num(sra, NULL, "sync_max", 0);
> +		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
> +	err =3D err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
>  	if (!already_running)
>  		err =3D err ?: sysfs_set_str(sra, NULL, "sync_action", "reshape");
> =20
> @@ -2247,7 +2250,8 @@ started:
>  		}
>  	}
> =20
> -	err =3D start_reshape(sra, restart, freeze_reshape);
> +	err =3D start_reshape(sra, restart, freeze_reshape,
> +			   info->array.raid_disks - reshape.parity);
>  	if (err) {
>  		fprintf(stderr,=20
>  			Name ": Cannot %s reshape for %s\n",
> @@ -3753,7 +3757,7 @@ int Grow_continue_command(char *devname, int fd,
>  	/* continue reshape
>  	 */
>  	ret_val =3D Grow_continue(fd, st, content, backup_file,
> -				FREEZE_RESHAPE_NONE);
> +				FREEZE_RESHAPE_CONTINUE);
> =20
>  Grow_continue_command_exit:
>  	if (fd2 > -1)


--Sig_/cTHn6kssom1hbjWOGcfsszw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiOwxG5fc6gV+Wb0RAijwAJ9xtpyLmp4QihcgUQ9+O5CYPr5teQCgmzsG
cHXoyv8sirFJSs8lfUHsEPA=
=pQVh
-----END PGP SIGNATURE-----

--Sig_/cTHn6kssom1hbjWOGcfsszw--
