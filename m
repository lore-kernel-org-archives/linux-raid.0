From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 09/14] Move restore backup code to function
Date: Wed, 21 Sep 2011 12:28:42 +1000
Message-ID: <20110921122842.69aec696@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115455.5201.60281.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L7eCMGiUC+xX7AXL9R2Rji="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115455.5201.60281.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/L7eCMGiUC+xX7AXL9R2Rji=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:54:55 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Reshape backup should be able to be restored during reshape continuation
> also. To reuse already existing code it is moved to function.

I have applied this, but I had to fix it up a bit first.
'spare' is not the same as 'spares' - it is closer to 'next_spare'.

Thanks,
NeilBrown

>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Assemble.c |   40 +++------------------------------------
>  Grow.c     |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  mdadm.h    |    6 ++++++
>  3 files changed, 71 insertions(+), 37 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 66d2ee4..6188fb5 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1555,44 +1555,10 @@ int assemble_container_content(struct supertype *=
st, int mdfd,
> =20
>  		if (content->reshape_active) {
>  			int spare =3D content->array.raid_disks + expansion;
> -			int i;
> -			int *fdlist =3D malloc(sizeof(int) *
> -					     (working + expansion
> -					      + content->array.raid_disks));
> -			for (i=3D0; i<spare; i++)
> -				fdlist[i] =3D -1;
> -			for (dev =3D content->devs; dev; dev =3D dev->next) {
> -				char buf[20];
> -				int fd;
> -				sprintf(buf, "%d:%d",
> -					dev->disk.major,
> -					dev->disk.minor);
> -				fd =3D dev_open(buf, O_RDWR);
> -
> -				if (dev->disk.raid_disk >=3D 0)
> -					fdlist[dev->disk.raid_disk] =3D fd;
> -				else
> -					fdlist[spare++] =3D fd;
> -			}
> -			if (st->ss->external && st->ss->recover_backup)
> -				err =3D st->ss->recover_backup(st, content);
> -			else
> -				err =3D Grow_restart(st, content, fdlist, spare,
> -						   backup_file, verbose > 0);
> -			while (spare > 0) {
> -				spare--;
> -				if (fdlist[spare] >=3D 0)
> -					close(fdlist[spare]);
> -			}
> -			free(fdlist);
> -			if (err) {
> -				fprintf(stderr, Name ": Failed to restore critical"
> -					" section for reshape - sorry.\n");
> -				if (!backup_file)
> -					fprintf(stderr, Name ":  Possibly you need"
> -						" to specify a --backup-file\n");
> +			if (restore_backup(st, content,
> +					   working,
> +					   spare, backup_file, verbose))
>  				return 1;
> -			}
> =20
>  			err =3D Grow_continue(mdfd, st, content, backup_file);
>  		} else switch(content->array.level) {
> diff --git a/Grow.c b/Grow.c
> index b331287..0b96f7a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3578,6 +3578,68 @@ int Grow_restart(struct supertype *st, struct mdin=
fo *info, int *fdlist, int cnt
>  	return 1;
>  }
> =20
> +int restore_backup(struct supertype *st,
> +		   struct mdinfo *content,
> +		   int working_disks,
> +		   int spares,
> +		   char *backup_file,
> +		   int verbose)
> +{
> +	int i;
> +	int *fdlist;
> +	struct mdinfo *dev;
> +	int err;
> +	int disk_count =3D working_disks + spares;
> +	int next_spare =3D working_disks;
> +
> +	dprintf("Called restore_backup()\n");
> +	fdlist =3D malloc(sizeof(int) * disk_count);
> +	if (fdlist =3D=3D NULL) {
> +		fprintf(stderr,
> +			Name ": cannot allocate memory for disk list\n");
> +		return 1;
> +	}
> +	for (i =3D 0; i < disk_count; i++)
> +		fdlist[i] =3D -1;
> +	for (dev =3D content->devs; dev; dev =3D dev->next) {
> +		char buf[22];
> +		int fd;
> +		sprintf(buf, "%d:%d",
> +			dev->disk.major,
> +			dev->disk.minor);
> +		fd =3D dev_open(buf, O_RDWR);
> +
> +		if (dev->disk.raid_disk >=3D 0)
> +			fdlist[dev->disk.raid_disk] =3D fd;
> +		else
> +			fdlist[next_spare++] =3D fd;
> +	}
> +
> +	if (st->ss->external && st->ss->recover_backup)
> +		err =3D st->ss->recover_backup(st, content);
> +	else
> +		err =3D Grow_restart(st, content, fdlist, spares,
> +				   backup_file, verbose > 0);
> +
> +	while (disk_count > 0) {
> +		disk_count--;
> +		if (fdlist[disk_count] >=3D 0)
> +			close(fdlist[disk_count]);
> +	}
> +	free(fdlist);
> +	if (err) {
> +		fprintf(stderr, Name ": Failed to restore critical"
> +			" section for reshape - sorry.\n");
> +		if (!backup_file)
> +			fprintf(stderr, Name ":  Possibly you need"
> +				" to specify a --backup-file\n");
> +		return 1;
> +	}
> +
> +	dprintf("restore_backup() returns status OK.\n");
> +	return 0;
> +}
> +
>  int Grow_continue_command(char *devname, int fd,
>  			  char *backup_file, int verbose)
>  {
> diff --git a/mdadm.h b/mdadm.h
> index 7761db6..6165979 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1026,6 +1026,12 @@ extern int Grow_continue(int mdfd, struct supertyp=
e *st,
>  			 struct mdinfo *info, char *backup_file);
>  extern int Grow_continue_command(char *devname, int fd,
>  				 char *backup_file, int verbose);
> +extern int restore_backup(struct supertype *st,
> +			  struct mdinfo *content,
> +			  int working_disks,
> +			  int spares,
> +			  char *backup_file,
> +			  int verbose);
> =20
>  extern int Assemble(struct supertype *st, char *mddev,
>  		    struct mddev_ident *ident,
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/L7eCMGiUC+xX7AXL9R2Rji=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeUvaG5fc6gV+Wb0RAiTXAJ4z2PuXBnpRvirq1Mn2VNzs3kQ2hwCgvzqI
VUigMp99V/DUzM0GgsKfels=
=xdLY
-----END PGP SIGNATURE-----

--Sig_/L7eCMGiUC+xX7AXL9R2Rji=--
