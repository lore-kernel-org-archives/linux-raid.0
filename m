From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 10/14] Perform restore backup for reshape continuation
Date: Wed, 21 Sep 2011 12:29:56 +1000
Message-ID: <20110921122956.6786fc86@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115503.5201.11096.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3wlq0EGod=gYV+78QBUBYZy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115503.5201.11096.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/3wlq0EGod=gYV+78QBUBYZy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:55:03 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> It can happen that reshape is broken by different reason than reboot.
> this means that on reshape continuation start we cannot be sure
> that critical section has been restored already.

I don't think this is true.

If the array is running, then the critical section must have been restored.
Anything else is simply wrong.

What scenario are you thinking of here?

Thanks,
NeilBrown


>=20
> Restore data from checkpoint before reshape continuation to avoid
> data corruption.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 0b96f7a..da8b72d 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3652,6 +3652,9 @@ int Grow_continue_command(char *devname, int fd,
>  	char container[20];
>  	int cfd =3D -1;
>  	int fd2 =3D -1;
> +	int spares;
> +	int working_disks;
> +	struct mdinfo *dev;
> =20
>  	dprintf("Grow continue from command line called for %s\n",
>  		devname);
> @@ -3753,7 +3756,20 @@ int Grow_continue_command(char *devname, int fd,
> =20
>  	/* continue reshape
>  	 */
> -	ret_val =3D Grow_continue(fd, st, content, backup_file);
> +	dev =3D content->devs;
> +	spares =3D 0;
> +	working_disks =3D 0;
> +	while (dev) {
> +		if (dev->disk.raid_disk =3D=3D -1)
> +			spares++;
> +		else
> +			working_disks++;
> +		dev =3D dev->next;
> +	}
> +	ret_val =3D restore_backup(st, content, working_disks, spares,
> +				 backup_file, verbose);
> +	if (!ret_val)
> +		ret_val =3D Grow_continue(fd, st, content, backup_file);
> =20
>  Grow_continue_command_exit:
>  	if (fd2 > -1)


--Sig_/3wlq0EGod=gYV+78QBUBYZy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeUwkG5fc6gV+Wb0RAs/5AJ9PaKB9XZgIH3RD7JWXJjnBdWPS2gCgi744
sd+KmplS3V24pfmRMgtY7NE=
=apKR
-----END PGP SIGNATURE-----

--Sig_/3wlq0EGod=gYV+78QBUBYZy--
