From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/8] Verify reshape restart position
Date: Mon, 3 Oct 2011 10:06:28 +1100
Message-ID: <20111003100628.3e09e24c@notabene.brown>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
	<20110927120522.4890.83002.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XtO+Ii/85t/dnUFdkXUMVXS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927120522.4890.83002.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/XtO+Ii/85t/dnUFdkXUMVXS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 14:05:22 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Check if reshape restart position is the same as set in md.
> If position doesn't match this means that we cannot restart reshape.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index afe4c72..3ff249d 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3653,6 +3653,8 @@ int Grow_continue_command(char *devname, int fd,
>  	char buf[40];
>  	int cfd =3D -1;
>  	int fd2 =3D -1;
> +	char *ep;
> +	unsigned long long position;
> =20
>  	dprintf("Grow continue from command line called for %s\n",
>  		devname);
> @@ -3754,6 +3756,36 @@ int Grow_continue_command(char *devname, int fd,
>  		}
>  	}
> =20
> +	/* verify that array under reshape is started from
> +	 * correct position
> +	 */
> +	ret_val =3D sysfs_get_str(content, NULL, "sync_max", buf, 40);
> +	if (ret_val <=3D 0) {
> +		fprintf(stderr, Name
> +			": cannot open verify reshape progress for %s (%i)\n",
> +			content->sys_name, ret_val);
> +		ret_val =3D 1;
> +		goto Grow_continue_command_exit;
> +	}
> +	dprintf(Name ": Read sync_max sysfs entry is: %s\n", buf);
> +	errno =3D 0;
> +	position =3D strtoull(buf, &ep, 0);
> +	if (errno || ep =3D=3D buf || (*ep !=3D 0 && *ep !=3D '\n' && *ep !=3D =
' ')) {
> +		fprintf(stderr, Name ": md is not allowed to finish reshape "
> +			"wihout mdadm assistance.\n");
> +		ret_val =3D 1;
> +		goto Grow_continue_command_exit;
> +	}
> +	position *=3D get_data_disks(map_name(pers, mdstat->level),
> +				   content->new_layout,
> +				   content->array.raid_disks);
> +	if (position !=3D content->reshape_progress) {
> +		fprintf(stderr, Name ": md is not allowed to finish reshape "
> +			"wihout mdadm assistance.\n");
> +		ret_val =3D 1;
> +		goto Grow_continue_command_exit;
> +	}
> +
>  	/* continue reshape
>  	 */
>  	ret_val =3D Grow_continue(fd, st, content, backup_file,


Applied with a few small changes.

1/ is it never correct to test errno to see if an error occurred.  You must=
=20
   test something else to see if an error occurred, and the check errno to
   see what the error was.
2/ The error message didn't seem helpful.  I changed it to:

     Fatal error: array reshape was not properly frozen.

Thanks,
NeilBrown



--Sig_/XtO+Ii/85t/dnUFdkXUMVXS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiO50G5fc6gV+Wb0RAvNDAJ9hkoEwPZGvByiBp+oMH45qRQEZ/ACgp6H1
3PclkyBa4GOahuvPaBNSy0k=
=YNP9
-----END PGP SIGNATURE-----

--Sig_/XtO+Ii/85t/dnUFdkXUMVXS--
