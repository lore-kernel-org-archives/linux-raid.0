From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 12/14] Early reshape backup verification
Date: Wed, 21 Sep 2011 12:31:20 +1000
Message-ID: <20110921123120.5021dd84@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115518.5201.5649.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5kYWkRnAE+pHi84MaNmns=l"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115518.5201.5649.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/5kYWkRnAE+pHi84MaNmns=l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:55:18 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Ever reshape needs to backup its critical section. For this purposes
> backup file or external metadata mechanisms can be used.

This is not correct.
For internal metadata the critical section can be stored on a spare device,
and this is preferred where possible.

So it is not the case that you must have a backup_file for non-external
data.

NeilBrown


>=20
> Add verification if backup file or metadata mechanisms can have chance
> to restore data form backup.
> For native metadata existence of passed (from command line) backup file
> is checked. For external metadta manage_reshape() and recover_backup()
> are tested for this purposes.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index fa22382..d54b8a8 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3667,6 +3667,18 @@ int Grow_continue_command(char *devname, int fd,
>  			devname);
>  		return 1;
>  	}
> +
> +	/* request backup file
> +	 * when no metadta specific backup action is defined
> +	 */
> +	if ((backup_file =3D=3D NULL) &&
> +	    ((st->ss->manage_reshape =3D=3D NULL) ||
> +	     (st->ss->recover_backup =3D=3D NULL))) {
> +		fprintf(stderr, Name ": Please provide backup file "
> +			"for reshape continuation.\n");
> +		return 1;
> +	}
> +
>  	dprintf("Grow continue is run for ");
>  	if (st->ss->external =3D=3D 0) {
>  		dprintf("native array (%s)\n", devname);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/5kYWkRnAE+pHi84MaNmns=l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeUx4G5fc6gV+Wb0RAoibAKDXFZNX+xHK26m9sW1p+74TZ5yudwCfYUiN
y1N/VA32BbXzc4JzFgpC/pw=
=3B7Q
-----END PGP SIGNATURE-----

--Sig_/5kYWkRnAE+pHi84MaNmns=l--
