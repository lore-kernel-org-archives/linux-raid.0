From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 13/14] Check if md allows to control reshape
Date: Wed, 21 Sep 2011 12:33:38 +1000
Message-ID: <20110921123338.6ede25bc@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115525.5201.42756.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JYduVslgs4+cIEKle=S.1/T"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115525.5201.42756.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/JYduVslgs4+cIEKle=S.1/T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:55:25 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> It can happen that there is no mdadm in memory and 'max' was already
> set to sync_max. Such array cannot be put under check pointing control
> again.

Again I don't understand what you are trying to guard against.
If resync_max is 'max', then the kernel is allowed to fun reshape to
completion without any help from mdadm.  If mdadm needs to monitor things it
always sets resync_max to a smaller value.

Confused.

NeilBrown


>=20
> Verify such situation and refuse to control array in such condition.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index d54b8a8..04e6679 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3656,6 +3656,7 @@ int Grow_continue_command(char *devname, int fd,
>  	int spares;
>  	int working_disks;
>  	struct mdinfo *dev;
> +	char buf[40];
> =20
>  	dprintf("Grow continue from command line called for %s\n",
>  		devname);
> @@ -3769,6 +3770,24 @@ int Grow_continue_command(char *devname, int fd,
>  		}
>  	}
> =20
> +	/* verify that array under reshape is stopped
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
> +	if (strncmp(buf, "max", 3) =3D=3D 0) {
> +		fprintf(stderr, Name ": md is not allowed to finish reshape "
> +			"wihout mdadm assistance.\n");
> +		ret_val =3D 1;
> +		goto Grow_continue_command_exit;
> +	}
> +
>  	/* continue reshape
>  	 */
>  	dev =3D content->devs;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/JYduVslgs4+cIEKle=S.1/T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeU0CG5fc6gV+Wb0RAjv2AKCiyKCiQZHkN07AZoD9fkjKZQZzJQCguGij
35Drx6evgU/hqVth8mKAskc=
=RnHb
-----END PGP SIGNATURE-----

--Sig_/JYduVslgs4+cIEKle=S.1/T--
